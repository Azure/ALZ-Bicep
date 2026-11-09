# ALZ Bicep - CloudHealth Application Health Model Topology

Preview (experimental): assembles the application domain and subdomain taxonomy and deploys it through the generic health model topology module. Deployable directly for fast testing, and compiled for embedding in the application policy.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parHealthModelName | Yes      | Name of the application landing zone health model.
parLocation    | Yes      | Location for the health model. Must support Microsoft.CloudHealth.
parAuthenticationSettingName | No       | Name of the managed-identity authentication setting.
parIncludedResourceTypesGlobal | No       | Resource types added to every subdomain discovery query across all domains.
parComputeResourceTypes | No       | Resource types added to every Compute subdomain discovery query.
parDataResourceTypes | No       | Resource types added to every Data subdomain discovery query.
parRoutingResourceTypes | No       | Resource types added to every Routing subdomain discovery query.
parAiResourceTypes | No       | Resource types added to every Ai subdomain discovery query.
parConfigResourceTypes | No       | Resource types added to every Config subdomain discovery query.
parComputeSubscriptionId | No       | Subscription ID whose resources the Compute domain discovery queries.
parDataSubscriptionId | No       | Subscription ID whose resources the Data domain discovery queries.
parRoutingSubscriptionId | No       | Subscription ID whose resources the Routing domain discovery queries.
parAiSubscriptionId | No       | Subscription ID whose resources the Ai domain discovery queries.
parConfigSubscriptionId | No       | Subscription ID whose resources the Config domain discovery queries.
parDomainOverrides | No       | Per-domain advanced overrides. Each key may set tagFilters and replace the built-in subdomain split.

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the application landing zone health model.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Location for the health model. Must support Microsoft.CloudHealth.

### parAuthenticationSettingName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the managed-identity authentication setting.

- Default value: `managed-identity`

### parIncludedResourceTypesGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every subdomain discovery query across all domains.

### parComputeResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Compute subdomain discovery query.

### parDataResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Data subdomain discovery query.

### parRoutingResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Routing subdomain discovery query.

### parAiResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Ai subdomain discovery query.

### parConfigResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Config subdomain discovery query.

### parComputeSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Compute domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parDataSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Data domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parRoutingSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Routing domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parAiSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Ai domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parConfigSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Config domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parDomainOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Per-domain advanced overrides. Each key may set tagFilters and replace the built-in subdomain split.

## Outputs

Name | Type | Description
---- | ---- | -----------
outSubdomainQueries | array | Assembled discovery queries, one per subdomain, for verification.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelApplicationTopology.json"
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
        "parComputeResourceTypes": {
            "value": []
        },
        "parDataResourceTypes": {
            "value": []
        },
        "parRoutingResourceTypes": {
            "value": []
        },
        "parAiResourceTypes": {
            "value": []
        },
        "parConfigResourceTypes": {
            "value": []
        },
        "parComputeSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parDataSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parRoutingSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parAiSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parConfigSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parDomainOverrides": {
            "value": {}
        }
    }
}
```
