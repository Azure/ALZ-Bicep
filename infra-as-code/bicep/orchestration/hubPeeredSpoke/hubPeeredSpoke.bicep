targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Orchestration - Hub Peered Spoke'
metadata description = 'Orchestration module used to create and configure a spoke network to deliver the Azure Landing Zone Hub & Spoke architecture'

// **Parameters**
// Generic Parameters - Used in multiple modules
@sys.description('The region to deploy all resources into.')
param parLocation string = deployment().location

@sys.description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('Subscription Id to the Virtual Network Hub object. Default: Empty String')
param parPeeredVnetSubscriptionId string = ''

@sys.description('Array of Tags to be applied to all resources in module. Default: Empty Object')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Subscription Module Parameters
@sys.description('The Management Group Id to place the subscription in. Default: Empty String')
param parPeeredVnetSubscriptionMgPlacement string = ''

// Resource Group Module Parameters
@sys.description('Name of Resource Group to be created to contain spoke networking resources like the virtual network.')
param parResourceGroupNameForSpokeNetworking string = '${parTopLevelManagementGroupPrefix}-${parLocation}-spoke-networking'

// Spoke Networking Module Parameters
@sys.description('Existing DDoS Protection plan to utilize. Default: Empty string')
param parDdosProtectionPlanId string = ''

@sys.description('The Resource IDs of the Private DNS Zones to associate with spokes. Default: Empty Array')
param parPrivateDnsZoneResourceIds array = []

@sys.description('The Name of the Spoke Virtual Network.')
param parSpokeNetworkName string = 'vnet-spoke'

@sys.description('CIDR for Spoke Network.')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@sys.description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDnsServerIps array = []

@sys.description('IP Address where network traffic should route to. Default: Empty string')
param parNextHopIpAddress string = ''

@sys.description('Switch which allows BGP Route Propogation to be disabled on the route table.')
param parDisableBgpRoutePropagation bool = false

@sys.description('Name of Route table to create for the default route of Hub.')
param parSpokeToHubRouteTableName string = 'rtb-spoke-to-hub'

// Peering Modules Parameters
@sys.description('Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID.')
param parHubVirtualNetworkId string

@sys.description('Switch to enable/disable forwarded Traffic from outside spoke network.')
param parAllowSpokeForwardedTraffic bool = false

@sys.description('Switch to enable/disable VPN Gateway for the hub network peering.')
param parAllowHubVpnGatewayTransit bool = false

// VWAN Module Parameters

@sys.description('Optional Virtual Hub Connection Name Prefix.')
param parVirtualHubConnectionPrefix string = ''

@sys.description('Optional Virtual Hub Connection Name Suffix. Example: -vhc')
param parVirtualHubConnectionSuffix string = '-vhc'

@sys.description('Enable Internet Security for the Virtual Hub Connection.')
param parEnableInternetSecurity bool = false

// **Variables**
// Customer Usage Attribution Id
var varCuaid = '8ea6f19a-d698-4c00-9afb-5c92d4766fd2'

// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  baseSuffixManagementGroup: '${parLocation}-${uniqueString(parLocation, parTopLevelManagementGroupPrefix)}-mg'
  baseSuffixSubscription: '${parLocation}-${uniqueString(parLocation, parTopLevelManagementGroupPrefix)}-sub'
  baseSuffixResourceGroup: '${parLocation}-${uniqueString(parLocation, parTopLevelManagementGroupPrefix)}-rg'
}

var varModuleDeploymentNames = {
  modSubscriptionPlacement: take('${varDeploymentNameWrappers.basePrefix}-modSubscriptionPlacement-${parPeeredVnetSubscriptionMgPlacement}-${varDeploymentNameWrappers.baseSuffixManagementGroup}', 64)
  modResourceGroup: take('${varDeploymentNameWrappers.basePrefix}-modResourceGroup-${varDeploymentNameWrappers.baseSuffixSubscription}', 64)
  modSpokeNetworking: take('${varDeploymentNameWrappers.basePrefix}-modSpokeNetworking-${varDeploymentNameWrappers.baseSuffixResourceGroup}', 61)
  modSpokePeeringToHub: take('${varDeploymentNameWrappers.basePrefix}-modVnetPeering-ToHub-${varDeploymentNameWrappers.baseSuffixResourceGroup}', 61)
  modSpokePeeringFromHub: take('${varDeploymentNameWrappers.basePrefix}-modVnetPeering-FromHub-${varDeploymentNameWrappers.baseSuffixResourceGroup}', 61)
  modVnetPeeringVwan: take('${varDeploymentNameWrappers.basePrefix}-modVnetPeeringVwan-${varDeploymentNameWrappers.baseSuffixResourceGroup}', 61)
  modPrivateDnsZoneLinkToSpoke: take('${varDeploymentNameWrappers.basePrefix}-modPDnsLinkToSpoke-${varDeploymentNameWrappers.baseSuffixResourceGroup}', 61)
}

var varHubVirtualNetworkName = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[8] : '')

var varHubVirtualNetworkResourceGroup = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[4] : '')

var varHubVirtualNetworkSubscriptionId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[2] : '')

var varNextHopIPAddress = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? parNextHopIpAddress : '')

var varVirtualHubResourceId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? parHubVirtualNetworkId : '')

var varVirtualHubResourceGroup = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? split(parHubVirtualNetworkId, '/')[4] : '')

