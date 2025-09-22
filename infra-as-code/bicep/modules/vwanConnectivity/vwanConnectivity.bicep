metadata name = 'ALZ Bicep - Azure vWAN Connectivity Module'
metadata description = 'Module used to set up vWAN Connectivity'

type azFirewallIntelModeType = 'Alert' | 'Deny' | 'Off'

type azFirewallTierType = 'Basic' | 'Standard' | 'Premium'

type azFirewallPolicyDeploymentStyleType = 'SharedGlobal' | 'PerRegion'

type azFirewallAvailabilityZones = ('1' | '2' | '3')[]

type virtualWanOptionsType = ({
  @sys.description('Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.')
  parVpnGatewayEnabled: bool

  @sys.description('Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.')
  parExpressRouteGatewayEnabled: bool

  @sys.description('Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.')
  parAzFirewallEnabled: bool

  @sys.description('The IP address range in CIDR notation for the vWAN virtual Hub to use.')
  parVirtualHubAddressPrefix: string

  @sys.description('The Virtual WAN Hub location.')
  parHubLocation: string

  @sys.description('The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`.')
  parHubRoutingPreference: ('ExpressRoute' | 'VpnGateway' | 'ASPath')

  @sys.description('The Virtual WAN Hub capacity. The value should be between 2 to 50.')
  @minValue(2)
  @maxValue(50)
  parVirtualRouterAutoScaleConfiguration: int

  @sys.description('The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.')
  parVirtualHubRoutingIntentDestinations: ('Internet' | 'PrivateTraffic')[]

  @sys.description('This parameter is used to specify a custom name for the VPN Gateway.')
  parVpnGatewayCustomName: string?

  @sys.description('This parameter is used to specify a custom name for the ExpressRoute Gateway.')
  parExpressRouteGatewayCustomName: string?

  @sys.description('This parameter is used to specify a custom name for the Azure Firewall.')
  parAzFirewallCustomName: string?

  @sys.description('This parameter is used to specify a custom name for the Azure Firewall Policy.')
  parAzFirewallPolicyCustomName: string?

  @sys.description('This parameter is used to specify a custom name for the Virtual WAN Hub.')
  parVirtualWanHubCustomName: string?

  @sys.description('Array of custom DNS servers used by Azure Firewall.')
  parAzFirewallDnsServers: array?

  @sys.description('The Azure Firewall Threat Intelligence Mode.')
  parAzFirewallIntelMode: azFirewallIntelModeType?

  @sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
  parAzFirewallDnsProxyEnabled: bool?

  @sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
  parAzFirewallTier: azFirewallTierType?

  @sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
  parAzFirewallAvailabilityZones: azFirewallAvailabilityZones?

  @sys.description('Configuration of sidecar virtual network for the Virtual WAN Hub.')
  parSidecarVirtualNetwork: sideCarVirtualNetworkType
})[]

type sideCarVirtualNetworkType = {
  @description('The name of the sidecar virtual network.')
  name: string?

  @description('Disable the sidecar virtual network.')
  sidecarVirtualNetworkEnabled: bool

  @description('The address space of the sidecar virtual network.')
  addressPrefixes: string[]

  @description('The location of the sidecar virtual network.')
  location: string?

  @description('The resource ID of the virtual hub to associate with the sidecar virtual network.')
  virtualHubIdOverride: string?

  @description('Flow timeout in minutes for the virtual network.')
  flowTimeoutInMinutes: int?

  @description('Number of IP addresses allocated from the pool. To be used only when the addressPrefix param is defined with a resource ID of an IPAM pool.')
  ipamPoolNumberOfIpAddresses: string?

  @description('Resource lock configuration for the virtual network.')
  lock: lockType?

  @description('Virtual network peerings in addition to the primary VWAN Hub peering connection.')
  vnetPeerings: array?

  @description('Subnets for the virtual network.')
  subnets: array?

  @description('Enable VNet encryption for the virtual network.')
  vnetEncryption: bool?

  @description('If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled.')
  vnetEncryptionEnforcement: 'AllowUnencrypted' | 'DropUnencrypted'?

  @description('Role assignments for the virtual network.')
  roleAssignments: array?

  @description('BGP community for the virtual network.')
  virtualNetworkBgpCommunity: string?

  @description('Diagnostic settings for the virtual network.')
  diagnosticSettings: array?

  @description('DNS servers for the virtual network.')
  dnsServers: array?

  @description('Enable VM protection for the virtual network.')
  enableVmProtection: bool?

  @description('DDoS protection plan resource ID.')
  ddosProtectionPlanResourceIdOverride: string?
}

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('Region in which the resource group was created.')
param parLocation string = resourceGroup().location

