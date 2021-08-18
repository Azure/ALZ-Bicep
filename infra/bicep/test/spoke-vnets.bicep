targetScope = 'resourceGroup'

@description('Azure region to deploy to')
param region string

@description('Azure region naming prefix')
param regionNamePrefix string

@description('CIDR block for VNET - array')
param vnetCIDR array

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet-${regionNamePrefix}-spoke'
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: vnetCIDR
    }
    enableDdosProtection: false
  }
}

output vnetRID string = vnet.id
