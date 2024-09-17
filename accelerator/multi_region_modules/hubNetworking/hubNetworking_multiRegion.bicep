metadata name = 'ALZ Bicep - Hub Networking Module'
metadata description = 'ALZ Bicep Module used to set up Hub Networking'

type subnetOptionsType = ({
  @description('Name of subnet.')
  name: string

  @description('IP-address range for subnet.')
  ipAddressRange: string

  @description('Id of Network Security Group to associate with subnet.')
  networkSecurityGroupId: string?

  @description('Id of Route Table to associate with subnet.')
  routeTableId: string?

  @description('Name of the delegation to create for the subnet.')
  delegation: string?
})[]

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('The secondary Azure Region to deploy the resources into.')
param parSecondaryLocation string = resourceGroup().location

@sys.description('Prefix value which will be prepended to all resource names.')
param parCompanyPrefix string = 'alz'

@sys.description('Name for Hub Network.')
param parHubNetworkName string = '${parCompanyPrefix}-hub-${parLocation}'

@sys.description('Name for Hub Network in the secondary location.')
param parHubNetworkNameSecondaryLocation string = '${parCompanyPrefix}-hub-${parSecondaryLocation}'

@sys.description('''Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parGlobalResourceLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('The IP address range for Hub Network.')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@sys.description('The IP address range for Hub Network in the secondary location.')
param parHubNetworkAddressPrefixSecondaryLocation string = '10.20.0.0/16'

@sys.description('The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.')
param parSubnets subnetOptionsType = [
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

@sys.description('The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks in the secondary location.')
param parSubnetsSecondaryLocation subnetOptionsType = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.20.15.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.20.252.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.20.254.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallManagementSubnet'
    ipAddressRange: '10.20.253.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
]

@sys.description('Array of DNS Server IP addresses for VNet.')
param parDnsServerIps array = []

 @sys.description('Array of DNS Server IP addresses for VNet in the secondary location.')
param parDnsServerIpsSecondaryLocation array = []

@sys.description('''Resource Lock Configuration for Virtual Network.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parVirtualNetworkLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Public IP Address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIpSku string = 'Standard'

@sys.description('Public IP Address SKU in secondary location.')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIpSkuSecondaryLocation string = 'Standard'

@sys.description('Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-')
param parPublicIpPrefix string = ''

@sys.description('Optional Prefix for Public IPs in secondary location. Include a succedent dash if required . Example: prefix-')
param parPublicIpPrefixSecondaryLocation string = ''

@sys.description('Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix')
param parPublicIpSuffix string = '-PublicIP'

@sys.description('Switch to enable/disable Azure Bastion deployment.')
param parAzBastionEnabled bool = true

@sys.description('Switch to enable/disable Azure Bastion deployment in secondary location.')
param parAzBastionEnabledSecondaryLocation bool = true

@sys.description('Name Associated with Bastion Service.')
param parAzBastionName string = '${parCompanyPrefix}-bastion'

@sys.description('Name Associated with Bastion Service in secondary location.')
param parAzBastionNameSecondaryLocation string = '${parCompanyPrefix}-bastion'

@sys.description('Azure Bastion SKU.')
@allowed([
  'Basic'
  'Standard'
])
param parAzBastionSku string = 'Standard'

@sys.description('Azure Bastion SKU in secondary location.')
@allowed([
  'Basic'
  'Standard'
])
param parAzBastionSkuSecondaryLocation string = 'Standard'

@sys.description('Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client')
param parAzBastionTunneling bool = false

@sys.description('Switch to enable/disable Bastion native client support in secondary location. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client')
param parAzBastionTunnelingSecondaryLocation bool = false

@sys.description('Name for Azure Bastion Subnet NSG.')
param parAzBastionNsgName string = 'nsg-AzureBastionSubnet'

@sys.description('Name for Azure Bastion Subnet NSG in secondary location.')
param parAzBastionNsgNameSecondaryLocation string = 'nsg-AzureBastionSubnet'

@sys.description('''Resource Lock Configuration for Bastion.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parBastionLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('Switch to enable/disable DDoS Network Protection deployment in the secondary location.')
param parDdosEnabledSecondaryLocation bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

@sys.description('DDoS Plan Name in the secondary location.')
param parDdosPlanNameSecondaryLocation string = '${parCompanyPrefix}-ddos-plan'

@sys.description('''Resource Lock Configuration for DDoS Plan.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parDdosLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Switch to enable/disable Azure Firewall deployment.')
param parAzFirewallEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall deployment in the secondary location.')
param parAzFirewallEnabledSecondaryLocation bool = true

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parCompanyPrefix}-azfw-${parLocation}'

@sys.description('Azure Firewall Name in the secondary location.')
param parAzFirewallNameSecondaryLocation string = '${parCompanyPrefix}-azfw-${parLocation}'

@sys.description('Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.')
param parAzFirewallPoliciesEnabled bool = true

@sys.description('Set this to true for the initial deployment as one firewall policy is required in the secondary location. Set this to false in subsequent deployments if using custom policies.')
param parAzFirewallPoliciesEnabledSecondaryLocation bool = true

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

@sys.description('Azure Firewall Policies Name in the secondary location.')
param parAzFirewallPoliciesNameSecondaryLocation string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

@description('The operation mode for automatically learning private ranges to not be SNAT.')
param parAzFirewallPoliciesAutoLearn string = 'Disabled'
@allowed([
  'Disabled'
  'Enabled'
])

@description('The operation mode for automatically learning private ranges to not be SNAT in the secondary location.')
param parAzFirewallPoliciesAutoLearnSecondaryLocation  string = 'Disabled'
@allowed([
  'Disabled'
  'Enabled'
])

@description('Private IP addresses/IP ranges to which traffic will not be SNAT.')
param parAzFirewallPoliciesPrivateRanges array = []

@description('Private IP addresses/IP ranges to which traffic will not be SNAT in the secondary location.')
param parAzFirewallPoliciesPrivateRangesSecondaryLocation array = []

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy in the secondary location.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTierSecondaryLocation string = 'Standard'

@sys.description('The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param parAzFirewallIntelMode string = 'Alert'

@sys.description('The Azure Firewall Threat Intelligence Mode in the secondary location. If not set, the default value is Alert.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param parAzFirewallIntelModeSecondaryLocation string = 'Alert'

@sys.description('Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.')
param parAzFirewallCustomPublicIps array = []

@sys.description('Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations in the secondary location.')
param parAzFirewallCustomPublicIpsSecondaryLocation array = []

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
@sys.description('Availability Zones to deploy the Azure Firewall across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZonesSecondaryLocation array = []

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
@sys.description('Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.')
param parAzErGatewayAvailabilityZonesSecondaryLocation array = []

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.')
param parAzVpnGatewayAvailabilityZones array = []

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.')
param parAzVpnGatewayAvailabilityZonesSecondaryLocation array = []

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy in the secndary location.')
param parAzFirewallDnsProxyEnabledSecondaryLocation bool = true

@sys.description('Array of custom DNS servers used by Azure Firewall.')
param parAzFirewallDnsServers array = []

@sys.description('Array of custom DNS servers used by Azure Firewall in the secondary location.')
param parAzFirewallDnsServersSecondaryLocation array = []

@sys.description(''' Resource Lock Configuration for Azure Firewall.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parAzureFirewallLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Name of Route table to create for the default route of Hub.')
param parHubRouteTableName string = '${parCompanyPrefix}-hub-routetable'

@sys.description('Name of Route table to create for the default route of Hub in the secondary location.')
param parHubRouteTableNameSecondaryLocation string = '${parCompanyPrefix}-hub-routetable'

@sys.description('Switch to enable/disable BGP Propagation on route table.')
param parDisableBgpRoutePropagation bool = false

@sys.description('Switch to enable/disable BGP Propagation on route table in the secondary location.')
param parDisableBgpRoutePropagationSecondaryLocation bool = false

@sys.description('''Resource Lock Configuration for Hub Route Table.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parHubRouteTableLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Switch to enable/disable Private DNS Zones deployment.')
param parPrivateDnsZonesEnabled bool = true

@sys.description('Switch to enable/disable Private DNS Zones deployment in the secondary location.')
param parPrivateDnsZonesEnabledSecondaryLocation bool = true

@sys.description('Resource Group Name for Private DNS Zones.')
param parPrivateDnsZonesResourceGroup string = resourceGroup().name

@sys.description('Resource Group Name for Private DNS Zones in the secondary location.')
param parPrivateDnsZonesResourceGroupSecondaryLocation string = resourceGroup().name

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
  'privatelink.azuredatabricks.net'
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
  'privatelink.dp.kubernetesconfiguration.azure.com'
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

@sys.description('Array of DNS Zones to provision in Hub Virtual Network in the secondary location. Default: All known Azure Private DNS Zones')
param parPrivateDnsZonesSecondaryLocation array = [
  'privatelink.${toLower(parSecondaryLocation)}.azmk8s.io'
  'privatelink.${toLower(parSecondaryLocation)}.batch.azure.com'
  'privatelink.${toLower(parSecondaryLocation)}.kusto.windows.net'
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
  'privatelink.azuredatabricks.net'
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
  'privatelink.dp.kubernetesconfiguration.azure.com'
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

@sys.description('Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup in secondary location.')
param parPrivateDnsZoneAutoMergeAzureBackupZoneSecondaryLocation bool = true

@sys.description('Resource ID of Failover VNet for Private DNS Zone VNet Failover Links')
param parVirtualNetworkIdToLinkFailover string = ''

@sys.description('Resource ID of Failover VNet for Private DNS Zone VNet Failover Links in secondary location')
param parVirtualNetworkIdToLinkFailoverSecondaryLocation string = ''

@sys.description('''Resource Lock Configuration for Private DNS Zone(s).

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parPrivateDNSZonesLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Switch to enable/disable VPN virtual network gateway deployment.')
param parVpnGatewayEnabled bool = true

@sys.description('Switch to enable/disable VPN virtual network gateway deployment in secondary location.')
param parVpnGatewayEnabledSecondaryLocation bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@sys.description('Configuration for VPN virtual network gateway to be deployed.')
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
  vpnClientConfiguration: {}
}

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@sys.description('Configuration for VPN virtual network gateway to be deployed in secondary location.')
param parVpnGatewayConfigSecondaryLocation object = {
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
  vpnClientConfiguration: {}
}

@sys.description('Switch to enable/disable ExpressRoute virtual network gateway deployment.')
param parExpressRouteGatewayEnabled bool = true

@sys.description('Switch to enable/disable ExpressRoute virtual network gateway deployment in secondary location.')
param parExpressRouteGatewayEnabledSecondaryLocation bool = true

@sys.description('Configuration for ExpressRoute virtual network gateway to be deployed.')
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

@sys.description('Configuration for ExpressRoute virtual network gateway to be deployed in secondary location.')
param parExpressRouteGatewayConfigSecondaryLocation object = {
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

@sys.description('''Resource Lock Configuration for ExpressRoute Virtual Network Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parVirtualNetworkGatewayLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

@sys.description('Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.')
param parBastionOutboundSshRdpPorts array = [ '22', '3389' ]

@sys.description('Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion in secondary location.')
param parBastionOutboundSshRdpPortsSecondaryLocation array = [ '22', '3389' ]

var varSubnetMap = map(range(0, length(parSubnets)), i => {
    name: parSubnets[i].name
    ipAddressRange: parSubnets[i].ipAddressRange
    networkSecurityGroupId: parSubnets[i].?networkSecurityGroupId ?? ''
    routeTableId: parSubnets[i].?routeTableId ?? ''
    delegation: parSubnets[i].?delegation ?? ''
  })

var varSubnetMapSecondaryLocation = map(range(0, length(parSubnetsSecondaryLocation)), i => {
  name: parSubnetsSecondaryLocation[i].name
  ipAddressRange: parSubnetsSecondaryLocation[i].ipAddressRange
  networkSecurityGroupId: parSubnetsSecondaryLocation[i].?networkSecurityGroupId ?? ''
  routeTableId: parSubnetsSecondaryLocation[i].?routeTableId ?? ''
  delegation: parSubnetsSecondaryLocation[i].?delegation ?? ''
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

var varSubnetPropertiesSecondaryLocation = [for subnet in varSubnetMapSecondaryLocation: {
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

    networkSecurityGroup: (subnet.name == 'AzureBastionSubnet' && parAzBastionEnabledSecondaryLocation) ? {
      id: '${resourceGroup().id}/providers/Microsoft.Network/networkSecurityGroups/${parAzBastionNsgNameSecondaryLocation}'
    } : (empty(subnet.networkSecurityGroupId)) ? null : {
      id: subnet.networkSecurityGroupId
    }

    routeTable: (empty(subnet.routeTableId)) ? null : {
      id: subnet.routeTableId
    }
  }
}]

var varVpnGwConfig = ((parVpnGatewayEnabled) && (!empty(parVpnGatewayConfig)) ? parVpnGatewayConfig : json('{"name": "noconfigVpn"}'))

var varVpnGwConfigSecondaryLocation = ((parVpnGatewayEnabledSecondaryLocation) && (!empty(parVpnGatewayConfigSecondaryLocation)) ? parVpnGatewayConfigSecondaryLocation : json('{"name": "noconfigVpn"}'))

var varErGwConfig = ((parExpressRouteGatewayEnabled) && !empty(parExpressRouteGatewayConfig) ? parExpressRouteGatewayConfig : json('{"name": "noconfigEr"}'))

var varErGwConfigSecondaryLocation = ((parExpressRouteGatewayEnabledSecondaryLocation) && !empty(parExpressRouteGatewayConfigSecondaryLocation) ? parExpressRouteGatewayConfigSecondaryLocation : json('{"name": "noconfigEr"}'))

var varGwConfig = [
  varVpnGwConfig
  varErGwConfig
]

var varGwConfigSecondaryLocation = [
  varVpnGwConfigSecondaryLocation
  varErGwConfigSecondaryLocation
]

// Customer Usage Attribution Id Telemetry
var varCuaid = '2686e846-5fdc-4d4f-b533-16dcb09d6e6c'

// ZTN Telemetry
var varZtnP1CuaId = '3ab23b1e-c5c5-42d4-b163-1402384ba2db'
var varZtnP1Trigger = (parDdosEnabled && parAzFirewallEnabled && (parAzFirewallTier == 'Premium')) ? true : false

var varZtnP1TriggerSecondaryLocation = (parDdosEnabledSecondaryLocation && parAzFirewallEnabledSecondaryLocation && (parAzFirewallTierSecondaryLocation == 'Premium')) ? true : false

var varAzFirewallUseCustomPublicIps = length(parAzFirewallCustomPublicIps) > 0

var varAzFirewallUseCustomPublicIpsSecondaryLocation = length(parAzFirewallCustomPublicIpsSecondaryLocation) > 0

//DDos Protection plan will only be enabled if parDdosEnabled is true.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-02-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

//DDos Protection plan will only be enabled if parDdosEnabled is true.
resource resDdosProtectionPlanSecondaryLocation 'Microsoft.Network/ddosProtectionPlans@2023-02-01' = if (parDdosEnabledSecondaryLocation) {
  name: parDdosPlanNameSecondaryLocation
  location: parSecondaryLocation
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

// Create resource lock if parDdosEnabled is true and parGlobalResourceLock.kind != 'None' or if parDdosLock.kind != 'None'
resource resDDoSProtectionPlanLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parDdosEnabledSecondaryLocation && (parDdosLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resDdosProtectionPlanSecondaryLocation
  name: parDdosLock.?name ?? '${resDdosProtectionPlanSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parDdosLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parDdosLock.?notes
  }
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

resource resHubVnetSecondaryLocation 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  dependsOn: [
    resBastionNsgSecondaryLocation
  ]
  name: parHubNetworkNameSecondaryLocation
  location: parSecondaryLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        parHubNetworkAddressPrefixSecondaryLocation
      ]
    }
    dhcpOptions: {
      dnsServers: parDnsServerIpsSecondaryLocation
    }
    subnets: varSubnetPropertiesSecondaryLocation
    enableDdosProtection: parDdosEnabledSecondaryLocation
    ddosProtectionPlan: (parDdosEnabledSecondaryLocation) ? {
      id: resDdosProtectionPlanSecondaryLocation.id
    } : null
  }
}

// Create a virtual network resource lock if parGlobalResourceLock.kind != 'None' or if parVirtualNetworkLock.kind != 'None'
resource resVirtualNetworkLock 'Microsoft.Authorization/locks@2020-05-01' = if (parVirtualNetworkLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resHubVnet
  name: parVirtualNetworkLock.?name ?? '${resHubVnet.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualNetworkLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualNetworkLock.?notes
  }
}

// Create a virtual network resource lock if parGlobalResourceLock.kind != 'None' or if parVirtualNetworkLock.kind != 'None'
resource resVirtualNetworkLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parVirtualNetworkLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resHubVnetSecondaryLocation
  name: parVirtualNetworkLock.?name ?? '${resHubVnet.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualNetworkLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualNetworkLock.?notes
  }
}

module modBastionPublicIp '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzBastionEnabled) {
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
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parBastionLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modBastionPublicIpSecondaryLocation '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzBastionEnabledSecondaryLocation) {
  name: 'deploy-Bastion-Public-IP-Secondary-Location'
  params: {
    parLocation: parSecondaryLocation
    parPublicIpName: '${parPublicIpPrefixSecondaryLocation}${parAzBastionNameSecondaryLocation}${parPublicIpSuffix}'
    parPublicIpSku: {
      name: parPublicIpSkuSecondaryLocation
    }
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parBastionLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

resource resBastionSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzBastionEnabled) {
  parent: resHubVnet
  name: 'AzureBastionSubnet'
}

resource resBastionSubnetRefSecondaryLocation 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzBastionEnabledSecondaryLocation) {
  parent: resHubVnetSecondaryLocation
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

resource resBastionNsgSecondaryLocation 'Microsoft.Network/networkSecurityGroups@2023-02-01' = if (parAzBastionEnabledSecondaryLocation) {
  name: parAzBastionNsgNameSecondaryLocation
  location: parSecondaryLocation
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
          destinationPortRanges: parBastionOutboundSshRdpPortsSecondaryLocation
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

// Create bastion nsg resource lock if parAzBastionEnbled is true and parGlobalResourceLock.kind != 'None' or if parBastionLock.kind != 'None'
resource resBastionNsgLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAzBastionEnabled && (parBastionLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resBastionNsg
  name: parBastionLock.?name ?? '${resBastionNsg.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parBastionLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parBastionLock.?notes
  }
}

// Create bastion nsg resource lock if parAzBastionEnbled is true and parGlobalResourceLock.kind != 'None' or if parBastionLock.kind != 'None'
resource resBastionNsgLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parAzBastionEnabledSecondaryLocation && (parBastionLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resBastionNsgSecondaryLocation
  name: parBastionLock.?name ?? '${resBastionNsgSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parBastionLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parBastionLock.?notes
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

// AzureBastionSubnet is required to deploy Bastion service. This subnet must exist in the parsubnets array if you enable Bastion Service.
// There is a minimum subnet requirement of /27 prefix.
// If you are deploying standard this needs to be larger. https://docs.microsoft.com/en-us/azure/bastion/configuration-settings#subnet
resource resBastionSecondaryLocation 'Microsoft.Network/bastionHosts@2023-02-01' = if (parAzBastionEnabledSecondaryLocation) {
  location: parSecondaryLocation
  name: parAzBastionNameSecondaryLocation
  tags: parTags
  sku: {
    name: parAzBastionSkuSecondaryLocation
  }
  properties: {
    dnsName: uniqueString(resourceGroup().id)
    enableTunneling: (parAzBastionSkuSecondaryLocation == 'Standard' && parAzBastionTunnelingSecondaryLocation) ? parAzBastionTunnelingSecondaryLocation : false
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resBastionSubnetRefSecondaryLocation.id
          }
          publicIPAddress: {
            id: parAzBastionEnabledSecondaryLocation ? modBastionPublicIpSecondaryLocation.outputs.outPublicIpId : ''
          }
        }
      }
    ]
  }
}

