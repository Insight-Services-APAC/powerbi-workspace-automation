
//parameters
param location string = resourceGroup().location

param sqlServerName string = 'uniquestorage001' 

param sqlAdministratorLogin string

param sqlAADAdminUser string

param sqlAADAdminUserObjectId string

param tenantId string

param vnetName string

param vaultName string

var subId = subscription().subscriptionId

//Retrieve SQL Admin password secret
resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: vaultName
  scope: resourceGroup(subId, resourceGroup().name)
}

//Pass values to SQL Server module for creation
module sql './sqlServer.bicep' = {
  name: 'deploySQL'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: kv.getSecret('ASQL-PASSW')
    sqlAADAdminUser: sqlAADAdminUser
    sqlAADAdminUserObjectId: sqlAADAdminUserObjectId
    tenantId: tenantId
    vnetName: vnetName
  }
}

