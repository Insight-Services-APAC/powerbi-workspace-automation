
//parameters
param factoryName string

param vaultName string

resource symbolicname 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${factoryName}/keyvault01'
  properties: {
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: 'https://${vaultName}.vault.azure.net'
    }
  }
}
