# ALZ Bicep - Role Assignment to Subscriptions

Module to assign a role to multiple Subscriptions

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSubscriptionIds | No       | List of subscription IDs (e.g., 4f9f8765-911a-4a6d-af60-4bc0473268c0).
parRoleDefinitionId | Yes      | Role Definition ID (e.g., Reader Role ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).
parAssigneePrincipalType | Yes      | Principal type: "Group" (Security Group) or "ServicePrincipal" (Service Principal/Managed Identity).
parAssigneeObjectId | Yes      | Object ID of the group, service principal, or managed identity.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parRoleAssignmentCondition | No       | Role assignment condition (e.g., Owner, User Access Administrator).
parRoleAssignmentConditionVersion | No       | Role assignment condition version. Must be "2.0".

### parSubscriptionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

List of subscription IDs (e.g., 4f9f8765-911a-4a6d-af60-4bc0473268c0).

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
        "template": "infra-as-code/bicep/modules/roleAssignments/roleAssignmentSubscriptionMany.json"
    },
    "parameters": {
        "parSubscriptionIds": {
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
