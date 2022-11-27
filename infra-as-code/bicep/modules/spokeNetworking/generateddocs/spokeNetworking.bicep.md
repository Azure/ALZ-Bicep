# ALZ Bicep - Spoke Networking module

This module creates spoke networking resources

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into. Default: resourceGroup().location
parDisableBgpRoutePropagation | No       | Switch to enable/disable BGP Propagation on route table. Default: false
parDdosProtectionPlanId | No       | Id of the DdosProtectionPlan which will be applied to the Virtual Network. Default: Empty String
parSpokeNetworkAddressPrefix | No       | The IP address range for all virtual networks to use. Default: 10.11.0.0/16
parSpokeNetworkName | No       | The Name of the Spoke Virtual Network. Default: vnet-spoke
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet. Default: Empty Array
parNextHopIpAddress | No       | IP Address where network traffic should route to leveraged with DNS Proxy. Default: Empty String
parSpokeToHubRouteTableName | No       | Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub
parTags        | No       | Tags you would like to be applied to all resources in this module. Default: Empty Object
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into. Default: resourceGroup().location

- Default value: `[resourceGroup().location]`

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table. Default: false

- Default value: `False`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Id of the DdosProtectionPlan which will be applied to the Virtual Network. Default: Empty String

### parSpokeNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for all virtual networks to use. Default: 10.11.0.0/16

- Default value: `10.11.0.0/16`

### parSpokeNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Name of the Spoke Virtual Network. Default: vnet-spoke

- Default value: `vnet-spoke`

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet. Default: Empty Array

### parNextHopIpAddress

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

IP Address where network traffic should route to leveraged with DNS Proxy. Default: Empty String

### parSpokeToHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub

- Default value: `rtb-spoke-to-hub`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module. Default: Empty Object

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outSpokeVirtualNetworkName | string |
outSpokeVirtualNetworkId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/spokeNetworking/spokeNetworking.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parDisableBgpRoutePropagation": {
            "value": false
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parSpokeNetworkAddressPrefix": {
            "value": "10.11.0.0/16"
        },
        "parSpokeNetworkName": {
            "value": "vnet-spoke"
        },
        "parDnsServerIps": {
            "value": []
        },
        "parNextHopIpAddress": {
            "value": ""
        },
        "parSpokeToHubRouteTableName": {
            "value": "rtb-spoke-to-hub"
        },
        "parTags": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
