

#Deploy Key Vault
if($env:EnvOpts_CD_Services_KeyVault_Enable -eq "True")
{
    $vaultname = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_KeyVault_Name
    Write-Host "Creating Key Vault: $vaultname"
    az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/keyVault.json --parameters location=$env:EnvOpts_CD_ResourceGroup_Location vaultName=$vaultname tenantId=$env:EnvOpts_CD_ResourceGroup_TenantId userObjectID=$env:SPObjectId 
}
else 
{
    Write-Host "Skipped Creation of Key Vault"
}