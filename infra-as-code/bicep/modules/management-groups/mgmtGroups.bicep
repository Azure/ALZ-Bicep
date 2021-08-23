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


targetScope = 'managementGroup'

@description('The management group that will be used to create all management groups.  Specific the management group id.')
param parParentManagementGroupId string

@description('Prefix for the management structure.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string

var varPlatformManagementGroups = [
  'management'
  'connectivity'
  'identity'
]

var varLandingZoneManagementGroups = [
  'corp'
  'online'
]

// Level 1
resource resTopLevelMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parTopLevelManagementGroupPrefix
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups', parParentManagementGroupId)
      }
    }
  }
}

// Level 2
resource resPlatformMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}


resource resLandingZonesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resSandboxesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${parTopLevelManagementGroupPrefix}-sandboxes'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resDecommissionedMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${parTopLevelManagementGroupPrefix}-decommissioned'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}


// Level 3 - Child Management Groups under Platform MG
resource resPlatformChildMG 'Microsoft.Management/managementGroups@2021-04-01' = [for childMG in varPlatformManagementGroups: {
  name: '${resPlatformMG.name}-${childMG}'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resPlatformMG.id
      }
    }
  }
}]

// Level 3 - Child Management Groups under Landing Zones MG
resource resLandingZoneChildMG 'Microsoft.Management/managementGroups@2021-04-01' = [for childMG in varLandingZoneManagementGroups: {
  name: '${resLandingZonesMG.name}-${childMG}'
  scope: tenant()
  properties: {
    details: {
      parent: {
        id: resLandingZonesMG.id
      }
    }
  }
}]