// Create Bastion resource lock if parAzBastionEnabled is true and parGlobalResourceLock.kind != 'None' or if parBastionLock.kind != 'None'
resource resBastionLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAzBastionEnabled && (parBastionLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resBastion
  name: parBastionLock.?name ?? '${resBastion.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parBastionLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parBastionLock.?notes
  }
}

// Create Bastion resource lock if parAzBastionEnabled is true and parGlobalResourceLock.kind != 'None' or if parBastionLock.kind != 'None'
resource resBastionLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parAzBastionEnabledSecondaryLocation && (parBastionLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resBastionSecondaryLocation
  name: parBastionLock.?name ?? '${resBastionSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parBastionLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parBastionLock.?notes
  }
}

resource resGatewaySubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parVpnGatewayEnabled || parExpressRouteGatewayEnabled ) {
  parent: resHubVnet
  name: 'GatewaySubnet'
}

resource resGatewaySubnetRefSecondaryLocation 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parVpnGatewayEnabledSecondaryLocation || parExpressRouteGatewayEnabledSecondaryLocation ) {
  parent: resHubVnetSecondaryLocation
  name: 'GatewaySubnet'
}

module modGatewayPublicIp '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = [for (gateway, i) in varGwConfig: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) {
  name: 'deploy-Gateway-Public-IP-${i}'
  params: {
    parLocation: parLocation
    parAvailabilityZones: toLower(gateway.gatewayType) == 'expressroute' ? parAzErGatewayAvailabilityZones : toLower(gateway.gatewayType) == 'vpn' ? parAzVpnGatewayAvailabilityZones : []
    parPublicIpName: '${parPublicIpPrefix}${gateway.name}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSku
    }
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parVirtualNetworkGatewayLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

