@description('Prefix value which will be prepended to all resource names. Default: alz')
param parCompanyPrefix string = 'alz'

@description('The IP address range in CIDR notation for the vWAN virtual Hub to use. Default: 10.100.0.0/23')
param parVhubAddressPrefix string = '10.100.0.0/23'

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parAzureFirewallTier string = 'Standard'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Switch which allows Virtual Hub. Default: true')
param parVirtualHubEnabled bool = true

@description('Switch which allows VPN Gateway. Default: false')
param parVPNGatewayEnabled bool = true

@description('Switch which allows ExpressRoute Gateway. Default: false')
param parERGatewayEnabled bool = true

@description('Switch which allows Azure Firewall deployment to be disabled. Default: false')
param parAzureFirewallEnabled bool = true

@description('Switch which enables DNS proxy for Azure Firewall policies. Default: false')
param parNetworkDNSEnableProxy bool = true

@description('Prefix Used for Virtual WAN. Default: {parCompanyPrefix}-vwan-{parLocation}')
param parVWanName string = '${parCompanyPrefix}-vwan-${parLocation}'

@description('Prefix Used for Virtual Hub. Default: {parCompanyPrefix}-hub-{parLocation}')
param parVHubName string = '${parCompanyPrefix}-vhub-${parLocation}'

@description('Prefix Used for VPN Gateway. Default: {parCompanyPrefix}-vpngw-{parLocation}')
param parVPNGwName string = '${parCompanyPrefix}-vpngw-${parLocation}'

@description('Prefix Used for ExpressRoute Gateway. Default: {parCompanyPrefix}-ergw-{parLocation}')
param parERGwName string = '${parCompanyPrefix}-ergw-${parLocation}'

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

@description('Region in which the resource group was created. Default: {resourceGroup().location}')
param parLocation string = resourceGroup().location

@description('The scale unit for this VPN Gateway: Default: 1')
param parVPNGwScaleUnit int = 1

@description('The scale unit for this ExpressRoute Gateway: Default: 1')
param parERGwScaleUnit int = 1

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

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7f94f23b-7a59-4a5c-9a8d-2a253a566f61'

// Virtual WAN resource
resource resVWAN 'Microsoft.Network/virtualWans@2021-05-01' = {
  name: parVWanName
  location: parLocation
  tags: parTags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    type: 'Standard'
  }
}

resource resVHub 'Microsoft.Network/virtualHubs@2021-05-01' = if (parVirtualHubEnabled && !empty(parVhubAddressPrefix)) {
  name: parVHubName
  location: parLocation
  tags: parTags
  properties: {
    addressPrefix: parVhubAddressPrefix
    sku: 'Standard'
    virtualWan: {
      id: resVWAN.id
    }
  }
}

resource resVHubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2021-05-01' = if (parVirtualHubEnabled && parAzureFirewallEnabled) {
  parent: resVHub
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

resource resVPNGateway 'Microsoft.Network/vpnGateways@2021-05-01' = if (parVirtualHubEnabled && parVPNGatewayEnabled) {
  name: parVPNGwName
  location: parLocation
  tags: parTags
  properties: {
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
    virtualHub: {
      id: resVHub.id
    }
    vpnGatewayScaleUnit: parVPNGwScaleUnit
  }
}

resource resERGateway 'Microsoft.Network/expressRouteGateways@2021-05-01' = if (parVirtualHubEnabled && parERGatewayEnabled) {
  name: parERGwName
  location: parLocation
  tags: parTags
  properties: {
    virtualHub: {
      id: resVHub.id
    }
    autoScaleConfiguration: {
      bounds: {
        min: parERGwScaleUnit
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
      enableProxy: parNetworkDNSEnableProxy
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
      id: parVirtualHubEnabled ? resVHub.id : ''
    }
    additionalProperties: {
      'Network.DNS.EnableProxy': '${parNetworkDNSEnableProxy}'
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
output outVirtualWANName string = resVWAN.name
output outVirtualWANID string = resVWAN.id

// Output Virtual Hub name and ID
output outVirtualHubName string = resVHub.name
output outVirtualHubID string = resVHub.id

// Output DDoS Plan ID
output outDdosPlanResourceID string = resDdosProtectionPlan.id

// Output Private DNS Zones
output outPrivateDnsZones array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZones : [])
