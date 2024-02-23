# ALZ Bicep - Spoke Networking module

This module creates spoke networking resources

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into.
parDisableBgpRoutePropagation | No       | Switch to enable/disable BGP Propagation on route table.
parDdosProtectionPlanId | No       | Id of the DdosProtectionPlan which will be applied to the Virtual Network.
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parSpokeNetworkAddressPrefix | No       | The IP address range for all virtual networks to use.
parSpokeNetworkName | No       | The Name of the Spoke Virtual Network.
parSpokeNetworkLock | No       | Resource Lock Configuration for Spoke Network  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet.
parNextHopIpAddress | No       | IP Address where network traffic should route to leveraged with DNS Proxy.
parSpokeToHubRouteTableName | No       | Name of Route table to create for the default route of Hub.
parSpokeRouteTableLock | No       | Resource Lock Configuration for Spoke Network Route Table.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table.

- Default value: `False`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Id of the DdosProtectionPlan which will be applied to the Virtual Network.

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parSpokeNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for all virtual networks to use.

- Default value: `10.11.0.0/16`

### parSpokeNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Name of the Spoke Virtual Network.

- Default value: `vnet-spoke`

### parSpokeNetworkLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Spoke Network

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Spoke Networking Module.}`

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet.

### parNextHopIpAddress

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

IP Address where network traffic should route to leveraged with DNS Proxy.

### parSpokeToHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub.

- Default value: `rtb-spoke-to-hub`

### parSpokeRouteTableLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Spoke Network Route Table.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Spoke Networking Module.}`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

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
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parSpokeNetworkAddressPrefix": {
            "value": "10.11.0.0/16"
        },
        "parSpokeNetworkName": {
            "value": "vnet-spoke"
        },
        "parSpokeNetworkLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Spoke Networking Module."
            }
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
        "parSpokeRouteTableLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Spoke Networking Module."
            }
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