module modGatewayPublicIpSecondaryLocation '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = [for (gateway, i) in varGwConfigSecondaryLocation: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) {
  name: 'deploy-Gateway-Public-IP-Secondary-Location-${i}'
  params: {
    parLocation: parSecondaryLocation
    parAvailabilityZones: toLower(gateway.gatewayType) == 'expressroute' ? parAzErGatewayAvailabilityZonesSecondaryLocation : toLower(gateway.gatewayType) == 'vpn' ? parAzVpnGatewayAvailabilityZonesSecondaryLocation : []
    parPublicIpName: '${parPublicIpPrefixSecondaryLocation}${gateway.name}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSkuSecondaryLocation
    }
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parVirtualNetworkGatewayLock
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
    vpnGatewayGeneration: (toLower(gateway.gatewayType) == 'vpn') ? gateway.generation : 'None'
    vpnType: gateway.vpnType
    sku: {
      name: gateway.sku
      tier: gateway.sku
    }
    vpnClientConfiguration: (toLower(gateway.gatewayType) == 'vpn') ? {
      vpnClientAddressPool: gateway.vpnClientConfiguration.?vpnClientAddressPool ?? ''
      vpnClientProtocols: gateway.vpnClientConfiguration.?vpnClientProtocols ?? ''
      vpnAuthenticationTypes: gateway.vpnClientConfiguration.?vpnAuthenticationTypes ?? ''
      aadTenant: gateway.vpnClientConfiguration.?aadTenant ?? ''
      aadAudience: gateway.vpnClientConfiguration.?aadAudience ?? ''
      aadIssuer: gateway.vpnClientConfiguration.?aadIssuer ?? ''
      vpnClientRootCertificates: gateway.vpnClientConfiguration.?vpnClientRootCertificates ?? ''
      radiusServerAddress: gateway.vpnClientConfiguration.?radiusServerAddress ?? ''
      radiusServerSecret: gateway.vpnClientConfiguration.?radiusServerSecret ?? ''
    } : null
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

