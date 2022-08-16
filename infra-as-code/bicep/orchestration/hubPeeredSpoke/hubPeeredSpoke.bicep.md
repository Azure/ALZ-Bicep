# hubPeeredSpoke

[Azure Landing Zones - Bicep Modules](..)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The region to deploy all resources into. DEFAULTS TO deployment().location
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy. DEFAULTS TO = alz
parPeeredVnetSubscriptionId | No       | Subscription Id to the Virtual Network Hub object. DEFAULTS TO empty
parTags        | No       | Array of Tags to be applied to all resources in module. Default: empty array
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry DEFAULTS TO = false
parPeeredVnetSubscriptionMgPlacement | No       | The Management Group Id to place the subscription in. DEFAULTS TO empty
parResourceGroupNameForSpokeNetworking | No       | Name of Resource Group to be created to contain spoke networking resources like the virtual network.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-spoke-networking
parDdosProtectionPlanId | No       | Existing DDoS Protection plan to utilize. Default: Empty string
parSpokeNetworkName | No       | The Name of the Spoke Virtual Network. Default: vnet-spoke
parSpokeNetworkAddressPrefix | No       | CIDR for Spoke Network. Default: 10.11.0.0/16
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet. Default: Empty Array
parNextHopIpAddress | No       | IP Address where network traffic should route to. Default: Empty string
parDisableBgpRoutePropagation | No       | Switch which allows BGP Route Propogation to be disabled on the route table
parSpokeToHubRouteTableName | No       | Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub
parHubVirtualNetworkId | Yes      | Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID. No default
parAllowSpokeForwardedTraffic | No       | Switch to enable/disable forwarded Traffic from outside spoke network. Default = false
parAllowHubVpnGatewayTransit | No       | Switch to enable/disable VPN Gateway for the hub network peering. Default = false

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region to deploy all resources into. DEFAULTS TO deployment().location

- Default value: `[deployment().location]`

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy. DEFAULTS TO = alz

- Default value: `alz`

### parPeeredVnetSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription Id to the Virtual Network Hub object. DEFAULTS TO empty

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Tags to be applied to all resources in module. Default: empty array

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry DEFAULTS TO = false

- Default value: `False`

### parPeeredVnetSubscriptionMgPlacement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Management Group Id to place the subscription in. DEFAULTS TO empty

### parResourceGroupNameForSpokeNetworking

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Resource Group to be created to contain spoke networking resources like the virtual network.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-spoke-networking

- Default value: `[format('{0}-{1}-spoke-networking', parameters('parTopLevelManagementGroupPrefix'), parameters('parLocation'))]`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Existing DDoS Protection plan to utilize. Default: Empty string

### parSpokeNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Name of the Spoke Virtual Network. Default: vnet-spoke

- Default value: `vnet-spoke`

### parSpokeNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

CIDR for Spoke Network. Default: 10.11.0.0/16

- Default value: `10.11.0.0/16`

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet. Default: Empty Array

### parNextHopIpAddress

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

IP Address where network traffic should route to. Default: Empty string

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch which allows BGP Route Propogation to be disabled on the route table

- Default value: `False`

### parSpokeToHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub

- Default value: `rtb-spoke-to-hub`

### parHubVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID. No default

### parAllowSpokeForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable forwarded Traffic from outside spoke network. Default = false

- Default value: `False`

### parAllowHubVpnGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN Gateway for the hub network peering. Default = false

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
        "template": "infra-as-code/bicep/orchestration/hubPeeredSpoke/hubPeeredSpoke.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[deployment().location]"
        },
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parPeeredVnetSubscriptionId": {
            "value": ""
        },
        "parTags": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parPeeredVnetSubscriptionMgPlacement": {
            "value": ""
        },
        "parResourceGroupNameForSpokeNetworking": {
            "value": "[format('{0}-{1}-spoke-networking', parameters('parTopLevelManagementGroupPrefix'), parameters('parLocation'))]"
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parSpokeNetworkName": {
            "value": "vnet-spoke"
        },
        "parSpokeNetworkAddressPrefix": {
            "value": "10.11.0.0/16"
        },
        "parDnsServerIps": {
            "value": []
        },
        "parNextHopIpAddress": {
            "value": ""
        },
        "parDisableBgpRoutePropagation": {
            "value": false
        },
        "parSpokeToHubRouteTableName": {
            "value": "rtb-spoke-to-hub"
        },
        "parHubVirtualNetworkId": {
            "value": ""
        },
        "parAllowSpokeForwardedTraffic": {
            "value": false
        },
        "parAllowHubVpnGatewayTransit": {
            "value": false
        }
    }
}
```
