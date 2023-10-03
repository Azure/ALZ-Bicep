using '../mgDiagSettingsAll.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parLogAnalyticsWorkspaceResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/alz-logging/providers/microsoft.operationalinsights/workspaces/alz-log-analytics'

param parTelemetryOptOut = false
