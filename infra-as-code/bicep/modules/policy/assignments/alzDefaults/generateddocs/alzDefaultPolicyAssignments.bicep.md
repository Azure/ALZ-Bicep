# ALZ Bicep - Default Policy Assignments

Assigns ALZ Default Policies to the Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for management group names/IDs.
parPlatformMgAlzDefaultsEnable | No       | Apply platform policies to Platform group or child groups.
parLandingZoneChildrenMgAlzDefaultsEnable | No       | Assign policies to Corp & Online Management Groups under Landing Zones.
parLandingZoneMgConfidentialEnable | No       | Assign policies to Confidential Corp and Online groups under Landing Zones.
parPlatformHealthModelPolicyAssignmentEnable | No       | Preview (experimental). Assign the CloudHealth platform health-model policy at the Platform management group. Defaults to true. Set to false to opt out.
parApplicationHealthModelPolicyAssignmentEnable | No       | Preview (experimental). Assign the CloudHealth application landing zone health-model policy at the Landing Zones management group. Defaults to true. Set to false to opt out.
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | Location of Log Analytics Workspace & Automation Account.
parLogAnalyticsWorkspaceResourceId | No       | Resource ID of Log Analytics Workspace.
parLogAnalyticsWorkspaceResourceCategory | No       | Category of logs for supported resource logging for Log Analytics Workspace.
parDataCollectionRuleVMInsightsResourceId | No       | Resource ID for VM Insights Data Collection Rule.
parDataCollectionRuleChangeTrackingResourceId | No       | Resource ID for Change Tracking Data Collection Rule.
parDataCollectionRuleMDFCSQLResourceId | No       | Resource ID for MDFC SQL Data Collection Rule.
parUserAssignedManagedIdentityResourceId | No       | Resource ID for User Assigned Managed Identity.
parMsDefenderForCloudEmailSecurityContact | No       | Email address for Microsoft Defender for Cloud alerts.
parDdosEnabled | No       | Enable/disable DDoS Network Protection.
parDdosProtectionPlanId | No       | Resource ID of the DDoS Protection Plan for Virtual Networks.
parPrivateDnsResourceGroupId | No       | Resource ID of the Resource Group for Private DNS Zones. Empty to skip assigning the Deploy-Private-DNS-Zones policy.
parPrivateDnsZonesLocation | No       | Location of Private DNS Zones.
parPrivateDnsZonesNamesToAuditInCorp | No       | List of Private DNS Zones to audit under the Corp Management Group. This overwrites default values.
parPolicyAssignmentsToDisableEnforcement | No       | Set the enforcement mode to DoNotEnforce for specific default ALZ policies.
parDisableAlzDefaultPolicies | No       | Set the enforcement mode to DoNotEnforce for all default ALZ policies.
parVmBackupExclusionTagName | No       | Tag name for excluding VMs from this policy scope.
parVmBackupExclusionTagValue | No       | Tag value for excluding VMs from this policy scope.
parServiceHealthAlertResourceGroupName | No       | Resource group name for the service health alert rule. Used by the Deploy-SvcHealth-BuiltIn policy assignment.
parServiceHealthAlertActionGroupResources | No       | Action group resources configuration for the service health alert rule. Used by the Deploy-SvcHealth-BuiltIn policy assignment.
parPlatformHealthModelLocation | No       | Azure region for the platform health model and remediation deployment. Must support Microsoft.CloudHealth.
parPlatformHealthModelTargetResourceGroupName | No       | Name of the resource group the remediation creates when needed and deploys the platform health model into.
parPlatformHealthModelName | No       | Name of the platform health model.
parPlatformHealthModelIncludedResourceTypesGlobal | No       | Resource types added to every platform domain discovery query and unioned with each per-domain list.
parPlatformHealthModelSecurityResourceTypes | No       | Resource types added to every Security subdomain discovery query.
parPlatformHealthModelConnectivityResourceTypes | No       | Resource types added to every Connectivity subdomain discovery query.
parPlatformHealthModelManagementResourceTypes | No       | Resource types added to every Management subdomain discovery query.
parPlatformHealthModelIdentityResourceTypes | No       | Resource types added to every Identity subdomain discovery query.
parPlatformHealthModelDomainOverrides | No       | Per-domain advanced overrides for the platform health model. Each domain key may set tagFilters (max five) and replace the built-in subdomain split.
parApplicationHealthModelLocation | No       | Azure region for the application landing zone health model and remediation deployment. Must support Microsoft.CloudHealth.
parApplicationHealthModelTargetResourceGroupName | No       | Name of the resource group the remediation creates when needed and deploys the application landing zone health model into.
parApplicationHealthModelName | No       | Name of the application landing zone health model.
parApplicationHealthModelIncludedResourceTypesGlobal | No       | Resource types added to every application landing zone domain discovery query and unioned with each per-domain list.
parApplicationHealthModelComputeResourceTypes | No       | Resource types added to every Compute subdomain discovery query.
parApplicationHealthModelDataResourceTypes | No       | Resource types added to every Data subdomain discovery query.
parApplicationHealthModelRoutingResourceTypes | No       | Resource types added to every Routing subdomain discovery query.
parApplicationHealthModelAiResourceTypes | No       | Resource types added to every AI subdomain discovery query.
parApplicationHealthModelConfigResourceTypes | No       | Resource types added to every Config subdomain discovery query.
parApplicationHealthModelDomainOverrides | No       | Per-domain advanced overrides for the application landing zone health model. Each domain key may set tagFilters (max five) and replace the built-in subdomain split.
parExcludedPolicyAssignments | No       | Names of policy assignments to exclude from the deployment entirely.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parManagementGroupIdOverrides | Yes      | Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for management group names/IDs.

### parPlatformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Apply platform policies to Platform group or child groups.

- Default value: `True`

### parLandingZoneChildrenMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assign policies to Corp & Online Management Groups under Landing Zones.

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assign policies to Confidential Corp and Online groups under Landing Zones.

- Default value: `False`

### parPlatformHealthModelPolicyAssignmentEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Preview (experimental). Assign the CloudHealth platform health-model policy at the Platform management group. Defaults to true. Set to false to opt out.

- Default value: `True`

### parApplicationHealthModelPolicyAssignmentEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Preview (experimental). Assign the CloudHealth application landing zone health-model policy at the Landing Zones management group. Defaults to true. Set to false to opt out.

- Default value: `True`

### parLogAnalyticsWorkSpaceAndAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location of Log Analytics Workspace & Automation Account.

- Default value: `eastus`

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of Log Analytics Workspace.

### parLogAnalyticsWorkspaceResourceCategory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Category of logs for supported resource logging for Log Analytics Workspace.

- Default value: `allLogs`

### parDataCollectionRuleVMInsightsResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID for VM Insights Data Collection Rule.

### parDataCollectionRuleChangeTrackingResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID for Change Tracking Data Collection Rule.

### parDataCollectionRuleMDFCSQLResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID for MDFC SQL Data Collection Rule.

### parUserAssignedManagedIdentityResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID for User Assigned Managed Identity.

### parMsDefenderForCloudEmailSecurityContact

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Email address for Microsoft Defender for Cloud alerts.

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enable/disable DDoS Network Protection.

- Default value: `True`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the DDoS Protection Plan for Virtual Networks.

### parPrivateDnsResourceGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the Resource Group for Private DNS Zones. Empty to skip assigning the Deploy-Private-DNS-Zones policy.

### parPrivateDnsZonesLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location of Private DNS Zones.

### parPrivateDnsZonesNamesToAuditInCorp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

List of Private DNS Zones to audit under the Corp Management Group. This overwrites default values.

### parPolicyAssignmentsToDisableEnforcement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the enforcement mode to DoNotEnforce for specific default ALZ policies.

### parDisableAlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the enforcement mode to DoNotEnforce for all default ALZ policies.

- Default value: `False`

### parVmBackupExclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tag name for excluding VMs from this policy scope.

### parVmBackupExclusionTagValue

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tag value for excluding VMs from this policy scope.

### parServiceHealthAlertResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource group name for the service health alert rule. Used by the Deploy-SvcHealth-BuiltIn policy assignment.

- Default value: `rg-serviceHealthAlert`

### parServiceHealthAlertActionGroupResources

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Action group resources configuration for the service health alert rule. Used by the Deploy-SvcHealth-BuiltIn policy assignment.

- Default value: `@{actionGroupEmail=System.Object[]; webhookServiceUri=System.Object[]; logicappResourceId=; logicappCallbackUrl=; eventHubResourceId=System.Object[]; functionResourceId=; functionTriggerUrl=}`

### parPlatformHealthModelLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure region for the platform health model and remediation deployment. Must support Microsoft.CloudHealth.

- Default value: `swedencentral`

### parPlatformHealthModelTargetResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the resource group the remediation creates when needed and deploys the platform health model into.

- Default value: `rg-alz-healthmodels`

### parPlatformHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the platform health model.

- Default value: `alz-platform-healthmodel`

### parPlatformHealthModelIncludedResourceTypesGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every platform domain discovery query and unioned with each per-domain list.

### parPlatformHealthModelSecurityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Security subdomain discovery query.

### parPlatformHealthModelConnectivityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Connectivity subdomain discovery query.

### parPlatformHealthModelManagementResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Management subdomain discovery query.

### parPlatformHealthModelIdentityResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Identity subdomain discovery query.

### parPlatformHealthModelDomainOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Per-domain advanced overrides for the platform health model. Each domain key may set tagFilters (max five) and replace the built-in subdomain split.

### parApplicationHealthModelLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure region for the application landing zone health model and remediation deployment. Must support Microsoft.CloudHealth.

- Default value: `swedencentral`

### parApplicationHealthModelTargetResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the resource group the remediation creates when needed and deploys the application landing zone health model into.

- Default value: `rg-application-healthmodels`

