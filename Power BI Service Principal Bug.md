# Power BI Service Principal Bug

## Setting via AZ CLI
Setting an App Registration permission for Power BI Service Tenant.ReadWrite.All does not work.

```sh
spName=sp-powerbi-automation
sp=$(az ad sp list --display-name "Power BI Service" | jq ".[0]")
pbiAppId=$(echo $sp | jq ".appId" -r)
tenantReadWriteAll=$(echo $sp | jq '.oauth2Permissions[] | select(.value == "Tenant.ReadWrite.All").id' -r)
appReg=$(az ad sp create-for-rbac -n $spName --skip-assignment true --years 1)
appId=$(echo $appReg | jq '.appId' -r)
az ad app permission add --id $appId --api-permissions "${tenantReadWriteAll}=Role" --api $pbiAppId
az ad app permission grant --id $appId --api $pbiAppId
```

### Issues
**d594897b-76e7-4b2b-984b-b4adff35e109** is the api-permission for `Tenant.ReadWrite.All`

When this is set as an Application Permission Type "Role", the permission cannot be granted as the Azure Portal doesn't recognise it as a valid Permision for the API. The assignment shows the permission GUID and not the Power BI Service name.

When this is set as an Delegated Permission Type "Scope", the assignment shows correctly in the Azure Portal however this permission is not valid for type Scope.

## Setting via Azure Portal
When `Tenant.ReadWrite.All` is set as an Application Permission (Type "Role") via the Azure Portal it is possible to grant the permission as a Global Administrator. 

When calling the Power BI API using a valid token, unuathorized is returned.

Retreiving the permission assignment via `az ad app show` shows:

```json
"requiredResourceAccess": [
    {
      "additionalProperties": null,
      "resourceAccess": [
        {
          "additionalProperties": null,
          "id": "28379fa9-8596-4fd9-869e-cb60a93b5d84",
          "type": "Role"
        }
      ],
      "resourceAppId": "00000009-0000-0000-c000-000000000000"
    }
  ],
```
Searching for a valid permission matching **28379fa9-8596-4fd9-869e-cb60a93b5d84** in "Power BI Service" via the following command returns no result:

```sh
az ad sp list --display-name "Power BI Service" | \
jq '.[0].oauth2Permissions[] | select(.id == "28379fa9-8596-4fd9-869e-cb60a93b5d84")'
```