@sys.description('Prefix value which will be prepended to all resource names.')
param parCompanyPrefix string = 'alz'

@sys.description('''Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parGlobalResourceLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('Switch to enable/disable Virtual Hub deployment.')
param parVirtualHubEnabled bool = true

@sys.description('Prefix Used for Virtual WAN.')
param parVirtualWanName string = '${parCompanyPrefix}-vwan-${parLocation}'

@description('The type of Virtual WAN to create.')
param parVirtualWanType string = 'Standard'

@sys.description('''Resource Lock Configuration for Virtual WAN.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parVirtualWanLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('Prefix Used for Virtual WAN Hub.')
param parVirtualWanHubName string = '${parCompanyPrefix}-vhub'

@sys.description('The name of the route table that manages routing between the Virtual WAN Hub and the Azure Firewall.')
param parVirtualWanHubDefaultRouteName string = 'default-to-azfw'

@sys.description('''Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `parHubLocation` - The Virtual WAN Hub location.
- `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`.
- `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.
- `parVirtualHubRoutingIntentDestinations` - The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.

''')
param parVirtualWanHubs virtualWanOptionsType = [
  {
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parHubLocation: parLocation
    parHubRoutingPreference: 'ExpressRoute'
    parVirtualRouterAutoScaleConfiguration: 2
    parVirtualHubRoutingIntentDestinations: []
    parAzFirewallDnsProxyEnabled: true
    parAzFirewallDnsServers: []
    parAzFirewallIntelMode: 'Alert'
    parAzFirewallTier: 'Standard'
    parAzFirewallAvailabilityZones: []
    parSidecarVirtualNetwork: {
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: [
        '10.101.0.0/24'
      ]
    }
  }
]

@sys.description('''Resource Lock Configuration for Virtual WAN Hub VPN Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parVpnGatewayLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('''Resource Lock Configuration for Virtual WAN Hub ExpressRoute Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parExpressRouteGatewayLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('''Resource Lock Configuration for Virtual WAN Hub.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parVirtualWanHubsLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('VPN Gateway Name.')
param parVpnGatewayName string = '${parCompanyPrefix}-vpngw'

@sys.description('ExpressRoute Gateway Name.')
param parExpressRouteGatewayName string = '${parCompanyPrefix}-ergw'

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parCompanyPrefix}-fw'

@sys.description('The deployment style of the Azure Firewall Policy. Either one shared firewall policy (`SharedGlobal`) or one policy per region (`PerRegion`), defaults to `SharedGlobal`.')
param parAzFirewallPolicyDeploymentStyle azFirewallPolicyDeploymentStyleType = 'SharedGlobal'

@sys.description('Azure Firewall Policies Name. This is used to automatically generate a name for the Azure Firewall Policy following concat of the pattern `parAzFirewallPoliciesName-hub.parHubLocation` if you want to provide a true custom name then specify a value in each object in the array of `parVirtualWanHubs.parAzFirewallPolicyCustomName`.')
param parAzFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy'

@description('The operation mode for automatically learning private ranges to not be SNAT.')
param parAzFirewallPoliciesAutoLearn string = 'Disabled'
@allowed([
  'Disabled'
  'Enabled'
])
@description('Private IP addresses/IP ranges to which traffic will not be SNAT.')
param parAzFirewallPoliciesPrivateRanges array = []

@sys.description('''Resource Lock Configuration for Azure Firewall.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parAzureFirewallLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('The scale unit for this VPN Gateway.')
param parVpnGatewayScaleUnit int = 1

@sys.description('The scale unit for this ExpressRoute Gateway.')
param parExpressRouteGatewayScaleUnit int = 1

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

@sys.description('''Resource Lock Configuration for DDoS Plan.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parDdosLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('Switch to enable/disable Private DNS Zones deployment.')
param parPrivateDnsZonesEnabled bool = true

@sys.description('Resource Group Name for Private DNS Zones.')
param parPrivateDnsZonesResourceGroup string = resourceGroup().name

@sys.description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones, baked into underlying AVM module see: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones')
param parPrivateDnsZones array = []

@sys.description('Array of Resource IDs of VNets to link to Private DNS Zones.')
param parVirtualNetworkResourceIdsToLinkTo array = []

@sys.description('''Resource Lock Configuration for Private DNS Zone(s).

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parPrivateDNSZonesLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
}

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id Telemetry
var varCuaid = '7f94f23b-7a59-4a5c-9a8d-2a253a566f61'

// ZTN Telemetry
var varZtnP1CuaId = '3ab23b1e-c5c5-42d4-b163-1402384ba2db'
var varZtnP1Trigger = (parDdosEnabled && !(contains(map(parVirtualWanHubs, hub => hub.parAzFirewallEnabled), false)) && (contains(
  map(parVirtualWanHubs, hub => hub.?parAzFirewallTier),
  'Premium'
)))

// Azure Firewalls in Hubs
var varAzureFirewallInHubs = filter(parVirtualWanHubs, hub => hub.parAzFirewallEnabled == true)

var azureFirewallInHubsIndex = [
  for index in varAzureFirewallInHubs: {
    index: indexOf(parVirtualWanHubs, index)
    parHubLocation: index.parHubLocation
  }
]

// Virtual WAN resource
resource resVwan 'Microsoft.Network/virtualWans@2024-05-01' = {
  name: parVirtualWanName
  location: parLocation
  tags: parTags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    type: parVirtualWanType
  }
}

// Create a Virtual WAN resource lock if parGlobalResourceLock.kind is not set to None and if parVirtualWanLock.kind is not set to None
resource resVwanLock 'Microsoft.Authorization/locks@2020-05-01' = if (parGlobalResourceLock.kind != 'None' && parVirtualWanLock.kind != 'None') {
  scope: resVwan
  name: parVirtualWanLock.?name ?? '${resVwan.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualWanLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualWanLock.?notes
  }
}

resource resVhub 'Microsoft.Network/virtualHubs@2024-05-01' = [
  for hub in parVirtualWanHubs: if (parVirtualHubEnabled && !empty(hub.parVirtualHubAddressPrefix)) {
    name: hub.?parVirtualWanHubCustomName ?? '${parVirtualWanHubName}-${hub.parHubLocation}'
    location: hub.parHubLocation
    tags: parTags
    properties: {
      addressPrefix: hub.parVirtualHubAddressPrefix
      sku: 'Standard'
      virtualWan: {
        id: resVwan.id
      }
      virtualRouterAutoScaleConfiguration: {
        minCapacity: hub.parVirtualRouterAutoScaleConfiguration
      }
      hubRoutingPreference: hub.parHubRoutingPreference
    }
  }
]

// Create a Virtual WAN Hub resource lock for each Virtual WAN Hub in parVirtualWanHubs if parGlobalResourceLock.kind is not set to None and if parVirtualWanHubsLock.kind is not set to None
resource resVhubLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (hub, i) in parVirtualWanHubs: if (parGlobalResourceLock.kind != 'None' && parVirtualWanHubsLock.kind != 'None') {
    scope: resVhub[i]
    name: parVirtualWanHubsLock.?name ?? '${resVhub[i].name}-lock'
    properties: {
      level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualWanHubsLock.kind
      notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualWanHubsLock.?notes
    }
  }
]

