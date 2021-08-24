/*
SUMMARY: Defines Custom Roles based on Cloud Adoption Framework for Azure guidance. 
DESCRIPTION:
  Custom roles are based on the following personas:
    * Subscription owner
    * Application owners (DevOps/AppOps)
    * Network management (NetOps)
    * Security operations (SecOps)
  Reference:  https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management
AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/

targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.')
param parAssignableScopeManagementGroupId string = 'alz'

module modSubscriptionOwnerRole 'definitions/caf-subscription-owner-role.bicep' = {
  name: 'deploy-subscription-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modApplicationOwnerRole 'definitions/caf-application-owner-role.bicep' = {
  name: 'deploy-application-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modNetworkManagementRole 'definitions/caf-network-management-role.bicep' = {
  name: 'deploy-network-management-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modSecurityOperationsRole 'definitions/caf-security-operations-role.bicep' = {
  name: 'deploy-security-operations-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

output outSubscriptionOwnerRoleId string = modSubscriptionOwnerRole.outputs.outRoleDefinitionId
output outApplicationOwnerRoleId string = modApplicationOwnerRole.outputs.outRoleDefinitionId
output outNetworkManagementRoleId string = modNetworkManagementRole.outputs.outRoleDefinitionId
output outSecurityOperationsRoleId string = modSecurityOperationsRole.outputs.outRoleDefinitionId
