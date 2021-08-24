/*
SUMMARY: Deploys an Azure Log Analytics Workspace & Solutions
DESCRIPTION:
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

AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

@description('Log Analytics Workspace name')
param parName string = 'la-alz'

@minValue(30)
@maxValue(730)
@description('Number of days of log retention for Log Analytics Workspace.  1 year of log retention by default.')
param parLogRetentionInDays int = 365

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
param parLogAnalyticsSolutions array = [
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

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: parName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerNode'
    }
    retentionInDays: parLogRetentionInDays
  }
}

resource resLogAnalyticsWorkspaceSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for solution in parLogAnalyticsSolutions: {
  name: '${solution}(${resLogAnalyticsWorkspace.name})'
  location: resourceGroup().location
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

output outLogAnalyticsWorkspaceName string = resLogAnalyticsWorkspace.name
output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
output outLogAnalyticsCustomerId string = resLogAnalyticsWorkspace.properties.customerId
output outLogAnalyticsSolutions array = parLogAnalyticsSolutions
