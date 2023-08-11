metadata name = 'ALZ Bicep - Hub Networking Module'
metadata description = 'ALZ Bicep Module used to set up Hub Networking'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('Prefix value which will be prepended to all resource names.')
param parCompanyPrefix string = 'alz'

@sys.description('Name for Hub Network.')
param parHubNetworkName string = '${parCompanyPrefix}-hub-${parLocation}'

@sys.description('The IP address range for Hub Network.')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@sys.description('The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.')
param parSubnets array = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.10.15.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.10.252.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.10.254.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallManagementSubnet'
    ipAddressRange: '10.10.253.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
]

@sys.description('Array of DNS Server IP addresses for VNet.')
param parDnsServerIps array = []

@sys.description('Public IP Address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIpSku string = 'Standard'

@sys.description('Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-')
param parPublicIpPrefix string = ''

@sys.description('Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix')
param parPublicIpSuffix string = '-PublicIP'

@sys.description('Switch to enable/disable Azure Bastion deployment.')
param parAzBastionEnabled bool = true

@sys.description('Name Associated with Bastion Service.')
param parAzBastionName string = '${parCompanyPrefix}-bastion'

@sys.description('Azure Bastion SKU.')
@allowed([
  'Basic'
  'Standard'
])
param parAzBastionSku string = 'Standard'

@sys.description('Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client')
param parAzBastionTunneling bool = false

@sys.description('Name for Azure Bastion Subnet NSG.')
param parAzBastionNsgName string = 'nsg-AzureBastionSubnet'

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

@sys.description('Switch to enable/disable Azure Firewall deployment.')
param parAzFirewallEnabled bool = true

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parCompanyPrefix}-azfw-${parLocation}'

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.')
param parAzErGatewayAvailabilityZones array = []

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.')
param parAzVpnGatewayAvailabilityZones array = []

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Name of Route table to create for the default route of Hub.')
param parHubRouteTableName string = '${parCompanyPrefix}-hub-routetable'

@sys.description('Switch to enable/disable BGP Propagation on route table.')
param parDisableBgpRoutePropagation bool = false

@sys.description('Switch to enable/disable Private DNS Zones deployment.')
param parPrivateDnsZonesEnabled bool = true

@sys.description('Resource Group Name for Private DNS Zones.')
param parPrivateDnsZonesResourceGroup string = resourceGroup().name

@sys.description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones')
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

@sys.description('Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.')
param parPrivateDnsZoneAutoMergeAzureBackupZone bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@sys.description('''Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
"parVpnGatewayConfig": {
  "value": {}
}''')
param parVpnGatewayConfig object = {
  name: '${parCompanyPrefix}-Vpn-Gateway'
  gatewayType: 'Vpn'
  sku: 'VpnGw1'
  vpnType: 'RouteBased'
  generation: 'Generation1'
  enableBgp: false
  activeActive: false
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  bgpPeeringAddress: ''
  bgpsettings: {
    asn: 65515
    bgpPeeringAddress: ''
    peerWeight: 5
  }
}

@sys.description('''Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
"parExpressRouteGatewayConfig": {
  "value": {}
}''')
param parExpressRouteGatewayConfig object = {
  name: '${parCompanyPrefix}-ExpressRoute-Gateway'
  gatewayType: 'ExpressRoute'
  sku: 'ErGw1AZ'
  vpnType: 'RouteBased'
  vpnGatewayGeneration: 'None'
  enableBgp: false
  activeActive: false
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  bgpPeeringAddress: ''
  bgpsettings: {
    asn: '65515'
    bgpPeeringAddress: ''
    peerWeight: '5'
  }
}

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

@sys.description('Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.')
param parBastionOutboundSshRdpPorts array = [ '22', '3389' ]

var varSubnetMap = map(range(0, length(parSubnets)), i => {
    name: parSubnets[i].name
    ipAddressRange: parSubnets[i].ipAddressRange
    networkSecurityGroupId: contains(parSubnets[i], 'networkSecurityGroupId') ? parSubnets[i].networkSecurityGroupId : ''
    routeTableId: contains(parSubnets[i], 'routeTableId') ? parSubnets[i].routeTableId : ''
    delegation: contains(parSubnets[i], 'delegation') ? parSubnets[i].delegation : ''
  })

