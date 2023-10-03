using '../mgDiagSettingsAll.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parTopLevelManagementGroupSuffix = ''

param parLandingZoneMgAlzDefaultsEnable = true

param parPlatformMgAlzDefaultsEnable = true

param parLandingZoneMgConfidentialEnable = false

param parLogAnalyticsWorkspaceResourceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/alz-logging/providers/microsoft.operationalinsights/workspaces/alz-log-analytics'

param parLandingZoneMgChildren = []

param parPlatformMgChildren = []

param parTelemetryOptOut = false
