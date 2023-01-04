# ALZ Bicep - Role Assignment to Management Groups

Module used to assign a Role Assignment to multiple Management Groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parManagementGroupIds | No       | A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).
parRoleDefinitionId | Yes      | Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)
parAssigneePrincipalType | Yes      | Principal type of the assignee.  Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)
parAssigneeObjectId | Yes      | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parManagementGroupIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of management group scopes that will be used for role assignment (i.e. [alz-platform-connectivity, alz-platform-identity]).

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

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/roleAssignments/roleAssignmentManagementGroupMany.json"
    },
    "parameters": {
        "parManagementGroupIds": {
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
        }
    }
}
```
