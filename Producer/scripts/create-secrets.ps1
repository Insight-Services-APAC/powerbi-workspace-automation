param (
    [Parameter()] [string] $KeyVaultName
)

$spid = Read-Host -Prompt 'Input the Service Principal name'
$spsecret = Read-Host -Prompt 'Input the Service Principal secret'

az keyvault secret set --name "spPowerBISecret" --vault-name $KeyVaultName --value $spsecret
az keyvault secret set --name "spPowerBIId" --vault-name $KeyVaultName --value $spid