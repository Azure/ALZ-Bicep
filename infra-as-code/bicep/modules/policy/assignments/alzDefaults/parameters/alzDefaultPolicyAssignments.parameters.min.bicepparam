using '../alzDefaultPolicyAssignments.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parLogAnalyticsWorkSpaceAndAutomationAccountLocation = 'eastus'

param parLogAnalyticsWorkspaceResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics'

param parLogAnalyticsWorkspaceLogRetentionInDays = '365'

param parAutomationAccountName = 'alz-automation-account'

param parMsDefenderForCloudEmailSecurityContact = 'security_contact@replace_me.com'

param parTelemetryOptOut = false
