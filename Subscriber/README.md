## Prerequisites
- AZ CLI
- AZ PowerShell Module
- VS Code
- Bicep (az bicep install)

## Pre-deployment

- Create a target Resource Group
    ### When Using DevOps for Deployment
    1. Service Principal configured in AAD
    2. Provide service principal with "Contributor" role on the Resource Group
    3. Create a new  "Azure Resource Manager" service connection in DevOps

## Deployment


### Infrastructure Deployment
There is an Azure pipeline for the Infrastrucutre deployment, but the following steps provide a manual approach if required
- Open either the "Development.json" or "Production.json" file saved uder the ".Subscriber\Deployment\Infrastrucutre\Environments" folder
- Update the relevant settings for the Azure environment and resource settings to be applied for the deployment (This is a once off exercise per environment unless settings change down the track)
- Once the config is set, navigate to the root of the solution folder
- Using PowerShell or the VSCode Terminal execute the following: "./Subscriber/Deployment/Infrastructure/Deploy-AzureResource.ps1 -specify environment-"
    - Environment should be either "Development" or "Production" which will then inform the sript which config file to use   
- Review the deployment processing
- If all is successful, then review the created resources in the target Azure resource group.

### Database Deployment
- Manual via Visual Studio or via Azure Pipeline

### ADF Deployment
There is an Azure pipeline for ADF deployment, but the following steps provide a manual approach if required
- This step is currently done via manual ARM template deployment after the infra deployment.
- Open the ADF web portal and select "Manage" and then "ARM Template" from the navigation.
- Select "Import ARM Template" which will open a seperate portal window to run an ARM Template.
- Select the "Build your own template in the editor" which will then provie a window with an option to upload a template.
- Browse to the "arm_template.json" file in the "./Sybscriber/Data Factory" folder.
- Once uploaded, update the template paramters to point to the correctly name Azure resources and Save the file.
- Select the resource group when prompted and click "Review & Create".
- This will execute the ARM template and add the linked services, datasets and pipelines into the ADF instance.
- Validate the creation of these components after completion.

## Post-Deployment
- Verify Azure resoure creation (Azure Portal)
- Verify Telemetry database object deployment (SSMS)
- Verify ADF content deployment (ADF Studio)
- Set Keyvault secret values
- Test ADF linked service connections and pipelines