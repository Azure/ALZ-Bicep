# ALZ Bicep - CloudHealth Management Group Policy Definitions

Preview (experimental): deploys CloudHealth health-model policy definitions at management-group scope for ALZ default assignments.

## Outputs

Name | Type | Description
---- | ---- | -----------
outPlatformPolicyDefinitionId | string | Resource ID of the platform CloudHealth policy definition.
outApplicationPolicyDefinitionId | string | Resource ID of the application CloudHealth policy definition.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelPolicyDefinitions.json"
    },
    "parameters": {}
}
```
