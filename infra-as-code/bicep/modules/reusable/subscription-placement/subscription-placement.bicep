/*
SUMMARY: Move a subscription to a new management group.
DESCRIPTION:
  Move a subscription to a new management group.
  
  Once the subscription is moved, Azure Policies assigned to the new management group or it's parent management group(s) will begin to govern the subscription.
AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/
targetScope = 'managementGroup'

@description('Subscription Id that should be moved to a new management group.')
param parSubscriptionId string

@description('Target management group for the subscription.  This management group must exist.')
param parTargetManagementGroupId string

resource resSubscriptionMove 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  scope: tenant()
  name: '${parTargetManagementGroupId}/${parSubscriptionId}'
}