resource resVhubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if (parVirtualHubEnabled && hub.parAzFirewallEnabled && empty(hub.parVirtualHubRoutingIntentDestinations)) {
    parent: resVhub[i]
    name: 'defaultRouteTable'
    properties: {
      labels: [
        'default'
      ]
      routes: [
        {
          name: parVirtualWanHubDefaultRouteName
          destinations: [
            '0.0.0.0/0'
          ]
          destinationType: 'CIDR'
          nextHop: (parVirtualHubEnabled && hub.parAzFirewallEnabled) ? resAzureFirewall[i].id : ''
          nextHopType: 'ResourceID'
        }
      ]
    }
  }
]

resource resVhubRoutingIntent 'Microsoft.Network/virtualHubs/routingIntent@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if (parVirtualHubEnabled && hub.parAzFirewallEnabled && !empty(hub.parVirtualHubRoutingIntentDestinations)) {
    parent: resVhub[i]
    name: !empty(hub.?parVirtualWanHubCustomName)
      ? '${hub.?parVirtualWanHubCustomName}-Routing-Intent'
      : '${parVirtualWanHubName}-${hub.parHubLocation}-Routing-Intent'
    properties: {
      routingPolicies: [
        for destination in hub.parVirtualHubRoutingIntentDestinations: {
          name: destination == 'Internet' ? 'PublicTraffic' : destination == 'PrivateTraffic' ? 'PrivateTraffic' : 'N/A'
          destinations: [
            destination
          ]
          nextHop: resAzureFirewall[i].id
        }
      ]
    }
  }
]

module modSidecarVirtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = [
  for (hub, i) in parVirtualWanHubs: if (hub.parSidecarVirtualNetwork.sidecarVirtualNetworkEnabled) {
    params: {
      name: hub.parSidecarVirtualNetwork.?name ?? '${parCompanyPrefix}-sidecar-vnet-${hub.parHubLocation}'
      addressPrefixes: hub.parSidecarVirtualNetwork.addressPrefixes
      location: hub.parSidecarVirtualNetwork.?location != null ? hub.parSidecarVirtualNetwork.?location : hub.parHubLocation
      flowTimeoutInMinutes: hub.parSidecarVirtualNetwork.?flowTimeoutInMinutes != null ? hub.parSidecarVirtualNetwork.?flowTimeoutInMinutes : 0
      ipamPoolNumberOfIpAddresses: hub.parSidecarVirtualNetwork.?ipamPoolNumberOfIpAddresses != null ? hub.parSidecarVirtualNetwork.?ipamPoolNumberOfIpAddresses : null
      lock: (parGlobalResourceLock.kind != 'None' || (hub.parSidecarVirtualNetwork.?lock != null && hub.parSidecarVirtualNetwork.?lock.?kind != 'None')) ? {
        name: hub.parSidecarVirtualNetwork.?lock.?name ?? 'pl-sidecar-vnet-lock'
        kind: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : hub.parSidecarVirtualNetwork.?lock.?kind
        notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : hub.parSidecarVirtualNetwork.?lock.?notes ?? 'This lock was created by the ALZ Bicep vWAN Connectivity Module.'
      } : null
      peerings: hub.parSidecarVirtualNetwork.?vnetPeerings != null ? hub.parSidecarVirtualNetwork.?vnetPeerings : []
      subnets: hub.parSidecarVirtualNetwork.?subnets != null ? hub.parSidecarVirtualNetwork.?subnets : []
      vnetEncryption: hub.parSidecarVirtualNetwork.?vnetEncryption != null ? hub.parSidecarVirtualNetwork.?vnetEncryption : null
      vnetEncryptionEnforcement: hub.parSidecarVirtualNetwork.?vnetEncryptionEnforcement != null ? hub.parSidecarVirtualNetwork.?vnetEncryptionEnforcement : null
      roleAssignments: hub.parSidecarVirtualNetwork.?roleAssignments
      virtualNetworkBgpCommunity: hub.parSidecarVirtualNetwork.?virtualNetworkBgpCommunity != null ? hub.parSidecarVirtualNetwork.?virtualNetworkBgpCommunity : null
      tags: parTags
      diagnosticSettings: hub.parSidecarVirtualNetwork.?diagnosticSettings != null ? hub.parSidecarVirtualNetwork.?diagnosticSettings : []
      dnsServers: hub.parSidecarVirtualNetwork.?dnsServers != null ? hub.parSidecarVirtualNetwork.?dnsServers : []
      enableVmProtection: hub.parSidecarVirtualNetwork.?enableVmProtection != null ? hub.parSidecarVirtualNetwork.?enableVmProtection : null
      ddosProtectionPlanResourceId: parDdosEnabled ? resDdosProtectionPlan.id : null
      enableTelemetry: parTelemetryOptOut ? false : true
    }
  }
]

