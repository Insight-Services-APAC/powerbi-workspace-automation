## Prerequisites
- AZ CLI
- AZ PowerShell Module
- DOTNET SDK
- VS Code

## Pre-deployment

- Create a target Resource Group
    ### When Using DevOps for Deployment
    1. Service Principal configured in AAD
    2. Provide service principal with "Contributor" role on the Resource Group
    3. Create a new  "Azure Resource Manager" service connection in DevOps

## Deployment


### Infrastrucutre Deployment

- Open either the "Development.json" or "Production.json" file saved uder the ".\Deployment\Infrastrucutre\Environments"    folder
- Update the relevant settings for the Azure environment and resource settings to be applied for the deployment (This is a once off exercise per environment unless settings change down the track)
- Once the config is set, navigate to the root of the solution folder
- Using PowerShell or the VSCode Terminal execute the following: "./Subscriber/Deployment/Infrastructure/Deploy-AzureResource.ps1 <Environment>"