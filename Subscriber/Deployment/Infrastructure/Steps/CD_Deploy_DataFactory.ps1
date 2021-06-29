

#Deploy Data Factory
if($env:EnvOpts_CD_Services_DataFactory_Enable -eq "True")
{
    $factoryname = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_DataFactory_Name
    Write-Host "Creating Data Factory: $factoryname"
    az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/dataFactory.json --parameters location=$env:EnvOpts_CD_ResourceGroup_Location factoryName=$factoryname 

    #Check if key vault exists to register add access policy for ADF MSI
    $vaultName = $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_KeyVault_Name
    $kvList = (az keyvault list -g $env:EnvOpts_CD_ResourceGroup_Name --query "[?name=='$vaultName']")
    $kvFlag = $kvList.Length -gt 0

    if($kvFlag)
    {
        Write-Host "Register ADF MSI in Key Vault"
        $msi = (az resource list --name $factoryname --resource-group $env:EnvOpts_CD_ResourceGroup_Name --query "[].identity.principalId" --out tsv)
        #$msi[1]
        az keyvault set-policy --name $vaultName --secret-permissions get list --object-id $msi
        
        Write-Host "Create key vault linked service"
        az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/dataFactory_KeyVault_LinkedService.json --parameters factoryName=$factoryname vaultName=$vaultName

        Write-Host "Register ADF MSI in ADLS"
        $storageaccountname =  $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_Storage_ADLS_Name.ToString()
        $subId = (az account show --subscription $env:EnvOpts_CD_ResourceGroup_Subscription --query "id")
        $scope = "/subscriptions/$subId/resourceGroups/$env:EnvOpts_CD_ResourceGroup_Name/providers/Microsoft.Storage/storageAccounts/$storageaccountname"
        
        az role assignment create --assignee $msi --role 'Storage Blob Data Contributor' --scope $scope   
    
    }



    
}
else 
{
    Write-Host "Skipped Creation of Data Factory"
}