# hubVirtualNetworkConnection

[Azure Landing Zones - Bicep Modules](..)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parVirtualWanHubResourceId | Yes      | Virtual WAN Hub resource ID. No default
parRemoteVirtualNetworkResourceId | Yes      | Remote Spoke virtual network resource ID. No default

### parVirtualWanHubResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual WAN Hub resource ID. No default

### parRemoteVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Remote Spoke virtual network resource ID. No default

## Outputs

Name | Type | Description
---- | ---- | -----------
outHubVirtualNetworkConnectionName | string |
outHubVirtualNetworkConnectionResourceId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/vnetPeeringVwan/hubVirtualNetworkConnection.json"
    },
    "parameters": {
        "parVirtualWanHubResourceId": {
            "value": ""
        },
        "parRemoteVirtualNetworkResourceId": {
            "value": ""
        }
    }
}
```
