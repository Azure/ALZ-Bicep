targetScope = 'managementGroup'

// **Parameters**
// Generic Parameters - Used in multiple modules
@description('The region to deploy all resoruces into. DEFAULTS TO deployment().location')
param parLocation string = deployment().location

@description('Prefix for the management group hierarchy. DEFAULTS TO = alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Subscription Id to the Virtual Network Hub object. DEFAULTS TO empty')
param parPeeredVnetSubscriptionId string = ''

@description('Array of Tags to be applied to all resources in module. Default: empty array')
param parTags object = {}

@description('Set Parameter to true to Opt-out of deployment telemetry DEFAULTS TO = false')
param parTelemetryOptOut bool = false

// Subscription Module Parameters
@description('The Management Group Id to place the subscription in. DEFAULTS TO empty')
param parPeeredVnetSubscriptionMgPlacement string = ''

// Resource Group Module Parameters
@description('Name of Resource Group to be created to contain spoke networking resources like the virtual network.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-spoke-networking')
param parResourceGroupNameForSpokeNetworking string = '${parTopLevelManagementGroupPrefix}-${parLocation}-spoke-networking'

// Spoke Networking Module Parameters
@description('Existing DDoS Protection plan to utilize. Default: Empty string')
param parDdosProtectionPlanId string = ''

@description('The Name of the Spoke Virtual Network. Default: vnet-spoke')
param parSpokeNetworkName string = 'vnet-spoke'

@description('CIDR for Spoke Network. Default: 10.11.0.0/16')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDnsServerIps  array = []

@description('IP Address where network traffic should route to. Default: Empty string')
param parNextHopIpAddress string = ''

@description('Switch which allows BGP Route Propogation to be disabled on the route table')
param parDisableBgpRoutePropagation bool = false

@description('Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub')
param parSpokeToHubRouteTableName string = 'rtb-spoke-to-hub'

// Peering Modules Parameters
@description('Virtual Network ID of Hub Virtual Network, or Azure Virtuel WAN hub ID. No default')
param parHubVirtualNetworkId string

@description('Switch to enable/disable forwarded Traffic from outside spoke network. Default = false')
param parAllowSpokeForwardedTraffic bool = false

@description('Switch to enable/disable VPN Gateway for the hub network peering. Default = false')
param parAllowHubVpnGatewayTransit bool = false

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
}

var varHubVirtualNetworkName = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[8] : '' )

var varHubVirtualNetworkResourceGroup = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[4] : '' )

var varHubVirtualNetworkSubscriptionId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? split(parHubVirtualNetworkId, '/')[2] : '' )

var varNextHopIPAddress = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualNetworks/') ? parNextHopIpAddress : '' )

var varVirtualHubResourceId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? parHubVirtualNetworkId : '' )

var varVirtualHubResourceGroup = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? split(parHubVirtualNetworkId, '/')[4] : '' )

var varVirtualHubSubscriptionId = (!empty(parHubVirtualNetworkId) && contains(parHubVirtualNetworkId, '/providers/Microsoft.Network/virtualHubs/') ? split(parHubVirtualNetworkId, '/')[2] : '' )

// **Modules**
// Module - Customer Usage Attribution - Telemtry
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: 'pid-${varCuaid}-${uniqueString(parLocation, parPeeredVnetSubscriptionId)}'
  params: {}
}

// Module - Subscription Placement - Management
module modSubscriptionPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parPeeredVnetSubscriptionMgPlacement)) {
  scope: managementGroup(parTopLevelManagementGroupPrefix)
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
  scope: resourceGroup(parPeeredVnetSubscriptionId,parResourceGroupNameForSpokeNetworking)
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

// Module - Hub to Spoke peering.
module modHubPeeringToSpoke '../../modules/vnetPeering/vnetPeering.bicep' = if (!empty(varHubVirtualNetworkName)) {
  scope: resourceGroup(varHubVirtualNetworkSubscriptionId,varHubVirtualNetworkResourceGroup)
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
  scope: resourceGroup(parPeeredVnetSubscriptionId,parResourceGroupNameForSpokeNetworking)
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
  }
}

output outSpokeVirtualNetworkName string = modSpokeNetworking.outputs.outSpokeVirtualNetworkName
output outSpokeVirtualNetworkId string = modSpokeNetworking.outputs.outSpokeVirtualNetworkId
