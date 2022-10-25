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

@description('Minimum resource configuration')
module minimum_managementgroups '../managementGroups.bicep' = {
  name: 'minimum managementGroups'
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
  }
}
