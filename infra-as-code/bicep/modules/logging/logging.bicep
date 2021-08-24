/*
SUMMARY: Deploys Azure Log Analytics Workspace & Automation Account.
DESCRIPTION:
  Deploys Azure Log Analytics Workspace & Automation Account to a Resource Group.  Automation Account will be linked to Log Analytics Workspace to provide integration for Inventory, Change Tracking and Update Management.
  
  The module will deploy the following Log Analytics Workspace solutions by default.  Solutions can be customized as required:

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

AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

@description('Log Analytics Workspace name')
param parLogAnalyticsWorkspaceName string = 'alz-log-analytics'

@minValue(30)
@maxValue(730)
@description('Number of days of log retention for Log Analytics Workspace.  1 year of log retention by default.')
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
@description('Solutions that will be added to the Log Analytics Workspace')
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

@description('Automation account name')
param parAutomationAccountName string = 'alz-automation-account'

module modAutomationAccount '../reusable/automation-account/automation-account.bicep' = {
  name: 'deploy-automation-account'
  params: {
    parName: parAutomationAccountName
  }
}

module modLogAnalyticsWorkspace '../reusable/log-analytics-workspace/log-analytics-workspace.bicep' = {
  name: 'deploy-log-analytics-workspace'
  params: {
    parName: parLogAnalyticsWorkspaceName
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
