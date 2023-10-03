using '../managementGroups.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parTopLevelManagementGroupSuffix = ''

param parTopLevelManagementGroupDisplayName = 'Azure Landing Zones'

param parTopLevelManagementGroupParentId = ''

param parLandingZoneMgAlzDefaultsEnable = true

param parPlatformMgAlzDefaultsEnable = true

param parLandingZoneMgConfidentialEnable = false

param parLandingZoneMgChildren = {}

param parPlatformMgChildren = {}

param parTelemetryOptOut = false
