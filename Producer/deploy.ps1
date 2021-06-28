[CmdletBinding()]
param (
    [Parameter()] [switch] $ApimExtract,
    [Parameter()] [switch] $ApimDeploy,
    [Parameter()] [switch] $InfraDeploy,
    [Parameter()] [switch] $KeyVaultConfig
)

$aadObjectId="???"
$clientPrefix="test"
$env="dev"
$storage = "${clientPrefix}syd${env}stapowerbi"
$apim = "${clientPrefix}-syd-${env}-api-powerbi"
$rg = "${clientPrefix}-syd-${env}-arg-powerbi"
$func = "${clientPrefix}-syd-${env}-fun-powerbi"
$kv = "${clientPrefix}-syd-${env}-key-powerbi"

$templates = "apim"

if ($KeyVaultConfig) {
    .\scripts\create-secretsps1 -KeyVaultName $kv
}

if ($InfraDeploy) {
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