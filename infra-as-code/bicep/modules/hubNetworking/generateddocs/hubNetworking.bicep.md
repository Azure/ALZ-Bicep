# ALZ Bicep - Hub Networking Module

ALZ Bicep Module used to set up Hub Networking

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into.
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names.
parHubNetworkName | No       | Name for Hub Network.
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parHubNetworkAddressPrefix | No       | The IP address range for Hub Network.
parSubnets     | No       | The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet.
parVirtualNetworkLock | No       | Resource Lock Configuration for Virtual Network.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPublicIpSku | No       | Public IP Address SKU.
parPublicIpPrefix | No       | Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-
parPublicIpSuffix | No       | Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix
parAzBastionEnabled | No       | Switch to enable/disable Azure Bastion deployment.
parAzBastionName | No       | Name Associated with Bastion Service.
parAzBastionSku | No       | Azure Bastion SKU.
parAzBastionTunneling | No       | Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client
parAzBastionNsgName | No       | Name for Azure Bastion Subnet NSG.
parBastionLock | No       | Resource Lock Configuration for Bastion.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment.
parDdosPlanName | No       | DDoS Plan Name.
parDdosLock    | No       | Resource Lock Configuration for DDoS Plan.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parAzFirewallEnabled | No       | Switch to enable/disable Azure Firewall deployment.
parAzFirewallName | No       | Azure Firewall Name.
parAzFirewallPoliciesEnabled | No       | Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name.
parAzFirewallPoliciesAutoLearn | No       | The operation mode for automatically learning private ranges to not be SNAT.
parAzFirewallPoliciesPrivateRanges | No       | Private IP addresses/IP ranges to which traffic will not be SNAT.
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parAzFirewallIntelMode | No       | The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.
parAzFirewallCustomPublicIps | No       | Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parAzErGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzVpnGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy.
parAzFirewallDnsServers | No       | Array of custom DNS servers used by Azure Firewall
parAzureFirewallLock | No       |  Resource Lock Configuration for Azure Firewall.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parHubRouteTableName | No       | Name of Route table to create for the default route of Hub.
parDisableBgpRoutePropagation | No       | Switch to enable/disable BGP Propagation on route table.
parHubRouteTableLock | No       | Resource Lock Configuration for Hub Route Table.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment.
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones.
parPrivateDnsZones | No       | Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones
parPrivateDnsZoneAutoMergeAzureBackupZone | No       | Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.
parVirtualNetworkIdToLinkFailover | No       | Resource ID of Failover VNet for Private DNS Zone VNet Failover Links
parPrivateDNSZonesLock | No       | Resource Lock Configuration for Private DNS Zone(s).  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVpnGatewayEnabled | No       | Switch to enable/disable VPN virtual network gateway deployment.
parVpnGatewayConfig | No       | Configuration for VPN virtual network gateway to be deployed.
parExpressRouteGatewayEnabled | No       | Switch to enable/disable ExpressRoute virtual network gateway deployment.
parExpressRouteGatewayConfig | No       | Configuration for ExpressRoute virtual network gateway to be deployed.
parVirtualNetworkGatewayLock | No       | Resource Lock Configuration for ExpressRoute Virtual Network Gateway.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.
parBastionOutboundSshRdpPorts | No       | Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parCompanyPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix value which will be prepended to all resource names.

- Default value: `alz`

### parHubNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Hub Network.

