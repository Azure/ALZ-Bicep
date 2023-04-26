# ALZ Bicep - ALZ Default Policy Assignments

This module will assign the ALZ Default Policy Assignments to the ALZ Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | The region where the Log Analytics Workspace & Automation Account are deployed.
parLogAnalyticsWorkspaceResourceId | No       | Log Analytics Workspace Resource ID.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parAutomationAccountName | No       | Automation account name.
parMsDefenderForCloudEmailSecurityContact | No       | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.
parDdosProtectionPlanId | No       | ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.
parPrivateDnsResourceGroupId | No       | Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.
parPrivateDnsZonesNamesToAuditInCorp | No       | Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.
parDisableAlzDefaultPolicies | No       | Set Enforcement Mode of all default Policies assignments to Do Not Enforce.
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

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parLogAnalyticsWorkSpaceAndAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region where the Log Analytics Workspace & Automation Account are deployed.

- Default value: `eastus`

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Resource ID.

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace.

- Default value: `365`

### parAutomationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation account name.

- Default value: `alz-automation-account`

### parMsDefenderForCloudEmailSecurityContact

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.

- Default value: `security_contact@replace_me.com`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.

### parPrivateDnsResourceGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.

### parPrivateDnsZonesNamesToAuditInCorp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.

### parDisableAlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Enforcement Mode of all default Policies assignments to Do Not Enforce.

- Default value: `False`

### parVmBackupExclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.

### parVmBackupExclusionTagValue

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.

### parExcludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

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
        "parLogAnalyticsWorkSpaceAndAutomationAccountLocation": {
            "value": "eastus"
        },
        "parLogAnalyticsWorkspaceResourceId": {
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
