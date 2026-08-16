targetScope = 'subscription'

metadata name = 'ALZ Bicep - CloudHealth Platform Health Model Policy'
metadata description = 'Preview (experimental): deploys a Microsoft CloudHealth platform health model through Azure Policy.'

@sys.description('Location for the policy assignment identity, remediation deployment, target resource group, and health model. Must support Microsoft.CloudHealth.')
param parLocation string = 'swedencentral'

@sys.description('Name of the resource group the remediation creates when needed and deploys the platform health model into.')
param parTargetResourceGroupName string = 'rg-alz-healthmodels'

@sys.description('Name of the platform health model. One model contains all four domain discovery rules.')
param parHealthModelName string = 'alz-platform-healthmodel'

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

@sys.description('Advanced per-domain overrides. Each domain key may set tagFilters (up to five { key, value } pairs, ANDed) and subdomains to replace the built-in subdomain split. Leave empty to use the built-in taxonomy with no tag filtering.')
param parDomainOverrides object = {}

var varBuiltInRoleIds = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  RoleBasedAccessControlAdministrator: 'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

var varRemediationRoleIds = {
  Contributor: varBuiltInRoleIds.Contributor
  RoleBasedAccessControlAdministrator: varBuiltInRoleIds.RoleBasedAccessControlAdministrator
}

var varAuthenticationSettingName = 'managed-identity'
var varPolicyEffect = parDeployHealthModel ? 'DeployIfNotExists' : 'Disabled'
var varCuaid = 'f44ef035-5331-4413-b707-325f42725e15'
var varPlatformTopology = json(loadTextContent('policy_healthModelPlatformTopology.json'))

var varPlatformSubscriptionDeploymentTemplate = {
  '$schema': 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
  contentVersion: '1.0.0.0'
  parameters: {
    targetResourceGroupName: {
      type: 'string'
    }
    parHealthModelName: {
      type: 'string'
    }
    parLocation: {
      type: 'string'
    }
    parAuthenticationSettingName: {
      type: 'string'
      defaultValue: 'managed-identity'
    }
    parIncludedResourceTypesGlobal: {
      type: 'array'
      defaultValue: []
    }
    parDomainOverrides: {
      type: 'object'
      defaultValue: {}
    }
    parSecurityResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parConnectivityResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parManagementResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parIdentityResourceTypes: {
      type: 'array'
      defaultValue: []
    }
  }
  variables: {
    readerRoleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    topologyDeploymentName: '[format(\'deploy-{0}-topology\', parameters(\'parHealthModelName\'))]'
  }
  resources: [
    {
      type: 'Microsoft.Resources/resourceGroups'
      apiVersion: '2025-04-01'
      name: '[parameters(\'targetResourceGroupName\')]'
      location: '[parameters(\'parLocation\')]'
      properties: {}
    }
    {
      type: 'Microsoft.Resources/deployments'
      apiVersion: '2022-09-01'
      name: '[variables(\'topologyDeploymentName\')]'
      resourceGroup: '[parameters(\'targetResourceGroupName\')]'
      dependsOn: [
        '[subscriptionResourceId(\'Microsoft.Resources/resourceGroups\', parameters(\'targetResourceGroupName\'))]'
      ]
      properties: {
        mode: 'Incremental'
        parameters: {
              parHealthModelName: {
                value: '[parameters(\'parHealthModelName\')]'
              }
              parLocation: {
                value: '[parameters(\'parLocation\')]'
              }
              parAuthenticationSettingName: {
                value: '[parameters(\'parAuthenticationSettingName\')]'
              }
              parIncludedResourceTypesGlobal: {
                value: '[parameters(\'parIncludedResourceTypesGlobal\')]'
              }
              parDomainOverrides: {
                value: '[parameters(\'parDomainOverrides\')]'
              }
              parSecurityResourceTypes: {
                value: '[parameters(\'parSecurityResourceTypes\')]'
              }
              parConnectivityResourceTypes: {
                value: '[parameters(\'parConnectivityResourceTypes\')]'
              }
              parManagementResourceTypes: {
                value: '[parameters(\'parManagementResourceTypes\')]'
              }
              parIdentityResourceTypes: {
                value: '[parameters(\'parIdentityResourceTypes\')]'
              }
        }
        template: varPlatformTopology
      }
    }
    {
      type: 'Microsoft.Authorization/roleAssignments'
      apiVersion: '2022-04-01'
      name: '[guid(subscription().id, parameters(\'parHealthModelName\'), variables(\'readerRoleDefinitionId\'))]'
      dependsOn: [
        '[resourceId(parameters(\'targetResourceGroupName\'), \'Microsoft.Resources/deployments\', variables(\'topologyDeploymentName\'))]'
      ]
      properties: {
        roleDefinitionId: '[subscriptionResourceId(\'Microsoft.Authorization/roleDefinitions\', variables(\'readerRoleDefinitionId\'))]'
        principalId: '[reference(resourceId(parameters(\'targetResourceGroupName\'), \'Microsoft.CloudHealth/healthmodels\', parameters(\'parHealthModelName\')), \'2026-05-01-preview\', \'Full\').identity.principalId]'
        principalType: 'ServicePrincipal'
      }
    }
  ]
}

