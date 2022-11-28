# ALZ Bicep - ALZ Default Policy Assignments

This policy assignment will assign the ALZ Default Policy to management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy. DEFAULT VALUE = alz
parLogAnalyticsWorkSpaceAndAutomationAccountLocation | No       | The region where the Log Analytics Workspace & Automation Account are deployed. DEFAULT VALUE = eastus
parLogAnalyticsWorkspaceResourceId | No       | Log Analytics Workspace Resource ID. - DEFAULT VALUE: Empty String 
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365
parAutomationAccountName | No       | Automation account name. - DEFAULT VALUE: alz-automation-account
parMsDefenderForCloudEmailSecurityContact | No       | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.
parDdosProtectionPlanId | No       | ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues. Default: Empty String
parPrivateDnsResourceGroupId | No       | Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group. Default: Empty String
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy. DEFAULT VALUE = alz

- Default value: `alz`

### parLogAnalyticsWorkSpaceAndAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region where the Log Analytics Workspace & Automation Account are deployed. DEFAULT VALUE = eastus

- Default value: `eastus`

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Resource ID. - DEFAULT VALUE: Empty String 

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365

- Default value: `365`

### parAutomationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation account name. - DEFAULT VALUE: alz-automation-account

- Default value: `alz-automation-account`

### parMsDefenderForCloudEmailSecurityContact

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.

- Default value: `security_contact@replace_me.com`

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues. Default: Empty String

### parPrivateDnsResourceGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group. Default: Empty String

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
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
