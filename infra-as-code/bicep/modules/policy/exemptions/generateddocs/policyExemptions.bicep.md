# ALZ Bicep - Management Group Policy Exemptions

Module used to create a policy exemption for a policy assignment in a management group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentId | Yes      | The ID of the policy set assignment for which the exemption will be established.
parExemptionCategory | No       | The exemption category to be used.
parDescription | Yes      | The description which provides context for the policy exemption.
parAssignmentScopeValidation | No       | Sets the scope to permit an exemption to bypass this validation and be created beyond the assignment scope.
parPolicyDefinitionReferenceIds | Yes      | List used to specify which policy definition(s) in the initiative the subject resource has an exemption to.
parExemptionName | Yes      | The resource name of the policy exemption.
parExemptionDisplayName | Yes      | The display name of the exemption.

### parPolicyAssignmentId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The ID of the policy set assignment for which the exemption will be established.

### parExemptionCategory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The exemption category to be used.

- Default value: `Waiver`

- Allowed values: `Waiver`, `Mitigated`

### parDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The description which provides context for the policy exemption.

### parAssignmentScopeValidation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Sets the scope to permit an exemption to bypass this validation and be created beyond the assignment scope.

- Default value: `Default`

- Allowed values: `Default`, `DoNotValidate`

### parPolicyDefinitionReferenceIds

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

List used to specify which policy definition(s) in the initiative the subject resource has an exemption to.

### parExemptionName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The resource name of the policy exemption.

### parExemptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The display name of the exemption.

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
