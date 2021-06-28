[CmdletBinding()]
param (
    [Parameter()] [switch] $ApimExtract,
    [Parameter()] [switch] $ApimDeploy,
    [Parameter()] [switch] $InfraDeploy,
    [Parameter()] [switch] $KeyVaultConfig,
    [Parameter()] [switch] $FuncDeploy,
    [Parameter()] [string] $clientPrefix="wch",
    [ValidateSet("dev", "tst", "prd")]
    [Parameter()] [string] $env = "dev",
    [Parameter()] [string] $aadObjectId = "9fb4af47-1091-4da1-a27c-db0e7f85401c"
)

$storage = "${clientPrefix}syd${env}stapowerbi"
$apim = "${clientPrefix}-syd-${env}-api-powerbi"
$rg = "${clientPrefix}-syd-${env}-arg-powerbi"
$func = "${clientPrefix}-syd-${env}-fun-powerbi"
$kv = "${clientPrefix}-syd-${env}-key-powerbi"

$templates = "apim"

if ($KeyVaultConfig) {
    .\scripts\create-app-registration.ps1 -KeyVaultName $kv
}

if ($InfraDeploy) {
    if (-Not $aadObjectId) {
        Write-Error "Must provide $aadObjectId"
        Exit 1
    }
    .\scripts\deploy-infra.ps1 `
        -ClientPrefix $clientPrefix `
        -Env $env `
        -AadObjectId $aadObjectId
}

if ($ApimDeploy) {
    .\scripts\deploy-apim.ps1 `
        -ApimName $apim `
        -ResourceGroup $rg `
        -SourcePath $templates `
        -StorageAccount $storage `
        -FunctionName $func
}

if ($ApimExtract) {
    $resourceGroup = "hss-syd-dev-arg-powerbi"
    $apimName = "hss-syd-dev-api-powerbi"

    .\scripts\apim-extract.ps1 `
        -ResourceGroup $resourceGroup `
        -SourceApim $apimName `
        -ExtractPath $templates
}

if ($FuncDeploy) {
    .\scripts\deploy-func.ps1 `
        -ResourceGroup $rg `
        -FunctionApp $func
}