# ALZ Bicep - Management Group Policy Assignments

Assign policies to management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentName | Yes      | Policy assignment name.
parPolicyAssignmentDisplayName | Yes      | Display name.
parPolicyAssignmentDescription | Yes      | Assignment description.
parPolicyAssignmentDefinitionId | Yes      | Policy definition ID.
parPolicyAssignmentParameters | No       | Policy parameters.
parPolicyAssignmentParameterOverrides | No       | Parameter overrides.
parPolicyAssignmentNonComplianceMessages | No       | Non-compliance messages.
parPolicyAssignmentNotScopes | No       | Excluded scope IDs.
parPolicyAssignmentEnforcementMode | No       | Enforcement mode.
parPolicyAssignmentOverrides | No       | Required overrides.
parPolicyAssignmentResourceSelectors | No       | Required resource selectors.
parPolicyAssignmentDefinitionVersion | Yes      | Policy definition version.
parPolicyAssignmentIdentityType | No       | Identity type.
parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs | No       | Additional MGs for role assignments.
parPolicyAssignmentIdentityRoleAssignmentsSubs | No       | Subscription IDs for role assignments.
parPolicyAssignmentIdentityRoleAssignmentsResourceGroups | No       | Subscriptions & resource groups for role assignments.
parPolicyAssignmentIdentityRoleDefinitionIds | No       | RBAC role definition IDs.
parTelemetryOptOut | No       | Opt-out of telemetry.

### parPolicyAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy assignment name.

### parPolicyAssignmentDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Display name.

### parPolicyAssignmentDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Assignment description.

### parPolicyAssignmentDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy definition ID.

### parPolicyAssignmentParameters

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Policy parameters.

### parPolicyAssignmentParameterOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Parameter overrides.

### parPolicyAssignmentNonComplianceMessages

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Non-compliance messages.

### parPolicyAssignmentNotScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Excluded scope IDs.

### parPolicyAssignmentEnforcementMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enforcement mode.

- Default value: `Default`

- Allowed values: `Default`, `DoNotEnforce`

### parPolicyAssignmentOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required overrides.

### parPolicyAssignmentResourceSelectors

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required resource selectors.

### parPolicyAssignmentDefinitionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy definition version.

### parPolicyAssignmentIdentityType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Identity type.

- Default value: `None`

- Allowed values: `None`, `SystemAssigned`

### parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Additional MGs for role assignments.

### parPolicyAssignmentIdentityRoleAssignmentsSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription IDs for role assignments.

### parPolicyAssignmentIdentityRoleAssignmentsResourceGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscriptions & resource groups for role assignments.

### parPolicyAssignmentIdentityRoleDefinitionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

RBAC role definition IDs.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt-out of telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outPolicyAssignmentId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.json"
    },
    "parameters": {
        "parPolicyAssignmentName": {
            "value": ""
        },
        "parPolicyAssignmentDisplayName": {
            "value": ""
        },
        "parPolicyAssignmentDescription": {
            "value": ""
        },
        "parPolicyAssignmentDefinitionId": {
            "value": ""
        },
        "parPolicyAssignmentParameters": {
            "value": {}
        },
        "parPolicyAssignmentParameterOverrides": {
            "value": {}
        },
        "parPolicyAssignmentNonComplianceMessages": {
            "value": []
        },
        "parPolicyAssignmentNotScopes": {
            "value": []
        },
        "parPolicyAssignmentEnforcementMode": {
            "value": "Default"
        },
        "parPolicyAssignmentOverrides": {
            "value": []
        },
        "parPolicyAssignmentResourceSelectors": {
            "value": []
        },
        "parPolicyAssignmentDefinitionVersion": {
            "value": ""
        },
        "parPolicyAssignmentIdentityType": {
            "value": "None"
        },
        "parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs": {
            "value": []
        },
        "parPolicyAssignmentIdentityRoleAssignmentsSubs": {
            "value": []
        },
        "parPolicyAssignmentIdentityRoleAssignmentsResourceGroups": {
            "value": []
        },
        "parPolicyAssignmentIdentityRoleDefinitionIds": {
            "value": []
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