//Minumum subnet size is /27 supporting documentation https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsub
resource resGatewaySecondaryLocation 'Microsoft.Network/virtualNetworkGateways@2023-02-01' = [for (gateway, i) in varGwConfigSecondaryLocation: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) {
  name: gateway.name
  location: parSecondaryLocation
  tags: parTags
  properties: {
    activeActive: gateway.activeActive
    enableBgp: gateway.enableBgp
    enableBgpRouteTranslationForNat: gateway.enableBgpRouteTranslationForNat
    enableDnsForwarding: gateway.enableDnsForwarding
    bgpSettings: (gateway.enableBgp) ? gateway.bgpSettings : null
    gatewayType: gateway.gatewayType
    vpnGatewayGeneration: (toLower(gateway.gatewayType) == 'vpn') ? gateway.generation : 'None'
    vpnType: gateway.vpnType
    sku: {
      name: gateway.sku
      tier: gateway.sku
    }
    vpnClientConfiguration: (toLower(gateway.gatewayType) == 'vpn') ? {
      vpnClientAddressPool: gateway.vpnClientConfiguration.?vpnClientAddressPool ?? ''
      vpnClientProtocols: gateway.vpnClientConfiguration.?vpnClientProtocols ?? ''
      vpnAuthenticationTypes: gateway.vpnClientConfiguration.?vpnAuthenticationTypes ?? ''
      aadTenant: gateway.vpnClientConfiguration.?aadTenant ?? ''
      aadAudience: gateway.vpnClientConfiguration.?aadAudience ?? ''
      aadIssuer: gateway.vpnClientConfiguration.?aadIssuer ?? ''
      vpnClientRootCertificates: gateway.vpnClientConfiguration.?vpnClientRootCertificates ?? ''
      radiusServerAddress: gateway.vpnClientConfiguration.?radiusServerAddress ?? ''
      radiusServerSecret: gateway.vpnClientConfiguration.?radiusServerSecret ?? ''
    } : null
    ipConfigurations: [
      {
        id: resHubVnetSecondaryLocation.id
        name: 'vnetGatewayConfig'
        properties: {
          publicIPAddress: {
            id: (((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr')) ? modGatewayPublicIpSecondaryLocation[i].outputs.outPublicIpId : 'na')
          }
          subnet: {
            id: resGatewaySubnetRefSecondaryLocation.id
          }
        }
      }
    ]
  }
}]

// Create a Virtual Network Gateway resource lock if gateway.name is not equal to noconfigVpn or noconfigEr and parGlobalResourceLock.kind != 'None' or if parVirtualNetworkGatewayLock.kind != 'None'
resource resVirtualNetworkGatewayLock 'Microsoft.Authorization/locks@2020-05-01' = [for (gateway, i) in varGwConfig: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr') && (parVirtualNetworkGatewayLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resGateway[i]
  name: parVirtualNetworkGatewayLock.?name ?? '${resGateway[i].name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualNetworkGatewayLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualNetworkGatewayLock.?notes
  }
}]

