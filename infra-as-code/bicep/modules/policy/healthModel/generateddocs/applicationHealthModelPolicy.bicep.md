# ALZ Bicep - CloudHealth Application Landing Zone Health Model Policy

Preview (experimental): deploys a Microsoft CloudHealth application landing zone health model through Azure Policy.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Location for the discovery identity, policy assignment identity, and remediation deployments. Must support Microsoft.CloudHealth.
parTargetResourceGroupName | No       | Name of the existing resource group into which the application landing zone health model is deployed.
parHealthModelName | No       | Name of the application landing zone health model. One model contains all five domain discovery rules.
parIdentityName | No       | Name of the user-assigned managed identity used by the discovery rules.
parPolicyName  | No       | Name of the custom policy definition.
parAssignmentName | No       | Name of the policy assignment.
parDeployHealthModel | No       | Preview (experimental). Deploy the health model through policy remediation. Defaults to true. Set to false only to pause remediation while keeping the policy, identities, and RBAC deployed with a Disabled effect.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parEnforcementMode | No       | Enforcement mode for the policy assignment.
parIncludedResourceTypesGlobal | No       | Resource types added to every domain discovery query and unioned with each per-domain list.
parComputeResourceTypes | No       | Resource types discovered for the Compute application domain, unioned with the global list.
parDataResourceTypes | No       | Resource types discovered for the Data application domain, unioned with the global list.
parRoutingResourceTypes | No       | Resource types discovered for the Routing application domain, unioned with the global list.
parAiResourceTypes | No       | Resource types discovered for the AI application domain, unioned with the global list.
parConfigResourceTypes | No       | Resource types discovered for the Config application domain, unioned with the global list.
parComputeSubscriptionId | No       | Subscription ID whose resources the Compute domain discovery queries.
parDataSubscriptionId | No       | Subscription ID whose resources the Data domain discovery queries.
parRoutingSubscriptionId | No       | Subscription ID whose resources the Routing domain discovery queries.
parAiSubscriptionId | No       | Subscription ID whose resources the AI domain discovery queries.
parConfigSubscriptionId | No       | Subscription ID whose resources the Config domain discovery queries.
parComputeTagFilter | No       | Optional list of up to five { key, value } tag pairs that must all match for Compute resources.
parDataTagFilter | No       | Optional list of up to five { key, value } tag pairs that must all match for Data resources.
parRoutingTagFilter | No       | Optional list of up to five { key, value } tag pairs that must all match for Routing resources.
parAiTagFilter | No       | Optional list of up to five { key, value } tag pairs that must all match for AI resources.
parConfigTagFilter | No       | Optional list of up to five { key, value } tag pairs that must all match for Config resources.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for the discovery identity, policy assignment identity, and remediation deployments. Must support Microsoft.CloudHealth.

- Default value: `swedencentral`

### parTargetResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the existing resource group into which the application landing zone health model is deployed.

- Default value: `rg-application-healthmodels`

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the application landing zone health model. One model contains all five domain discovery rules.

- Default value: `alz-application-healthmodel`

### parIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the user-assigned managed identity used by the discovery rules.

- Default value: `alz-application-healthmodel-mi`

### parPolicyName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the custom policy definition.

- Default value: `Deploy-App-CloudHealth-ApplicationModel`

### parAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the policy assignment.

- Default value: `Deploy-App-CloudHealth`

### parDeployHealthModel

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Preview (experimental). Deploy the health model through policy remediation. Defaults to true. Set to false only to pause remediation while keeping the policy, identities, and RBAC deployed with a Disabled effect.

- Default value: `True`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt out of deployment telemetry.

- Default value: `False`

### parEnforcementMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enforcement mode for the policy assignment.

- Default value: `Default`

- Allowed values: `Default`, `DoNotEnforce`

### parIncludedResourceTypesGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every domain discovery query and unioned with each per-domain list.

### parComputeResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Compute application domain, unioned with the global list.

- Default value: `Microsoft.Web/sites Microsoft.App/containerApps Microsoft.ContainerService/managedClusters Microsoft.Compute/virtualMachines Microsoft.Compute/virtualMachineScaleSets`

### parDataResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Data application domain, unioned with the global list.

