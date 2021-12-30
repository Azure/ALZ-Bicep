/*
SUMMARY: Deploys Azure Log Analytics Workspace & Automation Account.
DESCRIPTION:
  Deploys Azure Log Analytics Workspace & Automation Account to an existing Resource Group.  Automation Account will be linked to Log Analytics Workspace to provide integration for Inventory, Change Tracking and Update Management.
  
  The module will deploy the following Log Analytics Workspace solutions by default.  Solutions can be customized as required:

    * AgentHealthAssessment
    * AntiMalware
    * AzureActivity
    * ChangeTracking
    * Security
    * SecurityInsights (Azure Sentinel)
    * ServiceMap
    * SQLAssessment
    * Updates
    * VMInsights

AUTHOR/S: SenthuranSivananthan,aultt
VERSION: 1.1.1
*/

@description('Log Analytics Workspace name. - DEFAULT VALUE: alz-log-analytics')
param parLogAnalyticsWorkspaceName string = 'alz-log-analytics'

@description('Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings - DEFAULT VALUE: resourceGroup().location')
param parLogAnalyticsWorkspaceRegion string = resourceGroup().location

@minValue(30)
@maxValue(730)
@description('Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365')
param parLogAnalyticsWorkspaceLogRetentionInDays int = 365

@allowed([
  'AgentHealthAssessment'
  'AntiMalware'
  'AzureActivity'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAssessment'
  'Updates'
  'VMInsights'
])
@description('Solutions that will be added to the Log Analytics Workspace. - DEFAULT VALUE: [AgentHealthAssessment, AntiMalware, AzureActivity, ChangeTracking, Security, SecurityInsights, ServiceMap, SQLAssessment, Updates, VMInsights]')
param parLogAnalyticsWorkspaceSolutions array = [
  'AgentHealthAssessment'
  'AntiMalware'
  'AzureActivity'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAssessment'
  'Updates'
  'VMInsights'
]

@description('Automation account name. - DEFAULT VALUE: alz-automation-account')
param parAutomationAccountName string = 'alz-automation-account'

@description('Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings - DEFAULT VALUE: resourceGroup().location')
param parAutomationAccountRegion string = resourceGroup().location

resource resAutomationAccount 'Microsoft.Automation/automationAccounts@2019-06-01' = {
  name: parAutomationAccountName
  location: parAutomationAccountRegion
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: parLogAnalyticsWorkspaceName
  location: parLogAnalyticsWorkspaceRegion
  properties: {
    sku: {
      name: 'PerNode'
    }
    retentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
  }
}

resource resLogAnalyticsWorkspaceSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for solution in parLogAnalyticsWorkspaceSolutions: {
  name: '${solution}(${resLogAnalyticsWorkspace.name})'
  location: parLogAnalyticsWorkspaceRegion
  properties: {
    workspaceResourceId: resLogAnalyticsWorkspace.id
  }
  plan: {
    name: '${solution}(${resLogAnalyticsWorkspace.name})'
    product: 'OMSGallery/${solution}'
    publisher: 'Microsoft'
    promotionCode: ''
  }
}]

resource resLogAnalyticsLinkedServiceForAutomationAccount 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: '${parLogAnalyticsWorkspaceName}/Automation'
  properties: {
    resourceId: resAutomationAccount.id
  }
}

output outLogAnalyticsWorkspaceName string = resLogAnalyticsWorkspace.name
output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
output outLogAnalyticsCustomerId string = resLogAnalyticsWorkspace.properties.customerId
output outLogAnalyticsSolutions array = parLogAnalyticsWorkspaceSolutions

output outAutomationAccountName string = resAutomationAccount.name
output outAutomationAccountId string = resAutomationAccount.id
