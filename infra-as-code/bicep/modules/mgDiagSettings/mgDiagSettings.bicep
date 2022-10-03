targetScope = 'managementGroup'

@description('Log Analytics Workspace Resource ID.')
param parLogAnalyticsWorkspaceResourceId string

resource mgDiagSet 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'toLa'
  properties: {
    workspaceId: parLogAnalyticsWorkspaceResourceId
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Policy'
        enabled: true
      }
    ]
  }
}
