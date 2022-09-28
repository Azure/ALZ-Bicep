targetScope = 'tenant'

@description('Prefix used for the management group hierarchy in the managementGroups module.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group .')
param parLandingZoneMgChildren array = []

@description('Log Analytics Workspace Id')
param parLawId string

var varMgIds = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  landingZonesConfidentialCorp: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-corp'
  landingZonesConfidentialOnline: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-online'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox'
}

module modMgDiagSet './modules/diagSettings.bicep' = [for mgId in items(varMgIds): {
  scope: managementGroup(mgId.value)
  name: 'mg-diag-set-${mgId.key}'
  params: {
    parLawId: parLawId
  }
}]

// Custom Children Landing Zone Management Groups
module modLandingZonesMgChildrenDiagSet './modules/diagSettings.bicep' = [for childMg in (parLandingZoneMgChildren): {
  scope: managementGroup(childMg)
  name: 'mg-diag-set-${childMg}'
  params: {
    parLawId: parLawId
  }
}]
