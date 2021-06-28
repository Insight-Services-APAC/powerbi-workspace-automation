
//parameters
param location string = resourceGroup().location
param vaultName string = 'keyVault${uniqueString(resourceGroup().id)}' // must be globally unique
param tenantId string = '' 
param userObjectID string = ''
param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enableRbacAuthorization bool = false

@secure()
param ASQLAdminPassw string = '${newGuid()}'

param accessPolicies array = [
  {
    tenantId: tenantId
    objectId: userObjectID 
    permissions: {
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
      ]

    }
  }
]

var sku = 'standard'
var ASQLSecretName = 'ASQL-PASSW'
var ASQLADFLSSecretName = 'ADF-LS-ASQL-PBITelemetry'
var HSSAPIKey = 'HSS-API-Key'


resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: vaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableRbacAuthorization: enableRbacAuthorization
  }
}

resource secret1 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${ASQLSecretName}'
  properties: {
    value: ASQLAdminPassw
  }
  dependsOn: [
    keyvault
  ]
}

resource secret2 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${ASQLADFLSSecretName}'
  properties: {
    value: ''
  }
  dependsOn: [
    keyvault
  ]
}

resource secret3 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${HSSAPIKey}'
  properties: {
    value: '' 
  }
  dependsOn: [
    keyvault
  ]
}