// Create a Virtual Network Gateway resource lock if gateway.name is not equal to noconfigVpn or noconfigEr and parGlobalResourceLock.kind != 'None' or if parVirtualNetworkGatewayLock.kind != 'None'
resource resVirtualNetworkGatewayLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = [for (gateway, i) in varGwConfigSecondaryLocation: if ((gateway.name != 'noconfigVpn') && (gateway.name != 'noconfigEr') && (parVirtualNetworkGatewayLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resGatewaySecondaryLocation[i]
  name: parVirtualNetworkGatewayLock.?name ?? '${resGatewaySecondaryLocation[i].name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parVirtualNetworkGatewayLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parVirtualNetworkGatewayLock.?notes
  }
}]

resource resAzureFirewallSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzFirewallEnabled) {
  parent: resHubVnet
  name: 'AzureFirewallSubnet'
}

resource resAzureFirewallSubnetRefSecondaryLocation 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzFirewallEnabledSecondaryLocation) {
  parent: resHubVnetSecondaryLocation
  name: 'AzureFirewallSubnet'
}

resource resAzureFirewallMgmtSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  parent: resHubVnet
  name: 'AzureFirewallManagementSubnet'
}

resource resAzureFirewallMgmtSubnetRefSecondaryLocation 'Microsoft.Network/virtualNetworks/subnets@2023-02-01' existing = if (parAzFirewallEnabledSecondaryLocation && (contains(map(parSubnetsSecondaryLocation, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  parent: resHubVnetSecondaryLocation
  name: 'AzureFirewallManagementSubnet'
}

module modAzureFirewallPublicIp '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzFirewallEnabled) {
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
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parAzureFirewallLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modAzureFirewallPublicIpSecondaryLocation '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzFirewallEnabledSecondaryLocation) {
  name: 'deploy-Firewall-Public-IP-Secondary-Location'
  params: {
    parLocation: parSecondaryLocation
    parAvailabilityZones: parAzFirewallAvailabilityZonesSecondaryLocation
    parPublicIpName: '${parPublicIpPrefixSecondaryLocation}${parAzFirewallNameSecondaryLocation}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSkuSecondaryLocation
    }
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parAzureFirewallLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modAzureFirewallMgmtPublicIp '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
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
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parAzureFirewallLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modAzureFirewallMgmtPublicIpSecondaryLocation '../../../infra-as-code/bicep/modules/publicIp/publicIp.bicep' = if (parAzFirewallEnabledSecondaryLocation && (contains(map(parSubnetsSecondaryLocation, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  name: 'deploy-Firewall-mgmt-Public-IP-Secondary-Location'
  params: {
    parLocation: parSecondaryLocation
    parAvailabilityZones: parAzFirewallAvailabilityZonesSecondaryLocation
    parPublicIpName: '${parPublicIpPrefixSecondaryLocation}${parAzFirewallNameSecondaryLocation}-mgmt${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: 'Standard'
    }
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parAzureFirewallLock
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2023-02-01' = if (parAzFirewallEnabled && parAzFirewallPoliciesEnabled) {
  name: parAzFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: (parAzFirewallTier == 'Basic') ? {
    sku: {
      tier: parAzFirewallTier
    }
    snat: !empty(parAzFirewallPoliciesPrivateRanges)
    ? {
      autoLearnPrivateRanges: parAzFirewallPoliciesAutoLearn
      privateRanges: parAzFirewallPoliciesPrivateRanges
      }
    : null
    threatIntelMode: 'Alert'
  } : {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabled
      servers: parAzFirewallDnsServers
    }
    sku: {
      tier: parAzFirewallTier
    }
    threatIntelMode: parAzFirewallIntelMode
  }
}

resource resFirewallPoliciesSecondaryLocation 'Microsoft.Network/firewallPolicies@2023-02-01' = if (parAzFirewallEnabledSecondaryLocation && parAzFirewallPoliciesEnabledSecondaryLocation) {
  name: parAzFirewallPoliciesNameSecondaryLocation
  location: parSecondaryLocation
  tags: parTags
  properties: (parAzFirewallTierSecondaryLocation == 'Basic') ? {
    sku: {
      tier: parAzFirewallTierSecondaryLocation
    }
    snat: !empty(parAzFirewallPoliciesPrivateRangesSecondaryLocation)
    ? {
      autoLearnPrivateRanges: parAzFirewallPoliciesAutoLearnSecondaryLocation
      privateRanges: parAzFirewallPoliciesPrivateRangesSecondaryLocation
      }
    : null
    threatIntelMode: 'Alert'
  } : {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabledSecondaryLocation
      servers: parAzFirewallDnsServersSecondaryLocation
    }
    sku: {
      tier: parAzFirewallTierSecondaryLocation
    }
    threatIntelMode: parAzFirewallIntelModeSecondaryLocation
  }
}

// Create Azure Firewall Policy resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resFirewallPoliciesLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabled && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resFirewallPolicies
  name: parAzureFirewallLock.?name ?? '${resFirewallPolicies.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
  }
}

// Create Azure Firewall Policy resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resFirewallPoliciesLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabledSecondaryLocation && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resFirewallPoliciesSecondaryLocation
  name: parAzureFirewallLock.?name ?? '${resFirewallPoliciesSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
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
    ipConfigurations: varAzFirewallUseCustomPublicIps
     ? map(parAzFirewallCustomPublicIps, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIps[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
      })
     : [
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
    ipConfigurations: varAzFirewallUseCustomPublicIps
     ? map(parAzFirewallCustomPublicIps, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIps[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
      })
     : [
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

// AzureFirewallSubnet is required to deploy Azure Firewall . This subnet must exist in the parsubnets array if you deploy.
// There is a minimum subnet requirement of /26 prefix.
resource resAzureFirewallSecondaryLocation 'Microsoft.Network/azureFirewalls@2023-02-01' = if (parAzFirewallEnabledSecondaryLocation) {
  dependsOn: [
    resGatewaySecondaryLocation
  ]
  name: parAzFirewallNameSecondaryLocation
  location: parSecondaryLocation
  tags: parTags
  zones: (!empty(parAzFirewallAvailabilityZonesSecondaryLocation) ? parAzFirewallAvailabilityZonesSecondaryLocation : [])
  properties: parAzFirewallTierSecondaryLocation == 'Basic' ? {
    ipConfigurations: varAzFirewallUseCustomPublicIpsSecondaryLocation
     ? map(parAzFirewallCustomPublicIpsSecondaryLocation, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIpsSecondaryLocation[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRefSecondaryLocation.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? ip : ''
          }
        }
      })
     : [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRefSecondaryLocation.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? modAzureFirewallPublicIpSecondaryLocation.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    managementIpConfiguration: {
      name: 'mgmtIpConfig'
      properties: {
        publicIPAddress: {
          id: parAzFirewallEnabledSecondaryLocation ? modAzureFirewallMgmtPublicIpSecondaryLocation.outputs.outPublicIpId : ''
        }
        subnet: {
          id: resAzureFirewallMgmtSubnetRefSecondaryLocation.id
        }
      }
    }
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTierSecondaryLocation
    }
    firewallPolicy: {
      id: resFirewallPoliciesSecondaryLocation.id
    }
  } : {
    ipConfigurations: varAzFirewallUseCustomPublicIpsSecondaryLocation
     ? map(parAzFirewallCustomPublicIpsSecondaryLocation, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIpsSecondaryLocation[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRefSecondaryLocation.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? ip : ''
          }
        }
      })
     : [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRefSecondaryLocation.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabledSecondaryLocation ? modAzureFirewallPublicIpSecondaryLocation.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTierSecondaryLocation
    }
    firewallPolicy: {
      id: resFirewallPoliciesSecondaryLocation.id
    }
  }
}

