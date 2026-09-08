# ALZ Bicep - CloudHealth Platform Health Model Topology

Preview (experimental): assembles the platform domain and subdomain taxonomy and deploys it through the generic health model topology module. Deployable directly for fast testing, and compiled for embedding in the platform policy.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parHealthModelName | Yes      | Name of the platform health model.
parLocation    | Yes      | Location for the health model. Must support Microsoft.CloudHealth.
parAuthenticationSettingName | No       | Name of the managed-identity authentication setting.
parIncludedResourceTypesGlobal | No       | Resource types added to every subdomain discovery query across all domains.
parSecurityResourceTypes | No       | Resource types added to every Security subdomain discovery query.
parConnectivityResourceTypes | No       | Resource types added to every Connectivity subdomain discovery query.
parManagementResourceTypes | No       | Resource types added to every Management subdomain discovery query.
parIdentityResourceTypes | No       | Resource types added to every Identity subdomain discovery query.
parSecuritySubscriptionId | No       | Subscription ID whose resources the Security domain discovery queries.
parConnectivitySubscriptionId | No       | Subscription ID whose resources the Connectivity domain discovery queries.
parManagementSubscriptionId | No       | Subscription ID whose resources the Management domain discovery queries.
parIdentitySubscriptionId | No       | Subscription ID whose resources the Identity domain discovery queries.
parDomainOverrides | No       | Per-domain advanced overrides. Each key may set tagFilters and replace the built-in subdomain split.

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the platform health model.

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

### parSecurityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Security subdomain discovery query.

### parConnectivityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Connectivity subdomain discovery query.

### parManagementResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Management subdomain discovery query.

### parIdentityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Identity subdomain discovery query.

### parSecuritySubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Security domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parConnectivitySubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Connectivity domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parManagementSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Management domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parIdentitySubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Identity domain discovery queries.

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
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelPlatformTopology.json"
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
        "parSecurityResourceTypes": {
            "value": []
        },
        "parConnectivityResourceTypes": {
            "value": []
        },
        "parManagementResourceTypes": {
            "value": []
        },
        "parIdentityResourceTypes": {
            "value": []
        },
        "parSecuritySubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parConnectivitySubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parManagementSubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parIdentitySubscriptionId": {
            "value": "[subscription().subscriptionId]"
        },
        "parDomainOverrides": {
            "value": {}
        }
    }
}
```
