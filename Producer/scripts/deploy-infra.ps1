param (
    [Parameter()] [string] $ClientPrefix,
    [Parameter()] [string] $Env,
    [Parameter()] [string] $AadObjectId
)
$ClientPrefix = $ClientPrefix.ToLower()
$Env = $Env.ToLower()
$RESOURCE_GROUP="$ClientPrefix-syd-$Env-arg-powerbi"
$LOCATION="australiaeast"

az group create -n $RESOURCE_GROUP -l $LOCATION
Write-Host "$RESOURCE_GROUP deployment"
$out=(az deployment group create --template-file "infra\infra.bicep" `
    --resource-group $RESOURCE_GROUP `
    --parameters clientPrefix=$ClientPrefix `
    --parameters env=$Env `
    --parameters aadObjectId=$AadObjectId `
    --verbose)

