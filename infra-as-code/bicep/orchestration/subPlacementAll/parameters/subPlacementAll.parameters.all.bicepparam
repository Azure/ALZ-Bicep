using '../subPlacementAll.bicep'

param parTopLevelManagementGroupPrefix = 'alz'

param parTopLevelManagementGroupSuffix = ''

param parIntRootMgSubs = []

param parPlatformMgSubs = []

param parPlatformManagementMgSubs = []

param parPlatformConnectivityMgSubs = []

param parPlatformIdentityMgSubs = []

param parLandingZonesMgSubs = []

param parLandingZonesCorpMgSubs = []

param parLandingZonesOnlineMgSubs = []

param parLandingZonesConfidentialCorpMgSubs = []

param parLandingZonesConfidentialOnlineMgSubs = []

param parLandingZoneMgChildrenSubs = {}

param parPlatformMgChildrenSubs = {}

param parDecommissionedMgSubs = []

param parSandboxMgSubs = []

param parTelemetryOptOut = false