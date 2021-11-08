/*

SUMMARY: This module provides orchestration of all the required module deployments to achevie a Azure Landing Zones Hub and Spoke network topology deployment (also known as Adventure Works)
DESCRIPTION: This module provides orchestration of all the required module deployments to achevie a Azure Landing Zones Hub and Spoke network topology deployment (also known as Adventure Works).
             It will handle the sequencing and ordering of the following modules:
             - Management Groups
             - Custom RBAC Role Definitions
             - Custom Policy Definitions
             - Logging
             - Policy Assignments
             - Subscription Placement
             - Hub Networking
             - Spoke Networking (corp connected)
             All as outlined in the Deployment Flow wiki page here: https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow
AUTHOR/S: jtracey93
VERSION: 1.0.0

*/

// **Parameters**
// Management Group Module Parameters
@description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  baseSuffix: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modManagementGroups: '${varDeploymentNameWrappers.basePrefix}-mgs-${varDeploymentNameWrappers.baseSuffix}'
  modCustomRBACRoleDefinitions: '${varDeploymentNameWrappers.basePrefix}-rbacRoles-${varDeploymentNameWrappers.baseSuffix}'
  modCustomPolicyDefinitions: '${varDeploymentNameWrappers.basePrefix}-polDefs-${varDeploymentNameWrappers.baseSuffix}'
}

// **Scope**
targetScope = 'tenant'

// **Modules**
// Module - Management Groups
module modManagementGroups '../../managementGroups/managementGroups.bicep' = {
  scope: tenant()
  name: varModuleDeploymentNames.modManagementGroups
  params: {
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parTopLevelManagementGroupDisplayName: parTopLevelManagementGroupDisplayName
  }
}

// Module - Custom RBAC Role Definitions
// module modCustomRBACRoleDefinitions '../../customRoleDefinitions/customRoleDefinitions.bicep' = {
//   scope: managementGroup(parTopLevelManagementGroupPrefix)
//   name: varModuleDeploymentNames.modCustomRBACRoleDefinitions
//   params: {
//     parAssignableScopeManagementGroupId: parTopLevelManagementGroupPrefix
//   }
// }

// Module - Custom Policy Definitions and Initiatives
module modCustomPolicyDefinitions '../../policy/definitions/custom-policy-definitions.bicep' = {
  dependsOn: [
    modManagementGroups
  ]
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modCustomPolicyDefinitions
  params: {
    parTargetManagementGroupID: parTopLevelManagementGroupPrefix
  }
}



