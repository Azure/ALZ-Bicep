# subPlacementAll

[Azure Landing Zones - Bicep Modules](..)

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.  This management group will be created as part of the deployment.
parIntRootMgSubs | No       | An array of Subscription IDs to place in the Intermediate Root Management Group.
parPlatformMgSubs | No       | An array of Subscription IDs to place in the Platform Management Group.
parPlatformManagementMgSubs | No       | An array of Subscription IDs to place in the (Platform) Management Management Group.
parPlatformConnectivityMgSubs | No       | An array of Subscription IDs to place in the (Platform) Connectivity Management Group.
parPlatformIdentityMgSubs | No       | An array of Subscription IDs to place in the (Platform) Identity Management Group.
parLandingZonesMgSubs | No       | An array of Subscription IDs to place in the Landing Zones Management Group.
parLandingZonesCorpMgSubs | No       | An array of Subscription IDs to place in the Corp (Landing Zones) Management Group.
parLandingZonesOnlineMgSubs | No       | An array of Subscription IDs to place in the Online (Landing Zones) Management Group.
parLandingZonesConfidentialCorpMgSubs | No       | An array of Subscription IDs to place in the Confidential Corp (Landing Zones) Management Group.
parLandingZonesConfidentialOnlineMgSubs | No       | An array of Subscription IDs to place in the Confidential Online (Landing Zones) Management Group.
parLandingZoneMgChildrenSubs | No       | Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group describing the Subscription IDs which each of them contain.
parDecommissionedMgSubs | No       | An array of Subscription IDs to place in the Decommissioned Management Group.
parSandboxMgSubs | No       | An array of Subscription IDs to place in the Sandbox Management Group.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy.  This management group will be created as part of the deployment.

- Default value: `alz`

### parIntRootMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Intermediate Root Management Group.

### parPlatformMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Platform Management Group.

### parPlatformManagementMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Management Management Group.

### parPlatformConnectivityMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Connectivity Management Group.

### parPlatformIdentityMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the (Platform) Identity Management Group.

### parLandingZonesMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Landing Zones Management Group.

### parLandingZonesCorpMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Corp (Landing Zones) Management Group.

### parLandingZonesOnlineMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Online (Landing Zones) Management Group.

### parLandingZonesConfidentialCorpMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Confidential Corp (Landing Zones) Management Group.

### parLandingZonesConfidentialOnlineMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Confidential Online (Landing Zones) Management Group.

### parLandingZoneMgChildrenSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group describing the Subscription IDs which each of them contain.

### parDecommissionedMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Decommissioned Management Group.

### parSandboxMgSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Subscription IDs to place in the Sandbox Management Group.

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
        "template": "infra-as-code/bicep/orchestration/subPlacementAll/subPlacementAll.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
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
