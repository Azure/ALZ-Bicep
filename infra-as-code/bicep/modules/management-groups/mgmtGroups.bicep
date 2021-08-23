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
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group prefix.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

// Management Group definition for Platform
var varPlatformManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  displayName: 'Platform'
  childManagementGroups: [
    {
      name: '${parTopLevelManagementGroupPrefix}-platform-management'
      displayName: 'Management'
    }
    {
      name: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
      displayName: 'Connectivity'
    }
    {
      name: '${parTopLevelManagementGroupPrefix}-platform-identity'
      displayName: 'Identity'
    }
  ]
}

// Management Group definition for Landing Zones
var varLandingZoneManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  displayName: 'Landing Zones'
  childManagementGroups: [
    {
      name: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
      displayName: 'Corp'
    }
    {
      name: '${parTopLevelManagementGroupPrefix}-landingzones-online'
      displayName: 'Online'
    }
  ]
}

// Management Group definition for Sandboxes
var varSandboxesManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-sandboxes'
  displayName: 'Sandboxes'
}

// Management Group definition for Decomissioned
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
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups', parParentManagementGroupId)
      }
    }
  }
}

// Level 2
resource resPlatformMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformManagementGroup.name
  scope: tenant()
  properties: {
    displayName: varPlatformManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelMG.id
      }
    }
  }
}

resource resLandingZonesMG 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneManagementGroup.name
  scope: tenant()
  properties: {
    displayName: varLandingZoneManagementGroup.displayName
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
resource resPlatformChildMG 'Microsoft.Management/managementGroups@2021-04-01' = [for childMG in varPlatformManagementGroup.childManagementGroups: {
  name: childMG.name
  scope: tenant()
  properties: {
    displayName: childMG.displayName
    details: {
      parent: {
        id: resPlatformMG.id
      }
    }
  }
}]

// Level 3 - Child Management Groups under Landing Zones MG
resource resLandingZoneChildMG 'Microsoft.Management/managementGroups@2021-04-01' = [for childMG in varLandingZoneManagementGroup.childManagementGroups: {
  name: childMG.name
  scope: tenant()
  properties: {
    displayName: childMG.displayName
    details: {
      parent: {
        id: resLandingZonesMG.id
      }
    }
  }
}]

output outTopLevelManagementGroupPrefix string = parTopLevelManagementGroupPrefix
output outPlatformManagement object = varPlatformManagementGroup
output outLandingZoneManagementGroups object = varLandingZoneManagementGroup
output outSandboxManagementGroup object = varSandboxesManagementGroup
output outDecommissioned object = varDecommissionedManagementGroup 
