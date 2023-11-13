using '../logging.bicep'

param parLogAnalyticsWorkspaceName = 'alz-log-analytics'

param parLogAnalyticsWorkspaceLocation = 'chinaeast2'

param parLogAnalyticsWorkspaceSkuName = 'PerGB2018'

param parLogAnalyticsWorkspaceLogRetentionInDays = 365

param parLogAnalyticsWorkspaceSolutions = [
  'AgentHealthAssessment'
  'AntiMalware'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'SQLAdvancedThreatProtection'
  'SQLVulnerabilityAssessment'
  'SQLAssessment'
  'Updates'
  'VMInsights'
]

param parLogAnalyticsWorkspaceLinkAutomationAccount = true

param parAutomationAccountName = 'alz-automation-account'

param parAutomationAccountLocation = 'chinaeast2'

param parAutomationAccountUseManagedIdentity = true

param parAutomationAccountPublicNetworkAccess = true

param parTags = {
  Environment: 'Live'
}

param parTelemetryOptOut = false
