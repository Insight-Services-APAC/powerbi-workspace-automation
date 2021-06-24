
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
var secretName = 'ASQL-PASSW'

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

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${secretName}'
  properties: {
    value: ASQLAdminPassw
  }
}
