[CmdletBinding()]
param (
    [Parameter(Mandatory)] [string] $groupName,
    [Parameter(Mandatory)] [string] $spName
)

$app=$(az ad sp create-for-rbac -n $spName --skip-assignment true --years 1) | ConvertFrom-Json
$account=$(az account show) | ConvertFrom-Json
az role assignment create --role Contributor -g $groupName --assignee $app.appId

Write-Host "Service Connection Creation"
Write-Host "---------------------------"
Write-Host "Subscription Id:`t$($account.id)"
Write-Host "Subscription Name:`t$($account.name)"
Write-Host "Service Principal Id:`t$($app.appId)"
Write-Host "Service Principal Key:`t$($app.password)"
Write-Host "Tenant:`t$($account.tenantId)"
Write-Host "Tenant:`t$($account.tenantId)"
