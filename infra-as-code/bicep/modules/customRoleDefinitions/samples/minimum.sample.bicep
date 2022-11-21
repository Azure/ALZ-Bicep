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
module minimum_custom_role_definitions '../customRoleDefinitions.bicep' = {
  name: 'custom_role_definition'
}
