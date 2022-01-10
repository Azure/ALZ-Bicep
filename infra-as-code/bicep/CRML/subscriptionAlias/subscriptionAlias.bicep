/*
SUMMARY: The Subscription Alias module deploys an EA, MCA or MPA Subscription into the tenants default Management Group
DESCRIPTION:  The Subscription Alias module deploys an EA, MCA or MPA Subscription into the tenants default Management Group as per the docs here: https://docs.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription
AUTHOR/S: jtracey93
VERSION: 1.0.0
*/

targetScope = 'tenant'

@description('Name of the subscription to be created. Will also be used as the alias name. Whilst you can use any name you like we recommend it to be: all lowercase, no spaces, alphanumeric and hyphens only.')
param parSubscriptionName string

@description('The full resource ID of billing scope associated to the EA, MCA or MPA account you wish to create the subscription in.')
param parSubscriptionBillingScope string

@allowed([
  'DevTest'
  'Production'
])
@description('The offer type of the EA, MCA or MPA subscription to be created. Defaults to = Production')
param parSubscriptionOfferType string = 'Production'

resource resSubscription 'Microsoft.Subscription/aliases@2019-10-01-preview' = {
  name: parSubscriptionName
  properties: {
    displayName: parSubscriptionName
    billingScope: parSubscriptionBillingScope
    workload: parSubscriptionOfferType
  }
}

output outSubscriptionName string = resSubscription.name
output outSubscriptionId string = resSubscription.properties.subscriptionId
