# ALZ Bicep - Logging Module

ALZ Bicep Module used to set up Logging

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLogAnalyticsWorkspaceName | No       | Log Analytics Workspace name.
parLogAnalyticsWorkspaceLocation | No       | Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parLogAnalyticsWorkspaceSkuName | No       | Log Analytics Workspace sku name.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parLogAnalyticsWorkspaceSolutions | No       | Solutions that will be added to the Log Analytics Workspace.
parAutomationAccountName | No       | Automation account name.
parAutomationAccountLocation | No       | Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parAutomationAccountUseManagedIdentity | No       | Automation Account - use managed identity.
parTags        | No       | Tags you would like to be applied to all resources in this module.
parAutomationAccountTags | No       | Tags you would like to be applied to Automation Account.
parLogAnalyticsWorkspaceTags | No       | Tags you would like to be applied to Log Analytics Workspace.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLogAnalyticsWorkspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace name.

- Default value: `alz-log-analytics`

### parLogAnalyticsWorkspaceLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.

- Default value: `[resourceGroup().location]`

### parLogAnalyticsWorkspaceSkuName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace sku name.

- Default value: `PerGB2018`

- Allowed values: `CapacityReservation`, `Free`, `LACluster`, `PerGB2018`, `PerNode`, `Premium`, `Standalone`, `Standard`

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace.

- Default value: `365`

### parLogAnalyticsWorkspaceSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Solutions that will be added to the Log Analytics Workspace.

- Default value: `AgentHealthAssessment AntiMalware ChangeTracking Security SecurityInsights SQLAdvancedThreatProtection SQLVulnerabilityAssessment SQLAssessment Updates VMInsights`

- Allowed values: `AgentHealthAssessment`, `AntiMalware`, `ChangeTracking`, `Security`, `SecurityInsights`, `ServiceMap`, `SQLAdvancedThreatProtection`, `SQLVulnerabilityAssessment`, `SQLAssessment`, `Updates`, `VMInsights`

### parAutomationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation account name.

- Default value: `alz-automation-account`

### parAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.

- Default value: `[resourceGroup().location]`

### parAutomationAccountUseManagedIdentity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation Account - use managed identity.

- Default value: `True`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parAutomationAccountTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to Automation Account.

- Default value: `[parameters('parTags')]`

### parLogAnalyticsWorkspaceTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to Log Analytics Workspace.

- Default value: `[parameters('parTags')]`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outLogAnalyticsWorkspaceName | string |
outLogAnalyticsWorkspaceId | string |
outLogAnalyticsCustomerId | string |
outLogAnalyticsSolutions | array |
outAutomationAccountName | string |
outAutomationAccountId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/logging/logging.json"
    },
    "parameters": {
        "parLogAnalyticsWorkspaceName": {
            "value": "alz-log-analytics"
        },
        "parLogAnalyticsWorkspaceLocation": {
            "value": "[resourceGroup().location]"
        },
        "parLogAnalyticsWorkspaceSkuName": {
            "value": "PerGB2018"
        },
        "parLogAnalyticsWorkspaceLogRetentionInDays": {
            "value": 365
        },
        "parLogAnalyticsWorkspaceSolutions": {
            "value": [
                "AgentHealthAssessment",
                "AntiMalware",
                "ChangeTracking",
                "Security",
                "SecurityInsights",
                "SQLAdvancedThreatProtection",
                "SQLVulnerabilityAssessment",
                "SQLAssessment",
                "Updates",
                "VMInsights"
            ]
        },
        "parAutomationAccountName": {
            "value": "alz-automation-account"
        },
        "parAutomationAccountLocation": {
            "value": "[resourceGroup().location]"
        },
        "parAutomationAccountUseManagedIdentity": {
            "value": true
        },
        "parTags": {
            "value": {}
        },
        "parAutomationAccountTags": {
            "value": "[parameters('parTags')]"
        },
        "parLogAnalyticsWorkspaceTags": {
            "value": "[parameters('parTags')]"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
