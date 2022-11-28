# ALZ Bicep - Azure vWAN Connectivity Module

Module used to set up vWAN Connectivity

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Region in which the resource group was created. Default: {resourceGroup().location}
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names. Default: alz
parVirtualHubAddressPrefix | No       | The IP address range in CIDR notation for the vWAN virtual Hub to use. Default: 10.100.0.0/23
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy. Default: Standard 
parVirtualHubEnabled | No       | Switch to enable/disable Virtual Hub deployment. Default: true
parVpnGatewayEnabled | No       | Switch to enable/disable VPN Gateway deployment. Default: false
parExpressRouteGatewayEnabled | No       | Switch to enable/disable ExpressRoute Gateway deployment. Default: false
parAzFirewallEnabled | No       | Switch to enable/disable Azure Firewall deployment. Default: false
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy. Default: false
parVirtualWanName | No       | Prefix Used for Virtual WAN. Default: {parCompanyPrefix}-vwan-{parLocation}
parVirtualWanHubName | No       | Prefix Used for Virtual WAN Hub. Default: {parCompanyPrefix}-hub-{parLocation}
parVpnGatewayName | No       | Prefix Used for VPN Gateway. Default: {parCompanyPrefix}-vpngw-{parLocation}
parExpressRouteGatewayName | No       | Prefix Used for ExpressRoute Gateway. Default: {parCompanyPrefix}-ergw-{parLocation}
parAzFirewallName | No       | Azure Firewall Name. Default: {parCompanyPrefix}-fw-{parLocation}
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name. Default: {parCompanyPrefix}-fwpol-{parLocation}
parVpnGatewayScaleUnit | No       | The scale unit for this VPN Gateway: Default: 1
parExpressRouteGatewayScaleUnit | No       | The scale unit for this ExpressRoute Gateway: Default: 1
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment. Default: true
parDdosPlanName | No       | DDoS Plan Name. Default: {parCompanyPrefix}-ddos-plan
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment. Default: true
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones. Default: same resource group
parPrivateDnsZones | No       | Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones
parVirtualNetworkIdToLink | No       | Resource ID of VNet for Private DNS Zone VNet Links
parTags        | No       | Tags you would like to be applied to all resources in this module. Default: empty array
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Region in which the resource group was created. Default: {resourceGroup().location}

- Default value: `[resourceGroup().location]`

### parCompanyPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix value which will be prepended to all resource names. Default: alz

- Default value: `alz`

### parVirtualHubAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range in CIDR notation for the vWAN virtual Hub to use. Default: 10.100.0.0/23

- Default value: `10.100.0.0/23`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy. Default: Standard 

- Default value: `Standard`

- Allowed values: `Standard`, `Premium`

### parVirtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Hub deployment. Default: true

- Default value: `True`

### parVpnGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN Gateway deployment. Default: false

- Default value: `True`

### parExpressRouteGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable ExpressRoute Gateway deployment. Default: false

- Default value: `True`

### parAzFirewallEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall deployment. Default: false

- Default value: `True`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy. Default: false

- Default value: `True`

### parVirtualWanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN. Default: {parCompanyPrefix}-vwan-{parLocation}

- Default value: `[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parVirtualWanHubName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for Virtual WAN Hub. Default: {parCompanyPrefix}-hub-{parLocation}

- Default value: `[format('{0}-vhub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parVpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for VPN Gateway. Default: {parCompanyPrefix}-vpngw-{parLocation}

- Default value: `[format('{0}-vpngw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parExpressRouteGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for ExpressRoute Gateway. Default: {parCompanyPrefix}-ergw-{parLocation}

- Default value: `[format('{0}-ergw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name. Default: {parCompanyPrefix}-fw-{parLocation}

- Default value: `[format('{0}-fw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name. Default: {parCompanyPrefix}-fwpol-{parLocation}

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parVpnGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this VPN Gateway: Default: 1

- Default value: `1`

### parExpressRouteGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this ExpressRoute Gateway: Default: 1

- Default value: `1`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment. Default: true

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name. Default: {parCompanyPrefix}-ddos-plan

- Default value: `[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]`

### parPrivateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Private DNS Zones deployment. Default: true

- Default value: `True`

### parPrivateDnsZonesResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Name for Private DNS Zones. Default: same resource group

- Default value: `[resourceGroup().name]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parVirtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of VNet for Private DNS Zone VNet Links

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module. Default: empty array

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outVirtualWanName | string |
outVirtualWanId | string |
outVirtualHubName | string |
outVirtualHubId | string |
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
        "parVirtualHubAddressPrefix": {
            "value": "10.100.0.0/23"
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parVirtualHubEnabled": {
            "value": true
        },
        "parVpnGatewayEnabled": {
            "value": true
        },
        "parExpressRouteGatewayEnabled": {
            "value": true
        },
        "parAzFirewallEnabled": {
            "value": true
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parVirtualWanName": {
            "value": "[format('{0}-vwan-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parVirtualWanHubName": {
            "value": "[format('{0}-vhub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parVpnGatewayName": {
            "value": "[format('{0}-vpngw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parExpressRouteGatewayName": {
            "value": "[format('{0}-ergw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallName": {
            "value": "[format('{0}-fw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
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
