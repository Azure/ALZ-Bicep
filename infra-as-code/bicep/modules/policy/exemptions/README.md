# ALZ Bicep - Management Group Policy Exemptions

Module used to create a policy exemption for a policy assignment in a management group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPolicyAssignmentId | Yes      | SLZ Policy Set Assignment id
parExemptionCategory | No       | Exemption Category Default - Waiver
parDescription | Yes      | Description
parAssignmentScopeValidation | No       | Assignment Scope
parPolicyDefinitionReferenceIds | Yes      | Reference ids of Policies to be exempted
parExemptionName | Yes      | Exemption Name
parExemptionDisplayName | Yes      | Exemption Display Name

### parPolicyAssignmentId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

SLZ Policy Set Assignment id

### parExemptionCategory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Exemption Category Default - Waiver

- Default value: `Waiver`

- Allowed values: `Waiver`, `Mitigated`

### parDescription

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Description

### parAssignmentScopeValidation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assignment Scope

- Default value: `Default`

- Allowed values: `Default`, `DoNotValidate`

### parPolicyDefinitionReferenceIds

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Reference ids of Policies to be exempted

### parExemptionName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Exemption Name

### parExemptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Exemption Display Name

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
