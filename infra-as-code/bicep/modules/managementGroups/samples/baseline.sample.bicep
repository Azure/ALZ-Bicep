//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'tenant'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_managementgroups'../managementGroups.bicep' = {
  name: 'baseline managementGroups'
  params: {
    parTopLevelManagementGroupParentId: '00000000-0000-0000-0000-000000000000'
    parLandingZoneMgChildren: {
      'mg-landingzone': {
        displayName: 'Landing Zone'
        children: {
          'mg-operations': {
            displayName: 'Operations'
          }
        }
      }
    }
    parTopLevelManagementGroupPrefix: 'alz'
    parTopLevelManagementGroupDisplayName: 'Azure Landing Zones'
    parLandingZoneMgAlzDefaultsEnable: true
    parLandingZoneMgConfidentialEnable: false
    parTelemetryOptOut: false
  }
}
