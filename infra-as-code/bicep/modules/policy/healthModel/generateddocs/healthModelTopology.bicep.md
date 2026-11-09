# ALZ Bicep - CloudHealth Health Model Topology

Preview (experimental): deploys a Microsoft CloudHealth health model with domain grouping entities and one discovery rule per subdomain.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parHealthModelName | Yes      | Name of the health model. The root entity is declared with this exact name so the definition manages the provider built-in root.
parLocation    | Yes      | Location for the health model. Must support Microsoft.CloudHealth.
parAuthenticationSettingName | No       | Name of the managed-identity authentication setting.
parIncludedResourceTypesGlobal | No       | Resource types added to every subdomain discovery query and unioned with each subdomain list.
parDomains     | Yes      | Domains, each with its discovery scope and subdomains.

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the health model. The root entity is declared with this exact name so the definition manages the provider built-in root.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Location for the health model. Must support Microsoft.CloudHealth.

### parAuthenticationSettingName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the managed-identity authentication setting.

- Default value: `managed-identity`

### parIncludedResourceTypesGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every subdomain discovery query and unioned with each subdomain list.

### parDomains

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Domains, each with its discovery scope and subdomains.

## Outputs

Name | Type | Description
---- | ---- | -----------
outHealthModelName | string | Name of the deployed health model.
outSubdomainQueries | array | Assembled discovery queries, one per subdomain, for verification.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelTopology.json"
    },
    "parameters": {
        "parHealthModelName": {
            "value": ""
        },
        "parLocation": {
            "value": ""
        },
        "parAuthenticationSettingName": {
            "value": "managed-identity"
        },
        "parIncludedResourceTypesGlobal": {
            "value": []
        },
        "parDomains": {
            "value": []
        }
    }
}
```
