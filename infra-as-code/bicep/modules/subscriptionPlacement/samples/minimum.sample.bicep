//
// Minimum deployment sample
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Minimum resource configuration.')
module sub_placement '../subscriptionPlacement.bicep' = {
  name: 'sub_placement'
  params: {
    parSubscriptionIds: [
      '00000000-0000-0000-0000-000000000000'
      '11111111-1111-1111-1111-111111111111'
    ]
    parTargetManagementGroupId: '22222222-2222-2222-2222-222222222222'
  }
}
