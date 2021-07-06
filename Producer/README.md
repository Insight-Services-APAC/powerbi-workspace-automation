## Prerequisites
- AZ CLI
  - Bicep `az bicep install`
- AZ PowerShell Module
- DOTNET SDK
- VS Code

# Deployment

## Script Config

## ARM deployment

Creates the Azure Resource Group and dependant resources for the Producer capabilities. Requires 3 parameters
- **env**: Environment abbreviation. Valid values `[dev, tst, prd]`
- **clientPrefix**: Prefix used on all resources. Limit to 4 characters
- **aadObjectId**: The current user or AAD Security Group. Will be used to provide `[list, get]` permissions for Azure Key Vault

`.\deploy.ps1 -InfraDeploy -env "dev" -clientPrefix "wch" -aadObjectId "9fb4af47-1091-4da1-a27c-db0e7f85401c"`
## KeyVault Config

Creates an App Registration in AAD and saves the underlying service principal ID and Secret to Azure Key Vault

`.\deploy.ps1 -KeyVaultConfig -env "dev" -clientPrefix "wch"`

### Post-Configuration

1. Update the App Registration to include **Microsoft Graph - Read all groups**. (Must have consent from Tenant Administrator)
![Application Registration Permissions](docs/img/app-reg-permissions.png)
2. Add the App Registration to the AAD Security Group that will be configured to use the Power BI Admin API
   - If a Security Group does not exist. Create now and add the App Registration
## Function App deployment

`.\deploy.ps1 -FuncDeploy -env "dev" -clientPrefix "wch"`
## APIM Deployment

`.\deploy.ps1 -ApimDeploy -env "dev" -clientPrefix "wch"`
### Post-Configuration

The following steps are completed within API Management, in the Azure portal
- Create a Subscription for the Producer (HSS) API
  
![Producer Subscription](docs/img/new-producer-subscription.png)

- Create a Subscription for the Consumer (HSP) API

![Consumer Subscription](docs/img/new-consumer-subscription.png)

- Retrieve the Producer Primary Subscription Key

![Subscription Keys](docs/img/retrieve-subscription-key.png)

Create a Consumer details in Cosmos DB, via the API Management endpoint
```
POST https://<<apim-instance-name>>.azure-api.net/powerbi-hss/Subscription
Ocp-Apim-Subscription-Key: {{subscriptionKey}}

{
    "id": "wachs",
    "adminSecurityGroup": "PBI_ADMIN_WACHS",
    "departmentName": "WA Country Health Services",
    "workspacePrefix": "WACHS"
}
```
