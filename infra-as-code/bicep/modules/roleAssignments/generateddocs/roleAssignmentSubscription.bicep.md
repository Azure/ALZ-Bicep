# ALZ Bicep - Role Assignment to a Subscription

Assigns a role to a subscription.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parRoleAssignmentNameGuid | No       | GUID for role assignment.
parRoleDefinitionId | Yes      | Role Definition ID (e.g., Reader: acdd72a7-3385-48ef-bd42-f606fba81ae7).
parAssigneePrincipalType | Yes      | Principal type: "Group" or "ServicePrincipal".
parAssigneeObjectId | Yes      | Object ID of the assignee.
parTelemetryOptOut | No       | Opt out of telemetry.
parRoleAssignmentCondition | No       | Role assignment condition (e.g., Owner, User Access Administrator).
parRoleAssignmentConditionVersion | No       | Role condition version (must be "2.0").

### parRoleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

GUID for role assignment.

- Default value: `[guid(subscription().subscriptionId, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]`

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition ID (e.g., Reader: acdd72a7-3385-48ef-bd42-f606fba81ae7).

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type: "Group" or "ServicePrincipal".

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of the assignee.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt out of telemetry.

- Default value: `False`

### parRoleAssignmentCondition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role assignment condition (e.g., Owner, User Access Administrator).

### parRoleAssignmentConditionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role condition version (must be "2.0").

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
