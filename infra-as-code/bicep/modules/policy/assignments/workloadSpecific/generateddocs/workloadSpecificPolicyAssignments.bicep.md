# ALZ Bicep - Workload Specific Policy Assignments and Exemptions

Assigns Workload Specific Policy Assignments and Exemptions to the Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTopLevelManagementGroupPrefix | No       | Prefix for management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for management group names/IDs.
parTopLevelPolicyAssignmentSovereigntyGlobal | No       | Assign Sovereignty Baseline - Global Policies to root management group.
parPolicyAssignmentSovereigntyConfidential | No       | Assign Sovereignty Baseline - Confidential Policies to confidential landing zone groups.
parLandingZoneMgConfidentialEnable | No       | Assign policies to Confidential Corp and Online groups under Landing Zones.
parDisableSlzDefaultPolicies | No       | Set the enforcement mode to DoNotEnforce for all SLZ policies.
parDisableWorkloadSpecificPolicies | No       | Set the enforcement mode to DoNotEnforce for all workload specific policies.
parExcludedPolicyAssignments | No       | Names of policy assignments to exclude.
parTelemetryOptOut | No       | Opt out of deployment telemetry.
parManagementGroupIdOverrides | Yes      | Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for management group hierarchy.

- Default value: `alz`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for management group names/IDs.

### parTopLevelPolicyAssignmentSovereigntyGlobal

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assign Sovereignty Baseline - Global Policies to root management group.

- Default value: `@{parTopLevelSovereigntyGlobalPoliciesEnable=False; parListOfAllowedLocations=System.Object[]; parPolicyEffect=Deny}`

### parPolicyAssignmentSovereigntyConfidential

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assign Sovereignty Baseline - Confidential Policies to confidential landing zone groups.

- Default value: `@{parAllowedResourceTypes=System.Object[]; parListOfAllowedLocations=System.Object[]; parAllowedVirtualMachineSKUs=System.Object[]; parPolicyEffect=Deny}`

### parLandingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Assign policies to Confidential Corp and Online groups under Landing Zones.

- Default value: `False`

### parDisableSlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the enforcement mode to DoNotEnforce for all SLZ policies.

- Default value: `True`

### parDisableWorkloadSpecificPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the enforcement mode to DoNotEnforce for all workload specific policies.

- Default value: `True`

### parExcludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Names of policy assignments to exclude.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Opt out of deployment telemetry.

- Default value: `False`

### parManagementGroupIdOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/policy/assignments/workloadSpecific/workloadSpecificPolicyAssignments.json"
    },
    "parameters": {
        "parTopLevelManagementGroupPrefix": {
            "value": "alz"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
        },
        "parTopLevelPolicyAssignmentSovereigntyGlobal": {
            "value": {
                "parTopLevelSovereigntyGlobalPoliciesEnable": false,
                "parListOfAllowedLocations": [],
                "parPolicyEffect": "Deny"
            }
        },
        "parPolicyAssignmentSovereigntyConfidential": {
            "value": {
                "parAllowedResourceTypes": [],
                "parListOfAllowedLocations": [],
                "parAllowedVirtualMachineSKUs": [],
                "parPolicyEffect": "Deny"
            }
        },
        "parLandingZoneMgConfidentialEnable": {
            "value": false
        },
        "parDisableSlzDefaultPolicies": {
            "value": true
        },
        "parDisableWorkloadSpecificPolicies": {
            "value": true
        },
        "parExcludedPolicyAssignments": {
            "value": []
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parManagementGroupIdOverrides": {
            "value": null
        }
    }
}
```
