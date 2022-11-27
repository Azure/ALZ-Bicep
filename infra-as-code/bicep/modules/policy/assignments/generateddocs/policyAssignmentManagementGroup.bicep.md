# ALZ Bicep - Management Group Policy Assignments

Module used to assign policy definitions to management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentName | Yes      | The name of the policy assignment. e.g. "Deny-Public-IP"
parPolicyAssignmentDisplayName | Yes      | The display name of the policy assignment. e.g. "Deny the creation of Public IPs"
parPolicyAssignmentDescription | Yes      | The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."
parPolicyAssignmentDefinitionId | Yes      | The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"
parPolicyAssignmentParameters | No       | An object containing the parameter values for the policy to be assigned. DEFAULT VALUE = {}
parPolicyAssignmentParameterOverrides | No       | An object containing parameter values that override those provided to parPolicyAssignmentParameters, usually via a JSON file and loadJsonContent(FILE_PATH). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between parPolicyAssignmentParameters & parPolicyAssignmentParameterOverrides, inputs provided to parPolicyAssignmentParameterOverrides will win. DEFAULT VALUE = {}
parPolicyAssignmentNonComplianceMessages | No       | An array containing object/s for the non-compliance messages for the policy to be assigned. See https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages for more details on use. DEFAULT VALUE = []
parPolicyAssignmentNotScopes | No       | An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. ['/providers/Microsoft.Management/managementgroups/alz', '/providers/Microsoft.Management/managementgroups/alz-sandbox' ]. DEFAULT VALUE = []
parPolicyAssignmentEnforcementMode | No       | The enforcement mode for the policy assignment. See https://aka.ms/EnforcementMode for more details on use. DEAFULT VALUE = "Default"
parPolicyAssignmentIdentityType | No       | The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. DEAFULT VALUE = "None"
parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs | No       | An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. ['alz', 'alz-sandbox' ]. DEFAULT VALUE = [ <Management Group You Are Deploying To> ]
parPolicyAssignmentIdentityRoleAssignmentsSubs | No       | An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d' ]. DEFAULT VALUE = []
parPolicyAssignmentIdentityRoleDefinitionIds | No       | An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']. DEFAULT VALUE = []
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parPolicyAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the policy assignment. e.g. "Deny-Public-IP"

### parPolicyAssignmentDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The display name of the policy assignment. e.g. "Deny the creation of Public IPs"

### parPolicyAssignmentDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."

### parPolicyAssignmentDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"

### parPolicyAssignmentParameters

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object containing the parameter values for the policy to be assigned. DEFAULT VALUE = {}

### parPolicyAssignmentParameterOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object containing parameter values that override those provided to parPolicyAssignmentParameters, usually via a JSON file and loadJsonContent(FILE_PATH). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between parPolicyAssignmentParameters & parPolicyAssignmentParameterOverrides, inputs provided to parPolicyAssignmentParameterOverrides will win. DEFAULT VALUE = {}

### parPolicyAssignmentNonComplianceMessages

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing object/s for the non-compliance messages for the policy to be assigned. See https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages for more details on use. DEFAULT VALUE = []

### parPolicyAssignmentNotScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. ['/providers/Microsoft.Management/managementgroups/alz', '/providers/Microsoft.Management/managementgroups/alz-sandbox' ]. DEFAULT VALUE = []

### parPolicyAssignmentEnforcementMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The enforcement mode for the policy assignment. See https://aka.ms/EnforcementMode for more details on use. DEAFULT VALUE = "Default"

- Default value: `Default`

- Allowed values: `Default`, `DoNotEnforce`

### parPolicyAssignmentIdentityType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. DEAFULT VALUE = "None"

- Default value: `None`

- Allowed values: `None`, `SystemAssigned`

### parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. ['alz', 'alz-sandbox' ]. DEFAULT VALUE = [ <Management Group You Are Deploying To> ]

### parPolicyAssignmentIdentityRoleAssignmentsSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d' ]. DEFAULT VALUE = []

### parPolicyAssignmentIdentityRoleDefinitionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']. DEFAULT VALUE = []

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
        "parPolicyAssignmentIdentityType": {
            "value": "None"
        },
        "parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs": {
            "value": []
        },
        "parPolicyAssignmentIdentityRoleAssignmentsSubs": {
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
