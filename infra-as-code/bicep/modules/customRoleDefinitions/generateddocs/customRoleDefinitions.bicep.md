# ALZ Bicep - Custom Role Definitions

Custom Role Definitions for ALZ Bicep

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parAssignableScopeManagementGroupId | No       | The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.
parAdditionalRoles | No       | Additional role to create
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parAssignableScopeManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.

- Default value: `alz`

### parAdditionalRoles

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Additional role to create

- Default value: ` `

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
        "template": "infra-as-code/bicep/modules/customRoleDefinitions/customRoleDefinitions.json"
    },
    "parameters": {
        "parAssignableScopeManagementGroupId": {
            "value": "alz"
        },
        "parAdditionalRoles": {
            "value": [
                {
                    "name": "[alz] IP address writer",
                    "actions": [
                        "Microsoft.Network/publicIPAddresses/write"
                    ]
                },
                {
                    "name": "[alz] JIT Contributor",
                    "description": "Configure or edit a JIT policy for VMs",
                    "actions": [
                        "Microsoft.Security/locations/jitNetworkAccessPolicies/write",
                        "Microsoft.Compute/virtualMachines/write",
                        "Microsoft.Security/locations/jitNetworkAccessPolicies/read",
                        "Microsoft.Security/locations/jitNetworkAccessPolicies/initiate/action",
                        "Microsoft.Security/policies/read",
                        "Microsoft.Security/pricings/read",
                        "Microsoft.Compute/virtualMachines/read",
                        "Microsoft.Network/*/read"
                    ]
                }
            ]
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
