targetScope = 'resourceGroup'

@description('Azure region to deploy to')
param region string

@description('Azure region naming prefix')
param regionNamePrefix string

@description('CIDR block for VWAN Hub')
param vwanHubCIDR string

@description('VWAN Resoruce ID')
param vwanRID string

@description('Resource ID of Spoke VNET')
param spokeVNetRID string

resource vwanHub 'Microsoft.Network/virtualHubs@2021-02-01' = {
  name: 'vwan-hub-${regionNamePrefix}'
  location: region
  properties: {
    addressPrefix: vwanHubCIDR
    virtualWan: {
      id: vwanRID
    }
  }
}

resource vwanHubVPNGW 'Microsoft.Network/vpnGateways@2021-02-01' = {
  name: 'vwan-hub-${regionNamePrefix}_S2SvpnGW'
  location: region
  properties: {
    bgpSettings: {
      asn: 65515
    }
    vpnGatewayScaleUnit: 1
    virtualHub: {
      id: vwanHub.id
    }
  }
}

resource vwanSpokeVNetConnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-02-01' = {
  parent: vwanHub
  name: 'vnet-${regionNamePrefix}-spoke-connection'
  properties: {
    remoteVirtualNetwork: {
      id: spokeVNetRID
    }
    allowHubToRemoteVnetTransit: true
    allowRemoteVnetToUseHubVnetGateways: true
    enableInternetSecurity: true
  }
  dependsOn: [
    vwanHubVPNGW
  ]
}
