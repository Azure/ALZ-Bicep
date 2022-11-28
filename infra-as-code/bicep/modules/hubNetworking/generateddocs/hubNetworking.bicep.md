# ALZ Bicep - Hub Networking Module

ALZ Bicep Module used to set up Hub Networking

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into. Default: resourceGroup().location
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names. Default: alz
parHubNetworkName | No       | Prefix Used for Hub Network. Default: {parCompanyPrefix}-hub-{parLocation}
parHubNetworkAddressPrefix | No       | The IP address range for all virtual networks to use. Default: 10.10.0.0/16
parSubnets     | No       | The name and IP address range for each subnet in the virtual networks. Default: AzureBastionSubnet, GatewaySubnet, AzureFirewallSubnet
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet. Default: Empty Array
parPublicIpSku | No       | Public IP Address SKU. Default: Standard
parAzBastionEnabled | No       | Switch to enable/disable Azure Bastion deployment. Default: true
parAzBastionName | No       | Name Associated with Bastion Service:  Default: {parCompanyPrefix}-bastion
parAzBastionSku | No       | Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard. Default: Standard
parAzBastionNsgName | No       | NSG Name for Azure Bastion Subnet NSG. Default: nsg-AzureBastionSubnet
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment. Default: true
parDdosPlanName | No       | DDoS Plan Name. Default: {parCompanyPrefix}-ddos-plan
parAzFirewallEnabled | No       | Switch to enable/disable Azure Firewall deployment. Default: true
parAzFirewallName | No       | Azure Firewall Name. Default: {parCompanyPrefix}-azure-firewall
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name. Default: {parCompanyPrefix}-fwpol-{parLocation}
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy. Default: Standard
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty. Default: Empty Array
parAzErGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP. Default: Empty Array
parAzVpnGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP. Default: Empty Array
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy. Default: true
parHubRouteTableName | No       | Name of Route table to create for the default route of Hub. Default: {parCompanyPrefix}-hub-routetable
parDisableBgpRoutePropagation | No       | Switch to enable/disable BGP Propagation on route table. Default: false
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment. Default: true
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones. Default: resourceGroup().name
parPrivateDnsZones | No       | Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones
parVpnGatewayConfig | No       | Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e. "parVpnGatewayConfig": {   "value": {} }
parExpressRouteGatewayConfig | No       | Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e. "parExpressRouteGatewayConfig": {   "value": {} }
parTags        | No       | Tags you would like to be applied to all resources in this module. Default: Empty Object
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into. Default: resourceGroup().location

- Default value: `[resourceGroup().location]`

### parCompanyPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix value which will be prepended to all resource names. Default: alz

- Default value: `alz`

### parHubNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Hub Network. Default: {parCompanyPrefix}-hub-{parLocation}

- Default value: `[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parHubNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for all virtual networks to use. Default: 10.10.0.0/16

- Default value: `10.10.0.0/16`

### parSubnets

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name and IP address range for each subnet in the virtual networks. Default: AzureBastionSubnet, GatewaySubnet, AzureFirewallSubnet

- Default value: `  `

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet. Default: Empty Array

### parPublicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU. Default: Standard

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parAzBastionEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Bastion deployment. Default: true

- Default value: `True`

### parAzBastionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name Associated with Bastion Service:  Default: {parCompanyPrefix}-bastion

- Default value: `[format('{0}-bastion', parameters('parCompanyPrefix'))]`

### parAzBastionSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard. Default: Standard

- Default value: `Standard`

### parAzBastionNsgName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

NSG Name for Azure Bastion Subnet NSG. Default: nsg-AzureBastionSubnet

- Default value: `nsg-AzureBastionSubnet`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment. Default: true

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name. Default: {parCompanyPrefix}-ddos-plan

- Default value: `[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]`

### parAzFirewallEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall deployment. Default: true

- Default value: `True`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name. Default: {parCompanyPrefix}-azure-firewall

- Default value: `[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name. Default: {parCompanyPrefix}-fwpol-{parLocation}

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy. Default: Standard

- Default value: `Standard`

- Allowed values: `Standard`, `Premium`

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty. Default: Empty Array

- Allowed values: `1`, `2`, `3`

### parAzErGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP. Default: Empty Array

- Allowed values: `1`, `2`, `3`

### parAzVpnGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP. Default: Empty Array

- Allowed values: `1`, `2`, `3`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy. Default: true

- Default value: `True`

### parHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub. Default: {parCompanyPrefix}-hub-routetable

- Default value: `[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]`

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table. Default: false

- Default value: `False`

### parPrivateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Private DNS Zones deployment. Default: true

- Default value: `True`

### parPrivateDnsZonesResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Name for Private DNS Zones. Default: resourceGroup().name

- Default value: `[resourceGroup().name]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parVpnGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
"parVpnGatewayConfig": {
  "value": {}
}

- Default value: `@{name=[format('{0}-Vpn-Gateway', parameters('parCompanyPrefix'))]; gatewayType=Vpn; sku=VpnGw1; vpnType=RouteBased; generation=Generation1; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; asn=65515; bgpPeeringAddress=; bgpsettings=}`

### parExpressRouteGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
"parExpressRouteGatewayConfig": {
  "value": {}
}

- Default value: `@{name=[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]; gatewayType=ExpressRoute; sku=ErGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=None; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; asn=65515; bgpPeeringAddress=; bgpsettings=}`

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
outAzFirewallPrivateIp | string |
outAzFirewallName | string |
outPrivateDnsZones | array |
outDdosPlanResourceId | string |
outHubVirtualNetworkName | string |
outHubVirtualNetworkId | string |

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
        "parHubNetworkAddressPrefix": {
            "value": "10.10.0.0/16"
        },
        "parSubnets": {
            "value": [
                {
                    "name": "AzureBastionSubnet",
                    "ipAddressRange": "10.10.15.0/24"
                },
                {
                    "name": "GatewaySubnet",
                    "ipAddressRange": "10.10.252.0/24"
                },
                {
                    "name": "AzureFirewallSubnet",
                    "ipAddressRange": "10.10.254.0/24"
                }
            ]
        },
        "parDnsServerIps": {
            "value": []
        },
        "parPublicIpSku": {
            "value": "Standard"
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
        "parAzBastionNsgName": {
            "value": "nsg-AzureBastionSubnet"
        },
        "parDdosEnabled": {
            "value": true
        },
        "parDdosPlanName": {
            "value": "[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]"
        },
        "parAzFirewallEnabled": {
            "value": true
        },
        "parAzFirewallName": {
            "value": "[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallTier": {
            "value": "Standard"
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
        "parHubRouteTableName": {
            "value": "[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]"
        },
        "parDisableBgpRoutePropagation": {
            "value": false
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
                "privatelink.kubernetesconfiguration.azure.com",
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
                "asn": 65515,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": 65515,
                    "bgpPeeringAddress": "",
                    "peerWeight": 5
                }
            }
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
                "asn": "65515",
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": "65515",
                    "bgpPeeringAddress": "",
                    "peerWeight": "5"
                }
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
