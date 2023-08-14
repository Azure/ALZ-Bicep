# ALZ Bicep - Virtual Network Peering to vWAN

Module used to set up Virtual Network Peering from Virtual Network back to vWAN

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parVirtualWanHubResourceId | Yes      | Virtual WAN Hub resource ID.
parRemoteVirtualNetworkResourceId | Yes      | Remote Spoke virtual network resource ID.
parVirtualHubConnectionPrefix | No       | Optional Virtual Hub Connection Name Prefix.
parVirtualHubConnectionSuffix | No       | Optional Virtual Hub Connection Name Suffix. Example: -vhc
parEnableInternetSecurity | No       | Enable Internet Security for the Virtual Hub Connection.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parVirtualWanHubResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual WAN Hub resource ID.

### parRemoteVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Remote Spoke virtual network resource ID.

### parVirtualHubConnectionPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Virtual Hub Connection Name Prefix.

### parVirtualHubConnectionSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Virtual Hub Connection Name Suffix. Example: -vhc

- Default value: `-vhc`

### parEnableInternetSecurity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enable Internet Security for the Virtual Hub Connection.

- Default value: `False`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `False`

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
        "template": "infra-as-code/bicep/modules/vnetPeeringVwan/vnetPeeringVwan.json"
    },
    "parameters": {
        "parVirtualWanHubResourceId": {
            "value": ""
        },
        "parRemoteVirtualNetworkResourceId": {
            "value": ""
        },
        "parVirtualHubConnectionPrefix": {
            "value": ""
        },
        "parVirtualHubConnectionSuffix": {
            "value": "-vhc"
        },
        "parEnableInternetSecurity": {
            "value": false
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
