targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - CloudHealth Management Group Policy Definitions'
metadata description = 'Preview (experimental): deploys CloudHealth health-model policy definitions at management-group scope for ALZ default assignments.'

var varPlatformTopology = json(loadTextContent('policy_healthModelPlatformTopology.json'))
var varApplicationTopology = json(loadTextContent('policy_healthModelApplicationTopology.json'))

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

var varApplicationSubscriptionDeploymentTemplate = {
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
    parComputeResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parDataResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parRoutingResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parAiResourceTypes: {
      type: 'array'
      defaultValue: []
    }
    parConfigResourceTypes: {
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
              parComputeResourceTypes: {
                value: '[parameters(\'parComputeResourceTypes\')]'
              }
              parDataResourceTypes: {
                value: '[parameters(\'parDataResourceTypes\')]'
              }
              parRoutingResourceTypes: {
                value: '[parameters(\'parRoutingResourceTypes\')]'
              }
              parAiResourceTypes: {
                value: '[parameters(\'parAiResourceTypes\')]'
              }
              parConfigResourceTypes: {
                value: '[parameters(\'parConfigResourceTypes\')]'
              }
        }
        template: varApplicationTopology
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
  description: 'Deploys a Microsoft.CloudHealth platform health model when one is missing. Each platform domain (Security, Connectivity, Management, Identity) has a resource-type discovery rule.'
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
        description: 'Name of the resource group the remediation creates when needed and deploys the platform health model into.'
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

var varApplicationPolicyDefinitionProperties = {
  displayName: 'Deploy a Microsoft CloudHealth application landing zone health model with per-domain discovery rules'
  description: 'Deploys a Microsoft.CloudHealth application landing zone health model when one is missing. Each application domain (Compute, Data, Routing, AI, Config) has a resource-type discovery rule.'
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
        description: 'Enable (DeployIfNotExists) or turn off (Disabled) automatic deployment of the application landing zone health model when it is missing.'
      }
    }
    targetResourceGroupName: {
      type: 'String'
      metadata: {
        displayName: 'Target resource group'
        description: 'Name of the resource group the remediation creates when needed and deploys the application landing zone health model into.'
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
    computeResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Compute resource types'
        description: 'Resource types discovered for the Compute application domain, unioned with the global list to form that domain query.'
      }
    }
    dataResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Data resource types'
        description: 'Resource types discovered for the Data application domain, unioned with the global list to form that domain query.'
      }
    }
    routingResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Routing resource types'
        description: 'Resource types discovered for the Routing application domain, unioned with the global list to form that domain query.'
      }
    }
    aiResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'AI resource types'
        description: 'Resource types discovered for the AI application domain, unioned with the global list to form that domain query.'
      }
    }
    configResourceTypes: {
      type: 'Array'
      metadata: {
        strongType: 'resourceTypes'
        displayName: 'Config resource types'
        description: 'Resource types discovered for the Config application domain, unioned with the global list to form that domain query.'
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
          compute: {
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
          data: {
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
          routing: {
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
          ai: {
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
          config: {
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
              parComputeResourceTypes: {
                value: '[parameters(\'computeResourceTypes\')]'
              }
              parDataResourceTypes: {
                value: '[parameters(\'dataResourceTypes\')]'
              }
              parRoutingResourceTypes: {
                value: '[parameters(\'routingResourceTypes\')]'
              }
              parAiResourceTypes: {
                value: '[parameters(\'aiResourceTypes\')]'
              }
              parConfigResourceTypes: {
                value: '[parameters(\'configResourceTypes\')]'
              }
            }
            template: varApplicationSubscriptionDeploymentTemplate
          }
        }
      }
    }
  }
}

resource resPlatformPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2025-03-01' = {
  name: 'Deploy-ALZ-CloudHealth-PlatformModel'
  properties: varPlatformPolicyDefinitionProperties
}

resource resApplicationPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2025-03-01' = {
  name: 'Deploy-App-CloudHealth-ApplicationModel'
  properties: varApplicationPolicyDefinitionProperties
}

@sys.description('Resource ID of the platform CloudHealth policy definition.')
output outPlatformPolicyDefinitionId string = resPlatformPolicyDefinition.id

@sys.description('Resource ID of the application CloudHealth policy definition.')
output outApplicationPolicyDefinitionId string = resApplicationPolicyDefinition.id