// Create Azure Firewall resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resAzureFirewallLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabled && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resAzureFirewall
  name: parAzureFirewallLock.?name ?? '${resAzureFirewall.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
  }
}

// Create Azure Firewall resource lock if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parAzureFirewallLock.kind != 'None'
resource resAzureFirewallLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabledSecondaryLocation && (parAzureFirewallLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resAzureFirewallSecondaryLocation
  name: parAzureFirewallLock.?name ?? '${resAzureFirewallSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAzureFirewallLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAzureFirewallLock.?notes
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

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
resource resHubRouteTableSecondaryLocation 'Microsoft.Network/routeTables@2023-02-01' = if (parAzFirewallEnabledSecondaryLocation) {
  name: parHubRouteTableNameSecondaryLocation
  location: parSecondaryLocation
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default-azfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzFirewallEnabledSecondaryLocation ? resAzureFirewallSecondaryLocation.properties.ipConfigurations[0].properties.privateIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parDisableBgpRoutePropagationSecondaryLocation
  }
}

// Create a Route Table if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parHubRouteTableLock.kind != 'None'
resource resHubRouteTableLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabled && (parHubRouteTableLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resHubRouteTable
  name: parHubRouteTableLock.?name ?? '${resHubRouteTable.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parHubRouteTableLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parHubRouteTableLock.?notes
  }
}

