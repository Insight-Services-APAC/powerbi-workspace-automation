

#VNET
$vnetName =  $env:EnvOpts_CD_ResourceGroup_ResourcePrefix.ToString()+$env:EnvOpts_CD_Services_Vnet_Name
Write-Host "Creating VNet: $vnetName"
az deployment group create -g $env:EnvOpts_CD_ResourceGroup_Name -f ././Templates/virtualNetwork.bicep --parameters location=$env:EnvOpts_CD_ResourceGroup_Location vnetName=$vnetName
Write-Host "VNet created"