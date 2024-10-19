# ALZ Bicep - Management Group Policy Assignments

Module to assign policy definitions to management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentName | Yes      | Policy assignment name.
parPolicyAssignmentDisplayName | Yes      | Policy assignment display name.
parPolicyAssignmentDescription | Yes      | Policy assignment description.
parPolicyAssignmentDefinitionId | Yes      | Policy definition ID.
parPolicyAssignmentParameters | No       | Parameter values for the assigned policy.
parPolicyAssignmentParameterOverrides | No       | Overrides for parameter values in parPolicyAssignmentParameters.
parPolicyAssignmentNonComplianceMessages | No       | Non-compliance messages for the assigned policy.
parPolicyAssignmentNotScopes | No       | Scope Resource IDs excluded from policy assignment.
parPolicyAssignmentEnforcementMode | No       | Enforcement mode for the policy assignment.
parPolicyAssignmentOverrides | No       | List of required overrides for the policy assignment.
parPolicyAssignmentResourceSelectors | No       | List of required resource selectors for the policy assignment.
parPolicyAssignmentIdentityType | No       | Identity type for the policy assignment (required for Modify/DeployIfNotExists effects).
parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs | No       | Additional Management Groups for System-assigned Managed Identity role assignments.
parPolicyAssignmentIdentityRoleAssignmentsSubs | No       | Subscription IDs for System-assigned Managed Identity role assignments.
parPolicyAssignmentIdentityRoleAssignmentsResourceGroups | No       | Subscription IDs and Resource Groups for System-assigned Managed Identity role assignments.
parPolicyAssignmentIdentityRoleDefinitionIds | No       | RBAC role definition IDs for Managed Identity role assignments (required for Modify/DeployIfNotExists effects).
parTelemetryOptOut | No       | Opt-out of deployment telemetry.

### parPolicyAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy assignment name.

### parPolicyAssignmentDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy assignment display name.

### parPolicyAssignmentDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy assignment description.

### parPolicyAssignmentDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy definition ID.

### parPolicyAssignmentParameters

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Parameter values for the assigned policy.

### parPolicyAssignmentParameterOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Overrides for parameter values in parPolicyAssignmentParameters.

### parPolicyAssignmentNonComplianceMessages

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Non-compliance messages for the assigned policy.

### parPolicyAssignmentNotScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Scope Resource IDs excluded from policy assignment.

### parPolicyAssignmentEnforcementMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enforcement mode for the policy assignment.

- Default value: `Default`

- Allowed values: `Default`, `DoNotEnforce`

### parPolicyAssignmentOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

List of required overrides for the policy assignment.

### parPolicyAssignmentResourceSelectors

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

List of required resource selectors for the policy assignment.

### parPolicyAssignmentIdentityType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Identity type for the policy assignment (required for Modify/DeployIfNotExists effects).

- Default value: `None`

- Allowed values: `None`, `SystemAssigned`

### parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Additional Management Groups for System-assigned Managed Identity role assignments.

### parPolicyAssignmentIdentityRoleAssignmentsSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription IDs for System-assigned Managed Identity role assignments.

### parPolicyAssignmentIdentityRoleAssignmentsResourceGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription IDs and Resource Groups for System-assigned Managed Identity role assignments.

### parPolicyAssignmentIdentityRoleDefinitionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

RBAC role definition IDs for Managed Identity role assignments (required for Modify/DeployIfNotExists effects).

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt-out of deployment telemetry.

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
