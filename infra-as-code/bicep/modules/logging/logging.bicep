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

@allowed([
  'PerfAndMap'
  'PerfOnly'
])
@sys.description('VM Insights Experience - For details see: https://learn.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable.')
param parDataCollectionRuleVMInsightsExperience string = 'PerfAndMap'

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
#disable-next-line no-unused-params
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
#disable-next-line no-unused-params
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
  'ChangeTracking'
])
@sys.description('Solutions that will be added to the Log Analytics Workspace.')
param parLogAnalyticsWorkspaceSolutions array = [
  'SecurityInsights'
  'ChangeTracking'
]

@sys.description('''Resource Lock Configuration for Change Tracking solution.
- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.

''')
param parChangeTrackingSolutionLock lockType = {
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Logging Module.'
}


@sys.description('Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.')
param parUserAssignedManagedIdentityName string = 'alz-logging-mi'

@sys.description('User Assigned Managed Identity location.')
param parUserAssignedManagedIdentityLocation string = resourceGroup().location

@sys.description('Switch to enable/disable Automation Account deployment.')
param parAutomationAccountEnabled bool = false

@sys.description('Log Analytics Workspace should be linked with the automation account.')
param parLogAnalyticsWorkspaceLinkAutomationAccount bool = false

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

@sys.description('Log Analytics LinkedService name for Automation Account.')
param parLogAnalyticsLinkedServiceAutomationAccountName string = 'Automation'

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = 'f8087c67-cc41-46b2-994d-66e4b661860d'

// AMA resources (User Assigned Managed Identity, VM Insights DCR, Change Tracking DCR, MDFC SQL DCR) deployed via AVM module
module modAma 'br/public:avm/ptn/alz/ama:0.2.0' = {
  name: '${uniqueString(deployment().name, parLogAnalyticsWorkspaceLocation)}-ALZ-AMA'
  params: {
    location: parUserAssignedManagedIdentityLocation
    userAssignedIdentityName: parUserAssignedManagedIdentityName
    logAnalyticsWorkspaceResourceId: resLogAnalyticsWorkspace.id
    dataCollectionRuleVMInsightsName: parDataCollectionRuleVMInsightsName
    dataCollectionRuleVMInsightsExperience: parDataCollectionRuleVMInsightsExperience
    dataCollectionRuleChangeTrackingName: parDataCollectionRuleChangeTrackingName
    dataCollectionRuleMDFCSQLName: parDataCollectionRuleMDFCSQLName
    tags: parTags
    enableTelemetry: !parTelemetryOptOut
    lockConfig: parDataCollectionRuleVMInsightsLock.kind != 'None' ? parDataCollectionRuleVMInsightsLock : parGlobalResourceLock
  }
}

resource resAutomationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = if (parAutomationAccountEnabled) {
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
resource resAutomationAccountLock 'Microsoft.Authorization/locks@2020-05-01' = if (parAutomationAccountEnabled && (parAutomationAccountLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resAutomationAccount
  name: parAutomationAccountLock.?name ?? '${resAutomationAccount.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parAutomationAccountLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parAutomationAccountLock.?notes
  }
}

resource resLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
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

// Onboard the Log Analytics Workspace to Sentinel if SecurityInsights is in parLogAnalyticsWorkspaceSolutions
resource resSentinelOnboarding 'Microsoft.SecurityInsights/onboardingStates@2025-09-01' = if (contains(parLogAnalyticsWorkspaceSolutions, 'SecurityInsights')) {
  name: 'default'
  scope: resLogAnalyticsWorkspace
  properties: {}
}

resource resChangeTrackingSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (contains(parLogAnalyticsWorkspaceSolutions, 'ChangeTracking')) {
  name: 'ChangeTracking(${resLogAnalyticsWorkspace.name})'
  location: parLogAnalyticsWorkspaceLocation
  properties: {
    workspaceResourceId: resLogAnalyticsWorkspace.id
  }
  plan: {
    name: 'ChangeTracking(${resLogAnalyticsWorkspace.name})'
    product: 'OMSGallery/ChangeTracking'
    publisher: 'Microsoft'
    promotionCode: ''
  }
}

// Add resource lock for ChangeTracking solution
resource resChangeTrackingSolutionLock 'Microsoft.Authorization/locks@2020-05-01' = if (contains(parLogAnalyticsWorkspaceSolutions, 'ChangeTracking') && (parChangeTrackingSolutionLock.kind != 'None' || parGlobalResourceLock.kind != 'None')) {
  scope: resChangeTrackingSolution
  name: parChangeTrackingSolutionLock.?name ?? '${resChangeTrackingSolution.name}-lock'
  properties: {
    level: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.kind : parChangeTrackingSolutionLock.kind
    notes: (parGlobalResourceLock.kind != 'None') ? parGlobalResourceLock.?notes : parChangeTrackingSolutionLock.?notes
  }
}

resource resLogAnalyticsLinkedServiceForAutomationAccount 'Microsoft.OperationalInsights/workspaces/linkedServices@2025-07-01' = if (parLogAnalyticsWorkspaceLinkAutomationAccount) {
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

output outLogAnalyticsWorkspaceName string = resLogAnalyticsWorkspace.name
output outLogAnalyticsWorkspaceId string = resLogAnalyticsWorkspace.id
output outLogAnalyticsCustomerId string = resLogAnalyticsWorkspace.properties.customerId
output outLogAnalyticsSolutions array = parLogAnalyticsWorkspaceSolutions

output outAutomationAccountName string = parAutomationAccountEnabled ? resAutomationAccount.id : 'AA Deployment Disabled'
output outAutomationAccountId string = parAutomationAccountEnabled ? resAutomationAccount.id : 'AA Deployment Disabled'
