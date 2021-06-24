

#Deploy SQL Telemetry Database
if($env:EnvOpts_CD_Services_AzureSQLServer_TelemetryDB_Enable -eq "True")
{
    Write-Host "Creating Telemetry Database: $env:EnvOpts_CD_Services_AzureSQLServer_TelemetryDB_Name"
    $sqlservername = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_AzureSQLServer_Name
    az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/sqlDatabase.bicep --parameters location=$env:EnvOpts_CD_ResourceGroup_Location sqlServerName=$sqlservername sqlDBName=$env:EnvOpts_CD_Services_AzureSQLServer_TelemetryDB_Name sqlDBServiceObjectiveName=$env:EnvOpts_CD_Services_AzureSQLServer_TelemetryDB_SqlDBServiceObjectiveName sqlDBEdition=$env:EnvOpts_CD_Services_AzureSQLServer_TelemetryDB_SqlDBEdition
}
else 
{
    Write-Host "Skipped Creation of Telemetry Database"
}