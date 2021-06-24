

#Deploy SQL Server
if($env:EnvOpts_CD_Services_AzureSQLServer_Enable -eq "True")
{
    $sqlservername = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_AzureSQLServer_Name
    $vnetName =  $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_Vnet_Name
    $vaultname = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_KeyVault_Name

    Write-Host "Creating SQL Server: $sqlservername"
    az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/sqlServer_initiate.bicep --parameters location=$env:EnvOpts_CD_ResourceGroup_Location sqlServerName=$sqlservername sqlAdministratorLogin=$env:EnvOpts_CD_Services_AzureSQLServer_AdminUser sqlAADAdminUser=$env:EnvOpts_CD_ResourceGroup_AADUser sqlAADAdminUserObjectId=$env:EnvOpts_CD_ResourceGroup_AADUserObjectID tenantId=$env:EnvOpts_CD_ResourceGroup_TenantId vnetName=$vnetName vaultName=$vaultname
}
else 
{
    Write-Host "Skipped Creation of SQL Server"
}