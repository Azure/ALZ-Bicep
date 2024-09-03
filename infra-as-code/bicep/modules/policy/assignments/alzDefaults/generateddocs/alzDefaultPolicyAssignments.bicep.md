# ALZ Bicep - Default Policy Assignments

Assigns ALZ Default Policies to the Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for management group names/IDs. Include a dash if needed.
parTopLevelPolicyAssignmentSovereigntyGlobal | No       | Object used to assign Sovereignty Baseline - Global Policies to the intermediate root management group.'  - `parTopLevelSovereignGlobalPoliciesEnable` - Switch to enable/disable deployment of the Sovereignty Baseline - Global Policies Assignment to the intermediate root management group. - `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed. - `parPolicyEffect` - The effect type for the Sovereignty Baseline - Global Policies Assignment.  
parPolicyAssignmentSovereigntyConfidential | No       | Object used to assign Sovereignty Baseline - Confidential Policies to the confidential landing zone management groups.'  - `parAllowedResourceTypes` - The list of Azure resource types approved for usage, which is the set of resource types that have a SKU backed by Azure Confidential Computing or resource types that do not process customer data. Leave empty to allow all relevant resource types. - `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed. - `parallowedVirtualMachineSKUs` - The list of VM SKUs approved approved for usage, which is the set of SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs. - `parPolicyEffect` - The effect type for the Sovereignty Baseline - Confidential Policies Assignment.  
parPlatformMgAlzDefaultsEnable | No       | Toggle to apply platform policies to the Platform group or child groups.
parLandingZoneChildrenMgAlzDefaultsEnable | No       | Toggle to assign policies to Corp & Online Management Groups under Landing Zones.
parLandingZoneMgConfidentialEnable | No       | Toggle to assign policies to Confidential Corp and Online groups under Landing Zones.
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | Location of Log Analytics Workspace & Automation Account.
parLogAnalyticsWorkspaceResourceId | No       | Resource ID of Log Analytics Workspace.
parDataCollectionRuleVMInsightsResourceId | No       | Resource ID for VM Insights Data Collection Rule.
parDataCollectionRuleChangeTrackingResourceId | No       | Resource ID for Change Tracking Data Collection Rule.
parDataCollectionRuleMDFCSQLResourceId | No       | Resource ID for MDFC SQL Data Collection Rule.
parUserAssignedManagedIdentityResourceId | No       | Resource ID for User Assigned Managed Identity.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days to retain logs in Log Analytics Workspace.
parAutomationAccountName | No       | Name of the Automation Account.
parMsDefenderForCloudEmailSecurityContact | No       | Email address for Microsoft Defender for Cloud alerts.
parDdosEnabled | No       | Toggle to enable/disable DDoS Network Protection deployment. True enforces the Enable-DDoS-VNET policy at connectivity or landing zone groups; false does not.
parDdosProtectionPlanId | No       | Resource ID of the DDoS Protection Plan applied to Virtual Networks.
parPrivateDnsResourceGroupId | No       | Resource ID of the Resource Group containing Private DNS Zones. Leave empty to skip assigning the Deploy-Private-DNS-Zones policy to the Corp Management Group.
parPrivateDnsZonesNamesToAuditInCorp | No       | List of Private DNS Zones to audit if deployed in Subscriptions under the Corp Management Group. Include all zones, as this parameter overwrites default values. Retrieve names from the outPrivateDnsZonesNames output in the Hub Networking or Private DNS Zone modules.
parDisableAlzDefaultPolicies | No       | Set to true to disable enforcement of all default ALZ policies.
parDisableSlzDefaultPolicies | No       | Set to true to disable enforcement of all default sovereign policies.
parVmBackupExclusionTagName | No       | Tag name for excluding VMs from this policy’s scope. Use with the Exclusion Tag Value parameter.
parVmBackupExclusionTagValue | No       | Tag value for excluding VMs from this policy’s scope (use a comma-separated list for multiple values). Use with the Exclusion Tag Name parameter.
parExcludedPolicyAssignments | No       | Add assignment definition names to exclude specific policies. Find values in the Assigning Policies documentation.
parTelemetryOptOut | No       | Set to true to opt out of deployment telemetry.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for management group names/IDs. Include a dash if needed.

