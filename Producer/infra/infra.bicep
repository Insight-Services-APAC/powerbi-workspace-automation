param clientPrefix string = 'hss'
param region string = 'syd'

@allowed([
  'dev'
  'tst'
  'prd'
])
param env string = 'dev'
param publisherEmail string = 'paul.smithdale@insight.com'
param publisherName string = 'Paul Smithdale'

param location string = resourceGroup().location
param tenantId string = subscription().tenantId
var solutionSuffix = 'powerbi'
var cosmosDbName = 'PowerBIAutomation'
var apimName = '${clientPrefix}-${region}-${env}-api-${solutionSuffix}'
var appInsightsName = '${clientPrefix}-${region}-${env}-ain-${solutionSuffix}'
var cosmosName = '${clientPrefix}-${region}-${env}-cdb-${solutionSuffix}'
var storageName = toLower('${clientPrefix}${region}${env}sta${solutionSuffix}')
var funcAppName = '${clientPrefix}-${region}-${env}-fun-${solutionSuffix}'
var appServiceName = '${clientPrefix}-${region}-${env}-asp-${solutionSuffix}'
var keyVaultName = '${clientPrefix}-${region}-${env}-key-${solutionSuffix}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource appService 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: appServiceName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    capacity: 0
  }
  properties: {}
}

resource funcApp 'Microsoft.Web/sites@2021-01-01' = {
  name: funcAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appService.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'cosmosDbName'
          value: cosmosDbName
        }
        {
          name: 'CosmosDBConnection'
          value: listConnectionStrings(cosmosDb.id, cosmosDbSql.apiVersion).connectionStrings[0].connectionString
        }
        {
          name: 'AuthenticationConfig:ClientSecret'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=spPowerBISecret)'
        }
        {
          name: 'AuthenticationConfig:ClientId'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=spPowerBIId)'
        }
        {
          name: 'AuthenticationConfig:Tenant'
          value: '362e8191-a703-4ccf-8e0a-68f31eb9d487'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'SubscriptionContainerName'
          value: 'Subscriptions'
        }
        {
          name: 'WorkspaceContainerName'
          value: 'Workspaces'
        }
        {
          name: 'ActivitiesContainerName'
          value: 'Activities'
        }
      ]
    }
  }
  dependsOn: [
    storageAccount
    appService
    appInsights
    cosmosDbSql
  ]
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: []
  }
}

resource funcAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-04-01-preview' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: funcApp.identity.principalId
        tenantId: funcApp.identity.tenantId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
  dependsOn: [
    funcApp
    keyVault
  ]
}

resource apim 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: cosmosName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource cosmosDbSql 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  name: '${cosmosName}/${cosmosDbName}'
  properties: {
    resource: {
      id: cosmosDbName
    }
    options: {
      throughput: 400
    }
  }
}

resource subscriptionContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  name: '${cosmosName}/${cosmosDbName}/Subscriptions'
  properties: {
    resource: {
      id: 'Subscriptions'
      partitionKey:{
        paths: [
          '/id'
        ]
      }
    }
  }
}

resource workspaceContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  name: '${cosmosName}/${cosmosDbName}/Workspaces'
  properties: {
    resource: {
      id: 'Workspaces'
      partitionKey:{
        paths: [
          '/HSPName'
        ]
      }
      defaultTtl: 2592000
    }
  }
}

resource activitiesContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  name: '${cosmosName}/${cosmosDbName}/Activities'
  properties: {
    resource: {
      id: 'Activities'
      partitionKey:{
        paths: [
          '/id'
        ]
      }
      defaultTtl: 2592000
    }
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
