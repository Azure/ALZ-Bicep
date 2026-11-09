metadata name = 'ALZ Bicep - CloudHealth Application Health Model Topology'
metadata description = 'Preview (experimental): assembles the application domain and subdomain taxonomy and deploys it through the generic health model topology module. Deployable directly for fast testing, and compiled for embedding in the application policy.'

import { typDomain } from 'healthModelTopology.bicep'

@sys.description('Name of the application landing zone health model.')
param parHealthModelName string

@sys.description('Location for the health model. Must support Microsoft.CloudHealth.')
param parLocation string

@sys.description('Name of the managed-identity authentication setting.')
param parAuthenticationSettingName string = 'managed-identity'

@sys.description('Resource types added to every subdomain discovery query across all domains.')
param parIncludedResourceTypesGlobal array = []

@sys.description('Resource types added to every Compute subdomain discovery query.')
param parComputeResourceTypes array = []

@sys.description('Resource types added to every Data subdomain discovery query.')
param parDataResourceTypes array = []

@sys.description('Resource types added to every Routing subdomain discovery query.')
param parRoutingResourceTypes array = []

@sys.description('Resource types added to every Ai subdomain discovery query.')
param parAiResourceTypes array = []

@sys.description('Resource types added to every Config subdomain discovery query.')
param parConfigResourceTypes array = []

@minLength(36)
@sys.description('Subscription ID whose resources the Compute domain discovery queries.')
param parComputeSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Data domain discovery queries.')
param parDataSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Routing domain discovery queries.')
param parRoutingSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Ai domain discovery queries.')
param parAiSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Config domain discovery queries.')
param parConfigSubscriptionId string = subscription().subscriptionId

@sys.description('Per-domain advanced overrides. Each key may set tagFilters and replace the built-in subdomain split.')
param parDomainOverrides object = {}

var varDefaultSubdomains = {
  compute: [
    {
      name: 'web'
      displayName: 'Web and API hosting'
      resourceTypes: [
        'Microsoft.Web/sites'
      ]
    }
    {
      name: 'containers'
      displayName: 'Container platforms'
      resourceTypes: [
        'Microsoft.App/containerApps'
        'Microsoft.ContainerService/managedClusters'
      ]
    }
    {
      name: 'vms'
      displayName: 'Virtual machines'
      resourceTypes: [
        'Microsoft.Compute/virtualMachines'
        'Microsoft.Compute/virtualMachineScaleSets'
      ]
    }
  ]
  data: [
    {
      name: 'relational'
      displayName: 'Relational databases'
      resourceTypes: [
        'Microsoft.Sql/servers'
        'Microsoft.DBforPostgreSQL/flexibleServers'
      ]
    }
    {
      name: 'nosql'
      displayName: 'NoSQL databases'
      resourceTypes: [
        'Microsoft.DocumentDB/databaseAccounts'
      ]
    }
    {
      name: 'caching'
      displayName: 'Caching'
      resourceTypes: [
        'Microsoft.Cache/redis'
      ]
    }
    {
      name: 'storage'
      displayName: 'Object storage'
      resourceTypes: [
        'Microsoft.Storage/storageAccounts'
      ]
    }
  ]
  routing: [
    {
      name: 'global-edge'
      displayName: 'Global edge'
      resourceTypes: [
        'Microsoft.Cdn/profiles'
        'Microsoft.Network/trafficManagerProfiles'
      ]
    }
    {
      name: 'regional'
      displayName: 'Regional balancing'
      resourceTypes: [
        'Microsoft.Network/applicationGateways'
        'Microsoft.Network/loadBalancers'
      ]
    }
    {
      name: 'api'
      displayName: 'API gateway'
      resourceTypes: [
        'Microsoft.ApiManagement/service'
      ]
    }
  ]
  ai: [
    {
      name: 'models'
      displayName: 'Model endpoints'
      resourceTypes: [
        'Microsoft.CognitiveServices/accounts'
      ]
    }
    {
      name: 'search'
      displayName: 'Search and retrieval'
      resourceTypes: [
        'Microsoft.Search/searchServices'
      ]
    }
    {
      name: 'ml'
      displayName: 'Machine learning workspaces'
      resourceTypes: [
        'Microsoft.MachineLearningServices/workspaces'
      ]
    }
  ]
  config: [
    {
      name: 'settings'
      displayName: 'Application settings'
      resourceTypes: [
        'Microsoft.AppConfiguration/configurationStores'
      ]
    }
    {
      name: 'secrets'
      displayName: 'Secrets and keys'
      resourceTypes: [
        'Microsoft.KeyVault/vaults'
      ]
    }
    {
      name: 'identity'
      displayName: 'Workload identity'
      resourceTypes: [
        'Microsoft.ManagedIdentity/userAssignedIdentities'
      ]
    }
  ]
}

var varDomains typDomain[] = [
  {
    name: 'compute'
    displayName: 'Compute'
    subscriptionId: parComputeSubscriptionId
    extraResourceTypes: parComputeResourceTypes
    tagFilters: parDomainOverrides.?compute.?tagFilters ?? []
    subdomains: parDomainOverrides.?compute.?subdomains ?? varDefaultSubdomains.compute
  }
  {
    name: 'data'
    displayName: 'Data'
    subscriptionId: parDataSubscriptionId
    extraResourceTypes: parDataResourceTypes
    tagFilters: parDomainOverrides.?data.?tagFilters ?? []
    subdomains: parDomainOverrides.?data.?subdomains ?? varDefaultSubdomains.data
  }
  {
    name: 'routing'
    displayName: 'Routing'
    subscriptionId: parRoutingSubscriptionId
    extraResourceTypes: parRoutingResourceTypes
    tagFilters: parDomainOverrides.?routing.?tagFilters ?? []
    subdomains: parDomainOverrides.?routing.?subdomains ?? varDefaultSubdomains.routing
  }
  {
    name: 'aiml'
    displayName: 'AI'
    subscriptionId: parAiSubscriptionId
    extraResourceTypes: parAiResourceTypes
    tagFilters: parDomainOverrides.?ai.?tagFilters ?? []
    subdomains: parDomainOverrides.?ai.?subdomains ?? varDefaultSubdomains.ai
  }
  {
    name: 'appconfig'
    displayName: 'Config'
    subscriptionId: parConfigSubscriptionId
    extraResourceTypes: parConfigResourceTypes
    tagFilters: parDomainOverrides.?config.?tagFilters ?? []
    subdomains: parDomainOverrides.?config.?subdomains ?? varDefaultSubdomains.config
  }
]

module modTopology 'healthModelTopology.bicep' = {
  name: take('hm-application-topology-${uniqueString(parHealthModelName, deployment().name)}', 64)
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