### parApplicationHealthModelName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the application landing zone health model.

- Default value: `alz-application-healthmodel`

### parApplicationHealthModelIncludedResourceTypesGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every application landing zone domain discovery query and unioned with each per-domain list.

### parApplicationHealthModelComputeResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Compute subdomain discovery query.

### parApplicationHealthModelDataResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Data subdomain discovery query.

### parApplicationHealthModelRoutingResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Routing subdomain discovery query.

### parApplicationHealthModelAiResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every AI subdomain discovery query.

### parApplicationHealthModelConfigResourceTypes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource types added to every Config subdomain discovery query.

### parApplicationHealthModelDomainOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Per-domain advanced overrides for the application landing zone health model. Each domain key may set tagFilters (max five) and replace the built-in subdomain split.

### parExcludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Names of policy assignments to exclude from the deployment entirely.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt out of deployment telemetry.

- Default value: `False`

### parManagementGroupIdOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
        },
        "parPlatformMgAlzDefaultsEnable": {
            "value": true
        },
        "parLandingZoneChildrenMgAlzDefaultsEnable": {
            "value": true
        },
        "parLandingZoneMgConfidentialEnable": {
            "value": false
        },
        "parPlatformHealthModelPolicyAssignmentEnable": {
            "value": true
        },
        "parApplicationHealthModelPolicyAssignmentEnable": {
            "value": true
        },
        "parLogAnalyticsWorkSpaceAndAutomationAccountLocation": {
            "value": "eastus"
        },
        "parLogAnalyticsWorkspaceResourceId": {
            "value": ""
        },
        "parLogAnalyticsWorkspaceResourceCategory": {
            "value": "allLogs"
        },
        "parDataCollectionRuleVMInsightsResourceId": {
            "value": ""
        },
        "parDataCollectionRuleChangeTrackingResourceId": {
            "value": ""
        },
        "parDataCollectionRuleMDFCSQLResourceId": {
            "value": ""
        },
        "parUserAssignedManagedIdentityResourceId": {
            "value": ""
        },
        "parMsDefenderForCloudEmailSecurityContact": {
            "value": ""
        },
        "parDdosEnabled": {
            "value": true
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parPrivateDnsResourceGroupId": {
            "value": ""
        },
        "parPrivateDnsZonesLocation": {
            "value": ""
        },
        "parPrivateDnsZonesNamesToAuditInCorp": {
            "value": []
        },
        "parPolicyAssignmentsToDisableEnforcement": {
            "value": []
        },
        "parDisableAlzDefaultPolicies": {
            "value": false
        },
        "parVmBackupExclusionTagName": {
            "value": ""
        },
        "parVmBackupExclusionTagValue": {
            "value": []
        },
        "parServiceHealthAlertResourceGroupName": {
            "value": "rg-serviceHealthAlert"
        },
        "parServiceHealthAlertActionGroupResources": {
            "value": {
                "actionGroupEmail": [],
                "webhookServiceUri": [],
                "logicappResourceId": "",
                "logicappCallbackUrl": "",
                "eventHubResourceId": [],
                "functionResourceId": "",
                "functionTriggerUrl": ""
            }
        },
        "parPlatformHealthModelLocation": {
            "value": "swedencentral"
        },
        "parPlatformHealthModelTargetResourceGroupName": {
            "value": "rg-alz-healthmodels"
        },
        "parPlatformHealthModelName": {
            "value": "alz-platform-healthmodel"
        },
        "parPlatformHealthModelIncludedResourceTypesGlobal": {
            "value": []
        },
        "parPlatformHealthModelSecurityResourceTypes": {
            "value": []
        },
        "parPlatformHealthModelConnectivityResourceTypes": {
            "value": []
        },
        "parPlatformHealthModelManagementResourceTypes": {
            "value": []
        },
        "parPlatformHealthModelIdentityResourceTypes": {
            "value": []
        },
        "parPlatformHealthModelDomainOverrides": {
            "value": {}
        },
        "parApplicationHealthModelLocation": {
            "value": "swedencentral"
        },
        "parApplicationHealthModelTargetResourceGroupName": {
            "value": "rg-application-healthmodels"
        },
        "parApplicationHealthModelName": {
            "value": "alz-application-healthmodel"
        },
        "parApplicationHealthModelIncludedResourceTypesGlobal": {
            "value": []
        },
        "parApplicationHealthModelComputeResourceTypes": {
            "value": []
        },
        "parApplicationHealthModelDataResourceTypes": {
            "value": []
        },
        "parApplicationHealthModelRoutingResourceTypes": {
            "value": []
        },
        "parApplicationHealthModelAiResourceTypes": {
            "value": []
        },
        "parApplicationHealthModelConfigResourceTypes": {
            "value": []
        },
        "parApplicationHealthModelDomainOverrides": {
            "value": {}
        },
        "parExcludedPolicyAssignments": {
            "value": []
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parManagementGroupIdOverrides": {
            "value": null
        }
    }
}
```