- Default value: `[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parHubNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for Hub Network.

- Default value: `10.10.0.0/16`

### parSubnets

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.

- Default value: `   `

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet.

### parVirtualNetworkLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual Network.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parPublicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parPublicIpPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-

### parPublicIpSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix

- Default value: `-PublicIP`

### parAzBastionEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Bastion deployment.

- Default value: `True`

### parAzBastionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name Associated with Bastion Service.

- Default value: `[format('{0}-bastion', parameters('parCompanyPrefix'))]`

### parAzBastionSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Bastion SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parAzBastionTunneling

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client

- Default value: `False`

### parAzBastionNsgName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Azure Bastion Subnet NSG.

- Default value: `nsg-AzureBastionSubnet`

### parBastionLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Bastion.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

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



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parAzFirewallEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall deployment.

- Default value: `True`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.

- Default value: `True`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name.

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesAutoLearn

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The operation mode for automatically learning private ranges to not be SNAT.

- Default value: `Disabled`

### parAzFirewallPoliciesPrivateRanges

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Private IP addresses/IP ranges to which traffic will not be SNAT.

- Allowed values: `Disabled`, `Enabled`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallIntelMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.

- Default value: `Alert`

- Allowed values: `Alert`, `Deny`, `Off`

### parAzFirewallCustomPublicIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzErGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzVpnGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy.

- Default value: `True`

### parAzFirewallDnsServers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS servers used by Azure Firewall

### parAzureFirewallLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

 Resource Lock Configuration for Azure Firewall.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub.

- Default value: `[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]`

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table.

- Default value: `False`

### parHubRouteTableLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Hub Route Table.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

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

Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azuredatabricks.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.dp.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parPrivateDnsZoneAutoMergeAzureBackupZone

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.

- Default value: `True`

### parVirtualNetworkIdToLinkFailover

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of Failover VNet for Private DNS Zone VNet Failover Links

### parPrivateDNSZonesLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Private DNS Zone(s).

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parVpnGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN virtual network gateway deployment.

- Default value: `True`

### parVpnGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for VPN virtual network gateway to be deployed.

- Default value: `@{name=[format('{0}-Vpn-Gateway', parameters('parCompanyPrefix'))]; gatewayType=Vpn; sku=VpnGw1; vpnType=RouteBased; generation=Generation1; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=; vpnClientConfiguration=}`

### parExpressRouteGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable ExpressRoute virtual network gateway deployment.

- Default value: `True`

### parExpressRouteGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for ExpressRoute virtual network gateway to be deployed.

- Default value: `@{name=[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]; gatewayType=ExpressRoute; sku=ErGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=None; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=}`

### parVirtualNetworkGatewayLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for ExpressRoute Virtual Network Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

### parBastionOutboundSshRdpPorts

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.

- Default value: `22 3389`

## Outputs

Name | Type | Description
---- | ---- | -----------
outAzFirewallPrivateIp | string |
outAzFirewallName | string |
outPrivateDnsZones | array |
outPrivateDnsZonesNames | array |
outDdosPlanResourceId | string |
outHubVirtualNetworkName | string |
outHubVirtualNetworkId | string |
outHubRouteTableId | string |
outHubRouteTableName | string |
outBastionNsgId | string |
outBastionNsgName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/hubNetworking/hubNetworking.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parCompanyPrefix": {
            "value": "alz"
        },
        "parHubNetworkName": {
            "value": "[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parHubNetworkAddressPrefix": {
            "value": "10.10.0.0/16"
        },
        "parSubnets": {
            "value": [
                {
                    "name": "AzureBastionSubnet",
                    "ipAddressRange": "10.10.15.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "GatewaySubnet",
                    "ipAddressRange": "10.10.252.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallSubnet",
                    "ipAddressRange": "10.10.254.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallManagementSubnet",
                    "ipAddressRange": "10.10.253.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                }
            ]
        },
        "parDnsServerIps": {
            "value": []
        },
        "parVirtualNetworkLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parPublicIpSku": {
            "value": "Standard"
        },
        "parPublicIpPrefix": {
            "value": ""
        },
        "parPublicIpSuffix": {
            "value": "-PublicIP"
        },
        "parAzBastionEnabled": {
            "value": true
        },
        "parAzBastionName": {
            "value": "[format('{0}-bastion', parameters('parCompanyPrefix'))]"
        },
        "parAzBastionSku": {
            "value": "Standard"
        },
        "parAzBastionTunneling": {
            "value": false
        },
        "parAzBastionNsgName": {
            "value": "nsg-AzureBastionSubnet"
        },
        "parBastionLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
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
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parAzFirewallEnabled": {
            "value": true
        },
        "parAzFirewallName": {
            "value": "[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesEnabled": {
            "value": true
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesAutoLearn": {
            "value": "Disabled"
        },
        "parAzFirewallPoliciesPrivateRanges": {
            "value": []
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parAzFirewallIntelMode": {
            "value": "Alert"
        },
        "parAzFirewallCustomPublicIps": {
            "value": []
        },
        "parAzFirewallAvailabilityZones": {
            "value": []
        },
        "parAzErGatewayAvailabilityZones": {
            "value": []
        },
        "parAzVpnGatewayAvailabilityZones": {
            "value": []
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parAzFirewallDnsServers": {
            "value": []
        },
        "parAzureFirewallLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parHubRouteTableName": {
            "value": "[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]"
        },
        "parDisableBgpRoutePropagation": {
            "value": false
        },
        "parHubRouteTableLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parPrivateDnsZonesEnabled": {
            "value": true
        },
        "parPrivateDnsZonesResourceGroup": {
            "value": "[resourceGroup().name]"
        },
        "parPrivateDnsZones": {
            "value": [
                "[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))]",
                "[format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))]",
                "[format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))]",
                "privatelink.adf.azure.com",
                "privatelink.afs.azure.net",
                "privatelink.agentsvc.azure-automation.net",
                "privatelink.analysis.windows.net",
                "privatelink.api.azureml.ms",
                "privatelink.azconfig.io",
                "privatelink.azure-api.net",
                "privatelink.azure-automation.net",
                "privatelink.azurecr.io",
                "privatelink.azure-devices.net",
                "privatelink.azure-devices-provisioning.net",
                "privatelink.azuredatabricks.net",
                "privatelink.azurehdinsight.net",
                "privatelink.azurehealthcareapis.com",
                "privatelink.azurestaticapps.net",
                "privatelink.azuresynapse.net",
                "privatelink.azurewebsites.net",
                "privatelink.batch.azure.com",
                "privatelink.blob.core.windows.net",
                "privatelink.cassandra.cosmos.azure.com",
                "privatelink.cognitiveservices.azure.com",
                "privatelink.database.windows.net",
                "privatelink.datafactory.azure.net",
                "privatelink.dev.azuresynapse.net",
                "privatelink.dfs.core.windows.net",
                "privatelink.dicom.azurehealthcareapis.com",
                "privatelink.digitaltwins.azure.net",
                "privatelink.directline.botframework.com",
                "privatelink.documents.azure.com",
                "privatelink.eventgrid.azure.net",
                "privatelink.file.core.windows.net",
                "privatelink.gremlin.cosmos.azure.com",
                "privatelink.guestconfiguration.azure.com",
                "privatelink.his.arc.azure.com",
                "privatelink.dp.kubernetesconfiguration.azure.com",
                "privatelink.managedhsm.azure.net",
                "privatelink.mariadb.database.azure.com",
                "privatelink.media.azure.net",
                "privatelink.mongo.cosmos.azure.com",
                "privatelink.monitor.azure.com",
                "privatelink.mysql.database.azure.com",
                "privatelink.notebooks.azure.net",
                "privatelink.ods.opinsights.azure.com",
                "privatelink.oms.opinsights.azure.com",
                "privatelink.pbidedicated.windows.net",
                "privatelink.postgres.database.azure.com",
                "privatelink.prod.migration.windowsazure.com",
                "privatelink.purview.azure.com",
                "privatelink.purviewstudio.azure.com",
                "privatelink.queue.core.windows.net",
                "privatelink.redis.cache.windows.net",
                "privatelink.redisenterprise.cache.azure.net",
                "privatelink.search.windows.net",
                "privatelink.service.signalr.net",
                "privatelink.servicebus.windows.net",
                "privatelink.siterecovery.windowsazure.com",
                "privatelink.sql.azuresynapse.net",
                "privatelink.table.core.windows.net",
                "privatelink.table.cosmos.azure.com",
                "privatelink.tip1.powerquery.microsoft.com",
                "privatelink.token.botframework.com",
                "privatelink.vaultcore.azure.net",
                "privatelink.web.core.windows.net",
                "privatelink.webpubsub.azure.com"
            ]
        },
        "parPrivateDnsZoneAutoMergeAzureBackupZone": {
            "value": true
        },
        "parVirtualNetworkIdToLinkFailover": {
            "value": ""
        },
        "parPrivateDNSZonesLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parVpnGatewayEnabled": {
            "value": true
        },
        "parVpnGatewayConfig": {
            "value": {
                "name": "[format('{0}-Vpn-Gateway', parameters('parCompanyPrefix'))]",
                "gatewayType": "Vpn",
                "sku": "VpnGw1",
                "vpnType": "RouteBased",
                "generation": "Generation1",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": 65515,
                    "bgpPeeringAddress": "",
                    "peerWeight": 5
                },
                "vpnClientConfiguration": {}
            }
        },
        "parExpressRouteGatewayEnabled": {
            "value": true
        },
        "parExpressRouteGatewayConfig": {
            "value": {
                "name": "[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]",
                "gatewayType": "ExpressRoute",
                "sku": "ErGw1AZ",
                "vpnType": "RouteBased",
                "vpnGatewayGeneration": "None",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": "65515",
                    "bgpPeeringAddress": "",
                    "peerWeight": "5"
                }
            }
        },
        "parVirtualNetworkGatewayLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parTags": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parBastionOutboundSshRdpPorts": {
            "value": [
                "22",
                "3389"
            ]
        }
    }
}
```
