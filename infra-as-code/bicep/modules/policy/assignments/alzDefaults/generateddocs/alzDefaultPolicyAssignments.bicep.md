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
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | Location of Log Analytics Workspace & Automation Account.
parLogAnalyticsWorkspaceResourceId | No       | Resource ID of Log Analytics Workspace.
parLogAnalyticsWorkspaceResourceCategory | No       | Category of logs for supported resource logging for Log Analytics Workspace.
parDataCollectionRuleVMInsightsResourceId | No       | Resource ID for VM Insights Data Collection Rule.
parDataCollectionRuleChangeTrackingResourceId | No       | Resource ID for Change Tracking Data Collection Rule.
parDataCollectionRuleMDFCSQLResourceId | No       | Resource ID for MDFC SQL Data Collection Rule.
parUserAssignedManagedIdentityResourceId | No       | Resource ID for User Assigned Managed Identity.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days to retain logs in Log Analytics Workspace.
parAutomationAccountName | No       | Name of the Automation Account.
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

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days to retain logs in Log Analytics Workspace.

- Default value: `365`

### parAutomationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the Automation Account.

- Default value: `alz-automation-account`

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
        "parLogAnalyticsWorkspaceLogRetentionInDays": {
            "value": "365"
        },
        "parAutomationAccountName": {
            "value": "alz-automation-account"
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
