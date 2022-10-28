# ALZ Bicep - Security Operations Role

Role for Security Operations

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parAssignableScopeManagementGroupId | Yes      | The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.

### parAssignableScopeManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.

## Outputs

Name | Type | Description
---- | ---- | -----------
outRoleDefinitionId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/customRoleDefinitions/definitions/cafSecurityOperationsRole.json"
    },
    "parameters": {
        "parAssignableScopeManagementGroupId": {
            "value": ""
        }
    }
}
```
