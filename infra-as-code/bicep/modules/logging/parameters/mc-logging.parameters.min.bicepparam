using '../logging.bicep'

param parLogAnalyticsWorkspaceLocation = 'chinaeast2'

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

param parAutomationAccountLocation = 'chinaeast2'

param parTelemetryOptOut = false