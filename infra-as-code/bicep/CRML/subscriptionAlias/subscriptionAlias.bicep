/*
SUMMARY: The Subscription Alias module deploys an EA, MCA or MPA Subscription into the tenants default Management Group
DESCRIPTION:  The Subscription Alias module deploys an EA, MCA or MPA Subscription into the tenants default Management Group as per the docs here: https://docs.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription
AUTHOR/S: jtracey93, johnlokerse
VERSION: 1.1.0
  - Updated version of the API
  - Added additional properties: parTags, parManagementGroupId, parSubscriptionOwnerId and subscriptionTenantId
*/

targetScope = 'tenant'

metadata name = 'ALZ Bicep CRML - Subscription Alias Module'
metadata description = 'Module to deploy an Azure Subscription into an existing billing scope that can be from an EA, MCA or MPA'

@sys.description('Name of the subscription to be created. Will also be used as the alias name. Whilst you can use any name you like we recommend it to be: all lowercase, no spaces, alphanumeric and hyphens only.')
param parSubscriptionName string

@sys.description('The full resource ID of billing scope associated to the EA, MCA or MPA account you wish to create the subscription in.')
param parSubscriptionBillingScope string

@sys.description('Tags you would like to be applied.')
param parTags object = {}

@sys.description('The ID of the existing management group where the subscription will be placed. Also known as its parent management group. (Optional)')
param parManagementGroupId string = ''

@sys.description('The object ID of a responsible user, AAD group or service principal. (Optional)')
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
  name: parSubscriptionName
  properties: {
    additionalProperties: {
      tags: parTags
      managementGroupId: empty(parManagementGroupId) ? json('null') : managementGroup(parManagementGroupId)
      subscriptionOwnerId: empty(parSubscriptionOwnerId) ? json('null') : parSubscriptionOwnerId
      subscriptionTenantId: parTenantId
    }
    displayName: parSubscriptionName
    billingScope: parSubscriptionBillingScope
    workload: parSubscriptionOfferType
  }
}

output outSubscriptionName string = resSubscription.name
output outSubscriptionId string = resSubscription.properties.subscriptionId
