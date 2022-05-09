@description('Region in which the resource group was created. Default: {resourceGroup().location}')
param parLocation string = resourceGroup().location

@description('Prefix value which will be prepended to all resource names. Default: alz')
param parCompanyPrefix string = 'alz'

@description('The IP address range in CIDR notation for the vWAN virtual Hub to use. Default: 10.100.0.0/23')
param parVirtualHubAddressPrefix string = '10.100.0.0/23'

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parAzureFirewallTier string = 'Standard'

@description('Switch which allows Virtual Hub. Default: true')
param parVirtualHubEnabled bool = true

@description('Switch which allows VPN Gateway. Default: false')
param parVpnGatewayEnabled bool = true

@description('Switch which allows ExpressRoute Gateway. Default: false')
param parExpressRouteGatewayEnabled bool = true

@description('Switch which allows Azure Firewall deployment to be disabled. Default: false')
param parAzureFirewallEnabled bool = true

@description('Switch which enables DNS proxy for Azure Firewall policies. Default: false')
param parNetworkDnsEnableProxy bool = true

@description('Prefix Used for Virtual WAN. Default: {parCompanyPrefix}-vwan-{parLocation}')
param parVirtualWanName string = '${parCompanyPrefix}-vwan-${parLocation}'

@description('Prefix Used for Virtual Hub. Default: {parCompanyPrefix}-hub-{parLocation}')
param parVirtualHubName string = '${parCompanyPrefix}-vhub-${parLocation}'

@description('Prefix Used for VPN Gateway. Default: {parCompanyPrefix}-vpngw-{parLocation}')
param parVpnGatewayName string = '${parCompanyPrefix}-vpngw-${parLocation}'

@description('Prefix Used for ExpressRoute Gateway. Default: {parCompanyPrefix}-ergw-{parLocation}')
param parExpressRouteGatewayName string = '${parCompanyPrefix}-ergw-${parLocation}'

@description('Azure Firewall Name. Default: {parCompanyPrefix}-fw-{parLocation}')
param parAzureFirewallName string = '${parCompanyPrefix}-fw-${parLocation}'

@allowed([
  '1'
  '2'
  '3'
])
@description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzureFirewallAvailabilityZones array = []

@description('Azure Firewall Policies Name. Default: {parCompanyPrefix}-fwpol-{parLocation}')
param parFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

@description('The scale unit for this VPN Gateway: Default: 1')
param parVpnGatewayScaleUnit int = 1

@description('The scale unit for this ExpressRoute Gateway: Default: 1')
param parExpressRouteGatewayScaleUnit int = 1

@description('Switch which allows DDOS deployment to be disabled. Default: true')
param parDdosEnabled bool = true

@description('DDOS Plan Name. Default: {parCompanyPrefix}-ddos-plan')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

@description('Switch which allows and deploys Private DNS Zones. Default: true')
param parPrivateDnsZonesEnabled bool = true

@description('Resource Group Name for Private DNS Zones. Default: same resource group')
param parPrivateDnsZonesResourceGroup string = resourceGroup().name

@description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones')
param parPrivateDnsZones array = [
  'privatelink.azure-automation.net'
  'privatelink.database.windows.net'
  'privatelink.sql.azuresynapse.net'
  'privatelink.dev.azuresynapse.net'
  'privatelink.azuresynapse.net'
  'privatelink.blob.core.windows.net'
  'privatelink.table.core.windows.net'
  'privatelink.queue.core.windows.net'
  'privatelink.file.core.windows.net'
  'privatelink.web.core.windows.net'
  'privatelink.dfs.core.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.table.cosmos.azure.com'
  'privatelink.${parLocation}.batch.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.mariadb.database.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.managedhsm.azure.net'
  'privatelink.${parLocation}.azmk8s.io'
  'privatelink.${parLocation}.backup.windowsazure.com'
  'privatelink.siterecovery.windowsazure.com'
  'privatelink.servicebus.windows.net'
  'privatelink.azure-devices.net'
  'privatelink.eventgrid.azure.net'
  'privatelink.azurewebsites.net'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.service.signalr.net'
  'privatelink.monitor.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.afs.azure.net'
  'privatelink.datafactory.azure.net'
  'privatelink.adf.azure.com'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.azconfig.io'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.azurecr.io'
  'privatelink.search.windows.net'
  'privatelink.azurehdinsight.net'
  'privatelink.media.azure.net'
  'privatelink.his.arc.azure.com'
  'privatelink.guestconfiguration.azure.com'
]

