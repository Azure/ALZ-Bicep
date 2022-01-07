/*
SUMMARY: This module defines custom roles based on the recommendations from the Azure Landing Zone Conceptual Architecture.
DESCRIPTION:
  The role definitions are defined in Identity and access management recommendations.    Reference:  https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management
  
  Module supports the following custom roles:

    * Subscription owner
    * Application owners (DevOps/AppOps)
    * Network management (NetOps)
    * Security operations (SecOps)

There are differences for custom roles for Azure China regions due to following resource provider which are not returned in the list of providers from Azure Resource Manager in China.
  * Microsoft.Support resource provider is not supported because Azure support in China regions are provided by 21Vianet.

AUTHOR/S: SenthuranSivananthan, @faister
VERSION: 1.0.0
*/

targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param parAssignableScopeManagementGroupId string = 'alz'

module modRolesSubscriptionOwnerRole 'definitions/caf-subscription-owner-role.bicep' = {
  name: 'deploy-subscription-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesApplicationOwnerRole 'definitions/caf-application-owner-role.bicep' = {
  name: 'deploy-application-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesNetworkManagementRole 'definitions/china/mc-caf-network-management-role.bicep' = {
  name: 'deploy-network-management-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesSecurityOperationsRole 'definitions/china/mc-caf-security-operations-role.bicep' = {
  name: 'deploy-security-operations-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

output outRolesSubscriptionOwnerRoleId string = modRolesSubscriptionOwnerRole.outputs.outRoleDefinitionId
output outRolesApplicationOwnerRoleId string = modRolesApplicationOwnerRole.outputs.outRoleDefinitionId
output outRolesNetworkManagementRoleId string = modRolesNetworkManagementRole.outputs.outRoleDefinitionId
output outRolesSecurityOperationsRoleId string = modRolesSecurityOperationsRole.outputs.outRoleDefinitionId
