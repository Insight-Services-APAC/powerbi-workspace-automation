

//parameters
param location string = resourceGroup().location

param vnetName string = 'vnet'

var addressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.1.0/24'

//Create VNET
resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: vnetName
  location: location
  tags: {}
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'data'
        properties: {
          addressPrefix: subnetAddressPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Sql'
              locations: [
                location
              ]
            }
          ]
        }
      }
    ]
  }
}