var varSubnetProperties = [for subnet in varSubnetMap: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange

    delegations: (empty(subnet.delegation)) ? null : [
      {
        name: subnet.delegation
        properties: {
          serviceName: subnet.delegation
        }
      }
    ]

    networkSecurityGroup: (subnet.name == 'AzureBastionSubnet' && parAzBastionEnabled) ? {
      id: '${resourceGroup().id}/providers/Microsoft.Network/networkSecurityGroups/${parAzBastionNsgName}'
    } : (empty(subnet.networkSecurityGroupId)) ? null : {
      id: subnet.networkSecurityGroupId
    }

    routeTable: (empty(subnet.routeTableId)) ? null : {
      id: subnet.routeTableId
    }
  }
}]

var varVpnGwConfig = ((!empty(parVpnGatewayConfig)) ? parVpnGatewayConfig : json('{"name": "noconfigVpn"}'))

var varErGwConfig = ((!empty(parExpressRouteGatewayConfig)) ? parExpressRouteGatewayConfig : json('{"name": "noconfigEr"}'))

var varGwConfig = [
  varVpnGwConfig
  varErGwConfig
]

// Customer Usage Attribution Id Telemetry
var varCuaid = '2686e846-5fdc-4d4f-b533-16dcb09d6e6c'

// ZTN Telemetry
var varZtnP1CuaId = '3ab23b1e-c5c5-42d4-b163-1402384ba2db'
var varZtnP1Trigger = (parDdosEnabled && parAzFirewallEnabled && (parAzFirewallTier == 'Premium')) ? true : false

//DDos Protection plan will only be enabled if parDdosEnabled is true.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-02-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

resource resHubVnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  dependsOn: [
    resBastionNsg
  ]
  name: parHubNetworkName
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        parHubNetworkAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: parDnsServerIps
    }
    subnets: varSubnetProperties
    enableDdosProtection: parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: resDdosProtectionPlan.id
    } : null
  }
}

module modBastionPublicIp '../publicIp/publicIp.bicep' = if (parAzBastionEnabled) {
  name: 'deploy-Bastion-Public-IP'
  params: {
    parLocation: parLocation
    parPublicIpName: '${parPublicIpPrefix}${parAzBastionName}${parPublicIpSuffix}'
    parPublicIpSku: {
      name: parPublicIpSku
    }
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

resource resBastionSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = {
  parent: resHubVnet
  name: 'AzureBastionSubnet'
}

resource resBastionNsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = if (parAzBastionEnabled) {
  name: parAzBastionNsgName
  location: parLocation
  tags: parTags

  properties: {
    securityRules: [
      // Inbound Rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 130
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 140
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 150
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          access: 'Deny'
          direction: 'Inbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
      // Outbound Rules
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 100
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: parBastionOutboundSshRdpPorts
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 110
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 120
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 130
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// AzureBastionSubnet is required to deploy Bastion service. This subnet must exist in the parsubnets array if you enable Bastion Service.
// There is a minimum subnet requirement of /27 prefix.
// If you are deploying standard this needs to be larger. https://docs.microsoft.com/en-us/azure/bastion/configuration-settings#subnet
resource resBastion 'Microsoft.Network/bastionHosts@2023-02-01' = if (parAzBastionEnabled) {
  location: parLocation
  name: parAzBastionName
  tags: parTags
  sku: {
    name: parAzBastionSku
  }
  properties: {
    dnsName: uniqueString(resourceGroup().id)
    enableTunneling: (parAzBastionSku == 'Standard' && parAzBastionTunneling) ? parAzBastionTunneling : false
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resBastionSubnetRef.id
          }
          publicIPAddress: {
            id: parAzBastionEnabled ? modBastionPublicIp.outputs.outPublicIpId : ''
          }
        }
      }
    ]
  }
}

resource resGatewaySubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = {
  parent: resHubVnet
  name: 'GatewaySubnet'
}

module modGatewayPublicIp '../publicIp/publicIp.bicep' = [for (gateway, i) in varGwConfig: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) {
  name: 'deploy-Gateway-Public-IP-${i}'
  params: {
    parLocation: parLocation
    parAvailabilityZones: gateway.gatewayType == 'ExpressRoute' ? parAzErGatewayAvailabilityZones : gateway.gatewayType == 'Vpn' ? parAzVpnGatewayAvailabilityZones : []
    parPublicIpName: '${parPublicIpPrefix}${gateway.name}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSku
    }
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

//Minumum subnet size is /27 supporting documentation https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsub
resource resGateway 'Microsoft.Network/virtualNetworkGateways@2023-02-01' = [for (gateway, i) in varGwConfig: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) {
  name: gateway.name
  location: parLocation
  tags: parTags
  properties: {
    activeActive: gateway.activeActive
    enableBgp: gateway.enableBgp
    enableBgpRouteTranslationForNat: gateway.enableBgpRouteTranslationForNat
    enableDnsForwarding: gateway.enableDnsForwarding
    bgpSettings: (gateway.enableBgp) ? gateway.bgpSettings : null
    gatewayType: gateway.gatewayType
    vpnGatewayGeneration: (gateway.gatewayType == 'VPN') ? gateway.generation : 'None'
    vpnType: gateway.vpnType
    sku: {
      name: gateway.sku
      tier: gateway.sku
    }
    ipConfigurations: [
      {
        id: resHubVnet.id
        name: 'vnetGatewayConfig'
        properties: {
          publicIPAddress: {
            id: (((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) ? modGatewayPublicIp[i].outputs.outPublicIpId : 'na')
          }
          subnet: {
            id: resGatewaySubnetRef.id
          }
        }
      }
    ]
  }
}]

resource resAzureFirewallSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = {
  parent: resHubVnet
  name: 'AzureFirewallSubnet'
}

resource resAzureFirewallMgmtSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  parent: resHubVnet
  name: 'AzureFirewallManagementSubnet'
}

module modAzureFirewallPublicIp '../publicIp/publicIp.bicep' = if (parAzFirewallEnabled) {
  name: 'deploy-Firewall-Public-IP'
  params: {
    parLocation: parLocation
    parAvailabilityZones: parAzFirewallAvailabilityZones
    parPublicIpName: '${parPublicIpPrefix}${parAzFirewallName}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSku
    }
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modAzureFirewallMgmtPublicIp '../publicIp/publicIp.bicep' = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  name: 'deploy-Firewall-mgmt-Public-IP'
  params: {
    parLocation: parLocation
    parAvailabilityZones: parAzFirewallAvailabilityZones
    parPublicIpName: '${parPublicIpPrefix}${parAzFirewallName}-mgmt${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: 'Standard'
    }
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2023-02-01' = if (parAzFirewallEnabled) {
  name: parAzFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: (parAzFirewallTier == 'Basic') ? {
    sku: {
      tier: parAzFirewallTier
    }
  } : {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabled
    }
    sku: {
      tier: parAzFirewallTier
    }
  }
}