- Default value: `Microsoft.Storage/storageAccounts Microsoft.DocumentDB/databaseAccounts Microsoft.Sql/servers Microsoft.DBforPostgreSQL/flexibleServers Microsoft.Cache/redis`

### parRoutingResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Routing application domain, unioned with the global list.

- Default value: `Microsoft.Cdn/profiles Microsoft.Network/applicationGateways Microsoft.Network/loadBalancers Microsoft.Network/trafficManagerProfiles Microsoft.ApiManagement/service`

### parAiResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the AI application domain, unioned with the global list.

- Default value: `Microsoft.CognitiveServices/accounts Microsoft.Search/searchServices Microsoft.MachineLearningServices/workspaces`

### parConfigResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Config application domain, unioned with the global list.

- Default value: `Microsoft.AppConfiguration/configurationStores Microsoft.KeyVault/vaults Microsoft.ManagedIdentity/userAssignedIdentities`

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

Subscription ID whose resources the AI domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parConfigSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Subscription ID whose resources the Config domain discovery queries.

- Default value: `[subscription().subscriptionId]`

### parComputeTagFilter

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional list of up to five { key, value } tag pairs that must all match for Compute resources.

### parDataTagFilter

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional list of up to five { key, value } tag pairs that must all match for Data resources.

### parRoutingTagFilter

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional list of up to five { key, value } tag pairs that must all match for Routing resources.

### parAiTagFilter

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional list of up to five { key, value } tag pairs that must all match for AI resources.

### parConfigTagFilter

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional list of up to five { key, value } tag pairs that must all match for Config resources.

## Outputs

Name | Type | Description
---- | ---- | -----------
outPolicyDefinitionId | string | Resource ID of the custom policy definition.
outPolicyAssignmentId | string | Resource ID of the policy assignment.
outDiscoveryIdentityId | string | Resource ID of the discovery user-assigned managed identity.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/healthModel/applicationHealthModelPolicy.json"
    },
    "parameters": {
        "parLocation": {
            "value": "swedencentral"
        },
        "parTargetResourceGroupName": {
            "value": "rg-application-healthmodels"
        },
        "parHealthModelName": {
            "value": "alz-application-healthmodel"
        },
        "parIdentityName": {
            "value": "alz-application-healthmodel-mi"
        },
        "parPolicyName": {
            "value": "Deploy-App-CloudHealth-ApplicationModel"
        },
        "parAssignmentName": {
            "value": "Deploy-App-CloudHealth"
        },
        "parDeployHealthModel": {
            "value": true
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parEnforcementMode": {
            "value": "Default"
        },
        "parIncludedResourceTypesGlobal": {
            "value": []
        },
        "parComputeResourceTypes": {
            "value": [
                "Microsoft.Web/sites",
                "Microsoft.App/containerApps",
                "Microsoft.ContainerService/managedClusters",
                "Microsoft.Compute/virtualMachines",
                "Microsoft.Compute/virtualMachineScaleSets"
            ]
        },
        "parDataResourceTypes": {
            "value": [
                "Microsoft.Storage/storageAccounts",
                "Microsoft.DocumentDB/databaseAccounts",
                "Microsoft.Sql/servers",
                "Microsoft.DBforPostgreSQL/flexibleServers",
                "Microsoft.Cache/redis"
            ]
        },
        "parRoutingResourceTypes": {
            "value": [
                "Microsoft.Cdn/profiles",
                "Microsoft.Network/applicationGateways",
                "Microsoft.Network/loadBalancers",
                "Microsoft.Network/trafficManagerProfiles",
                "Microsoft.ApiManagement/service"
            ]
        },
        "parAiResourceTypes": {
            "value": [
                "Microsoft.CognitiveServices/accounts",
                "Microsoft.Search/searchServices",
                "Microsoft.MachineLearningServices/workspaces"
            ]
        },
        "parConfigResourceTypes": {
            "value": [
                "Microsoft.AppConfiguration/configurationStores",
                "Microsoft.KeyVault/vaults",
                "Microsoft.ManagedIdentity/userAssignedIdentities"
            ]
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
        "parComputeTagFilter": {
            "value": []
        },
        "parDataTagFilter": {
            "value": []
        },
        "parRoutingTagFilter": {
            "value": []
        },
        "parAiTagFilter": {
            "value": []
        },
        "parConfigTagFilter": {
            "value": []
        }
    }
}
```
