# ALZ Bicep - CloudHealth Platform Health Model Policy

Preview (experimental): deploys a Microsoft CloudHealth platform health model through Azure Policy.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | Location for the policy assignment identity, remediation deployment, target resource group, and health model. Must support Microsoft.CloudHealth.
parTargetResourceGroupName | No       | Name of the resource group the remediation creates when needed and deploys the platform health model into.
parHealthModelName | No       | Name of the platform health model. One model contains all four domain discovery rules.
parPolicyName  | No       | Name of the custom policy definition.
parAssignmentName | No       | Name of the policy assignment.
parDeployHealthModel | No       | Preview (experimental). Deploy the health model through policy remediation. Defaults to true. Set to false only to pause remediation while keeping the policy, identities, and RBAC deployed with a Disabled effect.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parEnforcementMode | No       | Enforcement mode for the policy assignment.
parIncludedResourceTypesGlobal | No       | Resource types added to every domain discovery query and unioned with each per-domain list.
parSecurityResourceTypes | No       | Resource types discovered for the Security platform domain, unioned with the global list.
parConnectivityResourceTypes | No       | Resource types discovered for the Connectivity platform domain, unioned with the global list.
parManagementResourceTypes | No       | Resource types discovered for the Management platform domain, unioned with the global list.
parIdentityResourceTypes | No       | Resource types discovered for the Identity platform domain, unioned with the global list.
parDomainOverrides | No       | Advanced per-domain overrides. Each domain key may set tagFilters (up to five { key, value } pairs, ANDed) and subdomains to replace the built-in subdomain split. Leave empty to use the built-in taxonomy with no tag filtering.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for the policy assignment identity, remediation deployment, target resource group, and health model. Must support Microsoft.CloudHealth.

- Default value: `swedencentral`

### parTargetResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the resource group the remediation creates when needed and deploys the platform health model into.

- Default value: `rg-alz-healthmodels`

### parHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the platform health model. One model contains all four domain discovery rules.

- Default value: `alz-platform-healthmodel`

### parPolicyName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the custom policy definition.

- Default value: `Deploy-ALZ-CloudHealth-PlatformModel`

### parAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the policy assignment.

- Default value: `Deploy-ALZ-CloudHealth`

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

### parSecurityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Security platform domain, unioned with the global list.

- Default value: `Microsoft.KeyVault/vaults Microsoft.Network/azureFirewalls Microsoft.Network/firewallPolicies Microsoft.Network/ddosProtectionPlans`

### parConnectivityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Connectivity platform domain, unioned with the global list.

- Default value: `Microsoft.Network/virtualNetworks Microsoft.Network/virtualNetworkGateways Microsoft.Network/expressRouteCircuits Microsoft.Network/publicIPAddresses Microsoft.Network/loadBalancers Microsoft.Network/applicationGateways Microsoft.Network/privateDnsZones Microsoft.Network/bastionHosts Microsoft.Network/natGateways Microsoft.Network/connections`

### parManagementResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Management platform domain, unioned with the global list.

- Default value: `Microsoft.OperationalInsights/workspaces Microsoft.Automation/automationAccounts Microsoft.RecoveryServices/vaults Microsoft.Storage/storageAccounts Microsoft.Insights/components Microsoft.Insights/actionGroups`

### parIdentityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types discovered for the Identity platform domain, unioned with the global list.

- Default value: `Microsoft.ManagedIdentity/userAssignedIdentities Microsoft.Compute/virtualMachines Microsoft.KeyVault/vaults Microsoft.Network/privateDnsZones`

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
        "template": "infra-as-code/bicep/modules/policy/healthModel/healthModelPolicy.json"
    },
    "parameters": {
        "parLocation": {
            "value": "swedencentral"
        },
        "parTargetResourceGroupName": {
            "value": "rg-alz-healthmodels"
        },
        "parHealthModelName": {
            "value": "alz-platform-healthmodel"
        },
        "parPolicyName": {
            "value": "Deploy-ALZ-CloudHealth-PlatformModel"
        },
        "parAssignmentName": {
            "value": "Deploy-ALZ-CloudHealth"
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
        "parSecurityResourceTypes": {
            "value": [
                "Microsoft.KeyVault/vaults",
                "Microsoft.Network/azureFirewalls",
                "Microsoft.Network/firewallPolicies",
                "Microsoft.Network/ddosProtectionPlans"
            ]
        },
        "parConnectivityResourceTypes": {
            "value": [
                "Microsoft.Network/virtualNetworks",
                "Microsoft.Network/virtualNetworkGateways",
                "Microsoft.Network/expressRouteCircuits",
                "Microsoft.Network/publicIPAddresses",
                "Microsoft.Network/loadBalancers",
                "Microsoft.Network/applicationGateways",
                "Microsoft.Network/privateDnsZones",
                "Microsoft.Network/bastionHosts",
                "Microsoft.Network/natGateways",
                "Microsoft.Network/connections"
            ]
        },
        "parManagementResourceTypes": {
            "value": [
                "Microsoft.OperationalInsights/workspaces",
                "Microsoft.Automation/automationAccounts",
                "Microsoft.RecoveryServices/vaults",
                "Microsoft.Storage/storageAccounts",
                "Microsoft.Insights/components",
                "Microsoft.Insights/actionGroups"
            ]
        },
        "parIdentityResourceTypes": {
            "value": [
                "Microsoft.ManagedIdentity/userAssignedIdentities",
                "Microsoft.Compute/virtualMachines",
                "Microsoft.KeyVault/vaults",
                "Microsoft.Network/privateDnsZones"
            ]
        },
        "parDomainOverrides": {
            "value": {}
        }
    }
}
```
