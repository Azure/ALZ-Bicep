targetScope = 'subscription'

metadata name = 'ALZ Bicep - CloudHealth Application Landing Zone Health Model Policy'
metadata description = 'Preview (experimental): deploys a Microsoft CloudHealth application landing zone health model through Azure Policy.'

type typTagFilter = {
  key: string
  value: string
}

@sys.description('Location for the discovery identity, policy assignment identity, and remediation deployments. Must support Microsoft.CloudHealth.')
param parLocation string = 'swedencentral'

@sys.description('Name of the existing resource group into which the application landing zone health model is deployed.')
param parTargetResourceGroupName string = 'rg-application-healthmodels'

@sys.description('Name of the application landing zone health model. One model contains all five domain discovery rules.')
param parHealthModelName string = 'alz-application-healthmodel'

@sys.description('Name of the user-assigned managed identity used by the discovery rules.')
param parIdentityName string = 'alz-application-healthmodel-mi'

@sys.description('Name of the custom policy definition.')
param parPolicyName string = 'Deploy-App-CloudHealth-ApplicationModel'

@sys.description('Name of the policy assignment.')
@maxLength(24)
param parAssignmentName string = 'Deploy-App-CloudHealth'

@sys.description('Preview (experimental). Deploy the health model through policy remediation. Defaults to true. Set to false only to pause remediation while keeping the policy, identities, and RBAC deployed with a Disabled effect.')
param parDeployHealthModel bool = true

@sys.description('Opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

@allowed([
  'Default'
  'DoNotEnforce'
])
@sys.description('Enforcement mode for the policy assignment.')
param parEnforcementMode string = 'Default'

@sys.description('Resource types added to every domain discovery query and unioned with each per-domain list.')
param parIncludedResourceTypesGlobal array = []

@sys.description('Resource types discovered for the Compute application domain, unioned with the global list.')
param parComputeResourceTypes array = [
  'Microsoft.Web/sites'
  'Microsoft.App/containerApps'
  'Microsoft.ContainerService/managedClusters'
  'Microsoft.Compute/virtualMachines'
  'Microsoft.Compute/virtualMachineScaleSets'
]

@sys.description('Resource types discovered for the Data application domain, unioned with the global list.')
param parDataResourceTypes array = [
  'Microsoft.Storage/storageAccounts'
  'Microsoft.DocumentDB/databaseAccounts'
  'Microsoft.Sql/servers'
  'Microsoft.DBforPostgreSQL/flexibleServers'
  'Microsoft.Cache/redis'
]

@sys.description('Resource types discovered for the Routing application domain, unioned with the global list.')
param parRoutingResourceTypes array = [
  'Microsoft.Cdn/profiles'
  'Microsoft.Network/applicationGateways'
  'Microsoft.Network/loadBalancers'
  'Microsoft.Network/trafficManagerProfiles'
  'Microsoft.ApiManagement/service'
]

@sys.description('Resource types discovered for the AI application domain, unioned with the global list.')
param parAiResourceTypes array = [
  'Microsoft.CognitiveServices/accounts'
  'Microsoft.Search/searchServices'
  'Microsoft.MachineLearningServices/workspaces'
]

@sys.description('Resource types discovered for the Config application domain, unioned with the global list.')
param parConfigResourceTypes array = [
  'Microsoft.AppConfiguration/configurationStores'
  'Microsoft.KeyVault/vaults'
  'Microsoft.ManagedIdentity/userAssignedIdentities'
]

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
@sys.description('Subscription ID whose resources the AI domain discovery queries.')
param parAiSubscriptionId string = subscription().subscriptionId

@minLength(36)
@sys.description('Subscription ID whose resources the Config domain discovery queries.')
param parConfigSubscriptionId string = subscription().subscriptionId

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Compute resources.')
param parComputeTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Data resources.')
param parDataTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Routing resources.')
param parRoutingTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for AI resources.')
param parAiTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Config resources.')
param parConfigTagFilter typTagFilter[] = []

var varBuiltInRoleIds = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  ManagedIdentityOperator: 'f1a07417-d97a-45cb-824c-7a7467783830'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

var varRemediationRoleIds = {
  Contributor: varBuiltInRoleIds.Contributor
  ManagedIdentityOperator: varBuiltInRoleIds.ManagedIdentityOperator
}

var varAuthenticationSettingName = 'managed-identity'
var varPolicyEffect = parDeployHealthModel ? 'DeployIfNotExists' : 'Disabled'
var varCuaid = '84c647e7-3b04-458d-b0e9-eccef38de3ec'
var varDiscoverySubscriptionIds = union(
  [
    parComputeSubscriptionId
    parDataSubscriptionId
    parRoutingSubscriptionId
    parAiSubscriptionId
    parConfigSubscriptionId
  ],
  []
)

resource resTargetResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: parTargetResourceGroupName
}

