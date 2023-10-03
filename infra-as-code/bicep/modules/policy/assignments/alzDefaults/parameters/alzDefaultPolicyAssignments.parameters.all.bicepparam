using '../alzDefaultPolicyAssignments.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parTopLevelManagementGroupSuffix = ''

param parLogAnalyticsWorkSpaceAndAutomationAccountLocation = 'eastus'

param parLogAnalyticsWorkspaceResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics'

param parLogAnalyticsWorkspaceLogRetentionInDays = '365'

param parAutomationAccountName = 'alz-automation-account'

param parMsDefenderForCloudEmailSecurityContact = 'security_contact@replace_me.com'

param parDdosProtectionPlanId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-alz-hub-networking-001/providers/Microsoft.Network/ddosProtectionPlans/alz-ddos-plan'

param parPrivateDnsResourceGroupId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-alz-hub-networking-001'

param parPrivateDnsZonesNamesToAuditInCorp = []

param parDisableAlzDefaultPolicies = false

param parVmBackupExclusionTagName = ''

param parVmBackupExclusionTagValue = []

param parExcludedPolicyAssignments = []

param parTelemetryOptOut = false
