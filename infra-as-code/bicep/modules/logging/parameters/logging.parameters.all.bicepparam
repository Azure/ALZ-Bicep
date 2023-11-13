using '../logging.bicep'

param parLogAnalyticsWorkspaceName = 'alz-log-analytics'

param parLogAnalyticsWorkspaceLocation = 'eastus'

param parLogAnalyticsWorkspaceSkuName = 'PerGB2018'

param parLogAnalyticsWorkspaceCapacityReservationLevel = 100

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

param parAutomationAccountLocation = 'eastus2'

param parAutomationAccountUseManagedIdentity = true

param parAutomationAccountPublicNetworkAccess = true

param parTags = {
  Environment: 'Live'
}

param parUseSentinelClassicPricingTiers = false

param parTelemetryOptOut = false
