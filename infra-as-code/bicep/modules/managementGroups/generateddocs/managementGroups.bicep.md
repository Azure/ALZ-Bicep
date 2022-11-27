# ALZ Bicep - Management Groups Module

ALZ Bicep Module to set up Management Group structure

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy. This management group will be created as part of the deployment. Default: alz
parTopLevelManagementGroupDisplayName | No       | Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter. Default: Azure Landing Zones
parTopLevelManagementGroupParentId | No       | Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group. Default: Empty String
parLandingZoneMgAlzDefaultsEnable | No       | Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true
parLandingZoneMgConfidentialEnable | No       | Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true. Default: false
parLandingZoneMgChildren | No       | Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed. Default: Empty Object
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy. This management group will be created as part of the deployment. Default: alz

- Default value: `alz`

### parTopLevelManagementGroupDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter. Default: Azure Landing Zones

- Default value: `Azure Landing Zones`

### parTopLevelManagementGroupParentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group. Default: Empty String

### parLandingZoneMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true. Default: false

- Default value: `False`

### parLandingZoneMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed. Default: Empty Object

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outTopLevelManagementGroupId | string |
outPlatformManagementGroupId | string |
outPlatformManagementManagementGroupId | string |
outPlatformConnectivityManagementGroupId | string |
outPlatformIdentityManagementGroupId | string |
outLandingZonesManagementGroupId | string |
outLandingZoneChildrenManagementGroupIds | array |
outSandboxManagementGroupId | string |
outDecommissionedManagementGroupId | string |
outTopLevelManagementGroupName | string |
outPlatformManagementGroupName | string |
outPlatformManagementManagementGroupName | string |
outPlatformConnectivityManagementGroupName | string |
outPlatformIdentityManagementGroupName | string |
outLandingZonesManagementGroupName | string |
outLandingZoneChildrenManagementGroupNames | array |
outSandboxManagementGroupName | string |
outDecommissionedManagementGroupName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/managementGroups/managementGroups.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupDisplayName": {
            "value": "Azure Landing Zones"
        },
        "parTopLevelManagementGroupParentId": {
            "value": ""
        },
        "parLandingZoneMgAlzDefaultsEnable": {
            "value": true
        },
        "parLandingZoneMgConfidentialEnable": {
            "value": false
        },
        "parLandingZoneMgChildren": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
