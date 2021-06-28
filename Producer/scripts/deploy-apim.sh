#!/bin/bash

echo "*********VARIABLES*********"
CONTAINER="templates"
REMOTE_TEMPLATE_PATH="temp"
# APIM Variables
echo "APIM Name: $(APIM_NAME)"
echo "Resource Group: $(RESOURCE_GROUP)"
echo "Storage Account: $(STORAGE_ACCOUNT)"
echo "Function App: $(FUNCTION_APP)"
echo "Template Path: $(LOCAL_TEMPLATE_DIRECTORY)"
ROOT_FILE_URL="https://$(STORAGE_ACCOUNT).blob.core.windows.net/$CONTAINER/$REMOTE_TEMPLATE_PATH"
echo "Remote Template URL: $ROOT_FILE_URL"

echo "*********CONNECTION*********"
CONNECTION=$(az storage account show-connection-string \
    --resource-group $(RESOURCE_GROUP) \
    --name $(STORAGE_ACCOUNT) \
    --query connectionString)



echo "*********UPLOAD*********"
output=$(az storage blob upload-batch \
    --destination $CONTAINER \
    --source "$LOCAL_TEMPLATE_DIRECTORY/" \
    --destination-path $REMOTE_TEMPLATE_PATH \
    --connection-string $CONNECTION)




echo "*********DEPLOYMENT VARIABLES*********"
sed -i "s/test-syd-dev-fun-powerbi/$(FUNCTION_APP)/g" LOCAL_TEMPLATE_DIRECTORY/policies/*.xml

$FUNC_KEY = $(az functionapp keys list --name $(FUNCTION_APP) `
    --resource-group $(RESOURCE_GROUP) `
    --query "functionKeys.default" -o tsv)
NAMED_VALUES = "{\"hsssyddevfunpowerbikey\": \"$FUNC_KEY\"}"




echo *********DEPLOYMENT*********"

END=`date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ'`
SAS=`az storage container generate-sas -n $CONTAINER --https-only --permissions dlrw --expiry $END --connection-string $CONNECTION -o tsv`

az deployment group create \
  --resource-group $(RESOURCE_GROUP) \
  --template-uri "$ROOT_FILE_URL/ApimArm-master.template.json?$SAS" \
  --parameters "ApimServiceName=$APIM_NAME" \
  --parameters "LinkedTemplatesBaseUrl=$ROOT_FILE_URL" \
  --parameters "LinkedTemplatesSasToken=?$SAS" \
  --parameters "PolicyXMLBaseUrl=$ROOT_FILE_URL/policies" \
  --parameters "PolicyXMLSasToken=?$SAS" \
  --parameters "NamedValues=$NAMED_VALUES" \
  --parameters "FunctionBackendName=$(FUNCTION_APP)" \
  --verbose