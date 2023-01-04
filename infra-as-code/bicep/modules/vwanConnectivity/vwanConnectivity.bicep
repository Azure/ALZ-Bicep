metadata name = 'ALZ Bicep - Azure vWAN Connectivity Module'
metadata description = 'Module used to set up vWAN Connectivity'

@sys.description('Region in which the resource group was created.')
param parLocation string = resourceGroup().location

@sys.description('Prefix value which will be prepended to all resource names.')
param parCompanyPrefix string = 'alz'

@sys.description('The IP address range in CIDR notation for the vWAN virtual Hub to use.')
param parVirtualHubAddressPrefix string = '10.100.0.0/23'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@sys.description('Switch to enable/disable Virtual Hub deployment.')
param parVirtualHubEnabled bool = true

@sys.description('Switch to enable/disable VPN Gateway deployment.')
param parVpnGatewayEnabled bool = true

@sys.description('Switch to enable/disable ExpressRoute Gateway deployment.')
param parExpressRouteGatewayEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall deployment.')
param parAzFirewallEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Prefix Used for Virtual WAN.')
param parVirtualWanName string = '${parCompanyPrefix}-vwan-${parLocation}'

@sys.description('Prefix Used for Virtual WAN Hub.')
param parVirtualWanHubName string = '${parCompanyPrefix}-vhub-${parLocation}'

@sys.description('Prefix Used for VPN Gateway.')
param parVpnGatewayName string = '${parCompanyPrefix}-vpngw-${parLocation}'

@sys.description('Prefix Used for ExpressRoute Gateway.')
param parExpressRouteGatewayName string = '${parCompanyPrefix}-ergw-${parLocation}'

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parCompanyPrefix}-fw-${parLocation}'

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

@sys.description('The scale unit for this VPN Gateway.')
param parVpnGatewayScaleUnit int = 1

@sys.description('The scale unit for this ExpressRoute Gateway.')
param parExpressRouteGatewayScaleUnit int = 1

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

@sys.description('Switch to enable/disable Private DNS Zones deployment.')
param parPrivateDnsZonesEnabled bool = true

@sys.description('Resource Group Name for Private DNS Zones.')
param parPrivateDnsZonesResourceGroup string = resourceGroup().name

@sys.description('Array of DNS Zones to provision in Hub Virtual Network.')
param parPrivateDnsZones array = [
  'privatelink.${toLower(parLocation)}.azmk8s.io'
  'privatelink.${toLower(parLocation)}.batch.azure.com'
  'privatelink.${toLower(parLocation)}.kusto.windows.net'
  'privatelink.adf.azure.com'
  'privatelink.afs.azure.net'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.analysis.windows.net'
  'privatelink.api.azureml.ms'
  'privatelink.azconfig.io'
  'privatelink.azure-api.net'
  'privatelink.azure-automation.net'
  'privatelink.azurecr.io'
  'privatelink.azure-devices.net'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.azurehdinsight.net'
  'privatelink.azurehealthcareapis.com'
  'privatelink.azurestaticapps.net'
  'privatelink.azuresynapse.net'
  'privatelink.azurewebsites.net'
  'privatelink.batch.azure.com'
  'privatelink.blob.core.windows.net'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.database.windows.net'
  'privatelink.datafactory.azure.net'
  'privatelink.dev.azuresynapse.net'
  'privatelink.dfs.core.windows.net'
  'privatelink.dicom.azurehealthcareapis.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.directline.botframework.com'
  'privatelink.documents.azure.com'
  'privatelink.eventgrid.azure.net'
  'privatelink.file.core.windows.net'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.guestconfiguration.azure.com'
  'privatelink.his.arc.azure.com'
  'privatelink.kubernetesconfiguration.azure.com'
  'privatelink.managedhsm.azure.net'
  'privatelink.mariadb.database.azure.com'
  'privatelink.media.azure.net'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.monitor.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.notebooks.azure.net'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.pbidedicated.windows.net'
  'privatelink.postgres.database.azure.com'
  'privatelink.prod.migration.windowsazure.com'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.queue.core.windows.net'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.search.windows.net'
  'privatelink.service.signalr.net'
  'privatelink.servicebus.windows.net'
  'privatelink.siterecovery.windowsazure.com'
  'privatelink.sql.azuresynapse.net'
  'privatelink.table.core.windows.net'
  'privatelink.table.cosmos.azure.com'
  'privatelink.tip1.powerquery.microsoft.com'
  'privatelink.token.botframework.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.web.core.windows.net'
  'privatelink.webpubsub.azure.com'
]

@sys.description('Resource ID of VNet for Private DNS Zone VNet Links')
param parVirtualNetworkIdToLink string = ''

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '7f94f23b-7a59-4a5c-9a8d-2a253a566f61'

// Virtual WAN resource
resource resVwan 'Microsoft.Network/virtualWans@2021-08-01' = {
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

resource resVhub 'Microsoft.Network/virtualHubs@2021-08-01' = if (parVirtualHubEnabled && !empty(parVirtualHubAddressPrefix)) {
  name: parVirtualWanHubName
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

resource resVhubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2021-08-01' = if (parVirtualHubEnabled && parAzFirewallEnabled) {
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
        nextHop: (parVirtualHubEnabled && parAzFirewallEnabled) ? resAzureFirewall.id : ''
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

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2022-05-01' = if (parVirtualHubEnabled && parAzFirewallEnabled) {
  name: parAzFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabled
    }
    sku: {
      tier: parAzFirewallTier
    }
  }
}

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2022-05-01' = if (parVirtualHubEnabled && parAzFirewallEnabled) {
  name: parAzFirewallName
  location: parLocation
  tags: parTags
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : json('null'))
  properties: {
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    sku: {
      name: 'AZFW_Hub'
      tier: parAzFirewallTier
    }
    virtualHub: {
      id: parVirtualHubEnabled ? resVhub.id : ''
    }
    firewallPolicy: {
      id: (parVirtualHubEnabled && parAzFirewallEnabled) ? resFirewallPolicies.id : ''
    }
  }
}

// DDoS plan is deployed even though not supported to attach to Virtual WAN today as per https://docs.microsoft.com/azure/firewall-manager/overview#known-issues - However, it can still be linked via policy to spoke VNets etc.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-08-01' = if (parDdosEnabled) {
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

// Output Virtual WAN Hub name and ID
output outVirtualHubName string = resVhub.name
output outVirtualHubId string = resVhub.id

// Output DDoS Plan ID
output outDdosPlanResourceId string = resDdosProtectionPlan.id

// Output Private DNS Zones
output outPrivateDnsZones array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZones : [])
