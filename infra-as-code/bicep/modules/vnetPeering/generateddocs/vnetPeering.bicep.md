# ALZ Bicep - Virtual Network Peering module

Module used to set up Virtual Network Peering between Virtual Networks

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parDestinationVirtualNetworkId | Yes      | Virtual Network ID of Virtual Network destination.
parSourceVirtualNetworkName | Yes      | Name of source Virtual Network we are peering.
parDestinationVirtualNetworkName | Yes      | Name of destination virtual network we are peering.
parAllowVirtualNetworkAccess | No       | Switch to enable/disable Virtual Network Access for the Network Peer.
parAllowForwardedTraffic | No       | Switch to enable/disable forwarded traffic for the Network Peer.
parAllowGatewayTransit | No       | Switch to enable/disable gateway transit for the Network Peer.
parUseRemoteGateways | No       | Switch to enable/disable remote gateway for the Network Peer.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parDestinationVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual Network ID of Virtual Network destination.

### parSourceVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of source Virtual Network we are peering.

### parDestinationVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of destination virtual network we are peering.

### parAllowVirtualNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Network Access for the Network Peer.

- Default value: `True`

### parAllowForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable forwarded traffic for the Network Peer.

- Default value: `True`

### parAllowGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable gateway transit for the Network Peer.

- Default value: `False`

### parUseRemoteGateways

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable remote gateway for the Network Peer.

- Default value: `False`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/vnetPeering/vnetPeering.json"
    },
    "parameters": {
        "parDestinationVirtualNetworkId": {
            "value": ""
        },
        "parSourceVirtualNetworkName": {
            "value": ""
        },
        "parDestinationVirtualNetworkName": {
            "value": ""
        },
        "parAllowVirtualNetworkAccess": {
            "value": true
        },
        "parAllowForwardedTraffic": {
            "value": true
        },
        "parAllowGatewayTransit": {
            "value": false
        },
        "parUseRemoteGateways": {
            "value": false
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
