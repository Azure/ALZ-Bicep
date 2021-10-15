/*
SUMMARY: Module to deploy Azure Firewall 
DESCRIPTION: The following components will be options in this deployment
      * Azure Firewall
      * Azure Firewall Policy
AUTHOR/S: aultt
VERSION: 1.0.0
*/

@description('Azure Firewall Name. Default: None ')
param parAzureFirewallName string

@description('Azure Region to deploy Public IP Address to. Default: Current Resource Group')
param parLocation string = resourceGroup().location

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('ID of Azure Firewall Subnet to deploy azure firewall to. Default: None')
param parAzureFirewallSubnetID string

@description('ID of Azure Firewall Public IP. Default: None')
param parAzureFirewallPublicIPID string

@description('Azure Firewall Policy Nam. Default: None')
param parFirewallPolicyName string

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parFirewallPolicySku string

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parFirewallTier string

@description('Switch which allos DNS Proxy to be enabled on the virtual network. Default: none')
param parFirewallPolicyEnableProxy bool = true

@description('Azure Firewall threat Intel Mode. Default: Alert')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param parFirewallPolicyIntrusionDetection string = 'Alert'

@description('Azure Firewall Policy Intel Mode. Default: Alert ')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param parFirewallPolicyIntelMode string = 'Alert'

resource resAzureFirewallPolicy 'Microsoft.Network/firewallPolicies@2021-02-01' = {
  name:parFirewallPolicyName
  location: parLocation
  tags: parTags
  properties: {
    sku: {
      tier: parFirewallPolicySku
    }
    dnsSettings: {
      enableProxy: parFirewallPolicyEnableProxy
    }
    intrusionDetection: {
      mode: parFirewallPolicyIntrusionDetection
    }
    threatIntelMode: parFirewallPolicyIntelMode
  }
} 

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2021-02-01' = {
  name: parAzureFirewallName
  location: resourceGroup().location
  tags: parTags
  properties:{
    firewallPolicy:{
      id: resAzureFirewallPolicy.id
    }
    sku:{
      tier: parFirewallTier
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: parAzureFirewallSubnetID
          }
          publicIPAddress: {
            id: parAzureFirewallPublicIPID
          }
        }
      }
    ]
  }
}

output outAzureFirewallId string = resAzureFirewall.id
output outAzureFirewallPolicyId string = resAzureFirewallPolicy.id
output outAzureFirewallPrivateIp string = resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
