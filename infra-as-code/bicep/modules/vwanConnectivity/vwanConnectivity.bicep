/*
SUMMARY: Module to deploy the Virtual WAN network topology and its components as per the Azure Landing Zone conceptual architecture - https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology. This module draws parity with the Enterprise Scale implementation https://github.com/Azure/Enterprise-Scale/blob/main/eslzArm/subscriptionTemplates/vwan-connectivity.json
DESCRIPTION: The following Azure resources will be deployed in a single resource group specified in the deployment parameter:
              Virtual WAN
              Public IP
            The following resources are optional and can be configured by parameters:
              Virtual Hub
              VPN Gateway
              ExpressRoute Gateway
              Azure Firewall
AUTHOR/S: Fai Lai @faister
VERSION: 1.0.0
*/

@description('Prefix value which will be prepended to all resource names. Default: alz')
param parCompanyPrefix string = 'alz'

@description('The IP address range in CIDR notation for the vWAN virtual Hub to use. Default: 10.100.0.0/23')
param parVhubAddressPrefix string = '10.100.0.0/23'

@description('Switch which allows Azure Firewall deployment to be disabled. Default: false')
param parAzureFirewallEnabled bool = false

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parAzureFirewallTier string = 'Standard'

@description('Public IP Address SKU. Default: Standard')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIPSku string = 'Standard'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('Switch which allows Virtual Hub. Default: true')
param parVirtualHubEnabled bool = true

@description('Switch which allows VPN Gateway. Default: false')
param parVPNGatewayEnabled bool = false

@description('Switch which allows ExpressRoute Gateway. Default: false')
param parERGatewayEnabled bool = false

@description('Prefix Used for Virtual WAN. Default: {parCompanyPrefix}-vwan-{resourceGroup().location}')
param parVWanName string = '${parCompanyPrefix}-vwan-${resourceGroup().location}'

@description('Prefix Used for Virtual Hub. Default: {parCompanyPrefix}-hub-{resourceGroup().location}')
param parVHubName string = '${parCompanyPrefix}-vhub-${resourceGroup().location}'

@description('Prefix Used for VPN Gateway. Default: {parCompanyPrefix}-vpngw-{resourceGroup().location}')
param parVPNGwName string = '${parCompanyPrefix}-vpngw-${resourceGroup().location}'

@description('Prefix Used for ExpressRoute Gateway. Default: {parCompanyPrefix}-ergw-{resourceGroup().location}')
param parERGwName string = '${parCompanyPrefix}-ergw-${parLocation}'

@description('Azure Firewall Name. Default: {parCompanyPrefix}-fw-{parLocation}')
param parAzureFirewallName string = '${parCompanyPrefix}-fw-${parLocation}'

@description('Region in which the resource group was created. Default: {resourceGroup().location}')
param parLocation string = resourceGroup().location

@description('The scale unit for this VPN Gateway: Default: 1')
param parVPNGwScaleUnit int = 1

@description('The scale unit for this ExpressRoute Gateway: Default: 1')
param parERGwScaleUnit int = 1

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

resource resVHub 'Microsoft.Network/virtualHubs@2021-05-01' = if(parVirtualHubEnabled && !empty(parVhubAddressPrefix)) {
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

resource resVPNGateway 'Microsoft.Network/vpnGateways@2021-05-01' = if(parVirtualHubEnabled && parVPNGatewayEnabled) {
  name: parVPNGwName
  location: parLocation
  tags: parTags
  properties: {
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
    virtualHub:{
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
    virtualHub:{
      id: resVHub.id
    }
    autoScaleConfiguration: {
      bounds: {
        min: parERGwScaleUnit
      }
    }
  }
}

// AzureFirewallSubnet is required to deploy Azure Firewall . This subnet must exist in the parsubnets array if you deploy.
// There is a minimum subnet requirement of /26 prefix.  
resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2021-02-01' = if (parVirtualHubEnabled && parAzureFirewallEnabled) {
  name: parAzureFirewallName
  location: parLocation
  tags: parTags
  dependsOn: [
    // putting an explicit dependency because there is an implicit dependency below which produces a deployment error if parAzureFirewallEnabled == false
    modAzureFirewallPublicIP
  ]
  properties:{
    hubIPAddresses: {
      publicIPs: {
        addresses: [
          {
            address: modAzureFirewallPublicIP.outputs.outPublicIPID
          }
        ]
        count: 1
      }
    }    
    sku: {
      name: 'AZFW_Hub'
      tier: parAzureFirewallTier
    }
    virtualHub: {
      id: resVHub.id
    }
    additionalProperties: { }
  }
}

module modAzureFirewallPublicIP '../publicIp/publicIp.bicep' = {
  name: 'deploy-Firewall-Public-IP'
  params: {
    parPublicIPName: '${parAzureFirewallName}-PublicIP'
    parLocation: parLocation
    parPublicIPProperties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
    }
    parPublicIPSku: {
        name: parPublicIPSku
    }
    parTags: parTags
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString('${parLocation}')}'
  params: {}
}

// Output Virtual WAN name and ID
output outVirtualWANName string = resVWAN.name
output outVirtualWANID string = resVWAN.id

// Output Virtual Hub name and ID
output outVirtualHubName string = resVHub.name
output outVirtualHubID string = resVHub.id
