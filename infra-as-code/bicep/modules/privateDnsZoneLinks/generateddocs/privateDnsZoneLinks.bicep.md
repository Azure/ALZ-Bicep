# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSpokeVirtualNetworkResourceId | No       | The Spoke Virtual Network Resource ID.
parPrivateDnsZoneResourceId | No       | The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.
parResolutionPolicy | No       | The resolution policy on the virtual network link. Only applicable for virtual network links to privatelink zones, and for A,AAAA,CNAME queries. When set to 'NxDomainRedirect', Azure DNS resolver falls back to public resolution if private dns query resolution results in non-existent domain response.
parResourceLockConfig | No       | Resource Lock Configuration for Private DNS Zone Links.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.

### parSpokeVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Spoke Virtual Network Resource ID.

### parPrivateDnsZoneResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Private DNS Zone Resource IDs to associate with the spoke Virtual Network.

### parResolutionPolicy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resolution policy on the virtual network link. Only applicable for virtual network links to privatelink zones, and for A,AAAA,CNAME queries. When set to 'NxDomainRedirect', Azure DNS resolver falls back to public resolution if private dns query resolution results in non-existent domain response.

### parResourceLockConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Private DNS Zone Links.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



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
        "parResolutionPolicy": {
            "value": "NxDomainRedirect"
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
