# Module: Logging, Automation & Sentinel

Deploys Azure Log Analytics Workspace, Automation Account (linked together) & multiple Solutions deploy to the Log Analytics Workspace to an existing Resource Group.

Automation Account will be linked to Log Analytics Workspace to provide integration for Update Management, Change Tracking and Inventory, and Start/Stop VMs during off-hours for your servers and virtual machines.  Only one mapping can exist between Log Analytics Workspace and Automation Account.

The module will deploy the following Log Analytics Workspace solutions by default.  Solutions can be customized as required:

- AgentHealthAssessment
- AntiMalware
- AzureActivity
- ChangeTracking
- Security
- SecurityInsights (Azure Sentinel)
- ServiceMap
- SQLAdvancedThreatProtection
- SQLVulnerabilityAssessment
- SQLAssessment
- Updates
- VMInsights

 > Only certain regions are supported to link Log Analytics Workspace & Automation Account together (linked workspaces). Reference:  [Supported regions for linked Log Analytics workspace](https://docs.microsoft.com/azure/automation/how-to/region-mappings)

## Parameters

The module requires the following required input parameters.

| Parameter                                  | Type            | Description                                                 | Requirement                                                                                                                                                                                                                                                            | Example                                                                                                      |
| ------------------------------------------ | --------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| parLogAnalyticsWorkspaceName               | string          | Log Analytics Workspace name                                | Mandatory input, default: `alz-log-analytics`                                                                                                                                                                                                                          | `alz-log-analytics`                                                                                          |
| parLogAnalyticsWorkspaceLocation           | string          | Region name                                                 | Mandatory input, default: `resourceGroup().location`                                                                                                                                                                                                                   | `eastus`                                                                                                     |
| parLogAnalyticsWorkspaceSkuName            | string          | Log Analytics Workspace sku name                            | Mandatory input, default `PerGB2018`                                                                                                                                                                                                                                   | `PerGB2018`                                                                                                  |
| parLogAnalyticsWorkspaceLogRetentionInDays | int             | Number of days of log retention for Log Analytics Workspace | Mandatory input between 30-730, default: `365`                                                                                                                                                                                                                         | `365`                                                                                                        |
| parLogAnalyticsWorkspaceSolutions          | Array of string | Solutions that will be added to the Log Analytics Workspace | 1 or more of `AgentHealthAssessment`, `AntiMalware`, `AzureActivity`, `ChangeTracking`, `Security`, `SecurityInsights`, `ServiceMap`, `SQLAdvancedThreatProtection`, `SQLVulnerabilityAssessment`, `SQLAssessment`, `Updates`, `VMInsights`, default:  *all solutions* | Empty: `[]`<br />1 Solution: `["SecurityInsights"]`<br />Many Solutions: `["SecurityInsights","VMInsights"]` |
| parAutomationAccountName                   | string          | Automation account name                                     | Mandatory input, name must be unique in the subscription, default: `alz-automation-account`                                                                                                                                                                            | `alz-automation-account`                                                                                     |
| parAutomationAccountLocation               | string          | Region name                                                 | Mandatory input, default: `resourceGroup().location`                                                                                                                                                                                                                   | `eastus`                                                                                                     |
| parTags                                    | object          | Empty object `{}`                                           | Array of Tags to be applied to all resources in the logging module                                                                                                                                                                                                     | `{"key": "value"}`                                                                                           |
| parAutomationAccountTags                   | object          | Empty object `{}`                                           | Array of Tags to be applied to Automation Account in the logging module                                                                                                                                                                                                | `{"key": "value"}`                                                                                           |
| parLogAnalyticsWorkspaceTags               | object          | Empty object `{}`                                           | Array of Tags to be applied to Log Analytics Workspace in the logging module                                                                                                                                                                                           | `{"key": "value"}`                                                                                           |
| parTelemetryOptOut                         | bool            | Set Parameter to true to Opt-out of deployment telemetry    | Mandatory input, default: `false`                                                                                                                                                                                                                                      | `false`                                                                                                      |

## Outputs

The module will generate the following outputs:

| Output                       | Type            | Example                                                                                                                                                                                                                         |
| ---------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| outLogAnalyticsWorkspaceName | string          | alz-log-analytics                                                                                                                                                                                                               |
| outLogAnalyticsWorkspaceId   | string          | /subscriptions/4f9f8765-911a-4a6d-af60-4bc0473268c0/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics                                                                             |
| outLogAnalyticsCustomerId    | string          | 4192b202-f57d-4e75-a074-d215aa2acb49                                                                                                                                                                                            |
| outLogAnalyticsSolutions     | Array of string | ["AgentHealthAssessment", "AntiMalware","AzureActivity", "ChangeTracking", "Security", "SecurityInsights", "ServiceMap", "SQLAdvancedThreatProtection", "SQLVulnerabilityAssessment", "SQLAssessment", "Updates", "VMInsights"] |
| outAutomationAccountName     | string          | alz-automation-account                                                                                                                                                                                                          |
| outAutomationAccountId       | string          | /subscriptions/4f9f8765-911a-4a6d-af60-4bc0473268c0/resourceGroups/alz-logging/providers/Microsoft.Automation/automationAccounts/alz-automation-account                                                                         |

## Deployment

In this example, a Log Analytics Workspace and Automation Account will be deployed to the resource group `alz-logging`.  The inputs for this module are defined in `logging.parameters.all.json`.

There are separate input parameters files depending on which Azure cloud you are deploying because this module deploys resources into an existing resource group under the specified region. There is no change to the Bicep template file.
| Azure Cloud    | Bicep template | Input parameters file                     |
| -------------- | -------------- | ----------------------------------------- |
| Global regions | logging.bicep  | parameters/logging.parameters.all.json    |
| China regions  | logging.bicep  | parameters/mc-logging.parameters.all.json |

> For the examples below we assume you have downloaded or cloned the Git repo as-is and are in the root of the repository as your selected directory in your terminal of choice.
> If the deployment failed due an error that your alz-log-analytics/Automation resource of type 'Microsoft.OperationalInsights/workspaces/linkedServices' was not found, please retry the deployment step and it would succeed.

### Azure CLI
```bash
# For Azure Global regions  
# Set Platform management subscripion ID as the the current subscription 
ManagementSubscriptionId="[your platform management subscription ID]"
az account set --subscription $ManagementSubscriptionId

# Create Resource Group - optional when using an existing resource group
az group create \
  --name alz-logging \
  --location eastus

# Deploy Module 
az deployment group create \
  --template-file infra-as-code/bicep/modules/logging/logging.bicep \
  --parameters @infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json \
  --resource-group alz-logging
```
OR
```bash
# For Azure China regions  
# Set Platform management subscripion ID as the the current subscription 
ManagementSubscriptionId="[your platform management subscription ID]"
az account set --subscription $ManagementSubscriptionId

# Create Resource Group - optional when using an existing resource group
az group create \
  --name alz-logging \
  --location chinaeast2

# Deploy Module 
az deployment group create \
  --template-file infra-as-code/bicep/modules/logging/logging.bicep \
  --parameters @infra-as-code/bicep/modules/logging/parameters/mc-logging.parameters.all.json \
  --resource-group alz-logging
```

### PowerShell

```powershell
# For Azure Global regions
# Set Platform management subscripion ID as the the current subscription 
$ManagementSubscriptionId = "[your platform management subscription ID]"

Select-AzSubscription -SubscriptionId $ManagementSubscriptionId

# Create Resource Group - optional when using an existing resource group
New-AzResourceGroup `
  -Name alz-logging `
  -Location eastus

New-AzResourceGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/logging/logging.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json `
  -ResourceGroup alz-logging
```
OR
```powershell
# For Azure China regions
# Set Platform management subscripion ID as the the current subscription 
$ManagementSubscriptionId = "[your platform management subscription ID]"

Select-AzSubscription -SubscriptionId $ManagementSubscriptionId

# Create Resource Group - optional when using an existing resource group
New-AzResourceGroup `
  -Name alz-logging `
  -Location chinaeast2

New-AzResourceGroupDeployment `
  -TemplateFile infra-as-code/bicep/modules/logging/logging.bicep `
  -TemplateParameterFile infra-as-code/bicep/modules/logging/parameters/mc-logging.parameters.all.json `
  -ResourceGroup alz-logging
```

## Bicep Visualizer

![Bicep Visualizer](media/bicepVisualizer.png "Bicep Visualizer")
