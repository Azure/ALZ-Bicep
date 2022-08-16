# privateDnsZones

[Azure Landing Zones - Bicep Modules](..)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into. Default: resourceGroup().location
parPrivateDnsZones | No       | Array of custom DNS Zones to provision in Hub Virtual Network. Default: all known private link DNS zones deployed
parTags        | No       | Tags you would like to be applied to all resources in this module. Default: empty object
parVirtualNetworkIdToLink | No       | Resource ID of VNet for Private DNS Zone VNet Links
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into. Default: resourceGroup().location

- Default value: `[resourceGroup().location]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS Zones to provision in Hub Virtual Network. Default: all known private link DNS zones deployed

- Default value: `privatelink.azure-automation.net privatelink.database.windows.net privatelink.sql.azuresynapse.net privatelink.dev.azuresynapse.net privatelink.azuresynapse.net privatelink.blob.core.windows.net privatelink.table.core.windows.net privatelink.queue.core.windows.net privatelink.file.core.windows.net privatelink.web.core.windows.net privatelink.dfs.core.windows.net privatelink.documents.azure.com privatelink.mongo.cosmos.azure.com privatelink.cassandra.cosmos.azure.com privatelink.gremlin.cosmos.azure.com privatelink.table.cosmos.azure.com [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] privatelink.postgres.database.azure.com privatelink.mysql.database.azure.com privatelink.mariadb.database.azure.com privatelink.vaultcore.azure.net privatelink.managedhsm.azure.net [format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] privatelink.siterecovery.windowsazure.com privatelink.servicebus.windows.net privatelink.azure-devices.net privatelink.eventgrid.azure.net privatelink.azurewebsites.net privatelink.api.azureml.ms privatelink.notebooks.azure.net privatelink.service.signalr.net privatelink.monitor.azure.com privatelink.oms.opinsights.azure.com privatelink.ods.opinsights.azure.com privatelink.agentsvc.azure-automation.net privatelink.afs.azure.net privatelink.datafactory.azure.net privatelink.adf.azure.com privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.digitaltwins.azure.net privatelink.azconfig.io privatelink.cognitiveservices.azure.com privatelink.azurecr.io privatelink.search.windows.net privatelink.azurehdinsight.net privatelink.media.azure.net privatelink.his.arc.azure.com privatelink.guestconfiguration.azure.com`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module. Default: empty object

### parVirtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of VNet for Private DNS Zone VNet Links

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outPrivateDnsZones | array |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/privateDnsZones/privateDnsZones.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parPrivateDnsZones": {
            "value": [
                "privatelink.azure-automation.net",
                "privatelink.database.windows.net",
                "privatelink.sql.azuresynapse.net",
                "privatelink.dev.azuresynapse.net",
                "privatelink.azuresynapse.net",
                "privatelink.blob.core.windows.net",
                "privatelink.table.core.windows.net",
                "privatelink.queue.core.windows.net",
                "privatelink.file.core.windows.net",
                "privatelink.web.core.windows.net",
                "privatelink.dfs.core.windows.net",
                "privatelink.documents.azure.com",
                "privatelink.mongo.cosmos.azure.com",
                "privatelink.cassandra.cosmos.azure.com",
                "privatelink.gremlin.cosmos.azure.com",
                "privatelink.table.cosmos.azure.com",
                "[format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))]",
                "privatelink.postgres.database.azure.com",
                "privatelink.mysql.database.azure.com",
                "privatelink.mariadb.database.azure.com",
                "privatelink.vaultcore.azure.net",
                "privatelink.managedhsm.azure.net",
                "[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))]",
                "privatelink.siterecovery.windowsazure.com",
                "privatelink.servicebus.windows.net",
                "privatelink.azure-devices.net",
                "privatelink.eventgrid.azure.net",
                "privatelink.azurewebsites.net",
                "privatelink.api.azureml.ms",
                "privatelink.notebooks.azure.net",
                "privatelink.service.signalr.net",
                "privatelink.monitor.azure.com",
                "privatelink.oms.opinsights.azure.com",
                "privatelink.ods.opinsights.azure.com",
                "privatelink.agentsvc.azure-automation.net",
                "privatelink.afs.azure.net",
                "privatelink.datafactory.azure.net",
                "privatelink.adf.azure.com",
                "privatelink.redis.cache.windows.net",
                "privatelink.redisenterprise.cache.azure.net",
                "privatelink.purview.azure.com",
                "privatelink.purviewstudio.azure.com",
                "privatelink.digitaltwins.azure.net",
                "privatelink.azconfig.io",
                "privatelink.cognitiveservices.azure.com",
                "privatelink.azurecr.io",
                "privatelink.search.windows.net",
                "privatelink.azurehdinsight.net",
                "privatelink.media.azure.net",
                "privatelink.his.arc.azure.com",
                "privatelink.guestconfiguration.azure.com"
            ]
        },
        "parTags": {
            "value": {}
        },
        "parVirtualNetworkIdToLink": {
            "value": ""
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
