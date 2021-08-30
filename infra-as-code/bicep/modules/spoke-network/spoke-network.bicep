/*
SUMMARY: Module to deploy ALZ Spoke Network 
DESCRIPTION: The following components will be options in this deployment
              VNET
              Subnets
              UDR - if Firewall is enabled
              Private DNS Link
              Azure Key Vault
              Recovery Services
AUTHOR/S: Troy Ault
VERSION: 1.0.0
*/


@description('Switch which allows Azure Firewall deployment to be disabled')
param parAzureFirewallEnabled bool = false

@description('Switch which allows DDOS deployment to be disabled')
param parDdosEnabled bool = false

//@description('Switch which allows Private DNS Zones to be disabled')
//param parPrivateDNSZonesEnabled bool = false

@description('Tags you would like to be applied to all resources in this module')
param parTags object = {}

@description('Hub Virtual Network information stored as key value pair')
param parHubVirtualNetwork object ={
  Name : 'Hub-eastus'
  AddressPrefix : '10.10.0.0/16'
  Id: '/subscriptions/3facda0a-9a58-4f63-8436-ddd4ec4ca6fb/resourceGroups/HUB/providers/Microsoft.Network/virtualNetworks/Hub-eastus'
}

@description('')
param parDdosProtectionPlanId string = ''

@description('The IP address range for all virtual networks to use.')
param parSpokeNetworkAddressPrefix string = '10.11.0.0/16'

@description('Prefix Used for Hub Network')
param parSpokeNetworkPrefix string = 'Corp-Spoke'

@description('The name and IP address range for each subnet in the virtual networks.')
param parSubnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.11.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.11.10.0/24'
  }
]

//@description('Private DNS Zones.  Array of Name and Id of Zones')
//param parPrivateDNSZones array = []

@description('Firewall Ip Address')
param parFirewallIPAddress string = ''

@description('Name of Keyvault to be created')
param parKeyVaultName  string = 'CorpKeyVault'

@description('Name of Route table to create for the default route of Hub')
param parSpoketoHubRouteTableName string = 'SpoketoHubRouteTable'

@description('SKU of Keyvault being deployed')
@allowed([
  'standard'
  'premium'
])
param parkKeyVaultSku string = 'standard' 

@description('Identity Recovery Services will run under.')
@allowed([
  'SystemAssigned'
  'UserAssigned'
])
param parRecoveryServicesIdentityType string = 'SystemAssigned'

@description('Name of Recovery Services Vault to be deployed.')
param parRecoveryServicesVaultName string = 'MyRecoveryServicesVault'


var varSubnetProperties = [for subnet in parSubnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]


resource resSpokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${parSpokeNetworkPrefix}-${resourceGroup().location}'
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        parSpokeNetworkAddressPrefix
      ]
    }
    subnets: varSubnetProperties
    enableDdosProtection:parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: parDdosProtectionPlanId
      } : null
  }
}

resource resSpoketoHubPeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name:  '${resSpokeVirtualNetwork.name}/${parHubVirtualNetwork.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    remoteVirtualNetwork: {
        id: parHubVirtualNetwork.id
    }
  }
}


resource resHubtoSpokePeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name:  '${parHubVirtualNetwork.name}/${resSpokeVirtualNetwork.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    remoteVirtualNetwork: {
        id: resSpokeVirtualNetwork.id
    }
  }
}


resource resKeyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: parKeyVaultName
  location: resourceGroup().location
  tags: parTags
  properties: {
    sku: {
      family: 'A'
      name: parkKeyVaultSku
    }
    tenantId: subscription().tenantId
  }
}

resource resSpoketoHubRouteTable 'Microsoft.Network/routeTables@2021-02-01' = if(parAzureFirewallEnabled) {
  name: parSpoketoHubRouteTableName
  location: resourceGroup().location
  tags: parTags
  properties: {
    routes: [
      {
        name: 'udr-default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzureFirewallEnabled ? parFirewallIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}


resource resAzureRecoveryServices 'Microsoft.RecoveryServices/vaults@2021-06-01' = {
  name: parRecoveryServicesVaultName
  location: resourceGroup().location
  tags: parTags
  identity: {
    type: parRecoveryServicesIdentityType 
  }
  sku:{
    name: 'RS0'
    tier: 'Standard'
  }
}
