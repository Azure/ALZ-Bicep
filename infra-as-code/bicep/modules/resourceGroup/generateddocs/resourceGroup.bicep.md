# ALZ Bicep - Resource Group creation module

Module used to create Resource Groups for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | Yes      | Azure Region where Resource Group will be created.
parResourceGroupName | Yes      | Name of Resource Group to be created.
parResourceLockConfig | No       | Resource Lock Configuration for Resource Groups.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Azure Region where Resource Group will be created.

### parResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of Resource Group to be created.

### parResourceLockConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Resource Groups.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Resource Group Module.}`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outResourceGroupName | string |
outResourceGroupId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/resourceGroup/resourceGroup.json"
    },
    "parameters": {
        "parLocation": {
            "value": ""
        },
        "parResourceGroupName": {
            "value": ""
        },
        "parResourceLockConfig": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Resource Group Module."
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
