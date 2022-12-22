# ALZ Bicep - Custom Policy Defitions at Management Group Scope

This policy definition is used to deploy custom policy definitions at management group scope

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTargetManagementGroupId | No       | The management group scope to which the policy definitions are to be created at.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parTargetManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the policy definitions are to be created at.

- Default value: `alz`

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
        "template": "infra-as-code/bicep/modules/policy/definitions/customPolicyDefinitions.json"
    },
    "parameters": {
        "parTargetManagementGroupId": {
            "value": "alz"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