var varPlatformPolicyDefinitionProperties = {
  displayName: 'Deploy a Microsoft CloudHealth platform health model with per-domain discovery rules'
  description: 'Deploys a Microsoft.CloudHealth platform health model with one discovery rule per platform domain (Security, Connectivity, Management, Identity), each discovering resources by type, when missing.'
  policyType: 'Custom'
  mode: 'All'
  metadata: {
    category: 'Monitoring'
    version: '1.0.0'
    preview: true
    alzCloudEnvironments: [
      'AzureCloud'
    ]
    source: 'https://github.com/Azure/ALZ-Bicep'
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
        strongType: 'resourceTypes'
        displayName: 'Global included resource types'
        description: 'Resource types added to every domain discovery query, unioned with each per-domain list. Empty by default; use it to add one type across all domains.'
      }
    }
    securityResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Security resource types'
        description: 'Resource types discovered for the Security platform domain, unioned with the global list to form that domain query.'
      }
    }
    connectivityResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Connectivity resource types'
        description: 'Resource types discovered for the Connectivity platform domain, unioned with the global list to form that domain query.'
      }
    }
    managementResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Management resource types'
        description: 'Resource types discovered for the Management platform domain, unioned with the global list to form that domain query.'
      }
    }
    identityResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Identity resource types'
        description: 'Resource types discovered for the Identity platform domain, unioned with the global list to form that domain query.'
      }
    }
    domainOverrides: {
      type: 'Object'
      defaultValue: {}
      metadata: {
        displayName: 'Domain overrides (advanced)'
        description: 'Advanced per-domain overrides. Each domain key may set tagFilters (up to five { key, value } pairs, ANDed) and subdomains to replace the built-in subdomain split. Leave empty to use the built-in taxonomy with no tag filtering.'
      }
      schema: {
        type: 'object'
        additionalProperties: false
        properties: {
          security: {
            type: 'object'
            additionalProperties: false
            properties: {
              tagFilters: {
                type: 'array'
                maxItems: 5
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'key'
                    'value'
                  ]
                  properties: {
                    key: {
                      type: 'string'
                    }
                    value: {
                      type: 'string'
                    }
                  }
                }
              }
              subdomains: {
                type: 'array'
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'name'
                    'displayName'
                    'resourceTypes'
                  ]
                  properties: {
                    name: {
                      type: 'string'
                    }
                    displayName: {
                      type: 'string'
                    }
                    resourceTypes: {
                      type: 'array'
                      items: {
                        type: 'string'
                      }
                    }
                  }
                }
              }
            }
          }
          connectivity: {
            type: 'object'
            additionalProperties: false
            properties: {
              tagFilters: {
                type: 'array'
                maxItems: 5
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'key'
                    'value'
                  ]
                  properties: {
                    key: {
                      type: 'string'
                    }
                    value: {
                      type: 'string'
                    }
                  }
                }
              }
              subdomains: {
                type: 'array'
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'name'
                    'displayName'
                    'resourceTypes'
                  ]
                  properties: {
                    name: {
                      type: 'string'
                    }
                    displayName: {
                      type: 'string'
                    }
                    resourceTypes: {
                      type: 'array'
                      items: {
                        type: 'string'
                      }
                    }
                  }
                }
              }
            }
          }
          management: {
            type: 'object'
            additionalProperties: false
            properties: {
              tagFilters: {
                type: 'array'
                maxItems: 5
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'key'
                    'value'
                  ]
                  properties: {
                    key: {
                      type: 'string'
                    }
                    value: {
                      type: 'string'
                    }
                  }
                }
              }
              subdomains: {
                type: 'array'
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'name'
                    'displayName'
                    'resourceTypes'
                  ]
                  properties: {
                    name: {
                      type: 'string'
                    }
                    displayName: {
                      type: 'string'
                    }
                    resourceTypes: {
                      type: 'array'
                      items: {
                        type: 'string'
                      }
                    }
                  }
                }
              }
            }
          }
          identity: {
            type: 'object'
            additionalProperties: false
            properties: {
              tagFilters: {
                type: 'array'
                maxItems: 5
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'key'
                    'value'
                  ]
                  properties: {
                    key: {
                      type: 'string'
                    }
                    value: {
                      type: 'string'
                    }
                  }
                }
              }
              subdomains: {
                type: 'array'
                items: {
                  type: 'object'
                  additionalProperties: false
                  required: [
                    'name'
                    'displayName'
                    'resourceTypes'
                  ]
                  properties: {
                    name: {
                      type: 'string'
                    }
                    displayName: {
                      type: 'string'
                    }
                    resourceTypes: {
                      type: 'array'
                      items: {
                        type: 'string'
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  policyRule: {
    if: {
      field: 'type'
      equals: 'Microsoft.Resources/subscriptions'
    }
    then: {
      effect: '[parameters(\'effect\')]'
      details: {
        type: 'Microsoft.CloudHealth/healthmodels'
        name: '[parameters(\'healthModelName\')]'
        resourceGroupName: '[parameters(\'targetResourceGroupName\')]'
        existenceScope: 'resourceGroup'
        deploymentScope: 'Subscription'
        roleDefinitionIds: [
          '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        ]
        deployment: {
          location: '[parameters(\'location\')]'
          properties: {
            mode: 'Incremental'
            parameters: {
              targetResourceGroupName: {
                value: '[parameters(\'targetResourceGroupName\')]'
              }
              parHealthModelName: {
                value: '[parameters(\'healthModelName\')]'
              }
              parLocation: {
                value: '[parameters(\'location\')]'
              }
              parAuthenticationSettingName: {
                value: '[parameters(\'authenticationSettingName\')]'
              }
              parIncludedResourceTypesGlobal: {
                value: '[parameters(\'includedResourceTypesGlobal\')]'
              }
              parDomainOverrides: {
                value: '[parameters(\'domainOverrides\')]'
              }
              parSecurityResourceTypes: {
                value: '[parameters(\'securityResourceTypes\')]'
              }
              parConnectivityResourceTypes: {
                value: '[parameters(\'connectivityResourceTypes\')]'
              }
              parManagementResourceTypes: {
                value: '[parameters(\'managementResourceTypes\')]'
              }
              parIdentityResourceTypes: {
                value: '[parameters(\'identityResourceTypes\')]'
              }
            }
            template: varPlatformSubscriptionDeploymentTemplate
          }
        }
      }
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(subscription().subscriptionId, parPolicyName)}'
  params: {}
}

resource resPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2026-06-01' = {
  name: parPolicyName
  properties: varPlatformPolicyDefinitionProperties
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
      domainOverrides: {
        value: parDomainOverrides
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

