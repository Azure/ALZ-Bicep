# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSpokeVirtualNetworkResourceId | No       | The Spoke Virtual Network Resource ID.
parPrivateDnsZoneResourceId | No       | The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.

### parSpokeVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Spoke Virtual Network Resource ID.

- Default value: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/virtualNetworks/<VNET-NAME>`

### parPrivateDnsZoneResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.

- Default value: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/privateDnsZones/<ZONE-NAME>`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/privateDnsZoneLinks/samples/baseline.sample.json"
    },
    "parameters": {
        "parSpokeVirtualNetworkResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/virtualNetworks/<VNET-NAME>"
        },
        "parPrivateDnsZoneResourceId": {
            "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/<RG-NAME>/providers/Microsoft.Network/privateDnsZones/<ZONE-NAME>"
        }
    }
}
```
