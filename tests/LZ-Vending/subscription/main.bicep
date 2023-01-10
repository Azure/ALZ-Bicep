targetScope = 'managementGroup'

param subscriptionBillingScope string
param subscriptionDisplayName string

module subscription 'br/public:lz/sub-vending:1.2.1' = {
  name: subscriptionDisplayName
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionAliasName: subscriptionDisplayName
  }
}
