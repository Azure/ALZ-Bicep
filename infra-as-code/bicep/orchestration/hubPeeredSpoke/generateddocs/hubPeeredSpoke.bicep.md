# ALZ Bicep - Orchestration - Hub Peered Spoke

Orchestration module used to create and configure a spoke network to deliver the Azure Landing Zone Hub & Spoke architecture

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The region to deploy all resources into.
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parPeeredVnetSubscriptionId | No       | Subscription Id to the Virtual Network Hub object. Default: Empty String
parTags        | No       | Array of Tags to be applied to all resources in module. Default: Empty Object
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPeeredVnetSubscriptionMgPlacement | No       | The Management Group Id to place the subscription in. Default: Empty String
parResourceGroupNameForSpokeNetworking | No       | Name of Resource Group to be created to contain spoke networking resources like the virtual network.
parResourceGroupLock | No       | Resource Group Lock Configuration.
parDdosProtectionPlanId | No       | Existing DDoS Protection plan to utilize. Default: Empty string
parPrivateDnsZoneResourceIds | No       | The Resource IDs of the Private DNS Zones to associate with spokes. Default: Empty Array
parSpokeNetworkName | No       | The Name of the Spoke Virtual Network.
parSpokeNetworkAddressPrefix | No       | CIDR for Spoke Network.
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet. Default: Empty Array
parNextHopIpAddress | No       | IP Address where network traffic should route to. Default: Empty string
parDisableBgpRoutePropagation | No       | Switch which allows BGP Route Propogation to be disabled on the route table.
parSpokeToHubRouteTableName | No       | Name of Route table to create for the default route of Hub.
parSpokeNetworkLock | No       | Resource Lock Configuration for Spoke Network.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parSpokeRouteTableLock | No       | Resource Lock Configuration for Spoke Network Route Table.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPrivateDnsZoneVirtualNetworkLinkLock | No       | Resource Lock Configuration for Private DNS Virtual Network Network Links.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parHubVirtualNetworkId | Yes      | Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID.
parAllowSpokeForwardedTraffic | No       | Switch to enable/disable forwarded Traffic from outside spoke network.
parAllowHubVpnGatewayTransit | No       | Switch to enable/disable VPN Gateway for the hub network peering.
parVirtualHubConnectionPrefix | No       | Optional Virtual Hub Connection Name Prefix.
parVirtualHubConnectionSuffix | No       | Optional Virtual Hub Connection Name Suffix. Example: -vhc
parEnableInternetSecurity | No       | Enable Internet Security for the Virtual Hub Connection.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region to deploy all resources into.

- Default value: `[deployment().location]`

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parPeeredVnetSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription Id to the Virtual Network Hub object. Default: Empty String

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Tags to be applied to all resources in module. Default: Empty Object

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module.}`

### parPeeredVnetSubscriptionMgPlacement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Management Group Id to place the subscription in. Default: Empty String

### parResourceGroupNameForSpokeNetworking

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Resource Group to be created to contain spoke networking resources like the virtual network.

- Default value: `[format('{0}-{1}-spoke-networking', parameters('parTopLevelManagementGroupPrefix'), parameters('parLocation'))]`

### parResourceGroupLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Lock Configuration.

- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module.}`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Existing DDoS Protection plan to utilize. Default: Empty string

### parPrivateDnsZoneResourceIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Resource IDs of the Private DNS Zones to associate with spokes. Default: Empty Array

### parSpokeNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Name of the Spoke Virtual Network.

- Default value: `vnet-spoke`

### parSpokeNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

CIDR for Spoke Network.

- Default value: `10.11.0.0/16`

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet. Default: Empty Array

### parNextHopIpAddress

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

IP Address where network traffic should route to. Default: Empty string

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch which allows BGP Route Propogation to be disabled on the route table.

- Default value: `False`

### parSpokeToHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub.

- Default value: `rtb-spoke-to-hub`

### parSpokeNetworkLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Spoke Network.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module.}`

### parSpokeRouteTableLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Spoke Network Route Table.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module.}`

### parPrivateDnsZoneVirtualNetworkLinkLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Private DNS Virtual Network Network Links.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module.}`

### parHubVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID.

### parAllowSpokeForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable forwarded Traffic from outside spoke network.

- Default value: `False`

### parAllowHubVpnGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN Gateway for the hub network peering.

- Default value: `False`

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
        "parTopLevelManagementGroupSuffix": {
            "value": ""
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
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module."
            }
        },
        "parPeeredVnetSubscriptionMgPlacement": {
            "value": ""
        },
        "parResourceGroupNameForSpokeNetworking": {
            "value": "[format('{0}-{1}-spoke-networking', parameters('parTopLevelManagementGroupPrefix'), parameters('parLocation'))]"
        },
        "parResourceGroupLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module."
            }
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parPrivateDnsZoneResourceIds": {
            "value": []
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
        "parSpokeNetworkLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module."
            }
        },
        "parSpokeRouteTableLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module."
            }
        },
        "parPrivateDnsZoneVirtualNetworkLinkLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Peered Spoke Orchestration Networking Module."
            }
        },
        "parHubVirtualNetworkId": {
            "value": ""
        },
        "parAllowSpokeForwardedTraffic": {
            "value": false
        },
        "parAllowHubVpnGatewayTransit": {
            "value": false
        },
        "parVirtualHubConnectionPrefix": {
            "value": ""
        },
        "parVirtualHubConnectionSuffix": {
            "value": "-vhc"
        },
        "parEnableInternetSecurity": {
            "value": false
        }
    }
}
```
