
//parameters
param location string = resourceGroup().location

param sqlServerName string = 'uniquestorage001' 

param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

param sqlAADAdminUser string

param sqlAADAdminUserObjectId string

param tenantId string

param vnetName string

//Create SQL Server
resource sql 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  identity: {
    type: 'None'
  }
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: sqlAADAdminUser
      sid: sqlAADAdminUserObjectId
      tenantId: tenantId
      azureADOnlyAuthentication: false
    }
  }
}

//Get existing subnet id
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-07-01' existing = {
  name: '${vnetName}/data'
}

//Add SQL Server to Endpoint
resource sqlvnet 'Microsoft.Sql/servers/virtualNetworkRules@2020-11-01-preview' = {
  parent: sql
  name: '${vnetName}-data'
  properties: {
    virtualNetworkSubnetId: subnet.id
    ignoreMissingVnetServiceEndpoint: false
  }
}

//Allow Azure Resources to Connect
resource azfwrule 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = {
  parent: sql
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
