# ALZ Bicep orchestration - Management Group Diagnostic Settings - ALL

Orchestration module that helps enable Diagnostic Settings on the Management Group hierarchy as was defined during the deployment of the Management Group module

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parLandingZoneMgChildren | No       | Array of strings to allow additional or different child Management Groups of the Landing Zones Management Group.
parPlatformMgChildren | No       | Array of strings to allow additional or different child Management Groups of the Platform Management Group.
parLogAnalyticsWorkspaceResourceId | Yes      | Log Analytics Workspace Resource ID.
parDiagnosticSettingsName | No       | Diagnostic Settings Name.
parLandingZoneMgAlzDefaultsEnable | No       | Deploys Diagnostic Settings on Corp & Online Management Groups beneath Landing Zones Management Group if set to true.
parPlatformMgAlzDefaultsEnable | No       | Deploys Diagnostic Settings on Management, Connectivity and Identity Management Groups beneath Platform Management Group if set to true.
parLandingZoneMgConfidentialEnable | No       | Deploys Diagnostic Settings on Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parLandingZoneMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of strings to allow additional or different child Management Groups of the Landing Zones Management Group.

### parPlatformMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of strings to allow additional or different child Management Groups of the Platform Management Group.

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Log Analytics Workspace Resource ID.

### parDiagnosticSettingsName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Diagnostic Settings Name.

- Default value: `toLa`

### parLandingZoneMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Diagnostic Settings on Corp & Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `True`

### parPlatformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Diagnostic Settings on Management, Connectivity and Identity Management Groups beneath Platform Management Group if set to true.

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Diagnostic Settings on Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `False`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/orchestration/mgDiagSettingsAll/mgDiagSettingsAll.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
        },
        "parLandingZoneMgChildren": {
            "value": []
        },
        "parPlatformMgChildren": {
            "value": []
        },
        "parLogAnalyticsWorkspaceResourceId": {
            "value": ""
        },
        "parDiagnosticSettingsName": {
            "value": "toLa"
        },
        "parLandingZoneMgAlzDefaultsEnable": {
            "value": true
        },
        "parPlatformMgAlzDefaultsEnable": {
            "value": true
        },
        "parLandingZoneMgConfidentialEnable": {
            "value": false
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
