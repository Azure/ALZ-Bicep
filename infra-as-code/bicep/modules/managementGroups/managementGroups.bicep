/*
SUMMARY: The Management Groups module deploys a management group hierarchy in a customer's tenant under the 'Tenant Root Group'.
DESCRIPTION:  Management Group hierarchy is created through a tenant-scoped Azure Resource Manager (ARM) deployment.  The hierarchy is:
  * Tenant Root Group
    * Top Level Management Group (defined by parameter `parTopLevelManagementGroupPrefix`)
      * Platform
          * Management
          * Connectivity
          * Identity
      * Landing Zones
          * Corp
          * Online
      * Sandbox
      * Decommissioned
AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

targetScope = 'tenant'

@description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
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

// Sandbox Management Group
var varSandboxManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-sandbox'
  displayName: 'Sandbox'
}

// Decomissioned Management Group
var varDecommissionedManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-decommissioned'
  displayName: 'Decommissioned'
}

// Level 1
resource resTopLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parTopLevelManagementGroupPrefix
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
  }
}

// Level 2
resource resPlatformMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformMG.name
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
  properties: {
    displayName: varLandingZoneMG.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resSandboxMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varSandboxManagementGroup.name
  properties: {
    displayName: varSandboxManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resDecommissionedMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varDecommissionedManagementGroup.name
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

output outSandboxManagementGroupId string = resSandboxMG.id

output outDecommissionedManagementGroupId string = resDecommissionedMG.id
