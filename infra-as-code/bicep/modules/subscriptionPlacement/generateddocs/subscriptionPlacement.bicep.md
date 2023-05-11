# ALZ Bicep - Subscription Placement module

Module used to place subscriptions in management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parSubscriptionIds | No       | Array of Subscription Ids that should be moved to the new management group.
parTargetManagementGroupId | Yes      | Target management group for the subscription. This management group must exist.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### parSubscriptionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Subscription Ids that should be moved to the new management group.

### parTargetManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Target management group for the subscription. This management group must exist.

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
        "template": "infra-as-code/bicep/modules/subscriptionPlacement/subscriptionPlacement.json"
    },
    "parameters": {
        "parSubscriptionIds": {
            "value": []
        },
        "parTargetManagementGroupId": {
            "value": ""
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
