# ALZ Bicep - Resource Group lock module

Module used to lock Resource Groups for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parResourceLockConfig | No       | Resource Lock Configuration for Resource Groups.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parResourceGroupName | Yes      | Resource Group Name

### parResourceLockConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Resource Groups.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Resource Group Module.}`

### parResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Resource Group Name

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/resourceGroup/resourceGroupLock.json"
    },
    "parameters": {
        "parResourceLockConfig": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Resource Group Module."
            }
        },
        "parResourceGroupName": {
            "value": ""
        }
    }
}
```
