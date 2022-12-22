# ALZ Bicep - Custom Role Definitions

Custom Role Definitions

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parAssignableScopeManagementGroupId | No       | The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parAssignableScopeManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.

- Default value: `alz`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outRolesSubscriptionOwnerRoleId | string |
outRolesApplicationOwnerRoleId | string |
outRolesNetworkManagementRoleId | string |
outRolesSecurityOperationsRoleId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/customRoleDefinitions/mc-customRoleDefinitions.json"
    },
    "parameters": {
        "parAssignableScopeManagementGroupId": {
            "value": "alz"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
