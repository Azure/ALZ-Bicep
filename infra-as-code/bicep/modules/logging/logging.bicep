metadata name = 'ALZ Bicep - Logging Module'
metadata description = 'ALZ Bicep Module used to set up Logging'

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. The lock settings of the service.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')

  @description('Optional. Notes about this lock.')
  notes: string?
}

@sys.description('''Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parGlobalResourceLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@sys.description('Log Analytics Workspace name.')
param parLogAnalyticsWorkspaceName string = 'alz-log-analytics'

@sys.description('Log Analytics region name - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.')
param parLogAnalyticsWorkspaceLocation string = resourceGroup().location

@sys.description('VM Insights Data Collection Rule name for AMA integration.')
param parDataCollectionRuleVMInsightsName string = 'alz-ama-vmi-dcr'

@sys.description('''Resource Lock Configuration for VM Insights Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parDataCollectionRuleVMInsightsLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@sys.description('Change Tracking Data Collection Rule name for AMA integration.')
param parDataCollectionRuleChangeTrackingName string = 'alz-ama-ct-dcr'

@sys.description('''Resource Lock Configuration for Change Tracking Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parDataCollectionRuleChangeTrackingLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@sys.description('MDFC for SQL Data Collection Rule name for AMA integration.')
param parDataCollectionRuleMDFCSQLName string = 'alz-ama-mdfcsql-dcr'

@sys.description('''Resource Lock Configuration for MDFC Defender for SQL Data Collection Rule.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parDataCollectionRuleMDFCSQLLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
@sys.description('Log Analytics Workspace sku name.')
param parLogAnalyticsWorkspaceSkuName string = 'PerGB2018'

@allowed([
  100
  200
  300
  400
  500
  1000
  2000
  5000
])
@sys.description('Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.')
param parLogAnalyticsWorkspaceCapacityReservationLevel int = 100

@minValue(30)
@maxValue(730)
@sys.description('Number of days of log retention for Log Analytics Workspace.')
param parLogAnalyticsWorkspaceLogRetentionInDays int = 365

@sys.description('''Resource Lock Configuration for Log Analytics Workspace.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parLogAnalyticsWorkspaceLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@allowed([
  'SecurityInsights'
])
@sys.description('Solutions that will be added to the Log Analytics Workspace.')
param parLogAnalyticsWorkspaceSolutions array = [
  'SecurityInsights'
]

@sys.description('''Resource Lock Configuration for Log Analytics Workspace Solutions.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parLogAnalyticsWorkspaceSolutionsLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@sys.description('Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.')
param parUserAssignedManagedIdentityName string = 'alz-logging-mi'

@sys.description('User Assigned Managed Identity location.')
param parUserAssignedManagedIdentityLocation string = resourceGroup().location

@sys.description('Log Analytics Workspace should be linked with the automation account.')
param parLogAnalyticsWorkspaceLinkAutomationAccount bool = true

@sys.description('Automation account name.')
param parAutomationAccountName string = 'alz-automation-account'
@sys.description('Automation Account region name. - Ensure the regions selected is a supported mapping as per: https://docs.microsoft.com/azure/automation/how-to/region-mappings.')
param parAutomationAccountLocation string = resourceGroup().location

@sys.description('Automation Account - use managed identity.')
param parAutomationAccountUseManagedIdentity bool = true

@sys.description('Automation Account - Public network access.')
param parAutomationAccountPublicNetworkAccess bool = true

@sys.description('''Resource Lock Configuration for Automation Account.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parAutomationAccountLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Tags you would like to be applied to Automation Account.')
param parAutomationAccountTags object = parTags

@sys.description('Tags you would like to be applied to Log Analytics Workspace.')
param parLogAnalyticsWorkspaceTags object = parTags

@sys.description('Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.')
param parUseSentinelClassicPricingTiers bool = false

@sys.description('Log Analytics LinkedService name for Automation Account.')
param parLogAnalyticsLinkedServiceAutomationAccountName string = 'Automation'

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'f8087c67-cc41-46b2-994d-66e4b661860d'

resource resUserAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: parUserAssignedManagedIdentityName
  location: parUserAssignedManagedIdentityLocation
}

resource resAutomationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: parAutomationAccountName
  location: parAutomationAccountLocation
  tags: parAutomationAccountTags
  identity: parAutomationAccountUseManagedIdentity ? {
    type: 'SystemAssigned'
  } : null
  properties: {
    encryption: {
      keySource: 'Microsoft.Automation'
    }
    publicNetworkAccess: parAutomationAccountPublicNetworkAccess
    sku: {
      name: 'Basic'
    }
  }
}

// Create a resource lock for the automation account if parGlobalResourceLock.kind != 'None' or if parAutomationAccountLock.kind != 'None'
resource resAutomationAccountLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAutomationAccountLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resAutomationAccount
  name: parAutomationAccountLock.?name ?? '${resAutomationAccount.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAutomationAccountLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAutomationAccountLock.?notes
  }
}

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: parLogAnalyticsWorkspaceName
  location: parLogAnalyticsWorkspaceLocation
  tags: parLogAnalyticsWorkspaceTags
  properties: {
    sku: {
      name: parLogAnalyticsWorkspaceSkuName
      capacityReservationLevel: parLogAnalyticsWorkspaceSkuName == 'CapacityReservation' ? parLogAnalyticsWorkspaceCapacityReservationLevel : null
    }
    retentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
  }
}

// Create a resource lock for the log analytics workspace if parGlobalResourceLock.kind != 'None' or if parLogAnalyticsWorkspaceLock.kind != 'None'
resource resLogAnalyticsWorkspaceLock 'Microsoft.Authorization/locks@2020-05-01' = if (parLogAnalyticsWorkspaceLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resLogAnalyticsWorkspace
  name: parLogAnalyticsWorkspaceLock.?name ?? '${resLogAnalyticsWorkspace.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parLogAnalyticsWorkspaceLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parLogAnalyticsWorkspaceLock.?notes
  }
}

resource resDataCollectionRuleVMInsights 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: parDataCollectionRuleVMInsightsName
  location: parLogAnalyticsWorkspaceLocation
  properties: {
    description: 'Data collection rule for VM Insights'
    dataSources: {
      performanceCounters: [
       {
         name: 'VMInsightsPerfCounters'
         streams: [
          'Microsoft-InsightsMetrics'
         ]
         counterSpecifiers: [
          '\\VMInsights\\DetailedMetrics'
         ]
         samplingFrequencyInSeconds: 60
       }
      ]
      extensions: [
        {
          streams: [
            'Microsoft-ServiceMap'
          ]
          extensionName: 'DependencyAgent'
          extensionSettings: {}
          name: 'DependencyAgentDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resLogAnalyticsWorkspace.id
          name: 'VMInsightsPerf-Logs-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
      }
      {
        streams: [
          'Microsoft-ServiceMap'
        ]
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
      }
    ]
  }
}

// Create a resource lock for the Data Collection Rule if parGlobalResourceLock.kind != 'None' or if parDataCollectionRuleVMInsightsLock.kind != 'None'
resource resDataCollectionRuleVMInsightsLock 'Microsoft.Authorization/locks@2020-05-01' = if (parDataCollectionRuleVMInsightsLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resDataCollectionRuleVMInsights
  name: parDataCollectionRuleVMInsightsLock.?name ?? '${resDataCollectionRuleVMInsights.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parDataCollectionRuleVMInsightsLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parDataCollectionRuleVMInsightsLock.?notes
  }
}

resource resDataCollectionRuleChangeTracking 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: parDataCollectionRuleChangeTrackingName
  location: parLogAnalyticsWorkspaceLocation
  properties: {
    description: 'Data collection rule for CT.'
    dataSources: {
      extensions: [
        {
          streams: [
            'Microsoft-ConfigurationChange'
            'Microsoft-ConfigurationChangeV2'
            'Microsoft-ConfigurationData'
          ]
          extensionName: 'ChangeTracking-Windows'
          extensionSettings: {
            enableFiles: true
            enableSoftware: true
            enableRegistry: true
            enableServices: true
            enableInventory: true
            registrySettings: {
              registryCollectionFrequency: 3000
              registryInfo: [
                {
                  name: 'Registry_1'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Startup'
                  valueName: ''
                }
                {
                    name: 'Registry_2'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Shutdown'
                    valueName: ''
                }
                {
                    name: 'Registry_3'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run'
                    valueName: ''
                }
                {
                    name: 'Registry_4'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components'
                    valueName: ''
                }
                {
                    name: 'Registry_5'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\ShellEx\\ContextMenuHandlers'
                    valueName: ''
                }
                {
                    name: 'Registry_6'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Background\\ShellEx\\ContextMenuHandlers'
                    valueName: ''
                }
                {
                    name: 'Registry_7'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Shellex\\CopyHookHandlers'
                    valueName: ''
                }
                {
                    name: 'Registry_8'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                    valueName: ''
                }
                {
                    name: 'Registry_9'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                    valueName: ''
                }
                {
                    name: 'Registry_10'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                    valueName: ''
                }
                {
                    name: 'Registry_11'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                    valueName: ''
                }
                {
                    name: 'Registry_12'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Extensions'
                    valueName: ''
                }
                {
                    name: 'Registry_13'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Internet Explorer\\Extensions'
                    valueName: ''
                }
                {
                    name: 'Registry_14'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                    valueName: ''
                }
                {
                    name: 'Registry_15'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                    valueName: ''
                }
                {
                    name: 'Registry_16'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls'
                    valueName: ''
                }
                {
                    name: 'Registry_17'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify'
                    valueName: ''
                }
              ]
            }
            fileSettings: {
              fileCollectionFrequency: 2700
            }
            softwareSettings: {
              softwareCollectionFrequency: 1800
            }
            inventorySettings: {
              inventoryCollectionFrequency: 36000
            }
            serviceSettings: {
              serviceCollectionFrequency: 1800
            }
          }
          name: 'CTDataSource-Windows'
        }
        {
          streams: [
            'Microsoft-ConfigurationChange'
            'Microsoft-ConfigurationChangeV2'
            'Microsoft-ConfigurationData'
          ]
          extensionName: 'ChangeTracking-Linux'
          extensionSettings: {
            enableFiles: true
            enableSoftware: true
            enableRegistry: false
            enableServices: true
            enableInventory: true
            fileSettings: {
              fileCollectionFrequency: 900
              fileInfo: [
                {
                  name: 'ChangeTrackingLinuxPath_default'
                  enabled: true
                  destinationPath: '/etc/.*.conf'
                  useSudo: true
                  recurse: true
                  maxContentsReturnable: 5000000
                  pathType: 'File'
                  type: 'File'
                  links: 'Follow'
                  maxOutputSize: 500000
                  groupTag: 'Recommended'
                }
              ]
            }
            softwareSettings: {
              softwareCollectionFrequency: 300
            }
            inventorySettings: {
              inventoryCollectionFrequency: 36000
            }
            serviceSettings: {
              serviceCollectionFrequency: 300
            }
          }
          name: 'CTDataSource-Linux'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resLogAnalyticsWorkspace.id
          name: 'Microsoft-CT-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-ConfigurationChange'
          'Microsoft-ConfigurationChangeV2'
          'Microsoft-ConfigurationData'
        ]
        destinations: [
          'Microsoft-CT-Dest'
        ]
      }
    ]
  }
}

// Create a resource lock for the Data Collection Rule if parGlobalResourceLock.kind != 'None' or if parDataCollectionRuleChangeTrackingLock.kind != 'None'
resource resDataCollectionRuleChangeTrackingLock 'Microsoft.Authorization/locks@2020-05-01' = if (parDataCollectionRuleChangeTrackingLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resDataCollectionRuleChangeTracking
  name: parDataCollectionRuleChangeTrackingLock.?name ?? '${resDataCollectionRuleChangeTracking.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parDataCollectionRuleChangeTrackingLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parDataCollectionRuleChangeTrackingLock.?notes
  }
}

resource resDataCollectionRuleMDFCSQL'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: parDataCollectionRuleMDFCSQLName
  location: parLogAnalyticsWorkspaceLocation
  properties: {
    description: 'Data collection rule for Defender for SQL.'
    dataSources: {
      extensions: [
        {
          extensionName: 'MicrosoftDefenderForSQL'
          name: 'MicrosoftDefenderForSQL'
          streams: [
            'Microsoft-DefenderForSqlAlerts'
            'Microsoft-DefenderForSqlLogins'
            'Microsoft-DefenderForSqlTelemetry'
            'Microsoft-DefenderForSqlScanEvents'
            'Microsoft-DefenderForSqlScanResults'
          ]
          extensionSettings: {
            enableCollectionOfSqlQueriesForSecurityResearch: true
          }
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resLogAnalyticsWorkspace.id
          name: 'Microsoft-DefenderForSQL-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-DefenderForSqlAlerts'
          'Microsoft-DefenderForSqlLogins'
          'Microsoft-DefenderForSqlTelemetry'
          'Microsoft-DefenderForSqlScanEvents'
          'Microsoft-DefenderForSqlScanResults'
        ]
        destinations: [
          'Microsoft-DefenderForSQL-Dest'
        ]
      }
    ]
  }
}

// Create a resource lock for the Data Collection Rule if parGlobalResourceLock.kind != 'None' or if parDataCollectionRuleMDFCSQLLock.kind != 'None'
resource resDataCollectionRuleMDFCSQLLock 'Microsoft.Authorization/locks@2020-05-01' = if (parDataCollectionRuleMDFCSQLLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resDataCollectionRuleMDFCSQL
  name: parDataCollectionRuleMDFCSQLLock.?name ?? '${resDataCollectionRuleMDFCSQL.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parDataCollectionRuleMDFCSQLLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parDataCollectionRuleMDFCSQLLock.?notes
  }
}

resource resLogAnalyticsWorkspaceSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for solution in parLogAnalyticsWorkspaceSolutions: {
  name: '${solution}(${resLogAnalyticsWorkspace.name})'
  location: parLogAnalyticsWorkspaceLocation
  tags: parTags
  properties: solution == 'SecurityInsights' ? {
    workspaceResourceId: resLogAnalyticsWorkspace.id
    sku: parUseSentinelClassicPricingTiers ? null : {
      name: 'Unified'
    }
  } : {
    workspaceResourceId: resLogAnalyticsWorkspace.id
  }
  plan: {
    name: '${solution}(${resLogAnalyticsWorkspace.name})'
    product: 'OMSGallery/${solution}'
    publisher: 'Microsoft'
    promotionCode: ''
  }
}]

// Create a resource lock for each log analytics workspace solutions in parLogAnalyticsWorkspaceSolutions if parGlobalResourceLock.kind != 'None' or if parLogAnalyticsWorkspaceSolutionsLock.kind != 'None'
resource resLogAnalyticsWorkspaceSolutionsLock 'Microsoft.Authorization/locks@2020-05-01' = [for (solution, index) in parLogAnalyticsWorkspaceSolutions: if (parLogAnalyticsWorkspaceSolutionsLock.kind != 'None' || parGlobalResourceLock.kind != 'None') {
  scope: resLogAnalyticsWorkspaceSolutions[index]
  name: parLogAnalyticsWorkspaceSolutionsLock.?name ?? '${resLogAnalyticsWorkspaceSolutions[index].name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parLogAnalyticsWorkspaceSolutionsLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parLogAnalyticsWorkspaceSolutionsLock.?notes
  }
}]

resource resLogAnalyticsLinkedServiceForAutomationAccount 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = if (parLogAnalyticsWorkspaceLinkAutomationAccount) {
  parent: resLogAnalyticsWorkspace
  name: parLogAnalyticsLinkedServiceAutomationAccountName
  properties: {
    resourceId: resAutomationAccount.id
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

output outUserAssignedManagedIdentityId string = resUserAssignedManagedIdentity.id
output outUserAssignedManagedIdentityPrincipalId string = resUserAssignedManagedIdentity.properties.principalId

output outDataCollectionRuleVMInsightsName string = resDataCollectionRuleVMInsights.name
output outDataCollectionRuleVMInsightsId string = resDataCollectionRuleVMInsights.id

output outDataCollectionRuleChangeTrackingName string = resDataCollectionRuleChangeTracking.name
output outDataCollectionRuleChangeTrackingId string = resDataCollectionRuleChangeTracking.id

output outDataCollectionRuleMDFCSQLName string = resDataCollectionRuleMDFCSQL.name
output outDataCollectionRuleMDFCSQLId string = resDataCollectionRuleMDFCSQL.id

output outLogAnalyticsWorkspaceName string = resLogAnalyticsWorkspace.name
output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
output outLogAnalyticsCustomerId string = resLogAnalyticsWorkspace.properties.customerId
output outLogAnalyticsSolutions array = parLogAnalyticsWorkspaceSolutions

output outAutomationAccountName string = resAutomationAccount.name
output outAutomationAccountId string = resAutomationAccount.id
