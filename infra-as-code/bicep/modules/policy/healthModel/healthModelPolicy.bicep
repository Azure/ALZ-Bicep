targetScope = 'subscription'

metadata name = 'ALZ Bicep - CloudHealth Platform Health Model Policy'
metadata description = 'Preview (experimental): deploys a Microsoft CloudHealth platform health model through Azure Policy.'

type typTagFilter = {
  key: string
  value: string
}

@sys.description('Location for the discovery identity, policy assignment identity, and remediation deployments. Must support Microsoft.CloudHealth.')
param parLocation string = 'swedencentral'

@sys.description('Name of the existing resource group into which the platform health model is deployed.')
param parTargetResourceGroupName string = 'rg-alz-healthmodels'

@sys.description('Name of the platform health model. One model contains all four domain discovery rules.')
param parHealthModelName string = 'alz-platform-healthmodel'

@sys.description('Name of the user-assigned managed identity used by the discovery rules.')
param parIdentityName string = 'alz-healthmodel-mi'

@sys.description('Name of the custom policy definition.')
param parPolicyName string = 'Deploy-ALZ-CloudHealth-PlatformModel'

@sys.description('Name of the policy assignment.')
@maxLength(24)
param parAssignmentName string = 'Deploy-ALZ-CloudHealth'

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

@sys.description('Resource types discovered for the Security platform domain, unioned with the global list.')
param parSecurityResourceTypes array = [
  'Microsoft.KeyVault/vaults'
  'Microsoft.Network/azureFirewalls'
  'Microsoft.Network/firewallPolicies'
  'Microsoft.Network/ddosProtectionPlans'
]

@sys.description('Resource types discovered for the Connectivity platform domain, unioned with the global list.')
param parConnectivityResourceTypes array = [
  'Microsoft.Network/virtualNetworks'
  'Microsoft.Network/virtualNetworkGateways'
  'Microsoft.Network/expressRouteCircuits'
  'Microsoft.Network/publicIPAddresses'
  'Microsoft.Network/loadBalancers'
  'Microsoft.Network/applicationGateways'
  'Microsoft.Network/privateDnsZones'
  'Microsoft.Network/bastionHosts'
  'Microsoft.Network/natGateways'
  'Microsoft.Network/connections'
]

@sys.description('Resource types discovered for the Management platform domain, unioned with the global list.')
param parManagementResourceTypes array = [
  'Microsoft.OperationalInsights/workspaces'
  'Microsoft.Automation/automationAccounts'
  'Microsoft.RecoveryServices/vaults'
  'Microsoft.Storage/storageAccounts'
  'Microsoft.Insights/components'
  'Microsoft.Insights/actionGroups'
]

@sys.description('Resource types discovered for the Identity platform domain, unioned with the global list.')
param parIdentityResourceTypes array = [
  'Microsoft.ManagedIdentity/userAssignedIdentities'
  'Microsoft.Compute/virtualMachines'
  'Microsoft.KeyVault/vaults'
  'Microsoft.Network/privateDnsZones'
]

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

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Security resources.')
param parSecurityTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Connectivity resources.')
param parConnectivityTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Management resources.')
param parManagementTagFilter typTagFilter[] = []

@maxLength(5)
@sys.description('Optional list of up to five { key, value } tag pairs that must all match for Identity resources.')
param parIdentityTagFilter typTagFilter[] = []

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
var varCuaid = 'f44ef035-5331-4413-b707-325f42725e15'
var varDiscoverySubscriptionIds = union(
  [
    parSecuritySubscriptionId
    parConnectivitySubscriptionId
    parManagementSubscriptionId
    parIdentitySubscriptionId
  ],
  []
)

resource resTargetResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: parTargetResourceGroupName
}

