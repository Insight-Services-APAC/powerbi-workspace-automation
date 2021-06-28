[CmdletBinding()]
param (
    [Parameter()] [switch] $ApimExtract,
    [Parameter()] [switch] $ApimDeploy
)



$storage = "testsyddevstapowerbi"
$apim = "test-syd-dev-api-powerbi"
$rg = "test-syd-dev-arg-powerbi"
$func = "test-syd-dev-fun-powerbi"
$templates = "apim2"

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
    $extractPath = "apim2"

    .\scripts\apim-extract.ps1 `
        -ResourceGroup $resourceGroup `
        -SourceApim $apimName `
        -ExtractPath $extractPath
}