# ALZ Bicep - Management Group Diagnostic Settings

Module used to set up Diagnostic Settings for Management Groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLogAnalyticsWorkspaceResourceId | Yes      | Log Analytics Workspace Resource ID.
parDiagnosticSettingsName | No       | Diagnostic Settings Name.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### parLogAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Log Analytics Workspace Resource ID.

### parDiagnosticSettingsName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Diagnostic Settings Name.

- Default value: `toLa`

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
        "template": "infra-as-code/bicep/modules/mgDiagSettings/mgDiagSettings.json"
    },
    "parameters": {
        "parLogAnalyticsWorkspaceResourceId": {
            "value": ""
        },
        "parDiagnosticSettingsName": {
            "value": "toLa"
        },
        "parTelemetryOptOut": {
            "value": false
        }
    }
}
```
