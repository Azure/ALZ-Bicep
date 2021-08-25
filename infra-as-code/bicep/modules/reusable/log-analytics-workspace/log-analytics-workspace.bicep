/*
SUMMARY: Deploys an Azure Log Analytics Workspace & Solutions
DESCRIPTION:
  Deploys an Azure Log Analytics Workspace & Solutions to an existing Resource Group.
  
  The module will deploy the following solutions by default.  Solutions can be customized as required:

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
param parName string = 'alz-log-analytics'

@description('Region name. - DEFAULT VALUE: resourceGroup().location')
param parRegion string = resourceGroup().location

@minValue(30)
@maxValue(730)
@description('Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365')
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
@description('Solutions that will be added to the Log Analytics Workspace - DEFAULT VALUE: [AgentHealthAssessment, AntiMalware, AzureActivity, ChangeTracking, Security, SecurityInsights, ServiceMap, SQLAssessment, Updates, VMInsights]')
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
  location: parRegion
  properties: {
    sku: {
      name: 'PerNode'
    }
    retentionInDays: parLogRetentionInDays
  }
}

resource resLogAnalyticsWorkspaceSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for solution in parLogAnalyticsSolutions: {
  name: '${solution}(${resLogAnalyticsWorkspace.name})'
  location: parRegion
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
