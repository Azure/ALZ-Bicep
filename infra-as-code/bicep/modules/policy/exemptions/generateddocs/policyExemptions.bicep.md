# ALZ Bicep - Management Group Policy Exemptions

Creates a policy exemption for a management group policy assignment.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentId | Yes      | The policy assignment ID for the exemption.
parExemptionCategory | No       | Exemption category.
parDescription | Yes      | Context for the exemption.
parAssignmentScopeValidation | No       | Scope validation setting.
parPolicyDefinitionReferenceIds | Yes      | List of policy definitions exempted in the initiative.
parExemptionName | Yes      | Policy exemption resource name.
parExemptionDisplayName | Yes      | Exemption display name.

### parPolicyAssignmentId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The policy assignment ID for the exemption.

### parExemptionCategory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Exemption category.

- Default value: `Waiver`

- Allowed values: `Waiver`, `Mitigated`

### parDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Context for the exemption.

### parAssignmentScopeValidation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Scope validation setting.

- Default value: `Default`

- Allowed values: `Default`, `DoNotValidate`

### parPolicyDefinitionReferenceIds

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

List of policy definitions exempted in the initiative.

### parExemptionName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Policy exemption resource name.

### parExemptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Exemption display name.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/exemptions/policyExemptions.json"
    },
    "parameters": {
        "parPolicyAssignmentId": {
            "value": ""
        },
        "parExemptionCategory": {
            "value": "Waiver"
        },
        "parDescription": {
            "value": ""
        },
        "parAssignmentScopeValidation": {
            "value": "Default"
        },
        "parPolicyDefinitionReferenceIds": {
            "value": []
        },
        "parExemptionName": {
            "value": ""
        },
        "parExemptionDisplayName": {
            "value": ""
        }
    }
}
```
