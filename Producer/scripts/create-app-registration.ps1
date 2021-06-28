param (
    [Parameter()] [string] $KeyVaultName
)

$spName="sp-powerbi-automation"
$appReg=$(az ad sp create-for-rbac -n $spName --skip-assignment true --years 1) | ConvertFrom-Json
$spSecret=$appReg.password
$appId=$appReg.appId

az keyvault secret set --name "spPowerBISecret" --vault-name $keyVaultName --value $spSecret
az keyvault secret set --name "spPowerBIId" --vault-name $keyVaultName --value $appId