var varVirtualHubSubscriptionId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? split(parHubVirtualNetworkId, '/')[2] : '')

// **Modules**
// Module - Customer Usage Attribution - Telemetry
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  scope: managementGroup('${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}')
  name: 'pid-${varCuaid}-${uniqueString(parLocation, parPeeredVnetSubscriptionId)}'
  params: {}
}

// Module - Subscription Placement - Management
module modSubscriptionPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPeeredVnetSubscriptionMgPlacement)) {
  scope: managementGroup('${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}')
  name: varModuleDeploymentNames.modSubscriptionPlacement
  params: {
    parTargetManagementGroupId: parPeeredVnetSubscriptionMgPlacement
    parSubscriptionIds: [
      parPeeredVnetSubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Resource Group
module modResourceGroup '../../modules/resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parPeeredVnetSubscriptionId)
  name: varModuleDeploymentNames.modResourceGroup
  params: {
    parLocation: parLocation
    parResourceGroupName: parResourceGroupNameForSpokeNetworking
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Spoke Virtual Network
module modSpokeNetworking '../../modules/spokeNetworking/spokeNetworking.bicep' = {
  scope: resourceGroup(parPeeredVnetSubscriptionId, parResourceGroupNameForSpokeNetworking)
  name: varModuleDeploymentNames.modSpokeNetworking
  dependsOn: [
    modResourceGroup
  ]
  params: {
    parSpokeNetworkName: parSpokeNetworkName
    parSpokeNetworkAddressPrefix: parSpokeNetworkAddressPrefix
    parDdosProtectionPlanId: parDdosProtectionPlanId
    parDnsServerIps: parDnsServerIps
    parNextHopIpAddress: varNextHopIPAddress
    parSpokeToHubRouteTableName: parSpokeToHubRouteTableName
    parDisableBgpRoutePropagation: parDisableBgpRoutePropagation
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
    parLocation: parLocation
  }
}

// Module - Private DNS Zone Virtual Network Link to Spoke
module modPrivateDnsZoneLinkToSpoke '../../modules/privateDnsZoneLinks/privateDnsZoneLinks.bicep' = [for zone in parPrivateDnsZoneResourceIds: if (!empty(parPrivateDnsZoneResourceIds)) {
  scope: resourceGroup(split(zone, '/')[2], split(zone, '/')[4])
  name: take('${varModuleDeploymentNames.modPrivateDnsZoneLinkToSpoke}-${uniqueString(zone)}', 64)
  params: {
    parPrivateDnsZoneResourceId: zone
    parSpokeVirtualNetworkResourceId: modSpokeNetworking.outputs.outSpokeVirtualNetworkId
  }
}]

// Module - Hub to Spoke peering.
module modHubPeeringToSpoke '../../modules/vnetPeering/vnetPeering.bicep' = if (!empty(varHubVirtualNetworkName)) {
  scope: resourceGroup(varHubVirtualNetworkSubscriptionId, varHubVirtualNetworkResourceGroup)
  name: varModuleDeploymentNames.modSpokePeeringFromHub
  params: {
    parDestinationVirtualNetworkId: (!empty(varHubVirtualNetworkName) ? modSpokeNetworking.outputs.outSpokeVirtualNetworkId : '')
    parDestinationVirtualNetworkName: (!empty(varHubVirtualNetworkName) ? modSpokeNetworking.outputs.outSpokeVirtualNetworkName : '')
    parSourceVirtualNetworkName: varHubVirtualNetworkName
    parAllowForwardedTraffic: parAllowSpokeForwardedTraffic
    parAllowGatewayTransit: parAllowHubVpnGatewayTransit
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Spoke to Hub peering.
module modSpokePeeringToHub '../../modules/vnetPeering/vnetPeering.bicep' = if (!empty(varHubVirtualNetworkName)) {
  scope: resourceGroup(parPeeredVnetSubscriptionId, parResourceGroupNameForSpokeNetworking)
  name: varModuleDeploymentNames.modSpokePeeringToHub
  params: {
    parDestinationVirtualNetworkId: parHubVirtualNetworkId
    parDestinationVirtualNetworkName: varHubVirtualNetworkName
    parSourceVirtualNetworkName: (!empty(varHubVirtualNetworkName) ? modSpokeNetworking.outputs.outSpokeVirtualNetworkName : '')
    parUseRemoteGateways: parAllowHubVpnGatewayTransit
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module -  Spoke to Azure Virtual WAN Hub peering.
module modhubVirtualNetworkConnection '../../modules/vnetPeeringVwan/hubVirtualNetworkConnection.bicep' = if (!empty(varVirtualHubResourceId)) {
  scope: resourceGroup(varVirtualHubSubscriptionId, varVirtualHubResourceGroup)
  name: varModuleDeploymentNames.modVnetPeeringVwan
  params: {
    parVirtualWanHubResourceId: varVirtualHubResourceId
    parRemoteVirtualNetworkResourceId: modSpokeNetworking.outputs.outSpokeVirtualNetworkId
    parVirtualHubConnectionPrefix: parVirtualHubConnectionPrefix
    parVirtualHubConnectionSuffix: parVirtualHubConnectionSuffix
    parEnableInternetSecurity: parEnableInternetSecurity
  }
}

output outSpokeVirtualNetworkName string = modSpokeNetworking.outputs.outSpokeVirtualNetworkName
output outSpokeVirtualNetworkId string = modSpokeNetworking.outputs.outSpokeVirtualNetworkId
