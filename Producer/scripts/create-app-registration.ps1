param (
    [Parameter()] [string] $KeyVaultName
)

$spName="sp-powerbi-automation"
$appReg=$(az ad sp create-for-rbac -n $spName --skip-assignment true --years 1) | ConvertFrom-Json
$spSecret=$appReg.password
$appId=$appReg.appId

Write-Host "Key Vault: $KeyVaultName"

az keyvault secret set --name "spPowerBISecret" --vault-name $KeyVaultName --value $spSecret
az keyvault secret set --name "spPowerBIId" --vault-name $KeyVaultName --value $appId