module modVnetPeeringVwan '../vnetPeeringVwan/vnetPeeringVwan.bicep' = [
  for (hub, i) in parVirtualWanHubs: if (hub.parSidecarVirtualNetwork.sidecarVirtualNetworkEnabled) {
    name: take('deploy-vnet-peering-vwan-${hub.parSidecarVirtualNetwork.?name}-${hub.parHubLocation}', 64)
    scope: subscription()
    params: {
      parRemoteVirtualNetworkResourceId: modSidecarVirtualNetwork[i].outputs.resourceId
      parVirtualWanHubResourceId: resVhub[0].id
    }
  }
]

resource resVpnGateway 'Microsoft.Network/vpnGateways@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parVpnGatewayEnabled)) {
    dependsOn: resVhub
    name: hub.?parVpnGatewayCustomName ?? '${parVpnGatewayName}-${hub.parHubLocation}'
    location: hub.parHubLocation
    tags: parTags
    properties: {
      bgpSettings: {
        asn: 65515
        bgpPeeringAddress: ''
        peerWeight: 5
      }
      virtualHub: {
        id: resVhub[i].id
      }
      vpnGatewayScaleUnit: parVpnGatewayScaleUnit
    }
  }
]

// Create a Virtual Network Gateway resource lock if gateway.name is not equal to noconfigVpn or noconfigEr and parGlobalResourceLock.kind != 'None' or if parVpnGatewayLock.kind != 'None'
resource resVpnGatewayLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parVpnGatewayEnabled) && (parVpnGatewayLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
    scope: resVpnGateway[i]
    name: parVpnGatewayLock.?name ?? '${resVpnGateway[i].name}-lock'
    properties: {
      level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVpnGatewayLock.kind
      notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVpnGatewayLock.?notes
    }
  }
]

resource resErGateway 'Microsoft.Network/expressRouteGateways@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parExpressRouteGatewayEnabled)) {
    dependsOn: resVhub
    name: hub.?parExpressRouteGatewayCustomName ?? '${parExpressRouteGatewayName}-${hub.parHubLocation}'
    location: hub.parHubLocation
    tags: parTags
    properties: {
      virtualHub: {
        id: resVhub[i].id
      }
      autoScaleConfiguration: {
        bounds: {
          min: parExpressRouteGatewayScaleUnit
        }
      }
    }
  }
]

// Create a Virtual Network Gateway resource lock if gateway.name is not equal to noconfigVpn or noconfigEr and parGlobalResourceLock.kind != 'None' or if parVpnGatewayLock.kind != 'None'
resource resErGatewayLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parExpressRouteGatewayEnabled) && (parExpressRouteGatewayLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
    scope: resErGateway[i]
    name: parExpressRouteGatewayLock.?name ?? '${resErGateway[i].name}-lock'
    properties: {
      level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parExpressRouteGatewayLock.kind
      notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parExpressRouteGatewayLock.?notes
    }
  }
]

