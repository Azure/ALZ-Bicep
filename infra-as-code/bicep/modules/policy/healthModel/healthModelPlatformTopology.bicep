metadata name = 'ALZ Bicep - CloudHealth Platform Health Model Topology'
metadata description = 'Preview (experimental): assembles the platform domain and subdomain taxonomy and deploys it through the generic health model topology module. Deployable directly for fast testing, and compiled for embedding in the platform policy.'

import { typDomain } from 'healthModelTopology.bicep'

@sys.description('Name of the platform health model.')
param parHealthModelName string

@sys.description('Location for the health model. Must support Microsoft.CloudHealth.')
param parLocation string

@sys.description('Name of the managed-identity authentication setting.')
param parAuthenticationSettingName string = 'managed-identity'

@sys.description('Resource types added to every subdomain discovery query across all domains.')
param parIncludedResourceTypesGlobal array = []

@sys.description('Resource types added to every Security subdomain discovery query.')
param parSecurityResourceTypes array = []

@sys.description('Resource types added to every Connectivity subdomain discovery query.')
param parConnectivityResourceTypes array = []

@sys.description('Resource types added to every Management subdomain discovery query.')
param parManagementResourceTypes array = []

@sys.description('Resource types added to every Identity subdomain discovery query.')
param parIdentityResourceTypes array = []

@minLength(36)
@sys.description('Subscription ID whose resources the Security domain discovery queries.')
param parSecuritySubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Connectivity domain discovery queries.')
param parConnectivitySubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Management domain discovery queries.')
param parManagementSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Identity domain discovery queries.')
param parIdentitySubscriptionId string = subscription().subscriptionId

@sys.description('Per-domain advanced overrides. Each key may set tagFilters and replace the built-in subdomain split.')
param parDomainOverrides object = {}

var varDefaultSubdomains = {
  security: [
    {
      name: 'secrets'
      displayName: 'Secrets and keys'
      resourceTypes: ['Microsoft.KeyVault/vaults']
    }
    {
      name: 'perimeter'
      displayName: 'Perimeter filtering'
      resourceTypes: ['Microsoft.Network/azureFirewalls', 'Microsoft.Network/firewallPolicies']
    }
    {
      name: 'ddos'
      displayName: 'DDoS protection'
      resourceTypes: ['Microsoft.Network/ddosProtectionPlans']
    }
  ]
  connectivity: [
    {
      name: 'core'
      displayName: 'Core network'
      resourceTypes: ['Microsoft.Network/virtualNetworks']
    }
    {
      name: 'hybrid'
      displayName: 'Hybrid connectivity'
      resourceTypes: [
        'Microsoft.Network/virtualNetworkGateways'
        'Microsoft.Network/expressRouteCircuits'
        'Microsoft.Network/connections'
      ]
    }
    {
      name: 'edge'
      displayName: 'Ingress and egress'
      resourceTypes: [
        'Microsoft.Network/applicationGateways'
        'Microsoft.Network/loadBalancers'
        'Microsoft.Network/publicIPAddresses'
        'Microsoft.Network/natGateways'
      ]
    }
    {
      name: 'dns'
      displayName: 'Name resolution'
      resourceTypes: ['Microsoft.Network/privateDnsZones']
    }
    {
      name: 'remote-access'
      displayName: 'Remote access'
      resourceTypes: ['Microsoft.Network/bastionHosts']
    }
  ]
  management: [
    {
      name: 'observability'
      displayName: 'Observability'
      resourceTypes: ['Microsoft.OperationalInsights/workspaces', 'Microsoft.Insights/components']
    }
    {
      name: 'alerting'
      displayName: 'Alerting and response'
      resourceTypes: ['Microsoft.Insights/actionGroups']
    }
    {
      name: 'backup'
      displayName: 'Backup and recovery'
      resourceTypes: ['Microsoft.RecoveryServices/vaults']
    }
    {
      name: 'automation'
      displayName: 'Automation and patching'
      resourceTypes: ['Microsoft.Automation/automationAccounts']
    }
    {
      name: 'storage'
      displayName: 'Platform storage'
      resourceTypes: ['Microsoft.Storage/storageAccounts']
    }
  ]
  identity: [
    {
      name: 'domain-services'
      displayName: 'Domain services'
      resourceTypes: ['Microsoft.Compute/virtualMachines']
    }
    {
      name: 'workload-identity'
      displayName: 'Workload identity'
      resourceTypes: ['Microsoft.ManagedIdentity/userAssignedIdentities']
    }
    {
      name: 'secrets'
      displayName: 'Identity secrets'
      resourceTypes: ['Microsoft.KeyVault/vaults']
    }
    {
      name: 'dns'
      displayName: 'Identity DNS'
      resourceTypes: ['Microsoft.Network/privateDnsZones']
    }
  ]
}

var varDomains typDomain[] = [
  {
    name: 'security'
    displayName: 'Security'
    subscriptionId: parSecuritySubscriptionId
    extraResourceTypes: parSecurityResourceTypes
    tagFilters: parDomainOverrides.?security.?tagFilters ?? []
    subdomains: parDomainOverrides.?security.?subdomains ?? varDefaultSubdomains.security
  }
  {
    name: 'connectivity'
    displayName: 'Connectivity'
    subscriptionId: parConnectivitySubscriptionId
    extraResourceTypes: parConnectivityResourceTypes
    tagFilters: parDomainOverrides.?connectivity.?tagFilters ?? []
    subdomains: parDomainOverrides.?connectivity.?subdomains ?? varDefaultSubdomains.connectivity
  }
  {
    name: 'management'
    displayName: 'Management'
    subscriptionId: parManagementSubscriptionId
    extraResourceTypes: parManagementResourceTypes
    tagFilters: parDomainOverrides.?management.?tagFilters ?? []
    subdomains: parDomainOverrides.?management.?subdomains ?? varDefaultSubdomains.management
  }
  {
    name: 'identity'
    displayName: 'Identity'
    subscriptionId: parIdentitySubscriptionId
    extraResourceTypes: parIdentityResourceTypes
    tagFilters: parDomainOverrides.?identity.?tagFilters ?? []
    subdomains: parDomainOverrides.?identity.?subdomains ?? varDefaultSubdomains.identity
  }
]

module modTopology 'healthModelTopology.bicep' = {
  name: 'hm-platform-topology'
  params: {
    parHealthModelName: parHealthModelName
    parLocation: parLocation
    parAuthenticationSettingName: parAuthenticationSettingName
    parIncludedResourceTypesGlobal: parIncludedResourceTypesGlobal
    parDomains: varDomains
  }
}

@sys.description('Assembled discovery queries, one per subdomain, for verification.')
output outSubdomainQueries array = modTopology.outputs.outSubdomainQueries
