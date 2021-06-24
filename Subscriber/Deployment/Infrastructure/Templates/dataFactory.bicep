
//parameters
param location string = resourceGroup().location

param factoryName string

//Create Data factory
resource adf 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  tags: {}
  identity: {
    type: 'SystemAssigned'
  }
}