// AzureFirewallSubnet is required to deploy Azure Firewall . This subnet must exist in the parsubnets array if you deploy.
// There is a minimum subnet requirement of /26 prefix.
resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2023-02-01' = if (parAzFirewallEnabled) {
  dependsOn: [
    resGateway
  ]
  name: parAzFirewallName
  location: parLocation
  tags: parTags
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : [])
  properties: parAzFirewallTier == 'Basic' ? {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? modAzureFirewallPublicIp.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    managementIpConfiguration: {
      name: 'mgmtIpConfig'
      properties: {
        publicIPAddress: {
          id: parAzFirewallEnabled ? modAzureFirewallMgmtPublicIp.outputs.outPublicIpId : ''
        }
        subnet: {
          id: resAzureFirewallMgmtSubnetRef.id
        }
      }
    }
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTier
    }
    firewallPolicy: {
      id: resFirewallPolicies.id
    }
  } : {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? modAzureFirewallPublicIp.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTier
    }
    firewallPolicy: {
      id: resFirewallPolicies.id
    }
  }
}

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
resource resHubRouteTable 'Microsoft.Network/routeTables@2023-02-01' = if (parAzFirewallEnabled) {
  name: parHubRouteTableName
  location: parLocation
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-azfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parDisableBgpRoutePropagation
  }
}

module modPrivateDnsZones '../privateDnsZones/privateDnsZones.bicep' = if (parPrivateDnsZonesEnabled) {
  name: 'deploy-Private-DNS-Zones'
  scope: resourceGroup(parPrivateDnsZonesResourceGroup)
  params: {
    parLocation: parLocation
    parTags: parTags
    parVirtualNetworkIdToLink: resHubVnet.id
    parPrivateDnsZones: parPrivateDnsZones
    parPrivateDnsZoneAutoMergeAzureBackupZone: parPrivateDnsZoneAutoMergeAzureBackupZone
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

module modCustomerUsageAttributionZtnP1 '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut && varZtnP1Trigger) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varZtnP1CuaId}-${uniqueString(resourceGroup().location)}'
  params: {}
}

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzFirewallPrivateIp string = parAzFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzFirewallName string = parAzFirewallEnabled ? parAzFirewallName : ''

output outPrivateDnsZones array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZones : [])
output outPrivateDnsZonesNames array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZonesNames : [])

output outDdosPlanResourceId string = resDdosProtectionPlan.id
output outHubVirtualNetworkName string = resHubVnet.name
output outHubVirtualNetworkId string = resHubVnet.id
