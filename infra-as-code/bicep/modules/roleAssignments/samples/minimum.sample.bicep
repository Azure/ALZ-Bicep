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
module ra_mg'../roleAssignmentManagementGroup.bicep' = {
  name: 'ra_mg'
  params: {
    parRoleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    parAssigneePrincipalType: 'Group'
    parAssigneeObjectId: '00000000-0000-0000-0000-000000000000'
  }
}