// Create Azure Firewall Policy (per region) resources if parAzFirewallEnabled is true and parAzFirewallPolicyDeploymentStyle is set to PerRegion
resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if (parVirtualHubEnabled && parVirtualWanHubs[i].parAzFirewallEnabled && parAzFirewallPolicyDeploymentStyle == 'PerRegion') {
    name: hub.?parAzFirewallPolicyCustomName ?? '${parAzFirewallPoliciesName}-${hub.parHubLocation}'
    location: hub.parHubLocation
    tags: parTags
    properties: (hub.?parAzFirewallTier == 'Basic')
      ? {
          sku: {
            tier: hub.?parAzFirewallTier
          }
          snat: !empty(parAzFirewallPoliciesPrivateRanges)
            ? {
                autoLearnPrivateRanges: parAzFirewallPoliciesAutoLearn
                privateRanges: parAzFirewallPoliciesPrivateRanges
              }
            : null
          threatIntelMode: 'Alert'
        }
      : {
          dnsSettings: {
            enableProxy: hub.?parAzFirewallDnsProxyEnabled
            servers: hub.?parAzFirewallDnsServers
          }
          sku: {
            tier: hub.?parAzFirewallTier
          }
          threatIntelMode: hub.?parAzFirewallIntelMode
        }
  }
]

// Create Azure Firewall Policy resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resFirewallPoliciesLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled && parVirtualWanHubs[i].parAzFirewallEnabled) && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
    scope: resFirewallPolicies[i]
    name: parAzureFirewallLock.?name ?? '${resFirewallPolicies[i].name}-lock'
    properties: {
      level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
      notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
    }
  }
]

// Shared Global Azure Firewall Policy
resource resFirewallPoliciesSharedGlobal 'Microsoft.Network/firewallPolicies@2024-05-01' = if (parVirtualHubEnabled && parVirtualWanHubs[0].parAzFirewallEnabled && parAzFirewallPolicyDeploymentStyle == 'SharedGlobal') {
  name: parVirtualWanHubs[0].?parAzFirewallPolicyCustomName ?? '${parAzFirewallPoliciesName}-${parVirtualWanHubs[0].parHubLocation}'
  location: parVirtualWanHubs[0].parHubLocation
  tags: parTags
  properties: (parVirtualWanHubs[0].?parAzFirewallTier == 'Basic')
    ? {
        sku: {
          tier: parVirtualWanHubs[0].?parAzFirewallTier
        }
        snat: !empty(parAzFirewallPoliciesPrivateRanges)
          ? {
              autoLearnPrivateRanges: parAzFirewallPoliciesAutoLearn
              privateRanges: parAzFirewallPoliciesPrivateRanges
            }
          : null
        threatIntelMode: 'Alert'
      }
    : {
        dnsSettings: {
          enableProxy: parVirtualWanHubs[0].?parAzFirewallDnsProxyEnabled
          servers: parVirtualWanHubs[0].?parAzFirewallDnsServers
        }
        sku: {
          tier: parVirtualWanHubs[0].?parAzFirewallTier
        }
        threatIntelMode: parVirtualWanHubs[0].?parAzFirewallIntelMode
      }
}

// Create Azure Firewall Policy resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resFirewallPoliciesLockSharedGlobal 'Microsoft.Authorization/locks@2020-05-01' = if ((parVirtualHubEnabled && parVirtualWanHubs[0].parAzFirewallEnabled && parAzFirewallPolicyDeploymentStyle == 'SharedGlobal') && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resFirewallPoliciesSharedGlobal
  name: parAzureFirewallLock.?name ?? '${resFirewallPoliciesSharedGlobal.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
  }
}

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parAzFirewallEnabled)) {
    name: hub.?parAzFirewallCustomName ?? '${parAzFirewallName}-${hub.parHubLocation}'
    location: hub.parHubLocation
    tags: parTags
    zones: (!empty(hub.?parAzFirewallAvailabilityZones) ? hub.?parAzFirewallAvailabilityZones : null)
    properties: {
      hubIPAddresses: {
        publicIPs: {
          count: 1
        }
      }
      sku: {
        name: 'AZFW_Hub'
        tier: hub.?parAzFirewallTier
      }
      virtualHub: {
        id: parVirtualHubEnabled ? resVhub[i].id : ''
      }
      firewallPolicy: {
        id: (parVirtualHubEnabled && hub.parAzFirewallEnabled && parAzFirewallPolicyDeploymentStyle == 'SharedGlobal')
          ? resFirewallPoliciesSharedGlobal.id
          : resFirewallPolicies[i].id
      }
    }
  }
]

