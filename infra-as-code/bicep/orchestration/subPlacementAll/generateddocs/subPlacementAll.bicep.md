# ALZ Bicep orchestration - Subscription Placement - ALL

Orchestration module that helps to define where all Subscriptions should be placed in the ALZ Management Group Hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parIntRootMgSubs | No       | An array of Subscription IDs to place in the Intermediate Root Management Group. Default: Empty Array
parPlatformMgSubs | No       | An array of Subscription IDs to place in the Platform Management Group. Default: Empty Array
parPlatformManagementMgSubs | No       | An array of Subscription IDs to place in the (Platform) Management Management Group. Default: Empty Array
parPlatformConnectivityMgSubs | No       | An array of Subscription IDs to place in the (Platform) Connectivity Management Group. Default: Empty Array
parPlatformMgChildrenSubs | No       | Dictionary Object to allow additional or different child Management Groups of the Platform Management Group describing the Subscription IDs which each of them contain. Default: Empty Object
parPlatformIdentityMgSubs | No       | An array of Subscription IDs to place in the (Platform) Identity Management Group. Default: Empty Array
parLandingZonesMgSubs | No       | An array of Subscription IDs to place in the Landing Zones Management Group. Default: Empty Array
parLandingZonesCorpMgSubs | No       | An array of Subscription IDs to place in the Corp (Landing Zones) Management Group. Default: Empty Array
parLandingZonesOnlineMgSubs | No       | An array of Subscription IDs to place in the Online (Landing Zones) Management Group. Default: Empty Array
parLandingZonesConfidentialCorpMgSubs | No       | An array of Subscription IDs to place in the Confidential Corp (Landing Zones) Management Group. Default: Empty Array
parLandingZonesConfidentialOnlineMgSubs | No       | An array of Subscription IDs to place in the Confidential Online (Landing Zones) Management Group. Default: Empty Array
parLandingZoneMgChildrenSubs | No       | Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group describing the Subscription IDs which each of them contain. Default: Empty Object
parDecommissionedMgSubs | No       | An array of Subscription IDs to place in the Decommissioned Management Group. Default: Empty Array
parSandboxMgSubs | No       | An array of Subscription IDs to place in the Sandbox Management Group. Default: Empty Array
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parIntRootMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Intermediate Root Management Group. Default: Empty Array

### parPlatformMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Platform Management Group. Default: Empty Array

### parPlatformManagementMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Management Management Group. Default: Empty Array

### parPlatformConnectivityMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Connectivity Management Group. Default: Empty Array

### parPlatformMgChildrenSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of the Platform Management Group describing the Subscription IDs which each of them contain. Default: Empty Object

### parPlatformIdentityMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Identity Management Group. Default: Empty Array

### parLandingZonesMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Landing Zones Management Group. Default: Empty Array

### parLandingZonesCorpMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Corp (Landing Zones) Management Group. Default: Empty Array

### parLandingZonesOnlineMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Online (Landing Zones) Management Group. Default: Empty Array

### parLandingZonesConfidentialCorpMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Confidential Corp (Landing Zones) Management Group. Default: Empty Array

### parLandingZonesConfidentialOnlineMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Confidential Online (Landing Zones) Management Group. Default: Empty Array

### parLandingZoneMgChildrenSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group describing the Subscription IDs which each of them contain. Default: Empty Object

### parDecommissionedMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Decommissioned Management Group. Default: Empty Array

### parSandboxMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Sandbox Management Group. Default: Empty Array

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
        "template": "infra-as-code/bicep/orchestration/subPlacementAll/subPlacementAll.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
        },
        "parIntRootMgSubs": {
            "value": []
        },
        "parPlatformMgSubs": {
            "value": []
        },
        "parPlatformManagementMgSubs": {
            "value": []
        },
        "parPlatformConnectivityMgSubs": {
            "value": []
        },
        "parPlatformMgChildrenSubs": {
            "value": {}
        },
        "parPlatformIdentityMgSubs": {
            "value": []
        },
        "parLandingZonesMgSubs": {
            "value": []
        },
        "parLandingZonesCorpMgSubs": {
            "value": []
        },
        "parLandingZonesOnlineMgSubs": {
            "value": []
        },
        "parLandingZonesConfidentialCorpMgSubs": {
            "value": []
        },
        "parLandingZonesConfidentialOnlineMgSubs": {
            "value": []
        },
        "parLandingZoneMgChildrenSubs": {
            "value": {}
        },
        "parDecommissionedMgSubs": {
            "value": []
        },
        "parSandboxMgSubs": {
            "value": []
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