@description('Resource ID of VNet for Private DNS Zone VNet Links')
param parVirtualNetworkIdToLink string = ''

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7f94f23b-7a59-4a5c-9a8d-2a253a566f61'

// Virtual WAN resource
resource resVwan 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: parVirtualWanName
  location: parLocation
  tags: parTags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    type: 'Standard'
  }
}

resource resVhub 'Microsoft.Network/virtualHubs@2021-05-01' = if (parVirtualHubEnabled && !empty(parVirtualHubAddressPrefix)) {
  name: parVirtualHubName
  location: parLocation
  tags: parTags
  properties: {
    addressPrefix: parVirtualHubAddressPrefix
    sku: 'Standard'
    virtualWan: {
      id: resVwan.id
    }
  }
}

resource resVhubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2021-05-01' = if (parVirtualHubEnabled && parAzureFirewallEnabled) {
  parent: resVhub
  name: 'defaultRouteTable'
  properties: {
    labels: [
      'default'
    ]
    routes: [
      {
        name: 'default-to-azfw'
        destinations: [
          '0.0.0.0/0'
        ]
        destinationType: 'CIDR'
        nextHop: (parVirtualHubEnabled && parAzureFirewallEnabled) ? resAzureFirewall.id : ''
        nextHopType: 'ResourceID'
      }
    ]
  }
}

resource resVpnGateway 'Microsoft.Network/vpnGateways@2021-05-01' = if (parVirtualHubEnabled && parVpnGatewayEnabled) {
  name: parVpnGatewayName
  location: parLocation
  tags: parTags
  properties: {
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
    virtualHub: {
      id: resVhub.id
    }
    vpnGatewayScaleUnit: parVpnGatewayScaleUnit
  }
}

resource resErGateway 'Microsoft.Network/expressRouteGateways@2021-05-01' = if (parVirtualHubEnabled && parExpressRouteGatewayEnabled) {
  name: parExpressRouteGatewayName
  location: parLocation
  tags: parTags
  properties: {
    virtualHub: {
      id: resVhub.id
    }
    autoScaleConfiguration: {
      bounds: {
        min: parExpressRouteGatewayScaleUnit
      }
    }
  }
}

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2021-05-01' = if (parVirtualHubEnabled && parAzureFirewallEnabled) {
  name: parFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: {
    dnsSettings: {
      enableProxy: parNetworkDnsEnableProxy
    }
    sku: {
      tier: parAzureFirewallTier
    }
  }
}

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2021-02-01' = if (parVirtualHubEnabled && parAzureFirewallEnabled) {
  name: parAzureFirewallName
  location: parLocation
  tags: parTags
  zones: (!empty(parAzureFirewallAvailabilityZones) ? parAzureFirewallAvailabilityZones : json('null'))
  properties: {
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    sku: {
      name: 'AZFW_Hub'
      tier: parAzureFirewallTier
    }
    virtualHub: {
      id: parVirtualHubEnabled ? resVhub.id : ''
    }
    additionalProperties: {
      'Network.DNS.EnableProxy': '${parNetworkDnsEnableProxy}'
    }
    firewallPolicy: {
      id: (parVirtualHubEnabled && parAzureFirewallEnabled) ? resFirewallPolicies.id : ''
    }
  }
}

// DDoS plan is deployed even though not supported to attach to Virtual WAN today as per https://docs.microsoft.com/azure/firewall-manager/overview#known-issues - However, it can still be linked via policy to spoke VNets etc.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-02-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

// Private DNS Zones cannot be linked to the Virtual WAN Hub today however, they can be linked to spokes as they are normal VNets as per https://docs.microsoft.com/azure/virtual-wan/howto-private-link
module modPrivateDnsZones '../privateDnsZones/privateDnsZones.bicep' = if (parPrivateDnsZonesEnabled) {
  name: 'deploy-Private-DNS-Zones'
  scope: resourceGroup(parPrivateDnsZonesResourceGroup)
  params: {
    parLocation: parLocation
    parTags: parTags
    parVirtualNetworkIdToLink: parVirtualNetworkIdToLink
    parPrivateDnsZones: parPrivateDnsZones
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(parLocation)}'
  params: {}
}

// Output Virtual WAN name and ID
output outVirtualWanName string = resVwan.name
output outVirtualWanId string = resVwan.id

// Output Virtual Hub name and ID
output outVirtualHubName string = resVhub.name
output outVirtualHubId string = resVhub.id

// Output DDoS Plan ID
output outDdosPlanResourceId string = resDdosProtectionPlan.id

// Output Private DNS Zones
output outPrivateDnsZones array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZones : [])
