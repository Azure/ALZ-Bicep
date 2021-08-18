targetScope = 'subscription'

@description('The primary Azure Region - use cli long name')
param primaryRegion string = 'westeurope'

@description('The primary Azure Region naming prefix')
param primaryRegionNamePrefix string = 'weu'

@description('The secondary Azure Region - use cli long name')
param secondaryRegion string = 'northeurope'

@description('The secondary Azure Region naming prefix')
param secondaryRegionNamePrefix string = 'neu'

@description('CIDR block for spoke VNET in primary region - array')
param spokeVNetCIDRPrimaryRegion array = [
  '10.41.0.0/16'
]

@description('VWAN Hub Primary Region CIDR block')
param vwanHubCIDRPrimaryRegion string = '10.40.0.0/16'

@description('CIDR block for spoke VNET in secondary region - array')
param spokeVNetCIDRSecondaryRegion array = [
  '10.51.0.0/16'
]

@description('VWAN Hub Secondary Region CIDR block')
param vwanHubCIDRSecondaryRegion string = '10.50.0.0/16'

resource primaryRSG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rsg-${primaryRegionNamePrefix}-vwan'
  location: primaryRegion
}

resource primaryRSGSpokes 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rsg-${primaryRegionNamePrefix}-spokes'
  location: primaryRegion
}

resource secondaryRSG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rsg-${secondaryRegionNamePrefix}-vwan'
  location: secondaryRegion
}

resource secondaryRSGSpokes 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rsg-${secondaryRegionNamePrefix}-spokes'
  location: secondaryRegion
}

module spokeVNetDeployPrimaryRegion 'spoke-vnets.bicep' = {
  scope: primaryRSGSpokes
  name: 'Deploy-Spoke-VNet-Primary-Region'
  params: {
    region: primaryRegion
    regionNamePrefix: primaryRegionNamePrefix
    vnetCIDR: spokeVNetCIDRPrimaryRegion
  }
}

module spokeVNetDeploySecondaryRegion 'spoke-vnets.bicep' = {
  scope: secondaryRSGSpokes
  name: 'Deploy-Spoke-VNet-Secondary-Region'
  params: {
    region: secondaryRegion
    regionNamePrefix: secondaryRegionNamePrefix
    vnetCIDR: spokeVNetCIDRSecondaryRegion
  }
}

module vwanDeploy 'vwan.bicep' = {
  scope: primaryRSG
  name: 'Deploy-VWAN'
  params: {
    region: primaryRegion
    regionNamePrefix: primaryRegionNamePrefix
  }
}

module vwanHubDeployPrimaryRegion 'vwan-hub.bicep' = {
  scope: primaryRSG
  name: 'Deploy-VWAN-Hub-Primary-Region'
  params: {
    region: primaryRegion
    regionNamePrefix: primaryRegionNamePrefix
    vwanHubCIDR: vwanHubCIDRPrimaryRegion
    vwanRID: vwanDeploy.outputs.vwanRID
    spokeVNetRID: spokeVNetDeployPrimaryRegion.outputs.vnetRID
  }
}

module vwanHubDeploySecondaryRegion 'vwan-hub.bicep' = {
  scope: secondaryRSG
  name: 'Deploy-VWAN-Hub-Secondary-Region'
  params: {
    region: secondaryRegion
    regionNamePrefix: secondaryRegionNamePrefix
    vwanHubCIDR: vwanHubCIDRSecondaryRegion
    vwanRID: vwanDeploy.outputs.vwanRID
    spokeVNetRID: spokeVNetDeploySecondaryRegion.outputs.vnetRID
  }
}


