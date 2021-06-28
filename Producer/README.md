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

Creates the Azure Resource Group and dependant resources for the Producer capabilities. Requires 3 parameters
- **env**: Environment abbreviation. Valid values `[dev, tst, prd]`
- **clientPrefix**: Prefix used on all resources. Limit to 4 characters
- aadObjectId: The current user or AAD Security Group. Will be used to provide `[list, get]` permissions for Azure Key Vault
`.\deploy.ps1 -InfraDeploy -env "dev" -clientPrefix "test" -aadObjectId "1234566892015"`
## KeyVault Config

Creates an App Registration in AAD and saves the underlying service principal ID and Secret to Azure Key Vault
`.\deploy.ps1 -KeyVaultConfig -env "dev" -clientPrefix "wch"`

Post-Configuration
1.

## Function App deployment
`.\deploy.ps1 -FuncDeploy -env "dev" -clientPrefix "test"`
## APIM Deployment
`.\deploy.ps1 -ApimDeploy -env "dev" -clientPrefix "test"`


## Post-deployment
- Generate the HSS Subscription
- Generate the HSP Subscription
- Call HSS /Subscription endpoint to create new HSP Subscription