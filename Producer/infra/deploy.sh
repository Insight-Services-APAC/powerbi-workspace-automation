RESOURCE_GROUP="hss-syd-dev-arg-powerbi"
LOCATION="australiaeast"

az group create -n $RESOURCE_GROUP -l $LOCATION
az deployment group create --template-file "infra.bicep" --resource-group $RESOURCE_GROUP --verbose
