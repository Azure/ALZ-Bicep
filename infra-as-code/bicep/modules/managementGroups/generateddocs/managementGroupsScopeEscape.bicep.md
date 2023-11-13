# ALZ Bicep - Management Groups Module with Scope Escape

ALZ Bicep Module to set up Management Group structure, using Scope Escaping feature of ARM to allow deployment not requiring tenant root scope access.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy. This management group will be created as part of the deployment.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parTopLevelManagementGroupDisplayName | No       | Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.
parTopLevelManagementGroupParentId | No       | Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.
parLandingZoneMgAlzDefaultsEnable | No       | Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.
parPlatformMgAlzDefaultsEnable | No       | Deploys Management, Identity and Connectivity Management Groups beneath Platform Management Group if set to true.
parLandingZoneMgConfidentialEnable | No       | Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.
parLandingZoneMgChildren | No       | Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed.
parPlatformMgChildren | No       | Dictionary Object to allow additional or different child Management Groups of Platform Management Group to be deployed.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy. This management group will be created as part of the deployment.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parTopLevelManagementGroupDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.

- Default value: `Azure Landing Zones`

### parTopLevelManagementGroupParentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.

### parLandingZoneMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `True`

### parPlatformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Management, Identity and Connectivity Management Groups beneath Platform Management Group if set to true.

- Default value: `True`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `False`

### parLandingZoneMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed.

### parPlatformMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of Platform Management Group to be deployed.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
outTopLevelManagementGroupId | string |
outPlatformManagementGroupId | string |
outPlatformChildrenManagementGroupIds | array |
outLandingZonesManagementGroupId | string |
outLandingZoneChildrenManagementGroupIds | array |
outSandboxManagementGroupId | string |
outDecommissionedManagementGroupId | string |
outTopLevelManagementGroupName | string |
outPlatformManagementGroupName | string |
outPlatformChildrenManagementGroupNames | array |
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
        "template": "infra-as-code/bicep/modules/managementGroups/managementGroupsScopeEscape.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
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
        "parPlatformMgAlzDefaultsEnable": {
            "value": true
        },
        "parLandingZoneMgConfidentialEnable": {
            "value": false
        },
        "parLandingZoneMgChildren": {
            "value": {}
        },
        "parPlatformMgChildren": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
