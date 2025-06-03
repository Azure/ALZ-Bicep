# ALZ Bicep - Azure vWAN Connectivity Module

Module used to set up vWAN Connectivity

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Region in which the resource group was created.
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names.
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVirtualHubEnabled | No       | Switch to enable/disable Virtual Hub deployment.
parVirtualWanName | No       | Prefix Used for Virtual WAN.
parVirtualWanType | No       | The type of Virtual WAN to create.
parVirtualWanLock | No       | Resource Lock Configuration for Virtual WAN.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVirtualWanHubName | No       | Prefix Used for Virtual WAN Hub.
parVirtualWanHubDefaultRouteName | No       | The name of the route table that manages routing between the Virtual WAN Hub and the Azure Firewall.
parVirtualWanHubs | No       | Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.  - `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub. - `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub. - `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub. - `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use. - `parHubLocation` - The Virtual WAN Hub location. - `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`. - `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50. - `parVirtualHubRoutingIntentDestinations` - The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.  
parVpnGatewayLock | No       | Resource Lock Configuration for Virtual WAN Hub VPN Gateway.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parExpressRouteGatewayLock | No       | Resource Lock Configuration for Virtual WAN Hub ExpressRoute Gateway.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVirtualWanHubsLock | No       | Resource Lock Configuration for Virtual WAN Hub.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVpnGatewayName | No       | VPN Gateway Name.
parExpressRouteGatewayName | No       | ExpressRoute Gateway Name.
parAzFirewallName | No       | Azure Firewall Name.
parAzFirewallPolicyDeploymentStyle | No       | The deployment style of the Azure Firewall Policy. Either one shared firewall policy (`SharedGlobal`) or one policy per region (`PerRegion`), defaults to `SharedGlobal`.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name. This is used to automatically generate a name for the Azure Firewall Policy following concat of the pattern `parAzFirewallPoliciesName-hub.parHubLocation` if you want to provide a true custom name then specify a value in each object in the array of `parVirtualWanHubs.parAzFirewallPolicyCustomName`.
parAzFirewallPoliciesAutoLearn | No       | The operation mode for automatically learning private ranges to not be SNAT.
parAzFirewallPoliciesPrivateRanges | No       | Private IP addresses/IP ranges to which traffic will not be SNAT.
parAzureFirewallLock | No       | Resource Lock Configuration for Azure Firewall.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVpnGatewayScaleUnit | No       | The scale unit for this VPN Gateway.
parExpressRouteGatewayScaleUnit | No       | The scale unit for this ExpressRoute Gateway.
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment.
parDdosPlanName | No       | DDoS Plan Name.
parDdosLock    | No       | Resource Lock Configuration for DDoS Plan.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment.
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones.
parPrivateDnsZones | No       | Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones, baked into underlying AVM module see: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones
parVirtualNetworkResourceIdsToLinkTo | No       | Array of Resource IDs of VNets to link to Private DNS Zones.
parPrivateDNSZonesLock | No       | Resource Lock Configuration for Private DNS Zone(s).  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Region in which the resource group was created.

- Default value: `[resourceGroup().location]`

### parCompanyPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix value which will be prepended to all resource names.

- Default value: `alz`

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parVirtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Hub deployment.

- Default value: `True`

### parVirtualWanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN.

- Default value: `[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parVirtualWanType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The type of Virtual WAN to create.

- Default value: `Standard`

### parVirtualWanLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual WAN.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parVirtualWanHubName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN Hub.

- Default value: `[format('{0}-vhub', parameters('parCompanyPrefix'))]`

### parVirtualWanHubDefaultRouteName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the route table that manages routing between the Virtual WAN Hub and the Azure Firewall.

- Default value: `default-to-azfw`

### parVirtualWanHubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `parHubLocation` - The Virtual WAN Hub location.
- `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`.
- `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.
- `parVirtualHubRoutingIntentDestinations` - The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.



### parVpnGatewayLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual WAN Hub VPN Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parExpressRouteGatewayLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual WAN Hub ExpressRoute Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parVirtualWanHubsLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual WAN Hub.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parVpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

VPN Gateway Name.

- Default value: `[format('{0}-vpngw', parameters('parCompanyPrefix'))]`

### parExpressRouteGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

ExpressRoute Gateway Name.

- Default value: `[format('{0}-ergw', parameters('parCompanyPrefix'))]`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-fw', parameters('parCompanyPrefix'))]`

### parAzFirewallPolicyDeploymentStyle

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The deployment style of the Azure Firewall Policy. Either one shared firewall policy (`SharedGlobal`) or one policy per region (`PerRegion`), defaults to `SharedGlobal`.

- Default value: `SharedGlobal`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name. This is used to automatically generate a name for the Azure Firewall Policy following concat of the pattern `parAzFirewallPoliciesName-hub.parHubLocation` if you want to provide a true custom name then specify a value in each object in the array of `parVirtualWanHubs.parAzFirewallPolicyCustomName`.

- Default value: `[format('{0}-azfwpolicy', parameters('parCompanyPrefix'))]`

### parAzFirewallPoliciesAutoLearn

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The operation mode for automatically learning private ranges to not be SNAT.

- Default value: `Disabled`

### parAzFirewallPoliciesPrivateRanges

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Private IP addresses/IP ranges to which traffic will not be SNAT.

- Allowed values: `Disabled`, `Enabled`

### parAzureFirewallLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Azure Firewall.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parVpnGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this VPN Gateway.

- Default value: `1`

### parExpressRouteGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this ExpressRoute Gateway.

- Default value: `1`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment.

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name.

- Default value: `[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]`

### parDdosLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for DDoS Plan.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parPrivateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Private DNS Zones deployment.

- Default value: `True`

### parPrivateDnsZonesResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Name for Private DNS Zones.

- Default value: `[resourceGroup().name]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones, baked into underlying AVM module see: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones

### parVirtualNetworkResourceIdsToLinkTo

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Resource IDs of VNets to link to Private DNS Zones.

### parPrivateDNSZonesLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Private DNS Zone(s).

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep vWAN Connectivity Module.}`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outVirtualWanName | string |
outVirtualWanId | string |
outVirtualHubName | array |
outVirtualHubId | array |
outDdosPlanResourceId | string |
outPrivateDnsZones | array |
outPrivateDnsZonesNames | array |
outAzFwPrivateIps | array |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/vwanConnectivity/vwanConnectivity.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parCompanyPrefix": {
            "value": "alz"
        },
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parVirtualHubEnabled": {
            "value": true
        },
        "parVirtualWanName": {
            "value": "[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parVirtualWanType": {
            "value": "Standard"
        },
        "parVirtualWanLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parVirtualWanHubName": {
            "value": "[format('{0}-vhub', parameters('parCompanyPrefix'))]"
        },
        "parVirtualWanHubDefaultRouteName": {
            "value": "default-to-azfw"
        },
        "parVirtualWanHubs": {
            "value": [
                {
                    "parVpnGatewayEnabled": true,
                    "parExpressRouteGatewayEnabled": true,
                    "parAzFirewallEnabled": true,
                    "parVirtualHubAddressPrefix": "10.100.0.0/23",
                    "parHubLocation": "[parameters('parLocation')]",
                    "parHubRoutingPreference": "ExpressRoute",
                    "parVirtualRouterAutoScaleConfiguration": 2,
                    "parVirtualHubRoutingIntentDestinations": [],
                    "parAzFirewallDnsProxyEnabled": true,
                    "parAzFirewallDnsServers": [],
                    "parAzFirewallIntelMode": "Alert",
                    "parAzFirewallTier": "Standard",
                    "parAzFirewallAvailabilityZones": [],
                    "parSidecarVirtualNetwork": {
                        "sidecarVirtualNetworkEnabled": true,
                        "addressPrefixes": [
                            "10.101.0.0/24"
                        ]
                    }
                }
            ]
        },
        "parVpnGatewayLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parExpressRouteGatewayLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parVirtualWanHubsLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parVpnGatewayName": {
            "value": "[format('{0}-vpngw', parameters('parCompanyPrefix'))]"
        },
        "parExpressRouteGatewayName": {
            "value": "[format('{0}-ergw', parameters('parCompanyPrefix'))]"
        },
        "parAzFirewallName": {
            "value": "[format('{0}-fw', parameters('parCompanyPrefix'))]"
        },
        "parAzFirewallPolicyDeploymentStyle": {
            "value": "SharedGlobal"
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-azfwpolicy', parameters('parCompanyPrefix'))]"
        },
        "parAzFirewallPoliciesAutoLearn": {
            "value": "Disabled"
        },
        "parAzFirewallPoliciesPrivateRanges": {
            "value": []
        },
        "parAzureFirewallLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parVpnGatewayScaleUnit": {
            "value": 1
        },
        "parExpressRouteGatewayScaleUnit": {
            "value": 1
        },
        "parDdosEnabled": {
            "value": true
        },
        "parDdosPlanName": {
            "value": "[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]"
        },
        "parDdosLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
            }
        },
        "parPrivateDnsZonesEnabled": {
            "value": true
        },
        "parPrivateDnsZonesResourceGroup": {
            "value": "[resourceGroup().name]"
        },
        "parPrivateDnsZones": {
            "value": []
        },
        "parVirtualNetworkResourceIdsToLinkTo": {
            "value": []
        },
        "parPrivateDNSZonesLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep vWAN Connectivity Module."
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
