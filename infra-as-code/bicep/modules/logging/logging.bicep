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

AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

@description('Log Analytics Workspace name. - DEFAULT VALUE: alz-log-analytics')
param parLogAnalyticsWorkspaceName string = 'alz-log-analytics'

@description('Log Analytics region name. - DEFAULT VALUE: resourceGroup().location')
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

@description('Automation Account region name. - DEFAULT VALUE: resourceGroup().location')
param parAutomationAccountRegion string = resourceGroup().location

module modAutomationAccount '../automationAccount/automationAccount.bicep' = {
  name: 'deploy-automation-account'
  params: {
    parName: parAutomationAccountName
    parRegion: parAutomationAccountRegion
  }
}

module modLogAnalyticsWorkspace '../logAnalyticsWorkspace/logAnalyticsWorkspace.bicep' = {
  name: 'deploy-log-analytics-workspace'
  params: {
    parName: parLogAnalyticsWorkspaceName
    parRegion: parLogAnalyticsWorkspaceRegion
    parLogRetentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
    parLogAnalyticsSolutions: parLogAnalyticsWorkspaceSolutions
  }
}

resource resLogAnalyticsLinkedServiceForAutomationAccount 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  dependsOn: [
    modLogAnalyticsWorkspace
  ]

  name: '${parLogAnalyticsWorkspaceName}/Automation'
  properties: {
    resourceId: modAutomationAccount.outputs.outAutomationAccountId
  }
}

output outLogAnalyticsWorkspaceName string = modLogAnalyticsWorkspace.outputs.outLogAnalyticsWorkspaceName
output outLogAnalyticsWorkspaceId string = modLogAnalyticsWorkspace.outputs.outLogAnalyticsWorkspaceId
output outLogAnalyticsCustomerId string = modLogAnalyticsWorkspace.outputs.outLogAnalyticsCustomerId
output outLogAnalyticsSolutions array = modLogAnalyticsWorkspace.outputs.outLogAnalyticsSolutions

output outAutomationAccountName string = modAutomationAccount.outputs.outAutomationAccountName
output outAutomationAccountId string = modAutomationAccount.outputs.outAutomationAccountId
