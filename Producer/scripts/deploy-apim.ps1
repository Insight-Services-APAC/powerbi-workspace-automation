#!/bin/bash

# The following Environment Variables are required
#
# APIM_NAME: APIM Deployment Target resource name
# APIM_RESOURCE_GROUP: APIM Resource Group
# API_NAME: API Name
# SourcePath: API ARM Template path
# StorageAccount, ResourceGroup, StorageContainer: Storage account 

[CmdletBinding()]
param (
    [Parameter()] [string] $ApimName,
    [Parameter()] [string] $ResourceGroup,
    [Parameter()] [string] $SourcePath,
    [Parameter()] [string] $StorageAccount,
    [Parameter()] [string] $FunctionName,
    [Parameter()] [string] $StorageContainer = "templates"
)

function Upload-Templates {
    $ROOT_FILE_URL = "https://$StorageAccount.blob.core.windows.net/$StorageContainer/temp"
    Write-Host "**UPLOAD**"
    Write-Host "Connection String"
    $CONNECTION = $(az storage account show-connection-string `
            --resource-group $ResourceGroup `
            --name $StorageAccount `
            --query connectionString)

    Write-Host "Batch Upload"
    $output = $(az storage blob upload-batch `
            --destination $StorageContainer `
            --source "$SourcePath/" `
            --destination-path temp `
            --connection-string $CONNECTION)
}

function Deploy-Templates {
    # APIM Variables
    Write-Host "Destination APIM: $ApimName"
    Write-Host "Destination Resource Group: $ResourceGroup"
    $funcKey = $(az functionapp keys list --name $FunctionName `
            --resource-group $ResourceGroup `
            --query "functionKeys.default" -o tsv)

    $namedValues = @{
        hsssyddevfunpowerbikey=$funcKey
    }
    # Storage Account
    $ROOT_FILE_URL = "https://$StorageAccount.blob.core.windows.net/$StorageContainer/temp"
    Write-Host "Remote Template URL: $ROOT_FILE_URL"

    Write-Host "**DEPLOYMENT**"
    $CONNECTION = $(az storage account show-connection-string `
            --resource-group $ResourceGroup `
            --name $StorageAccount `
            --query connectionString)

    $END = (Get-Date).AddMinutes(5).ToString("yyyy-MM-ddTHH:mmZ")
    $SAS = $(az storage container generate-sas -n $StorageContainer --https-only --permissions dlrw --expiry $END --connection-string $CONNECTION -o tsv)

    $masterTemplate = "$ROOT_FILE_URL/ApimArm-master.template.json?$SAS"

    New-AzResourceGroupDeployment `
        -DeploymentName "PowerBIAPIM" `
        -ResourceGroupName $ResourceGroup `
        -TemplateUri $masterTemplate `
        -ApimServiceName $ApimName `
        -LinkedTemplatesBaseUrl $ROOT_FILE_URL `
        -LinkedTemplatesSasToken "?$SAS" `
        -PolicyXMLBaseUrl "$ROOT_FILE_URL/policies" `
        -PolicyXMLSasToken "?$SAS" `
        -NamedValues $namedValues `
        -FunctionBackendName $FunctionName
}

Upload-Templates

Deploy-Templates