//
// Baseline deployment sample
//

// Use this sample to deploy the baseline resource configuration.

targetScope = 'managementGroup'


// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline_custom_role_definitions '../customRoleDefinitions.bicep' = {
  name: 'custom_role_definition'
  params: {
    parAssignableScopeManagementGroupId: 'alz'
    parTelemetryOptOut: false
  }
}
