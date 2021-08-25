# Module:  Log Analytics Workspace & Solutions

Deploys an Azure Log Analytics Workspace & Solutions to a Resource Group.

The module will deploy the following solutions by default.  Solutions can be customized as required:

  * AgentHealthAssessment
  * AntiMalware
  * AzureActivity
  * ChangeTracking
  * Security
  * SecurityInsights
  * ServiceMap
  * SQLAssessment
  * Updates
  * VMInsights

## Parameters

The module requires the following required input parameters.

 Paramenter | Type | Description | Requirement | Example
----------- | ---- | ----------- | ----------- | -------
parName | string | Log Analytics Workspace name | Mandatory input | `alz-la`
parLogRetentionInDays | int | Number of days of log retention for Log Analytics Workspace.  1 year (365 days) of log retention by default. | 30-730 | `365`
parLogAnalyticsSolutions | Array of string | Solutions that will be added to the Log Analytics Workspace | 1 or more of `AgentHealthAssessment`, `AntiMalware`, `AzureActivity`, `ChangeTracking`, `Security`, `SecurityInsights`, `ServiceMap`, `SQLAssessment`, `Updates`, `VMInsights` | Empty: `[]`<br />1 Solution: `["SecurityInsights"]`<br />Many Solutions: `["SecurityInsights","VMInsights"]`

## Outputs

The module will generate the following outputs:

Output | Type | Example
------ | ---- | --------
outLogAnalyticsWorkspaceName | string | alz-la 
outLogAnalyticsWorkspaceId | string | /subscriptions/4f9f8765-911a-4a6d-af60-4bc0473268c0/resourceGroups/alz-log-analytics/providers/Microsoft.OperationalInsights/workspaces/alz-la
outLogAnalyticsCustomerId | string | 9637d722-aefd-48d9-bbff-1a398fb7c80a
outLogAnalyticsSolutions | Array of string | ["AgentHealthAssessment", "AntiMalware","AzureActivity", "ChangeTracking", "Security", "SecurityInsights", "ServiceMap", "SQLAssessment", "Updates", "VMInsights"]



## Deployment

In this example, a Log Analytics Workspace will be deployed to the resource group `alz-log-analytics`.  The inputs for this module are defined in `log-analytics-workspace.parameters.example.json`.

> For the below examples we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.

### Azure CLI
```bash
# Create Resource Group - optional when using an existing resource group
az group create \
  --name alz-log-analytics \
  --location eastus

# Deploy Module
az deployment group create \
  --template-file infra-as-code/bicep/modules/reusable/log-analytics-workspace/log-analytics-workspace.bicep \
  --parameters @infra-as-code/bicep/modules/reusable/log-analytics-workspace/log-analytics-workspace.parameters.example.json \
  --resource-group alz-log-analytics
```

### PowerShell

```powershell
# Create Resource Group - optional when using an existing resource group
New-AzResourceGroup `
  -Name alz-log-analytics `
  -Location eastus

# Deploy Module
New-AzResourceGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/reusable/log-analytics-workspace/log-analytics-workspace.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/reusable/log-analytics-workspace/log-analytics-workspace.parameters.example.json `
  -ResourceGroup alz-log-analytics
```

## Bicep Visualizer

![Bicep Visualizer](media/bicep-visualizer.png "Bicep Visualizer")
