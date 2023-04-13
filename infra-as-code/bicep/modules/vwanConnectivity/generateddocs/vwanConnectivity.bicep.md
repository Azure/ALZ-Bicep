# ALZ Bicep - Azure vWAN Connectivity Module

Module used to set up vWAN Connectivity

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Region in which the resource group was created.
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names.
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parVirtualHubEnabled | No       | Switch to enable/disable Virtual Hub deployment.
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy.
parVirtualWanName | No       | Prefix Used for Virtual WAN.
parVirtualWanHubName | No       | Prefix Used for Virtual WAN Hub.
parVirtualWanHubs | No       | Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.  - `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub. - `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub. - `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub. - `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use. - `parHubLocation` - The Virtual WAN Hub location. - `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`. - `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.  
parVpnGatewayName | No       | Prefix Used for VPN Gateway.
parExpressRouteGatewayName | No       | Prefix Used for ExpressRoute Gateway.
parAzFirewallName | No       | Azure Firewall Name.
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name.
parVpnGatewayScaleUnit | No       | The scale unit for this VPN Gateway.
parExpressRouteGatewayScaleUnit | No       | The scale unit for this ExpressRoute Gateway.
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment.
parDdosPlanName | No       | DDoS Plan Name.
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment.
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones.
parPrivateDnsZones | No       | Array of DNS Zones to provision in Hub Virtual Network.
parVirtualNetworkIdToLink | No       | Resource ID of VNet for Private DNS Zone VNet Links
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

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Standard`, `Premium`

### parVirtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Hub deployment.

- Default value: `True`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy.

- Default value: `True`

### parVirtualWanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN.

- Default value: `[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parVirtualWanHubName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN Hub.

- Default value: `[format('{0}-vhub', parameters('parCompanyPrefix'))]`

### parVirtualWanHubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `parHubLocation` - The Virtual WAN Hub location.
- `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`.
- `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.



### parVpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for VPN Gateway.

- Default value: `[format('{0}-vpngw', parameters('parCompanyPrefix'))]`

### parExpressRouteGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for ExpressRoute Gateway.

- Default value: `[format('{0}-ergw', parameters('parCompanyPrefix'))]`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-fw', parameters('parCompanyPrefix'))]`

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name.

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

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

Array of DNS Zones to provision in Hub Virtual Network.

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parVirtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of VNet for Private DNS Zone VNet Links

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
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parVirtualHubEnabled": {
            "value": true
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parVirtualWanName": {
            "value": "[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parVirtualWanHubName": {
            "value": "[format('{0}-vhub', parameters('parCompanyPrefix'))]"
        },
        "parVirtualWanHubs": {
            "value": [
                {
                    "parVpnGatewayEnabled": true,
                    "parExpressRouteGatewayEnabled": true,
                    "parAzFirewallEnabled": true,
                    "parVirtualHubAddressPrefix": "10.100.0.0/23",
                    "parHubLocation": "eastus",
                    "parHubRoutingPreference": "ExpressRoute",
                    "parVirtualRouterAutoScaleConfiguration": 2
                }
            ]
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
        "parAzFirewallAvailabilityZones": {
            "value": []
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
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
        "parVirtualNetworkIdToLink": {
            "value": ""
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
