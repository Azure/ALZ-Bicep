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

@description('Minimum resource configuration')
module minimum_policy '../definitions/customPolicyDefinitions.bicep' = {
  name: 'minimum policy'
}