module modDiscoveryIdentity 'healthModelDiscoveryIdentity.bicep' = {
  scope: resTargetResourceGroup
  name: 'hm-platform-identity-${uniqueString(subscription().subscriptionId, parTargetResourceGroupName, parIdentityName)}'
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
    displayName: 'Deploy a Microsoft CloudHealth platform health model with per-domain discovery rules'
    description: 'Deploys a Microsoft.CloudHealth platform health model with one discovery rule per platform domain (Security, Connectivity, Management, Identity), each discovering resources by type, when missing.'
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
          description: 'Enable (DeployIfNotExists) or turn off (Disabled) automatic deployment of the platform health model when it is missing.'
        }
      }
      targetResourceGroupName: {
        type: 'String'
        metadata: {
          displayName: 'Target resource group'
          description: 'Name of the existing resource group the platform health model is deployed into. The rule triggers on this resource group and its compliance is driven by whether the model exists here.'
        }
      }
      healthModelName: {
        type: 'String'
        metadata: {
          displayName: 'Health model name'
          description: 'Name of the Microsoft.CloudHealth health model to deploy. One model holds all four domain discovery rules.'
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
      securityResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Security resource types'
          description: 'Resource types discovered for the Security platform domain, unioned with the global list to form that domain query.'
        }
      }
      connectivityResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Connectivity resource types'
          description: 'Resource types discovered for the Connectivity platform domain, unioned with the global list to form that domain query.'
        }
      }
      managementResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Management resource types'
          description: 'Resource types discovered for the Management platform domain, unioned with the global list to form that domain query.'
        }
      }
      identityResourceTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Identity resource types'
          description: 'Resource types discovered for the Identity platform domain, unioned with the global list to form that domain query.'
        }
      }
      securitySubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Security subscription id'
          description: 'Required. Subscription id the Security domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      connectivitySubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Connectivity subscription id'
          description: 'Required. Subscription id the Connectivity domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      managementSubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Management subscription id'
          description: 'Required. Subscription id the Management domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      identitySubscriptionId: {
        type: 'String'
        metadata: {
          displayName: 'Identity subscription id'
          description: 'Required. Subscription id the Identity domain discovery query is scoped to (adds a where subscriptionId clause).'
        }
      }
      securityTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Security tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Security domain. Empty means no tag filtering.'
        }
      }
      connectivityTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Connectivity tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Connectivity domain. Empty means no tag filtering.'
        }
      }
      managementTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Management tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Management domain. Empty means no tag filtering.'
        }
      }
      identityTagFilter: {
        type: 'Array'
        metadata: {
          displayName: 'Identity tag filter'
          description: 'Optional list of { key, value } tag pairs that must all match (AND) for a resource to be discovered in the Identity domain. Empty means no tag filtering.'
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
                securityResourceTypes: {
                  value: '[parameters(\'securityResourceTypes\')]'
                }
                connectivityResourceTypes: {
                  value: '[parameters(\'connectivityResourceTypes\')]'
                }
                managementResourceTypes: {
                  value: '[parameters(\'managementResourceTypes\')]'
                }
                identityResourceTypes: {
                  value: '[parameters(\'identityResourceTypes\')]'
                }
                securitySubscriptionId: {
                  value: '[parameters(\'securitySubscriptionId\')]'
                }
                connectivitySubscriptionId: {
                  value: '[parameters(\'connectivitySubscriptionId\')]'
                }
                managementSubscriptionId: {
                  value: '[parameters(\'managementSubscriptionId\')]'
                }
                identitySubscriptionId: {
                  value: '[parameters(\'identitySubscriptionId\')]'
                }
                securityTagFilter: {
                  value: '[parameters(\'securityTagFilter\')]'
                }
                connectivityTagFilter: {
                  value: '[parameters(\'connectivityTagFilter\')]'
                }
                managementTagFilter: {
                  value: '[parameters(\'managementTagFilter\')]'
                }
                identityTagFilter: {
                  value: '[parameters(\'identityTagFilter\')]'
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
                  securityResourceTypes: {
                    type: 'array'
                  }
                  connectivityResourceTypes: {
                    type: 'array'
                  }
                  managementResourceTypes: {
                    type: 'array'
                  }
                  identityResourceTypes: {
                    type: 'array'
                  }
                  securitySubscriptionId: {
                    type: 'string'
                  }
                  connectivitySubscriptionId: {
                    type: 'string'
                  }
                  managementSubscriptionId: {
                    type: 'string'
                  }
                  identitySubscriptionId: {
                    type: 'string'
                  }
                  securityTagFilter: {
                    type: 'array'
                  }
                  connectivityTagFilter: {
                    type: 'array'
                  }
                  managementTagFilter: {
                    type: 'array'
                  }
                  identityTagFilter: {
                    type: 'array'
                  }
                }
                variables: {
                  securityTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'securityResourceTypes\'))]'
                  securityTagClause0: '[if(greater(length(parameters(\'securityTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'securityTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'securityTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  securityTagClause1: '[if(greater(length(parameters(\'securityTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'securityTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'securityTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  securityTagClause2: '[if(greater(length(parameters(\'securityTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'securityTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'securityTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  securityTagClause3: '[if(greater(length(parameters(\'securityTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'securityTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'securityTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  securityTagClause4: '[if(greater(length(parameters(\'securityTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'securityTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'securityTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  securityTagClause: '[concat(variables(\'securityTagClause0\'), variables(\'securityTagClause1\'), variables(\'securityTagClause2\'), variables(\'securityTagClause3\'), variables(\'securityTagClause4\'))]'
                  securityQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'securitySubscriptionId\'), \'\'\' | \', variables(\'securityTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'securityTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  connectivityTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'connectivityResourceTypes\'))]'
                  connectivityTagClause0: '[if(greater(length(parameters(\'connectivityTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'connectivityTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'connectivityTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  connectivityTagClause1: '[if(greater(length(parameters(\'connectivityTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'connectivityTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'connectivityTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  connectivityTagClause2: '[if(greater(length(parameters(\'connectivityTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'connectivityTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'connectivityTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  connectivityTagClause3: '[if(greater(length(parameters(\'connectivityTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'connectivityTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'connectivityTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  connectivityTagClause4: '[if(greater(length(parameters(\'connectivityTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'connectivityTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'connectivityTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  connectivityTagClause: '[concat(variables(\'connectivityTagClause0\'), variables(\'connectivityTagClause1\'), variables(\'connectivityTagClause2\'), variables(\'connectivityTagClause3\'), variables(\'connectivityTagClause4\'))]'
                  connectivityQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'connectivitySubscriptionId\'), \'\'\' | \', variables(\'connectivityTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'connectivityTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  managementTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'managementResourceTypes\'))]'
                  managementTagClause0: '[if(greater(length(parameters(\'managementTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'managementTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'managementTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  managementTagClause1: '[if(greater(length(parameters(\'managementTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'managementTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'managementTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  managementTagClause2: '[if(greater(length(parameters(\'managementTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'managementTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'managementTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  managementTagClause3: '[if(greater(length(parameters(\'managementTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'managementTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'managementTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  managementTagClause4: '[if(greater(length(parameters(\'managementTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'managementTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'managementTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  managementTagClause: '[concat(variables(\'managementTagClause0\'), variables(\'managementTagClause1\'), variables(\'managementTagClause2\'), variables(\'managementTagClause3\'), variables(\'managementTagClause4\'))]'
                  managementQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'managementSubscriptionId\'), \'\'\' | \', variables(\'managementTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'managementTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
                  identityTypes: '[union(parameters(\'includedResourceTypesGlobal\'), parameters(\'identityResourceTypes\'))]'
                  identityTagClause0: '[if(greater(length(parameters(\'identityTagFilter\')), 0), concat(\'where tags[\'\'\', parameters(\'identityTagFilter\')[0].key, \'\'\'] =~ \'\'\', parameters(\'identityTagFilter\')[0].value, \'\'\' | \'), \'\')]'
                  identityTagClause1: '[if(greater(length(parameters(\'identityTagFilter\')), 1), concat(\'where tags[\'\'\', parameters(\'identityTagFilter\')[1].key, \'\'\'] =~ \'\'\', parameters(\'identityTagFilter\')[1].value, \'\'\' | \'), \'\')]'
                  identityTagClause2: '[if(greater(length(parameters(\'identityTagFilter\')), 2), concat(\'where tags[\'\'\', parameters(\'identityTagFilter\')[2].key, \'\'\'] =~ \'\'\', parameters(\'identityTagFilter\')[2].value, \'\'\' | \'), \'\')]'
                  identityTagClause3: '[if(greater(length(parameters(\'identityTagFilter\')), 3), concat(\'where tags[\'\'\', parameters(\'identityTagFilter\')[3].key, \'\'\'] =~ \'\'\', parameters(\'identityTagFilter\')[3].value, \'\'\' | \'), \'\')]'
                  identityTagClause4: '[if(greater(length(parameters(\'identityTagFilter\')), 4), concat(\'where tags[\'\'\', parameters(\'identityTagFilter\')[4].key, \'\'\'] =~ \'\'\', parameters(\'identityTagFilter\')[4].value, \'\'\' | \'), \'\')]'
                  identityTagClause: '[concat(variables(\'identityTagClause0\'), variables(\'identityTagClause1\'), variables(\'identityTagClause2\'), variables(\'identityTagClause3\'), variables(\'identityTagClause4\'))]'
                  identityQuery: '[concat(\'resources | where subscriptionId =~ \'\'\', parameters(\'identitySubscriptionId\'), \'\'\' | \', variables(\'identityTagClause\'), \'where type in~ (\', concat(\'\'\'\', join(variables(\'identityTypes\'), \'\'\',\'\'\'), \'\'\'\'), \') | project id\')]'
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
                    name: '[format(\'{0}/discover-security\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Security platform resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'securityQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-connectivity\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Connectivity platform resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'connectivityQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-management\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Management platform resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'managementQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/discoveryrules'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/discover-identity\', parameters(\'healthModelName\'))]'
                    properties: {
                      displayName: 'Identity platform resources'
                      authenticationSetting: '[parameters(\'authenticationSettingName\')]'
                      addRecommendedSignals: 'Enabled'
                      addResourceHealthSignal: 'Enabled'
                      discoverRelationships: 'Enabled'
                      specification: {
                        kind: 'ResourceGraphQuery'
                        resourceGraphQuery: '[variables(\'identityQuery\')]'
                      }
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/authenticationsettings\', parameters(\'healthModelName\'), parameters(\'authenticationSettingName\'))]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-security\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-security'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-security\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-connectivity\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-connectivity'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-connectivity\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-management\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-management'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-management\')]'
                    ]
                  }
                  {
                    type: 'Microsoft.CloudHealth/healthmodels/relationships'
                    apiVersion: '2026-05-01-preview'
                    name: '[format(\'{0}/root-to-discover-identity\', parameters(\'healthModelName\'))]'
                    properties: {
                      parentEntityName: '[parameters(\'healthModelName\')]'
                      childEntityName: 'discover-identity'
                    }
                    dependsOn: [
                      '[resourceId(\'Microsoft.CloudHealth/healthmodels/discoveryrules\', parameters(\'healthModelName\'), \'discover-identity\')]'
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
    displayName: 'Deploy CloudHealth platform health model with per-domain discovery'
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
      securityResourceTypes: {
        value: parSecurityResourceTypes
      }
      connectivityResourceTypes: {
        value: parConnectivityResourceTypes
      }
      managementResourceTypes: {
        value: parManagementResourceTypes
      }
      identityResourceTypes: {
        value: parIdentityResourceTypes
      }
      securitySubscriptionId: {
        value: parSecuritySubscriptionId
      }
      connectivitySubscriptionId: {
        value: parConnectivitySubscriptionId
      }
      managementSubscriptionId: {
        value: parManagementSubscriptionId
      }
      identitySubscriptionId: {
        value: parIdentitySubscriptionId
      }
      securityTagFilter: {
        value: parSecurityTagFilter
      }
      connectivityTagFilter: {
        value: parConnectivityTagFilter
      }
      managementTagFilter: {
        value: parManagementTagFilter
      }
      identityTagFilter: {
        value: parIdentityTagFilter
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
