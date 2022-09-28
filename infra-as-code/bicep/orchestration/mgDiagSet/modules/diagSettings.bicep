targetScope = 'managementGroup'

param parLawId string

resource mgDiagSet 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'toLa'
  properties: {
    workspaceId: parLawId
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
