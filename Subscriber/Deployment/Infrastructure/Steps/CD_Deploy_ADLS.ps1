

if($env:EnvOpts_CD_Services_Storage_ADLS_Enable -eq "True")
{
    #StorageAccount For Cold Storage
    $storageaccountname =  $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_Storage_ADLS_Name.ToString()
    Write-Host "Creating Storage Account For Cold Storage: $storageaccountname"
    az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/storageAccount.json --parameters location=$env:EnvOpts_CD_ResourceGroup_Location storageAccountName=$storageaccountname storageSKU=$env:EnvOpts_CD_Services_Storage_ADLS_StorageSKU

}
else 
{
    Write-Host "Skipped Creation of Storage Account"
}