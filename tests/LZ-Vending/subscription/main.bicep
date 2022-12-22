targetScope = 'managementGroup'

param subscriptionBillingScope string
param subscriptionDisplayName string

module sub003 'br/public:lz/sub-vending:1.2.1' = {
  name: 'sub-bicep-lz-vending'
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionDisplayName: subscriptionDisplayName
  }
}
