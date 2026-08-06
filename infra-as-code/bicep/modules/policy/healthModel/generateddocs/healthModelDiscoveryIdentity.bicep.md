# ALZ Bicep - CloudHealth Discovery Identity

Preview (experimental): creates the user-assigned managed identity used by CloudHealth discovery rules.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parIdentityName | No       | Name of the user-assigned managed identity used by the discovery rules.
parLocation    | No       | Location for the user-assigned managed identity.

### parIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the user-assigned managed identity used by the discovery rules.

- Default value: `id-ahm-discovery`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for the user-assigned managed identity.

- Default value: `[resourceGroup().location]`

## Outputs

Name | Type | Description
---- | ---- | -----------
outIdentityId | string | Resource ID of the discovery user-assigned managed identity.
outPrincipalId | string | Principal ID of the discovery user-assigned managed identity.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelDiscoveryIdentity.json"
    },
    "parameters": {
        "parIdentityName": {
            "value": "id-ahm-discovery"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        }
    }
}
```