// Create Azure Firewall resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resAzureFirewallLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (hub, i) in parVirtualWanHubs: if ((parVirtualHubEnabled) && (hub.parAzFirewallEnabled) && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
    scope: resAzureFirewall[i]
    name: parAzureFirewallLock.?name ?? '${resAzureFirewall[i].name}-lock'
    properties: {
      level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
      notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
    }
  }
]

// DDoS plan is deployed even though not supported to attach to Virtual WAN today as per https://docs.microsoft.com/azure/firewall-manager/overview#known-issues - However, it can still be linked via policy to spoke VNets etc.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2024-05-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

// Create resource lock if parDdosEnabled is true and parGlobalResourceLock.kind != 'None' or if parDdosLock.kind != 'None'
resource resDDoSProtectionPlanLock 'Microsoft.Authorization/locks@2020-05-01' = if (parDdosEnabled && (parDdosLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resDdosProtectionPlan
  name: parDdosLock.?name ?? '${resDdosProtectionPlan.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parDdosLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parDdosLock.?notes
  }
}

// Private DNS Zones cannot be linked to the Virtual WAN Hub today however, they can be linked to spokes as they are normal VNets as per https://docs.microsoft.com/azure/virtual-wan/howto-private-link
module modPrivateDnsZonesAVM 'br/public:avm/ptn/network/private-link-private-dns-zones:0.3.0' = if (parPrivateDnsZonesEnabled) {
  name: 'deploy-Private-DNS-Zones-AVM-Single'
  scope: resourceGroup(parPrivateDnsZonesResourceGroup)
  params: {
    location: parLocation
    privateLinkPrivateDnsZones: empty(parPrivateDnsZones) ? null : parPrivateDnsZones
    virtualNetworkResourceIdsToLinkTo: parVirtualNetworkResourceIdsToLinkTo
    enableTelemetry: parTelemetryOptOut ? false : true
    tags: parTags
    lock: {
      name: parPrivateDNSZonesLock.?name ?? 'pl-pdns-zone-lock'
      kind: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parPrivateDNSZonesLock.kind
    }
  }
}

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(parLocation)}'
  params: {}
}

module modCustomerUsageAttributionZtnP1 '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut && varZtnP1Trigger) {
  name: 'pid-${varZtnP1CuaId}-${uniqueString(parLocation)}'
  params: {}
}

// Output Virtual WAN name and ID
output outVirtualWanName string = resVwan.name
output outVirtualWanId string = resVwan.id

// Output Virtual WAN Hub name and ID
output outVirtualHubName array = [
  for (hub, i) in parVirtualWanHubs: {
    virtualhubname: resVhub[i].name
    virtualhubid: resVhub[i].id
  }
]

output outVirtualHubId array = [
  for (hub, i) in parVirtualWanHubs: {
    virtualhubid: resVhub[i].id
  }
]

// Output DDoS Plan ID
output outDdosPlanResourceId string = parDdosEnabled ? resDdosProtectionPlan.id : ''

// Output Private DNS Zones
output outPrivateDnsZones array = (parPrivateDnsZonesEnabled
  ? modPrivateDnsZonesAVM.outputs.combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink
  : [])
output outPrivateDnsZonesNames array = (parPrivateDnsZonesEnabled
  ? map(
      modPrivateDnsZonesAVM.outputs.combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink,
      zone => zone.pdnsZoneName
    )
  : [])

// Output Azure Firewall Private IP's
output outAzFwPrivateIps array = [
  for (hub, i) in azureFirewallInHubsIndex: {
    '${parVirtualWanHubName}-${hub.parHubLocation}': resAzureFirewall[hub.index].properties.hubIPAddresses.privateIPAddress
  }
]
