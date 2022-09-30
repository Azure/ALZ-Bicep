targetScope = 'tenant'

@description('Prefix used for the management group hierarchy in the managementGroups module.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Dictionary Object to allow additional or different child Management Groups of the Landing Zones Management Group .')
param parLandingZoneMgChildren array = []

@description('Log Analytics Workspace Id')
param parLawId string

@description('Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.')
param parLandingZoneMgAlzDefaultsEnable bool = true

@description('Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.')
param parLandingZoneMgConfidentialEnable bool = false

var varMgIds = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox'
}

// Used if parLandingZoneMgAlzDefaultsEnable == true
var varLandingZoneMgChildrenAlzDefault = {
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online'
}

// Used if parLandingZoneMgConfidentialEnable == true
var varLandingZoneMgChildrenConfidential = {
  landingZonesConfidentialCorp: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-corp'
  landingZonesConfidentialOnline: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-online'
}

// Used if parLandingZoneMgConfidentialEnable not empty
var varLandingZoneMgCustomChildren = [for customMg in parLandingZoneMgChildren: {
  mgId: '${parTopLevelManagementGroupPrefix}-landingzones-${customMg}'
}]

// Build final object based on input parameters for default and confidential child MGs of LZs
var varLandingZoneMgDefaultChildrenUnioned = (parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable) ? union(varLandingZoneMgChildrenAlzDefault, varLandingZoneMgChildrenConfidential) : (parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable) ? varLandingZoneMgChildrenAlzDefault : (!parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable) ? varLandingZoneMgChildrenConfidential : (!parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable) ? {} : {}

module modMgDiagSet '../../modules/mgDiagSettings/diagSettings.bicep' = [for mgId in items(varMgIds): {
  scope: managementGroup(mgId.value)
  name: 'mg-diag-set-${mgId.value}'
  params: {
    parLawId: parLawId
  }
}]

// Default Children Landing Zone Management Groups
module modMgLandingZonesDiagSet '../../modules/mgDiagSettings/diagSettings.bicep' = [for childMg in items(varLandingZoneMgDefaultChildrenUnioned): {
  scope: managementGroup(childMg.value)
  name: 'mg-diag-set-${childMg.value}'
  params: {
    parLawId: parLawId
  }
}]

// Custom Children Landing Zone Management Groups
module modMgChildrenDiagSet '../../modules/mgDiagSettings/diagSettings.bicep' = [for childMg in varLandingZoneMgCustomChildren: {
  scope: managementGroup(childMg.mgId)
  name: 'mg-diag-set-${childMg.mgId}'
  params: {
    parLawId: parLogAnalyticsWorkspaceResourceId
  }
}]
