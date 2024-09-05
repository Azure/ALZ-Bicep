# ALZ Bicep - Role Assignment to a Subscription

Module to assign a role to a Subscription

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parRoleAssignmentNameGuid | No       | GUID for the role assignment name.
parRoleDefinitionId | Yes      | Role Definition ID (e.g., Reader Role ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).
parAssigneePrincipalType | Yes      | Principal type: "Group" (Security Group) or "ServicePrincipal" (Service Principal/Managed Identity).
parAssigneeObjectId | Yes      | Object ID of the group, service principal, or managed identity.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parRoleAssignmentCondition | No       | Role assignment condition (e.g., Owner, User Access Administrator).
parRoleAssignmentConditionVersion | No       | Role assignment condition version. Must be "2.0".

### parRoleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

GUID for the role assignment name.

- Default value: `[guid(subscription().subscriptionId, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]`

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition ID (e.g., Reader Role ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type: "Group" (Security Group) or "ServicePrincipal" (Service Principal/Managed Identity).

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of the group, service principal, or managed identity.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt out of deployment telemetry.

- Default value: `False`

### parRoleAssignmentCondition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition (e.g., Owner, User Access Administrator).

### parRoleAssignmentConditionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition version. Must be "2.0".

- Default value: `2.0`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/roleAssignments/roleAssignmentSubscription.json"
    },
    "parameters": {
        "parRoleAssignmentNameGuid": {
            "value": "[guid(subscription().subscriptionId, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]"
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
