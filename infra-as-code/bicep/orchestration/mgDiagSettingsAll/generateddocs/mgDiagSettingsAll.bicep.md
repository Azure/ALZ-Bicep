# ALZ Bicep orchestration - Management Group Diagnostic Settings - ALL

Orchestration module that helps enable Diagnostic Settings on the Management Group hierarchy as was defined during the deployment of the Management Group module

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy in the managementGroups module. Default: alz
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parLandingZoneMgChildren | No       | Array of strings to allow additional or different child Management Groups of the Landing Zones Management Group.
parLogAnalyticsWorkspaceResourceId | Yes      | Log Analytics Workspace Resource ID.
parLandingZoneMgAlzDefaultsEnable | No       | Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true
parLandingZoneMgConfidentialEnable | No       | Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true. Default: false
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy in the managementGroups module. Default: alz

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parLandingZoneMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of strings to allow additional or different child Management Groups of the Landing Zones Management Group.

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Log Analytics Workspace Resource ID.

### parLandingZoneMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true. Default: false

- Default value: `False`

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

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
        "parLogAnalyticsWorkspaceResourceId": {
            "value": ""
        },
        "parLandingZoneMgAlzDefaultsEnable": {
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
