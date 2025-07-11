# ALZ Bicep - Logging Module

ALZ Bicep Module used to set up Logging

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceName | No       | Log Analytics Workspace name.
parLogAnalyticsWorkspaceLocation | No       | Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parDataCollectionRuleVMInsightsExperience | No       | VM Insights Experience - For details see: https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable.
parDataCollectionRuleVMInsightsName | No       | VM Insights Data Collection Rule name for AMA integration.
parDataCollectionRuleVMInsightsLock | No       | Resource Lock Configuration for VM Insights Data Collection Rule.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parDataCollectionRuleChangeTrackingName | No       | Change Tracking Data Collection Rule name for AMA integration.
parDataCollectionRuleChangeTrackingLock | No       | Resource Lock Configuration for Change Tracking Data Collection Rule.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parDataCollectionRuleMDFCSQLName | No       | MDFC for SQL Data Collection Rule name for AMA integration.
parDataCollectionRuleMDFCSQLLock | No       | Resource Lock Configuration for MDFC Defender for SQL Data Collection Rule.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceSkuName | No       | Log Analytics Workspace sku name.
parLogAnalyticsWorkspaceCapacityReservationLevel | No       | Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parLogAnalyticsWorkspaceLock | No       | Resource Lock Configuration for Log Analytics Workspace.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parLogAnalyticsWorkspaceSolutions | No       | Solutions that will be added to the Log Analytics Workspace.
parSecurityInsightsOnboardingLock | No       | Resource Lock Configuration for Security Insights solution.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parChangeTrackingSolutionLock | No       | Resource Lock Configuration for Change Tracking solution. - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parUserAssignedManagedIdentityName | No       | Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.
parUserAssignedManagedIdentityLocation | No       | User Assigned Managed Identity location.
parAutomationAccountEnabled | No       | Switch to enable/disable Automation Account deployment.
parLogAnalyticsWorkspaceLinkAutomationAccount | No       | Log Analytics Workspace should be linked with the automation account.
parAutomationAccountName | No       | Automation account name.
parAutomationAccountLocation | No       | Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.
parAutomationAccountUseManagedIdentity | No       | Automation Account - use managed identity.
parAutomationAccountPublicNetworkAccess | No       | Automation Account - Public network access.
parAutomationAccountLock | No       | Resource Lock Configuration for Automation Account.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parAutomationAccountTags | No       | Tags you would like to be applied to Automation Account.
parLogAnalyticsWorkspaceTags | No       | Tags you would like to be applied to Log Analytics Workspace.
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

### parDataCollectionRuleVMInsightsExperience

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

VM Insights Experience - For details see: https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable.

- Default value: `PerfAndMap`

- Allowed values: `PerfAndMap`, `PerfOnly`

### parDataCollectionRuleVMInsightsName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

VM Insights Data Collection Rule name for AMA integration.

- Default value: `alz-ama-vmi-dcr`

### parDataCollectionRuleVMInsightsLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for VM Insights Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parDataCollectionRuleChangeTrackingName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Change Tracking Data Collection Rule name for AMA integration.

- Default value: `alz-ama-ct-dcr`

### parDataCollectionRuleChangeTrackingLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Change Tracking Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parDataCollectionRuleMDFCSQLName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

MDFC for SQL Data Collection Rule name for AMA integration.

- Default value: `alz-ama-mdfcsql-dcr`

### parDataCollectionRuleMDFCSQLLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for MDFC Defender for SQL Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

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

- Default value: `SecurityInsights ChangeTracking`

- Allowed values: `SecurityInsights`, `ChangeTracking`

### parSecurityInsightsOnboardingLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Security Insights solution.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parChangeTrackingSolutionLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Change Tracking solution.
- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Logging Module.}`

### parUserAssignedManagedIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.

- Default value: `alz-logging-mi`

### parUserAssignedManagedIdentityLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

User Assigned Managed Identity location.

- Default value: `[resourceGroup().location]`

### parAutomationAccountEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Automation Account deployment.

- Default value: `False`

### parLogAnalyticsWorkspaceLinkAutomationAccount

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace should be linked with the automation account.

- Default value: `False`

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
outUserAssignedManagedIdentityId | string |
outUserAssignedManagedIdentityPrincipalId | string |
outDataCollectionRuleVMInsightsName | string |
outDataCollectionRuleVMInsightsId | string |
outDataCollectionRuleChangeTrackingName | string |
outDataCollectionRuleChangeTrackingId | string |
outDataCollectionRuleMDFCSQLName | string |
outDataCollectionRuleMDFCSQLId | string |
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
        "parDataCollectionRuleVMInsightsExperience": {
            "value": "PerfAndMap"
        },
        "parDataCollectionRuleVMInsightsName": {
            "value": "alz-ama-vmi-dcr"
        },
        "parDataCollectionRuleVMInsightsLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parDataCollectionRuleChangeTrackingName": {
            "value": "alz-ama-ct-dcr"
        },
        "parDataCollectionRuleChangeTrackingLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parDataCollectionRuleMDFCSQLName": {
            "value": "alz-ama-mdfcsql-dcr"
        },
        "parDataCollectionRuleMDFCSQLLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
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
                "SecurityInsights",
                "ChangeTracking"
            ]
        },
        "parSecurityInsightsOnboardingLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parChangeTrackingSolutionLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Logging Module."
            }
        },
        "parUserAssignedManagedIdentityName": {
            "value": "alz-logging-mi"
        },
        "parUserAssignedManagedIdentityLocation": {
            "value": "[resourceGroup().location]"
        },
        "parAutomationAccountEnabled": {
            "value": false
        },
        "parLogAnalyticsWorkspaceLinkAutomationAccount": {
            "value": false
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
        "parLogAnalyticsLinkedServiceAutomationAccountName": {
            "value": "Automation"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