### parTopLevelPolicyAssignmentSovereigntyGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object used to assign Sovereignty Baseline - Global Policies to the intermediate root management group.'

- `parTopLevelSovereignGlobalPoliciesEnable` - Switch to enable/disable deployment of the Sovereignty Baseline - Global Policies Assignment to the intermediate root management group.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parPolicyEffect` - The effect type for the Sovereignty Baseline - Global Policies Assignment.



- Default value: `@{parTopLevelSovereigntyGlobalPoliciesEnable=False; parListOfAllowedLocations=System.Object[]; parPolicyEffect=Deny}`

### parPolicyAssignmentSovereigntyConfidential

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object used to assign Sovereignty Baseline - Confidential Policies to the confidential landing zone management groups.'

- `parAllowedResourceTypes` - The list of Azure resource types approved for usage, which is the set of resource types that have a SKU backed by Azure Confidential Computing or resource types that do not process customer data. Leave empty to allow all relevant resource types.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parallowedVirtualMachineSKUs` - The list of VM SKUs approved approved for usage, which is the set of SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs.
- `parPolicyEffect` - The effect type for the Sovereignty Baseline - Confidential Policies Assignment.



- Default value: `@{parAllowedResourceTypes=System.Object[]; parListOfAllowedLocations=System.Object[]; parAllowedVirtualMachineSKUs=System.Object[]; parPolicyEffect=Deny}`

### parPlatformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Toggle to apply platform policies to the Platform group or child groups.

- Default value: `True`

### parLandingZoneChildrenMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Toggle to assign policies to Corp & Online Management Groups under Landing Zones.

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Toggle to assign policies to Confidential Corp and Online groups under Landing Zones.

- Default value: `False`

### parLogAnalyticsWorkSpaceAndAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location of Log Analytics Workspace & Automation Account.

- Default value: `eastus`

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of Log Analytics Workspace.

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

- Default value: `security_contact@replace_me.com`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Toggle to enable/disable DDoS Network Protection deployment. True enforces the Enable-DDoS-VNET policy at connectivity or landing zone groups; false does not.

- Default value: `True`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the DDoS Protection Plan applied to Virtual Networks.

### parPrivateDnsResourceGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the Resource Group containing Private DNS Zones. Leave empty to skip assigning the Deploy-Private-DNS-Zones policy to the Corp Management Group.

### parPrivateDnsZonesNamesToAuditInCorp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

List of Private DNS Zones to audit if deployed in Subscriptions under the Corp Management Group. Include all zones, as this parameter overwrites default values. Retrieve names from the outPrivateDnsZonesNames output in the Hub Networking or Private DNS Zone modules.

### parDisableAlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set to true to disable enforcement of all default ALZ policies.

- Default value: `False`

### parDisableSlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set to true to disable enforcement of all default sovereign policies.

- Default value: `False`

### parVmBackupExclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tag name for excluding VMs from this policy’s scope. Use with the Exclusion Tag Value parameter.

### parVmBackupExclusionTagValue

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tag value for excluding VMs from this policy’s scope (use a comma-separated list for multiple values). Use with the Exclusion Tag Name parameter.

### parExcludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Add assignment definition names to exclude specific policies. Find values in the Assigning Policies documentation.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set to true to opt out of deployment telemetry.

- Default value: `False`

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
        "parTopLevelPolicyAssignmentSovereigntyGlobal": {
            "value": {
                "parTopLevelSovereigntyGlobalPoliciesEnable": false,
                "parListOfAllowedLocations": [],
                "parPolicyEffect": "Deny"
            }
        },
        "parPolicyAssignmentSovereigntyConfidential": {
            "value": {
                "parAllowedResourceTypes": [],
                "parListOfAllowedLocations": [],
                "parAllowedVirtualMachineSKUs": [],
                "parPolicyEffect": "Deny"
            }
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
            "value": "security_contact@replace_me.com"
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
        "parPrivateDnsZonesNamesToAuditInCorp": {
            "value": []
        },
        "parDisableAlzDefaultPolicies": {
            "value": false
        },
        "parDisableSlzDefaultPolicies": {
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
        }
    }
}
```
