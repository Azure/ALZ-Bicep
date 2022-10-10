# Module: Enable Diagnostic Settings on a Management Group

This module enables the supported Diagnostic Settings categories on a Management Group to an existing Azure Log Analytics Workspace.
> Consider using the `mgDiagSettingsAll` orchestration module instead to simplify configuring the Diagnostic Settings for all your Management Group hierarchy in a single module. [infra-as-code/bicep/orchestration/mgDiagSettingsAll](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/mgDiagSettingsAll)

## Parameters

The module requires the following input parameters.

| Parameter                             | Type   | Description                                                                                                                                                                          | Requirements                      | Example                                                                                 |
| ------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------- | --------------------------------------------------------------------------------------- |
| parLogAnalyticsWorkspaceResourceId | string   | Resource ID of the Log Analytics Workspace                                                             | Mandatory input | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics`                                                                                 |
 | parTargetManagementGroupId | string          | Target management group for the subscription.                               | Mandatory input, management group must exist | `alz-platform-connectivity`                                                                                                                                                                    |
 | parTelemetryOptOut         | bool            | Set Parameter to true to Opt-out of deployment telemetry                    | none                                         | `false`                                                                                                                                                                                        |

## Outputs

*The module will not generate any outputs.*

## Deployment

The inputs for this module are defined in `parameters/mgDiagSettings.parameters.all.json`. The Diagnostic Settings resource will be named toLa but can be changed in the module if desired.

> For the  examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI

```bash
# For Azure global regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/mgDiagSettings/mgDiagSettings.bicep \
  --parameters @infra-as-code/bicep/modules/mgDiagSettings/parameters/mgDiagSettings.parameters.all.json \
  --location eastus \
  --management-group-id alz
```

OR

```bash
# For Azure China regions
az deployment mg create \
  --template-file infra-as-code/bicep/modules/mgDiagSettings/mgDiagSettings.bicep \
  --parameters @infra-as-code/bicep/modules/mgDiagSettings/parameters/mgDiagSettings.parameters.all.json \
  --location chinaeast2 \
  --management-group-id alz
```

### PowerShell

```powershell
# For Azure global regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/mgDiagSettings/mgDiagSettings.bicep `
  -TemplateParameterFile @infra-as-code/bicep/modules/mgDiagSettings/parameters/mgDiagSettings.parameters.all.json `
  -Location eastus `
  -ManagementGroupId alz
```

OR

```powershell
# For Azure China regions
New-AzManagementGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/mgDiagSettings/mgDiagSettings.bicep `
  -TemplateParameterFile @infra-as-code/bicep/modules/mgDiagSettings/parameters/mgDiagSettings.parameters.all.json `
  -Location chinaeast2 `
  -ManagementGroupId alz
```

## Validation

To validate if Diagnostic Settings was correctly enabled for any specific management group, a REST API GET call can be used. Documentation and easy way to try this can be found in this link [(Management Group Diagnostic Settings - Get)](https://learn.microsoft.com/rest/api/monitor/management-group-diagnostic-settings/get?tabs=HTTP&tryIt=true&source=docs#code-try-0). There is currently not a direct way to validate this in the Azure Portal, Azure CLI or PowerShell.

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
