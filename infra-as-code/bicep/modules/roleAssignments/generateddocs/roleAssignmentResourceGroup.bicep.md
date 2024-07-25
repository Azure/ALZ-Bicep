# ALZ Bicep - Role Assignment to a Resource Group

Module used to assign a Role Assignment to a Resource Group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parRoleAssignmentNameGuid | No       | A GUID representing the role assignment name.
parRoleDefinitionId | Yes      | Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)
parAssigneePrincipalType | Yes      | Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)
parAssigneeObjectId | Yes      | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.
parRoleAssignmentCondition | No       | The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions support having a condition defined. Example of built-in roles that support conditions: - Owner - User Access Administrator - Role Based Access Control Administrator  To generate conditions code: - Create a role assignemnt with a condition from the portal for the privileged role that will be assigned. - Select the code view from the advanced editor and copy the condition's code. - Remove all newlines from the code - Escape any single quote using a backslash (only in Bicep, no need in JSON parameters file)  Example condition code: param parRoleAssignmentCondition string = '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'}) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635,b24988ac-6180-42a0-ab88-20f7382dd24c} AND @Request[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {\'Group\',\'ServicePrincipal\'})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635,b24988ac-6180-42a0-ab88-20f7382dd24c} AND @Resource[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {'Group','ServicePrincipal'})))' 
parRoleAssignmentConditionVersion | No       | Role assignment condition version. Currently the only accepted value is '2.0'

### parRoleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A GUID representing the role assignment name.

- Default value: `[guid(resourceGroup().id, parameters('parRoleDefinitionId'), parameters('parAssigneeObjectId'))]`

### parRoleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)

### parAssigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)

- Allowed values: `Group`, `ServicePrincipal`

### parAssigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

### parRoleAssignmentCondition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The role assignment condition. Only built-in and custom RBAC roles with `Microsoft.Authorization/roleAssignments/write` and/or `Microsoft.Authorization/roleAssignments/delete` permissions support having a condition defined.
Example of built-in roles that support conditions:
- Owner
- User Access Administrator
- Role Based Access Control Administrator

To generate conditions code:
- Create a role assignemnt with a condition from the portal for the privileged role that will be assigned.
- Select the code view from the advanced editor and copy the condition's code.
- Remove all newlines from the code
- Escape any single quote using a backslash (only in Bicep, no need in JSON parameters file)

Example condition code:
param parRoleAssignmentCondition string = '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'}) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635,b24988ac-6180-42a0-ab88-20f7382dd24c} AND @Request[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {\'Group\',\'ServicePrincipal\'})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635,b24988ac-6180-42a0-ab88-20f7382dd24c} AND @Resource[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {'Group','ServicePrincipal'})))'


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
