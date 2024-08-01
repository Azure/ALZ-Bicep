# ALZ Bicep - Role Assignment to Resource Groups

Module used to assign a Role Assignment to multiple Resource Groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parResourceGroupIds | No       | A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).
parRoleDefinitionId | Yes      | Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)
parAssigneePrincipalType | Yes      | Principal type of the assignee.  Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)
parAssigneeObjectId | Yes      | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry
parRoleAssignmentCondition | No       | The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions can have a condition defined. Example: Owner, User Access Administrator and RBAC Administrator.
parRoleAssignmentConditionVersion | No       | Role assignment condition version. Currently the only accepted value is '2.0'

### parResourceGroupIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type of the assignee.  Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

### parRoleAssignmentCondition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions can have a condition defined. Example: Owner, User Access Administrator and RBAC Administrator.

### parRoleAssignmentConditionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition version. Currently the only accepted value is '2.0'

- Default value: `2.0`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/roleAssignments/roleAssignmentResourceGroupMany.json"
    },
    "parameters": {
        "parResourceGroupIds": {
            "value": []
        },
        "parRoleDefinitionId": {
            "value": ""
        },
        "parAssigneePrincipalType": {
            "value": ""
        },
        "parAssigneeObjectId": {
            "value": ""
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parRoleAssignmentCondition": {
            "value": ""
        },
        "parRoleAssignmentConditionVersion": {
            "value": "2.0"
        }
    }
}
```
