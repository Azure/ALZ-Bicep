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
3ae59bd5b6ad9335584d17481b1e982f760d8105

42d9be90e4c35be3774b5d12c5841629300d00c1
