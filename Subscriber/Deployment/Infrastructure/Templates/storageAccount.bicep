
//parameters
param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
param storageAccountName string = 'uniquestorage001' 

param storageSKU string = 'Standard_LRS' 

//storage account creation
resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSKU
  }
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
  }
}

//Add initial containers
resource cont1 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${stg.name}/default/raw'
  properties: {
    publicAccess: 'None'
  }
}

resource cont2 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${stg.name}/default/landing'
  properties: {
    publicAccess: 'None'
  }
}