module modDiscoveryIdentity 'healthModelDiscoveryIdentity.bicep' = {
  scope: resTargetResourceGroup
  name: 'hm-application-identity-${uniqueString(subscription().subscriptionId, parTargetResourceGroupName, parIdentityName)}'
  params: {
    parIdentityName: parIdentityName
    parLocation: parLocation
  }
}

module modDiscoverySubscriptionReader '../../roleAssignments/roleAssignmentSubscription.bicep' = [
  for discoverySubscriptionId in varDiscoverySubscriptionIds: {
    scope: subscription(discoverySubscriptionId)
    name: 'health-model-reader-${uniqueString(discoverySubscriptionId, parIdentityName)}'
    params: {
      parRoleAssignmentNameGuid: guid(
        discoverySubscriptionId,
        varBuiltInRoleIds.Reader,
        modDiscoveryIdentity.outputs.outPrincipalId
      )
      parRoleDefinitionId: varBuiltInRoleIds.Reader
      parAssigneePrincipalType: 'ServicePrincipal'
      parAssigneeObjectId: modDiscoveryIdentity.outputs.outPrincipalId
      parTelemetryOptOut: parTelemetryOptOut
    }
  }
]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parPolicyName)}'
  params: {}
}

resource resPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2026-06-01' = {
  name: parPolicyName
  properties: {
    displayName: 'Deploy a Microsoft CloudHealth application landing zone health model with per-domain discovery rules'
    description: 'Deploys a Microsoft.CloudHealth application landing zone health model with one discovery rule per application domain (Compute, Data, Routing, AI, Config), each discovering resources by type, when missing.'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Monitoring'
      version: '1.0.0'
      preview: true
    }
    parameters: {
      effect: {
        type: 'String'
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        metadata: {
          displayName: 'Effect'
          description: 'Enable (DeployIfNotExists) or turn off (Disabled) automatic deployment of the application landing zone health model when it is missing.'
        }
      }
      targetResourceGroupName: {
        type: 'String'
        metadata: {
          displayName: 'Target resource group'
          description: 'Name of the existing resource group the application landing zone health model is deployed into. The rule triggers on this resource group and its compliance is driven by whether the model exists here.'
        }
      }
      healthModelName: {
        type: 'String'
        metadata: {
          displayName: 'Health model name'
          description: 'Name of the Microsoft.CloudHealth health model to deploy. One model holds all five domain discovery rules.'
        }
      }
      location: {
        type: 'String'
        metadata: {
          displayName: 'Location'
          description: 'Azure region for the health model and remediation deployment. Must support Microsoft.CloudHealth (for example uksouth, centralus, swedencentral, northeurope).'
        }
      }
      userAssignedIdentityId: {
        type: 'String'
        metadata: {
          displayName: 'Discovery identity id'
          description: 'Resource id of the user-assigned managed identity the discovery rules run as. Set automatically from the identity module; its read scope determines which subscriptions discovery can see.'
        }
      }
      authenticationSettingName: {
        type: 'String'
        metadata: {
          displayName: 'Authentication setting name'
          description: 'Name of the health model authentication setting that binds the discovery identity to the model.'
        }
      }
      includedResourceTypesGlobal: {
        type: 'Array'
        metadata: {
          displayName: 'Global included resource types'
          description: 'Resource types added to every domain discovery query, unioned with each per-domain list. Empty by default; use it to add one type across all domains.'
        }
      }
      computeResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Compute resource types'
          description: 'Resource types discovered for the Compute application domain, unioned with the global list to form that domain query.'
        }
      }
      dataResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Data resource types'
          description: 'Resource types discovered for the Data application domain, unioned with the global list to form that domain query.'
        }
      }
      routingResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Routing resource types'
          description: 'Resource types discovered for the Routing application domain, unioned with the global list to form that domain query.'
        }
      }
      aiResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'AI resource types'
          description: 'Resource types discovered for the AI application domain, unioned with the global list to form that domain query.'
        }
      }
      configResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Config resource types'
          description: 'Resource types discovered for the Config application domain, unioned with the global list to form that domain query.'
        }
      }
      computeSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Compute subscription id'
          description: 'Required. Subscription id the Compute domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      dataSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Data subscription id'
          description: 'Required. Subscription id the Data domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      routingSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Routing subscription id'
          description: 'Required. Subscription id the Routing domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      aiSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'AI subscription id'
          description: 'Required. Subscription id the AI domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      configSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Config subscription id'
          description: 'Required. Subscription id the Config domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      computeTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Compute tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Compute domain. Empty means no tag filtering.'
        }
      }
      dataTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Data tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Data domain. Empty means no tag filtering.'
        }
      }
      routingTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Routing tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Routing domain. Empty means no tag filtering.'
        }
      }
      aiTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'AI tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the AI domain. Empty means no tag filtering.'
        }
      }
      configTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Config tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Config domain. Empty means no tag filtering.'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            field: 'name'
            equals: '[parameters(\'targetResourceGroupName\')]'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
        details: {
          type: 'Microsoft.CloudHealth/healthmodels'
          name: '[parameters(\'healthModelName\')]'
          existenceScope: 'resourceGroup'
          deploymentScope: 'resourceGroup'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/${varBuiltInRoleIds.Contributor}'
            '/providers/Microsoft.Authorization/roleDefinitions/${varBuiltInRoleIds.ManagedIdentityOperator}'
          ]
          deployment: {
            properties: {
              mode: 'Incremental'
              parameters: {
                healthModelName: {
                  value: '[parameters(\'healthModelName\')]'
                }
                location: {
                  value: '[parameters(\'location\')]'
                }
                userAssignedIdentityId: {
                  value: '[parameters(\'userAssignedIdentityId\')]'
                }
                authenticationSettingName: {
                  value: '[parameters(\'authenticationSettingName\')]'
                }
                includedResourceTypesGlobal: {
                  value: '[parameters(\'includedResourceTypesGlobal\')]'
                }
                computeResourceTypes: {
                  value: '[parameters(\'computeResourceTypes\')]'
                }
                dataResourceTypes: {
                  value: '[parameters(\'dataResourceTypes\')]'
                }
                routingResourceTypes: {
                  value: '[parameters(\'routingResourceTypes\')]'
                }
                aiResourceTypes: {
                  value: '[parameters(\'aiResourceTypes\')]'
                }
                configResourceTypes: {
                  value: '[parameters(\'configResourceTypes\')]'
                }
                computeSubscriptionId: {
                  value: '[parameters(\'computeSubscriptionId\')]'
                }
                dataSubscriptionId: {
                  value: '[parameters(\'dataSubscriptionId\')]'
                }
                routingSubscriptionId: {
                  value: '[parameters(\'routingSubscriptionId\')]'
                }
                aiSubscriptionId: {
                  value: '[parameters(\'aiSubscriptionId\')]'
                }
                configSubscriptionId: {
                  value: '[parameters(\'configSubscriptionId\')]'
                }
                computeTagFilter: {
                  value: '[parameters(\'computeTagFilter\')]'
                }
                dataTagFilter: {
                  value: '[parameters(\'dataTagFilter\')]'
                }
                routingTagFilter: {
                  value: '[parameters(\'routingTagFilter\')]'
                }
                aiTagFilter: {
                  value: '[parameters(\'aiTagFilter\')]'
                }
                configTagFilter: {
                  value: '[parameters(\'configTagFilter\')]'
                }
              }
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  healthModelName: {
                    type: 'string'
                  }
                  location: {
                    type: 'string'
                  }
                  userAssignedIdentityId: {
                    type: 'string'
                  }
                  authenticationSettingName: {
                    type: 'string'
                  }
                  includedResourceTypesGlobal: {
                    type: 'array'
                  }
                  computeResourceTypes: {
                    type: 'array'
                  }
                  dataResourceTypes: {
                    type: 'array'
                  }
                  routingResourceTypes: {
                    type: 'array'
                  }
                  aiResourceTypes: {
                    type: 'array'
                  }
                  configResourceTypes: {
                    type: 'array'
                  }
                  computeSubscriptionId: {
                    type: 'string'
                  }
                  dataSubscriptionId: {
                    type: 'string'
                  }
                  routingSubscriptionId: {
                    type: 'string'
                  }
                  aiSubscriptionId: {
                    type: 'string'
                  }
                  configSubscriptionId: {
                    type: 'string'
                  }
                  computeTagFilter: {
                    type: 'array'
                  }
                  dataTagFilter: {
                    type: 'array'
                  }
                  routingTagFilter: {
                    type: 'array'
                  }
                  aiTagFilter: {
                    type: 'array'
                  }
                  configTagFilter: {
                    type: 'array'
                  }
                }
                variables: {
                  computeTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'computeResourceTypes\'))]'
                  computeTagClause0: '[if(greater(length(parameters(\'computeTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'computeTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'computeTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  computeTagClause1: '[if(greater(length(parameters(\'computeTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'computeTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'computeTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  computeTagClause2: '[if(greater(length(parameters(\'computeTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'computeTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'computeTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  computeTagClause3: '[if(greater(length(parameters(\'computeTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'computeTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'computeTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  computeTagClause4: '[if(greater(length(parameters(\'computeTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'computeTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'computeTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  computeTagClause: '[concat(variables(\'computeTagClause0\'), variables(\'computeTagClause1\'), variables(\'computeTagClause2\'), variables(\'computeTagClause3\'), variables(\'computeTagClause4\'))]'
                  computeQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'computeSubscriptionId\'), \'\'\' | \', variables(\'computeTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'computeTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  dataTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'dataResourceTypes\'))]'
                  dataTagClause0: '[if(greater(length(parameters(\'dataTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'dataTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'dataTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  dataTagClause1: '[if(greater(length(parameters(\'dataTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'dataTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'dataTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  dataTagClause2: '[if(greater(length(parameters(\'dataTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'dataTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'dataTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  dataTagClause3: '[if(greater(length(parameters(\'dataTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'dataTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'dataTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  dataTagClause4: '[if(greater(length(parameters(\'dataTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'dataTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'dataTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  dataTagClause: '[concat(variables(\'dataTagClause0\'), variables(\'dataTagClause1\'), variables(\'dataTagClause2\'), variables(\'dataTagClause3\'), variables(\'dataTagClause4\'))]'
                  dataQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'dataSubscriptionId\'), \'\'\' | \', variables(\'dataTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'dataTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  routingTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'routingResourceTypes\'))]'
                  routingTagClause0: '[if(greater(length(parameters(\'routingTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'routingTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'routingTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  routingTagClause1: '[if(greater(length(parameters(\'routingTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'routingTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'routingTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  routingTagClause2: '[if(greater(length(parameters(\'routingTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'routingTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'routingTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  routingTagClause3: '[if(greater(length(parameters(\'routingTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'routingTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'routingTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  routingTagClause4: '[if(greater(length(parameters(\'routingTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'routingTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'routingTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  routingTagClause: '[concat(variables(\'routingTagClause0\'), variables(\'routingTagClause1\'), variables(\'routingTagClause2\'), variables(\'routingTagClause3\'), variables(\'routingTagClause4\'))]'
                  routingQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'routingSubscriptionId\'), \'\'\' | \', variables(\'routingTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'routingTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  aiTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'aiResourceTypes\'))]'
                  aiTagClause0: '[if(greater(length(parameters(\'aiTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'aiTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'aiTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  aiTagClause1: '[if(greater(length(parameters(\'aiTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'aiTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'aiTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  aiTagClause2: '[if(greater(length(parameters(\'aiTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'aiTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'aiTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  aiTagClause3: '[if(greater(length(parameters(\'aiTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'aiTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'aiTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  aiTagClause4: '[if(greater(length(parameters(\'aiTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'aiTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'aiTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  aiTagClause: '[concat(variables(\'aiTagClause0\'), variables(\'aiTagClause1\'), variables(\'aiTagClause2\'), variables(\'aiTagClause3\'), variables(\'aiTagClause4\'))]'
                  aiQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'aiSubscriptionId\'), \'\'\' | \', variables(\'aiTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'aiTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  configTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'configResourceTypes\'))]'
                  configTagClause0: '[if(greater(length(parameters(\'configTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'configTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'configTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  configTagClause1: '[if(greater(length(parameters(\'configTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'configTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'configTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  configTagClause2: '[if(greater(length(parameters(\'configTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'configTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'configTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  configTagClause3: '[if(greater(length(parameters(\'configTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'configTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'configTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  configTagClause4: '[if(greater(length(parameters(\'configTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'configTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'configTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  configTagClause: '[concat(variables(\'configTagClause0\'), variables(\'configTagClause1\'), variables(\'configTagClause2\'), variables(\'configTagClause3\'), variables(\'configTagClause4\'))]'
                  configQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'configSubscriptionId\'), \'\'\' | \', variables(\'configTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'configTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                }
                resources: [
                  {
                    type: 'Microsoft.CloudHealth/healthmodels'
                    apiVersion: '2026-05-01-preview'
                    name: '[parameters(\'healthModelName\')]'
                    location: '[parameters(\'location\')]'
                    identity: {
                      type: 'UserAssigned'
                      userAssignedIdentities: {
                        '[parameters(\'userAssignedIdentityId\')]': {}
                      }
                    }
                    properties: {}
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/authenticationsettings'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/{1}\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    properties: {
                      authenticationKind: 'ManagedIdentity'
                      managedIdentityName: '[parameters(\'userAssignedIdentityId\')]'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels\', parameters(\'healthModelName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-compute\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Compute application resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'computeQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-data\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Data application resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'dataQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-routing\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Routing application resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'routingQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-ai\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'AI application resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'aiQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-config\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Config application resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'configQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-compute\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-compute'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-compute\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-data\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-data'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-data\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-routing\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-routing'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-routing\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-ai\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-ai'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-ai\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-config\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-config'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-config\')]'
                    ]
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2026-06-01' = {
  name: parAssignmentName
  location: parLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Deploy CloudHealth application landing zone health model with per-domain discovery'
    policyDefinitionId: resPolicyDefinition.id
    enforcementMode: parEnforcementMode
    parameters: {
      effect: {
        value: varPolicyEffect
      }
      targetResourceGroupName: {
        value: parTargetResourceGroupName
      }
      healthModelName: {
        value: parHealthModelName
      }
      location: {
        value: parLocation
      }
      userAssignedIdentityId: {
        value: modDiscoveryIdentity.outputs.outIdentityId
      }
      authenticationSettingName: {
        value: varAuthenticationSettingName
      }
      includedResourceTypesGlobal: {
        value: parIncludedResourceTypesGlobal
      }
      computeResourceTypes: {
        value: parComputeResourceTypes
      }
      dataResourceTypes: {
        value: parDataResourceTypes
      }
      routingResourceTypes: {
        value: parRoutingResourceTypes
      }
      aiResourceTypes: {
        value: parAiResourceTypes
      }
      configResourceTypes: {
        value: parConfigResourceTypes
      }
      computeSubscriptionId: {
        value: parComputeSubscriptionId
      }
      dataSubscriptionId: {
        value: parDataSubscriptionId
      }
      routingSubscriptionId: {
        value: parRoutingSubscriptionId
      }
      aiSubscriptionId: {
        value: parAiSubscriptionId
      }
      configSubscriptionId: {
        value: parConfigSubscriptionId
      }
      computeTagFilter: {
        value: parComputeTagFilter
      }
      dataTagFilter: {
        value: parDataTagFilter
      }
      routingTagFilter: {
        value: parRoutingTagFilter
      }
      aiTagFilter: {
        value: parAiTagFilter
      }
      configTagFilter: {
        value: parConfigTagFilter
      }
    }
  }
}

resource resRemediationRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in items(varRemediationRoleIds): {
    name: guid(subscription().id, parAssignmentName, role.value)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.value)
      principalId: resPolicyAssignment.identity.principalId
      principalType: 'ServicePrincipal'
    }
  }
]

@sys.description('Resource ID of the custom policy definition.')
output outPolicyDefinitionId string = resPolicyDefinition.id

@sys.description('Resource ID of the policy assignment.')
output outPolicyAssignmentId string = resPolicyAssignment.id

@sys.description('Resource ID of the discovery user-assigned managed identity.')
output outDiscoveryIdentityId string = modDiscoveryIdentity.outputs.outIdentityId
