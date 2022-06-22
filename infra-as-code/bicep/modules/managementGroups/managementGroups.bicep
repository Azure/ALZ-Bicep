targetScope = 'tenant'

@description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Platform and Child Management Groups
var varPlatformMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  displayName: 'Platform'
}

var varPlatformManagementMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-management'
  displayName: 'Management'
}

var varPlatformConnectivityMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  displayName: 'Connectivity'
}

var varPlatformIdentityMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-identity'
  displayName: 'Identity'
}

// Landing Zones & Child Management Groups
var varLandingZoneMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  displayName: 'Landing Zones'
}

var varLandingZoneCorpMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  displayName: 'Corp'
}

var varLandingZoneOnlineMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  displayName: 'Online'
}

// Sandbox Management Group
var varSandboxMg = {
  name: '${parTopLevelManagementGroupPrefix}-sandbox'
  displayName: 'Sandbox'
}

// Decomissioned Management Group
var varDecommissionedMg = {
  name: '${parTopLevelManagementGroupPrefix}-decommissioned'
  displayName: 'Decommissioned'
}

// Customer Usage Attribution Id
var varCuaid = '9b7965a0-d77c-41d6-85ef-ec3dfea4845b'

// Level 1
resource resTopLevelMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: parTopLevelManagementGroupPrefix
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
  }
}

// Level 2
resource resPlatformMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformMg.name
  properties: {
    displayName: varPlatformMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resLandingZonesMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneMg.name
  properties: {
    displayName: varLandingZoneMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resSandboxMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varSandboxMg.name
  properties: {
    displayName: varSandboxMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resDecommissionedMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varDecommissionedMg.name
  properties: {
    displayName: varDecommissionedMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Platform MG
resource resPlatformManagementMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformManagementMg.name
  properties: {
    displayName: varPlatformManagementMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

resource resPlatformConnectivityMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformConnectivityMg.name
  properties: {
    displayName: varPlatformConnectivityMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

resource resPlatformIdentityMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varPlatformIdentityMg.name
  properties: {
    displayName: varPlatformIdentityMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Landing Zones MG
resource resLandingZonesCorpMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneCorpMg.name
  properties: {
    displayName: varLandingZoneCorpMg.displayName
    details: {
      parent: {
        id: resLandingZonesMg.id
      }
    }
  }
}

resource resLandingZonesOnlineMg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varLandingZoneOnlineMg.name
  properties: {
    displayName: varLandingZoneOnlineMg.displayName
    details: {
      parent: {
        id: resLandingZonesMg.id
      }
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Output Management Group IDs
output outTopLevelManagementGroupId string = resTopLevelMg.id

output outPlatformManagementGroupId string = resPlatformMg.id
output outPlatformManagementManagementGroupId string = resPlatformManagementMg.id
output outPlatformConnectivityManagementGroupId string = resPlatformConnectivityMg.id
output outPlatformIdentityManagementGroupId string = resPlatformIdentityMg.id

output outLandingZonesManagementGroupId string = resLandingZonesMg.id
output outLandingZonesCorpManagementGroupId string = resLandingZonesCorpMg.id
output outLandingZonesOnlineManagementGroupId string = resLandingZonesOnlineMg.id

output outSandboxManagementGroupId string = resSandboxMg.id

output outDecommissionedManagementGroupId string = resDecommissionedMg.id

// Output Management Group Names
output outTopLevelManagementGroupName string = resTopLevelMg.name

output outPlatformManagementGroupName string = resPlatformMg.name
output outPlatformManagementManagementGroupName string = resPlatformManagementMg.name
output outPlatformConnectivityManagementGroupName string = resPlatformConnectivityMg.name
output outPlatformIdentityManagementGroupName string = resPlatformIdentityMg.name

output outLandingZonesManagementGroupName string = resLandingZonesMg.name
output outLandingZonesCorpManagementGroupName string = resLandingZonesCorpMg.name
output outLandingZonesOnlineManagementGroupName string = resLandingZonesOnlineMg.name

output outSandboxManagementGroupName string = resSandboxMg.name

output outDecommissionedManagementGroupName string = resDecommissionedMg.name
