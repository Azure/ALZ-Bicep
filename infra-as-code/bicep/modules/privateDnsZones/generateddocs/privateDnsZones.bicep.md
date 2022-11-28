# ALZ Bicep - Private DNS Zones

Module used to set up Private DNS Zones in accordance to Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into. Default: resourceGroup().location
parPrivateDnsZones | No       | Array of custom DNS Zones to provision in Hub Virtual Network. Default: all known private link DNS zones deployed
parTags        | No       | Tags you would like to be applied to all resources in this module. Default: empty object
parVirtualNetworkIdToLink | No       | Resource ID of VNet for Private DNS Zone VNet Links. Default: Empty String
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into. Default: resourceGroup().location

- Default value: `[resourceGroup().location]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS Zones to provision in Hub Virtual Network. Default: all known private link DNS zones deployed

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module. Default: empty object

### parVirtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of VNet for Private DNS Zone VNet Links. Default: Empty String

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

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
