metadata name = 'ALZ Bicep - CloudHealth Health Model Topology'
metadata description = 'Preview (experimental): deploys a Microsoft CloudHealth health model with domain grouping entities and one discovery rule per subdomain.'

@export()
@sys.description('A { key, value } tag pair that a discovered resource must match.')
type typTagFilter = {
  key: string
  value: string
}

@export()
@sys.description('A subdomain discovered by its own discovery rule and grouped under its parent domain.')
type typSubdomain = {
  name: string
  displayName: string
  resourceTypes: string[]
}

@export()
@sys.description('A domain grouping entity, its discovery scope, and its subdomains.')
type typDomain = {
  name: string
  displayName: string
  subscriptionId: string
  tagFilters: typTagFilter[]
  extraResourceTypes: string[]
  subdomains: typSubdomain[]
}

@sys.description('Name of the health model. The root entity is declared with this exact name so the definition manages the provider built-in root.')
param parHealthModelName string

@sys.description('Location for the health model. Must support Microsoft.CloudHealth.')
param parLocation string

@sys.description('Name of the managed-identity authentication setting.')
param parAuthenticationSettingName string = 'managed-identity'

@sys.description('Resource types added to every subdomain discovery query and unioned with each subdomain list.')
param parIncludedResourceTypesGlobal array = []

@sys.description('Domains, each with its discovery scope and subdomains.')
param parDomains typDomain[]

var varSubdomains = flatten(
  map(
    parDomains,
    domain =>
      map(
        domain.subdomains,
        subdomain => {
          name: '${domain.name}-${subdomain.name}'
          displayName: subdomain.displayName
          domainName: domain.name
          query: 'resources | where subscriptionId =~ \'${domain.subscriptionId}\' | ${join(map(domain.tagFilters, tagFilter => 'where tags[\'${tagFilter.key}\'] =~ \'${tagFilter.value}\' | '), '')}where type in~ (\'${join(union(union(parIncludedResourceTypesGlobal, domain.extraResourceTypes), subdomain.resourceTypes), '\',\'')}\') | project id'
        }
      )
  )
)

var varDomainNames = map(parDomains, domain => domain.name)

resource resHealthModel 'Microsoft.CloudHealth/healthmodels@2026-05-01-preview' = {
  name: parHealthModelName
  location: parLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource resAuthenticationSetting 'Microsoft.CloudHealth/healthmodels/authenticationsettings@2026-05-01-preview' = {
  parent: resHealthModel
  name: parAuthenticationSettingName
  properties: {
    displayName: 'Managed identity'
    authenticationKind: 'ManagedIdentity'
    managedIdentityName: 'SystemAssigned'
  }
}

// Declared with the model name so this definition manages the provider built-in root
// entity instead of creating a second, childless root.
resource resRootEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: resHealthModel
  name: parHealthModelName
  properties: {
    displayName: parHealthModelName
    signalGroups: {
      dependencies: {
        aggregationType: 'WorstOf'
      }
    }
  }
}

resource resDomainEntities 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = [
  for domain in parDomains: {
    parent: resHealthModel
    name: domain.name
    properties: {
      displayName: domain.displayName
      signalGroups: {
        dependencies: {
          aggregationType: 'WorstOf'
        }
      }
    }
  }
]

resource resSubdomainDiscoveryRules 'Microsoft.CloudHealth/healthmodels/discoveryrules@2026-05-01-preview' = [
  for subdomain in varSubdomains: {
    parent: resHealthModel
    name: subdomain.name
    properties: {
      displayName: subdomain.displayName
      authenticationSetting: resAuthenticationSetting.name
      addRecommendedSignals: 'Enabled'
      addResourceHealthSignal: 'Enabled'
      discoverRelationships: 'Enabled'
      specification: {
        kind: 'ResourceGraphQuery'
        resourceGraphQuery: subdomain.query
      }
    }
  }
]

resource resRootToDomain 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = [
  for (domain, index) in parDomains: {
    parent: resHealthModel
    name: 'r-${parHealthModelName}-${domain.name}'
    properties: {
      parentEntityName: resRootEntity.name
      childEntityName: resDomainEntities[index].name
    }
  }
]

resource resDomainToSubdomain 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = [
  for (subdomain, index) in varSubdomains: {
    parent: resHealthModel
    name: 'r-${subdomain.domainName}-${subdomain.name}'
    properties: {
      parentEntityName: resDomainEntities[indexOf(varDomainNames, subdomain.domainName)].name
      childEntityName: resSubdomainDiscoveryRules[index].name
    }
  }
]

@sys.description('Name of the deployed health model.')
output outHealthModelName string = resHealthModel.name

@sys.description('Assembled discovery queries, one per subdomain, for verification.')
output outSubdomainQueries array = map(varSubdomains, subdomain => {
  name: subdomain.name
  query: subdomain.query
})
