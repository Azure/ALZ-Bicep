targetScope = 'managementGroup'

metadata name = 'ALZ Bicep CRML - Subscription Alias Module with Scope Escape'
metadata description = 'Module to deploy an Azure Subscription into an existing billing scope that can be from an EA, MCA or MPA, using Scope Escaping feature of ARM to allow deployment not requiring tenant root scope access.'

@sys.description('Name of the subscription to be created. Will also be used as the alias name. Whilst you can use any name you like we recommend it to be: all lowercase, no spaces, alphanumeric and hyphens only.')
param parSubscriptionName string

@sys.description('The full resource ID of billing scope associated to the EA, MCA or MPA account you wish to create the subscription in.')
param parSubscriptionBillingScope string

@sys.description('Tags you would like to be applied.')
param parTags object = {}

@sys.description('The ID of the existing management group where the subscription will be placed. Also known as its parent management group. (Optional)')
param parManagementGroupId string = ''

@sys.description('The object ID of a responsible user, Microsoft Entra group or service principal. (Optional)')
param parSubscriptionOwnerId string = ''

@allowed([
  'DevTest'
  'Production'
])
@sys.description('The offer type of the EA, MCA or MPA subscription to be created. Defaults to = Production')
param parSubscriptionOfferType string = 'Production'

@sys.description('The ID of the tenant. Defaults to = tenant().tenantId')
param parTenantId string = tenant().tenantId

resource resSubscription 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: parSubscriptionName
  properties: {
    additionalProperties: {
      tags: parTags
      managementGroupId: empty(parManagementGroupId) ? null : contains(toLower(parManagementGroupId), toLower('/providers/Microsoft.Management/managementGroups/')) ? parManagementGroupId : '/providers/Microsoft.Management/managementGroups/${parManagementGroupId}'
      subscriptionOwnerId: empty(parSubscriptionOwnerId) ? null : parSubscriptionOwnerId
      subscriptionTenantId: parTenantId
    }
    displayName: parSubscriptionName
    billingScope: parSubscriptionBillingScope
    workload: parSubscriptionOfferType
  }
}

output outSubscriptionName string = resSubscription.name
output outSubscriptionId string = resSubscription.properties.subscriptionId