// Create a Route Table if parAzFirewallEnabled is true and parGlobalResourceLock.kind != 'None' or if parHubRouteTableLock.kind != 'None'
resource resHubRouteTableLockSecondaryLocation 'Microsoft.Authorization/locks@2020-05-01' = if (parAzFirewallEnabledSecondaryLocation && (parHubRouteTableLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resHubRouteTableSecondaryLocation
  name: parHubRouteTableLock.?name ?? '${resHubRouteTableSecondaryLocation.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parHubRouteTableLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parHubRouteTableLock.?notes
  }
}

module modPrivateDnsZones '../../../infra-as-code/bicep/modules/privateDnsZones/privateDnsZones.bicep' = if (parPrivateDnsZonesEnabled) {
  name: 'deploy-Private-DNS-Zones'
  scope: resourceGroup(parPrivateDnsZonesResourceGroup)
  params: {
    parLocation: parLocation
    parTags: parTags
    parVirtualNetworkIdToLink: resHubVnet.id
    parVirtualNetworkIdToLinkFailover: parVirtualNetworkIdToLinkFailover
    parPrivateDnsZones: parPrivateDnsZones
    parPrivateDnsZoneAutoMergeAzureBackupZone: parPrivateDnsZoneAutoMergeAzureBackupZone
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parPrivateDNSZonesLock
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modPrivateDnsZonesSecondaryLocation '../../../infra-as-code/bicep/modules/privateDnsZones/privateDnsZones.bicep' = if (parPrivateDnsZonesEnabledSecondaryLocation) {
  name: 'deploy-Private-DNS-Zones-Secondary-Location'
  scope: resourceGroup(parPrivateDnsZonesResourceGroupSecondaryLocation)
  params: {
    parLocation: parSecondaryLocation
    parTags: parTags
    parVirtualNetworkIdToLink: resHubVnetSecondaryLocation.id
    parVirtualNetworkIdToLinkFailover: parVirtualNetworkIdToLinkFailoverSecondaryLocation
    parPrivateDnsZones: parPrivateDnsZonesSecondaryLocation
    parPrivateDnsZoneAutoMergeAzureBackupZone: parPrivateDnsZoneAutoMergeAzureBackupZoneSecondaryLocation
    parResourceLockConfig: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock : parPrivateDNSZonesLock
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../../infra-as-code/bicep/CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

module modCustomerUsageAttributionZtnP1 '../../../infra-as-code/bicep/CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut && (varZtnP1Trigger || varZtnP1TriggerSecondaryLocation)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varZtnP1CuaId}-${uniqueString(resourceGroup().location)}'
  params: {}
}

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzFirewallPrivateIp string = parAzFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''
output outAzFirewallPrivateIpSecondaryLocation string = parAzFirewallEnabledSecondaryLocation ? resAzureFirewallSecondaryLocation.properties.ipConfigurations[0].properties.privateIPAddress : ''


//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
output outAzFirewallName string = parAzFirewallEnabled ? parAzFirewallName : ''
output outAzFirewallNameSecondaryLocation string = parAzFirewallEnabledSecondaryLocation ? parAzFirewallNameSecondaryLocation : ''

output outPrivateDnsZones array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZones : [])
output outPrivateDnsZonesSecondaryLocation array = (parPrivateDnsZonesEnabledSecondaryLocation ? modPrivateDnsZonesSecondaryLocation.outputs.outPrivateDnsZones : [])

output outPrivateDnsZonesNames array = (parPrivateDnsZonesEnabled ? modPrivateDnsZones.outputs.outPrivateDnsZonesNames : [])
output outPrivateDnsZonesNamesSecondaryLocation array = (parPrivateDnsZonesEnabledSecondaryLocation ? modPrivateDnsZonesSecondaryLocation.outputs.outPrivateDnsZonesNames : [])

output outDdosPlanResourceId string = resDdosProtectionPlan.id
output outDdosPlanResourceIdSecondaryLocation string = resDdosProtectionPlanSecondaryLocation.id

output outHubVirtualNetworkName string = resHubVnet.name
output outHubVirtualNetworkNameSecondaryLocation string = resHubVnetSecondaryLocation.name

output outHubVirtualNetworkId string = resHubVnet.id
output outHubVirtualNetworkIdSecondaryLocation string = resHubVnetSecondaryLocation.id

output outHubRouteTableId string = parAzFirewallEnabled ? resHubRouteTable.id : ''
output outHubRouteTableIdSecondaryLocation string = parAzFirewallEnabledSecondaryLocation ? resHubRouteTableSecondaryLocation.id : ''

output outHubRouteTableName string = parAzFirewallEnabled ? resHubRouteTable.name : ''
output outHubRouteTableNameSecondaryLocation string = parAzFirewallEnabledSecondaryLocation ? resHubRouteTableSecondaryLocation.name : ''

output outBastionNsgId string = parAzBastionEnabled ? resBastionNsg.id : ''
output outBastionNsgIdSecondaryLocation string = parAzBastionEnabledSecondaryLocation ? resBastionNsgSecondaryLocation.id : ''

output outBastionNsgName string = parAzBastionEnabled ? resBastionNsg.name : ''
output outBastionNsgNameSecondaryLocation string = parAzBastionEnabledSecondaryLocation ? resBastionNsgSecondaryLocation.name : ''

