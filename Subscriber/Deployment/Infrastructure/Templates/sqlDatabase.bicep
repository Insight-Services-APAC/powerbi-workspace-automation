
//parameters
param location string = resourceGroup().location

param sqlServerName string

param sqlDBName string = 'PBITelemetry'

param sqlDBServiceObjectiveName string = 'Basic'

param sqlDBEdition string = 'Basic'

var databaseCollation  = 'SQL_Latin1_General_CP1_CI_AS'

//Get SQL Server resource
resource sql 'Microsoft.Sql/servers@2020-11-01-preview' existing = {
  name: sqlServerName
}

//Create Database
resource sqldb 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sql
  name: sqlDBName
  location: location
  tags: {}
  sku: {
    name: sqlDBServiceObjectiveName
    tier: sqlDBEdition
    capacity: 5
  }
  properties: {
    collation: databaseCollation
  }
}


