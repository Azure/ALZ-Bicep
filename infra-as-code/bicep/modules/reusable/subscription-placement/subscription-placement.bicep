/*
SUMMARY: Move one or more subscriptions to a new management group.
DESCRIPTION:
  Move one or more subscriptions to a new management group.
  
  Once the subscription(s) are moved, Azure Policies assigned to the new management group or it's parent management group(s) will begin to govern the subscription(s).

AUTHOR/S: SenthuranSivananthan
VERSION: 1.0.0
*/
targetScope = 'managementGroup'

@description('Array of Subscription Ids that should be moved to the new management group.')
param parSubscriptionIds array = []

@description('Target management group for the subscription.  This management group must exist.')
param parTargetManagementGroupId string

resource resSubscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = [for parSubscriptionId in parSubscriptionIds: {
  scope: tenant()
  name: '${parTargetManagementGroupId}/${parSubscriptionId}'
}]
