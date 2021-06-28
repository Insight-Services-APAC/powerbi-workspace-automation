$resourceGroup = "hss-syd-dev-arg-powerbi"
$apimName = "hss-syd-dev-api-powerbi"
$extractPath = "apim2"
.\scripts\apim-extract.ps1 -ResourceGroup $resourceGroup -SourceApim $apimName -ExtractPath $extractPath