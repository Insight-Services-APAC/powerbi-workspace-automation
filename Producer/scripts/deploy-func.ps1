
param (
    [Parameter(Mandatory=$true)] [string] $ResourceGroup,
    [Parameter(Mandatory=$true)] [string] $FunctionApp
)


$out = ".\package"
$dest = "package.zip"

if (Test-Path $out) {
    Remove-Item $out -Recurse -Force    
}
# if (Test-Path $dest) {
#     Remove-Item $dest -Force
# }

# dotnet publish -o $out -c RELEASE src\Insight.PowerBI.Automation\Insight.PowerBI.Automation.csproj

# Compress-Archive -Path "$out\*" -DestinationPath $dest 
# Remove-Item $out -Recurse -Force

az functionapp deployment source config-zip `
    -g $ResourceGroup `
    -n $FunctionApp `
    --src $dest

# Remove-Item $dest -Force