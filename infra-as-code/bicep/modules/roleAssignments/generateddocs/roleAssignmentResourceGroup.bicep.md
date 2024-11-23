# ALZ Bicep - Role Assignment to a Resource Group

Module to assign a role to a Resource Group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parRoleAssignmentNameGuid | No       | GUID for the role assignment name.
parRoleDefinitionId | Yes      | Role Definition Id (e.g., Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)
parAssigneePrincipalType | Yes      | Principal type: 'Group' (Security Group) or 'ServicePrincipal' (Service Principal/Managed Identity).
parAssigneeObjectId | Yes      | Object ID of groups, service principals, or managed identities (use principal ID for managed identities).
parTelemetryOptOut | No       | Set to true to opt out of deployment telemetry.
parRoleAssignmentCondition | No       | Role assignment condition (e.g., Owner, User Access Administrator). Only roles with `write` or `delete` permissions can have a condition.
parRoleAssignmentConditionVersion | No       | Role assignment condition version. Only value accepted is '2.0'.

### parRoleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

GUID for the role assignment name.

- Default value: `[guid(resourceGroup().id, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]`

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition Id (e.g., Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type: 'Group' (Security Group) or 'ServicePrincipal' (Service Principal/Managed Identity).

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of groups, service principals, or managed identities (use principal ID for managed identities).

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set to true to opt out of deployment telemetry.

- Default value: `False`

### parRoleAssignmentCondition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition (e.g., Owner, User Access Administrator). Only roles with `write` or `delete` permissions can have a condition.

### parRoleAssignmentConditionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition version. Only value accepted is '2.0'.

- Default value: `2.0`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/roleAssignments/roleAssignmentResourceGroup.json"
    },
    "parameters": {
        "parRoleAssignmentNameGuid": {
            "value": "[guid(resourceGroup().id, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]"
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
