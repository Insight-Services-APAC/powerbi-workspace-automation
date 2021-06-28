param (
    [Parameter()] [string] $ResourceGroup,
    [Parameter()] [string] $SourceApim,
    [Parameter()] [string] $ExtractPath
)

$tookitPath = "tools\apim-devops-kit.zip"
Expand-Archive  $tookitPath reskit -Force

Write-Host "**Template Extract**"
dotnet ./reskit/netcoreapp3.1/apimtemplate.dll extract `
    --sourceApimName "$SourceApim" `
    --resourceGroup "$ResourceGroup" `
    --fileFolder "$ExtractPath" `
    --destinationApimName "REPLACE_ME" `
    --baseFileName "ApimArm" `
    --policyXMLBaseUrl "REPLACE_ME" --policyXMLSasToken "REPLACE_ME" `
    --linkedTemplatesBaseUrl "REPLACE_ME" --linkedTemplatesSasToken "REPLACE_ME" `
    --paramServiceUrl=false --paramNamedValue=true --notIncludeNamedValue=false

Write-Host "**Clean-up**"