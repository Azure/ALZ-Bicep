# ALZ Bicep - CloudHealth Application Landing Zone Health Model Policy

Preview (experimental): deploys a Microsoft CloudHealth application landing zone health model through Azure Policy.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Location for the policy assignment identity, remediation deployment, target resource group, and health model. Must support Microsoft.CloudHealth.
parTargetResourceGroupName | No       | Name of the resource group the remediation creates when needed and deploys the application landing zone health model into.
parHealthModelName | No       | Name of the application landing zone health model. One model contains all five domain discovery rules.
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
parDomainOverrides | No       | Advanced per-domain overrides. Each domain key may set tagFilters (up to five { key, value } pairs, ANDed) and subdomains to replace the built-in subdomain split. Leave empty to use the built-in taxonomy with no tag filtering.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for the policy assignment identity, remediation deployment, target resource group, and health model. Must support Microsoft.CloudHealth.

- Default value: `swedencentral`

### parTargetResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the resource group the remediation creates when needed and deploys the application landing zone health model into.

- Default value: `rg-application-healthmodels`

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the application landing zone health model. One model contains all five domain discovery rules.

- Default value: `alz-application-healthmodel`

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

### parDomainOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Advanced per-domain overrides. Each domain key may set tagFilters (up to five { key, value } pairs, ANDed) and subdomains to replace the built-in subdomain split. Leave empty to use the built-in taxonomy with no tag filtering.

## Outputs

Name | Type | Description
---- | ---- | -----------
outPolicyDefinitionId | string | Resource ID of the custom policy definition.
outPolicyAssignmentId | string | Resource ID of the policy assignment.

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
        "parDomainOverrides": {
            "value": {}
        }
    }
}
```
