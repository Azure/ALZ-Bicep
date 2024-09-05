# ALZ Bicep - Default Policy Assignments

Assigns ALZ Default Policies to the Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parTopLevelPolicyAssignmentSovereigntyGlobal | No       | Object used to assign SovrBL - Global Policies to the intermediate root MG.'  - `parTopLevelSovereignGlobalPoliciesEnable` - Switch to enable/disable deployment of the SovrBL - Global Pol Ass to the intermediate root MG. - `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed. - `parPolicyEffect` - The effect type for the SovrBL - Global Pol Ass.
parPolicyAssignmentSovereigntyConfidential | No       | Object used to assign SovrBL - Confidential Policies to the confidential landing zone management groups.'  - `parAllowedResourceTypes` - The list of Azure resource types approved for usage, which is the set of resource types that have a SKU backed by Azure Confidential Computing or resource types that do not process customer data. Leave empty to allow all relevant resource types. - `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed. - `parallowedVirtualMachineSKUs` - The list of VM SKUs approved approved for usage, which is the set of SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs. - `parPolicyEffect` - The effect type for the SovrBL - Confidential Pol Ass.
parPlatformMgAlzDefaultsEnable | No       | Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.
parLandingZoneChildrenMgAlzDefaultsEnable | No       | Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.
parLandingZoneMgConfidentialEnable | No       | Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group have been deployed. If set to false, policies will not try to be assigned to Confidential Corp & Confidential Online Management Groups
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | The region where the Log Analytics Workspace & Automation Account are deployed.
parLogAnalyticsWorkspaceResourceId | No       | Log Analytics Workspace Resource ID.
parDataCollectionRuleVMInsightsResourceId | No       | Data Collection Rule VM Insights Resource ID.
parDataCollectionRuleChangeTrackingResourceId | No       | Data Collection Rule Change Tracking Resource ID.
parDataCollectionRuleMDFCSQLResourceId | No       | Data Collection Rule MDFC SQL Resource ID.
parUserAssignedManagedIdentityResourceId | No       | User Assigned Managed Identity Resource ID.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parAutomationAccountName | No       | Automation account name.
parMsDefenderForCloudEmailSecurityContact | No       | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment. True will enforce policy Enable-DDoS-VNET at connectivity or landing zone Management Groups. False will not enforce policy Enable-DDoS-VNET.
parDdosProtectionPlanId | No       | ID of the DdosProtectionPlan which will be applied to the Virtual Networks.
parPrivateDnsResourceGroupId | No       | Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.
parPrivateDnsZonesNamesToAuditInCorp | No       | Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.
parDisableAlzDefaultPolicies | No       | Set Enforcement Mode of all default Pol Asss to Do Not Enforce.
parDisableSlzDefaultPolicies | No       | Set Enforcement Mode of all default sovereign Pol Asss to Do Not Enforce.
parVmBackupExclusionTagName | No       | Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.
parVmBackupExclusionTagValue | No       | Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.
parExcludedPolicyAssignments | No       | Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for management group names/IDs. Include a dash if needed.

### parTopLevelPolicyAssignmentSovereigntyGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object used to assign SovrBL - Global Policies to the intermediate root MG.'

- `parTopLevelSovereignGlobalPoliciesEnable` - Switch to enable/disable deployment of the SovrBL - Global Pol Ass to the intermediate root MG.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parPolicyEffect` - The effect type for the SovrBL - Global Pol Ass.



- Default value: `@{parTopLevelSovereigntyGlobalPoliciesEnable=False; parListOfAllowedLocations=System.Object[]; parPolicyEffect=Deny}`

### parPolicyAssignmentSovereigntyConfidential

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object used to assign SovrBL - Confidential Policies to the confidential landing zone management groups.'

- `parAllowedResourceTypes` - The list of Azure resource types approved for usage, which is the set of resource types that have a SKU backed by Azure Confidential Computing or resource types that do not process customer data. Leave empty to allow all relevant resource types.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parallowedVirtualMachineSKUs` - The list of VM SKUs approved approved for usage, which is the set of SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs.
- `parPolicyEffect` - The effect type for the SovrBL - Confidential Pol Ass.



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

Set Enforcement Mode of all default Pol Asss to Do Not Enforce.

- Default value: `False`

### parDisableSlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Enforcement Mode of all default sovereign Pol Asss to Do Not Enforce.

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
