# ALZ Bicep - Logging Module

ALZ Bicep Module used to set up Logging

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceName | No       | Log Analytics Workspace name.
parLogAnalyticsWorkspaceLocation | No       | Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parLogAnalyticsWorkspaceSkuName | No       | Log Analytics Workspace sku name.
parLogAnalyticsWorkspaceCapacityReservationLevel | No       | Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parLogAnalyticsWorkspaceLock | No       | Resource Lock Configuration for Log Analytics Workspace.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceSolutions | No       | Solutions that will be added to the Log Analytics Workspace.
parLogAnalyticsWorkspaceSolutionsLock | No       | Resource Lock Configuration for Log Analytics Workspace Solutions.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceLinkAutomationAccount | No       | Log Analytics Workspace should be linked with the automation account.
parAutomationAccountName | No       | Automation account name.
parAutomationAccountLocation | No       | Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parAutomationAccountUseManagedIdentity | No       | Automation Account - use managed identity.
parAutomationAccountPublicNetworkAccess | No       | Automation Account - Public network access.
parAutomationAccountLock | No       | Resource Lock Configuration for Automation Account.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parAutomationAccountTags | No       | Tags you would like to be applied to Automation Account.
parLogAnalyticsWorkspaceTags | No       | Tags you would like to be applied to Log Analytics Workspace.
parUseSentinelClassicPricingTiers | No       | Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.
parLogAnalyticsLinkedServiceAutomationAccountName | No       | Log Analytics LinkedService name for Automation Account.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

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

### parLogAnalyticsWorkspaceCapacityReservationLevel

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.

- Default value: `100`

- Allowed values: `100`, `200`, `300`, `400`, `500`, `1000`, `2000`, `5000`

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace.

- Default value: `365`

### parLogAnalyticsWorkspaceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Log Analytics Workspace.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parLogAnalyticsWorkspaceSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Solutions that will be added to the Log Analytics Workspace.

- Default value: `AgentHealthAssessment AntiMalware ChangeTracking Security SecurityInsights SQLAdvancedThreatProtection SQLVulnerabilityAssessment SQLAssessment Updates VMInsights`

- Allowed values: `AgentHealthAssessment`, `AntiMalware`, `ChangeTracking`, `Security`, `SecurityInsights`, `ServiceMap`, `SQLAdvancedThreatProtection`, `SQLVulnerabilityAssessment`, `SQLAssessment`, `Updates`, `VMInsights`

### parLogAnalyticsWorkspaceSolutionsLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Log Analytics Workspace Solutions.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parLogAnalyticsWorkspaceLinkAutomationAccount

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace should be linked with the automation account.

- Default value: `True`

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

### parAutomationAccountPublicNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation Account - Public network access.

- Default value: `True`

### parAutomationAccountLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Automation Account.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

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

### parUseSentinelClassicPricingTiers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.

- Default value: `False`

### parLogAnalyticsLinkedServiceAutomationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics LinkedService name for Automation Account.

- Default value: `Automation`

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
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parLogAnalyticsWorkspaceName": {
            "value": "alz-log-analytics"
        },
        "parLogAnalyticsWorkspaceLocation": {
            "value": "[resourceGroup().location]"
        },
        "parLogAnalyticsWorkspaceSkuName": {
            "value": "PerGB2018"
        },
        "parLogAnalyticsWorkspaceCapacityReservationLevel": {
            "value": 100
        },
        "parLogAnalyticsWorkspaceLogRetentionInDays": {
            "value": 365
        },
        "parLogAnalyticsWorkspaceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
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
        "parLogAnalyticsWorkspaceSolutionsLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parLogAnalyticsWorkspaceLinkAutomationAccount": {
            "value": true
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
        "parAutomationAccountPublicNetworkAccess": {
            "value": true
        },
        "parAutomationAccountLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
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
        "parUseSentinelClassicPricingTiers": {
            "value": false
        },
        "parLogAnalyticsLinkedServiceAutomationAccountName": {
            "value": "Automation"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
