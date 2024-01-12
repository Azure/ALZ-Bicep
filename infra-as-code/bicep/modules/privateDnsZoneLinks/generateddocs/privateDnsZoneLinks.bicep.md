# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSpokeVirtualNetworkResourceId | No       | The Spoke Virtual Network Resource ID.
parPrivateDnsZoneResourceId | No       | The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.
parResourceLockConfig | No       | Resource Lock Configuration Object

### parSpokeVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Spoke Virtual Network Resource ID.

### parPrivateDnsZoneResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.

### parResourceLockConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration Object

- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Private DNS Zone Links Module.}`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/privateDnsZoneLinks/privateDnsZoneLinks.json"
    },
    "parameters": {
        "parSpokeVirtualNetworkResourceId": {
            "value": ""
        },
        "parPrivateDnsZoneResourceId": {
            "value": ""
        },
        "parResourceLockConfig": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Private DNS Zone Links Module."
            }
        }
    }
}
```
