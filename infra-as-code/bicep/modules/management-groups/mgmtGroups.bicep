/*
SUMMARY: Defines Management Group structure that will be used to organize platform and landing zone subscriptions.
DESCRIPTION:
  This Bicep deployment template defines the management group structure that will be deployed in a customer's environment.  It will deploy:
    1. Platform management group with management, connectivity, and identity child management groups; and
    2. Landing Zones management group with corp and online child management groups.
    3. Sandbox management group
    4. Decommissioned management group
AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

targetScope = 'tenant'

@description('Prefix for the management group structure.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group prefix.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

// Platform and Child Management Groups
var varPlatformMG = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  displayName: 'Platform'
}

var varPlatformManagementMG = {
  name: '${parTopLevelManagementGroupPrefix}-platform-management'
  displayName: 'Management'
}

var varPlatformConnectivityMG = {
  name: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  displayName: 'Connectivity'
}

var varPlatformIdentityMG = {
  name: '${parTopLevelManagementGroupPrefix}-platform-identity'
  displayName: 'Identity'
}

// Landing Zones & Child Management Groups
var varLandingZoneMG = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  displayName: 'Landing Zones'
}

var varLandingZoneCorpMG = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  displayName: 'Corp'
}

var varLandingZoneOnlineMG = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  displayName: 'Online'
}

// Sandboxes Management Group
var varSandboxesManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-sandboxes'
  displayName: 'Sandboxes'
}

// Decomissioned Management Group
var varDecommissionedManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-decommissioned'
  displayName: 'Decommissioned'
}

// Level 1
resource resTopLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parTopLevelManagementGroupPrefix
  scope: tenant()
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
  }
}

// Level 2
resource resPlatformMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformMG.name
  scope: tenant()
  properties: {
    displayName: varPlatformMG.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resLandingZonesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneMG.name
  scope: tenant()
  properties: {
    displayName: varLandingZoneMG.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resSandboxesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varSandboxesManagementGroup.name
  scope: tenant()
  properties: {
    displayName: varSandboxesManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resDecommissionedMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varDecommissionedManagementGroup.name
  scope: tenant()
  properties: {
    displayName: varDecommissionedManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Platform MG
resource resPlatformManagementMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformManagementMG.name
  scope: tenant()
  properties: {
    displayName: varPlatformManagementMG.displayName
    details: {
      parent: {
        id: resPlatformMG.id
      }
    }
  }
}

resource resPlatformConnectivityMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformConnectivityMG.name
  scope: tenant()
  properties: {
    displayName: varPlatformConnectivityMG.displayName
    details: {
      parent: {
        id: resPlatformMG.id
      }
    }
  }
}

resource resPlatformIdentityMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformIdentityMG.name
  scope: tenant()
  properties: {
    displayName: varPlatformIdentityMG.displayName
    details: {
      parent: {
        id: resPlatformMG.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Landing Zones MG
resource resLandingZonesCorpMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneCorpMG.name
  scope: tenant()
  properties: {
    displayName: varLandingZoneCorpMG.displayName
    details: {
      parent: {
        id: resLandingZonesMG.id
      }
    }
  }
}

resource resLandingZonesOnlineMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneOnlineMG.name
  scope: tenant()
  properties: {
    displayName: varLandingZoneOnlineMG.displayName
    details: {
      parent: {
        id: resLandingZonesMG.id
      }
    }
  }
}


output outTopLevelMGId string = resTopLevelMG.id

output outPlatformMGId string = resPlatformMG.id
output outPlatformManagementMGId string = resPlatformManagementMG.id
output outPlatformConnectivityMGId string = resPlatformConnectivityMG.id
output outPlatformIdentityMGId string = resPlatformIdentityMG.id

output outLandingZonesMGId string = resLandingZonesMG.id
output outLandingZonesCorpMGId string = resLandingZonesCorpMG.id
output outLandingZonesOnlineMGId string = resLandingZonesOnlineMG.id

output outSandboxesManagementGroupId string = resSandboxesMG.id

output outDecommissionedManagementGroupId string = resDecommissionedMG.id
