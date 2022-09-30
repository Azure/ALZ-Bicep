# Module: Enable Diagnostic Settings on Management Groups

This module enables the supported Diagnostic Settings categories on a Management Group to an existing Azure Log Analytics Workspace.

## Parameters

The module requires the following input parameters.

| Parameter                             | Type   | Description                                                                                                                                                                          | Requirements                      | Example                                                                                 |
| ------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------- | --------------------------------------------------------------------------------------- |
| parLogAnalyticsWorkspaceResourceId | string   | Resource ID of the Log Analytics Workspace                                                             | Mandatory input | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics`                                                                                 |

## Outputs

*The module will not generate any outputs.*

## Deployment

This module requires being called with the  scope: managementGroup(mgId) function. This is done from within the orchestration module mgDiagSettingsAll.bicep module for all the management groups previously created and based on the input parameters for that parent module.
The Diagnostic Settings resource will be named toLa but can be changed in the module if desired.

## Validation

To validate if Diagnostic Settings was correctly enabled for any specific management group, a REST API GET call can be used. Documentation and easy way to try this can be found in this link [(Management Group Diagnostic Settings - Get)](https://learn.microsoft.com/rest/api/monitor/management-group-diagnostic-settings/get?tabs=HTTP&tryIt=true&source=docs#code-try-0).

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
