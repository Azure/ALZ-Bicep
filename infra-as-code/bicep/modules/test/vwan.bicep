targetScope = 'resourceGroup'

@description('Azure region to deploy to')
param region string

@description('Azure region naming prefix')
param regionNamePrefix string

resource vwan 'Microsoft.Network/virtualWans@2021-02-01' = {
  name: 'vwan-${regionNamePrefix}'
  location: region
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    office365LocalBreakoutCategory: 'None'
    type: 'Standard'
  }  
}

output vwanRID string = vwan.id
