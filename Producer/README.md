## Prerequisites
- AZ CLI
- AZ PowerShell Module
- DOTNET SDK
- VS Code

## Pre-deployment
- Service Principal configured in AAD
  - Requires Microsoft Graph Read.All
- Secret Generated
  - Used by Function Apps to access Power BI and Graph to read AD Security Groups

# Deployment


## Script Config

## ARM deployment

`deploy.ps1 -InfraDeploy -env "dev" -clientPrefix="test" -aadObjectId "1234566892015"`
## KeyVault Config
`deploy.ps1 -KeyVaultConfig -env "dev" -clientPrefix="test"`

## Function App deployment
Producer\scripts\deploy-func.ps1
`deploy.ps1 -FuncDeploy -env "dev" -clientPrefix="test"`
## APIM Deployment
`deploy.ps1 -ApimDeploy -env "dev" -clientPrefix="test"`


## Post-deployment
- Generate the HSS Subscription
- Generate the HSP Subscription
- Call HSS /Subscription endpoint to create new HSP Subscription