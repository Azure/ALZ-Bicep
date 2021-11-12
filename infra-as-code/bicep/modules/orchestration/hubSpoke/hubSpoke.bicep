/*

SUMMARY: This module provides orchestration of all the required module deployments to achevie a Azure Landing Zones Hub and Spoke network topology deployment (also known as Adventure Works)
DESCRIPTION: This module provides orchestration of all the required module deployments to achevie a Azure Landing Zones Hub and Spoke network topology deployment (also known as Adventure Works).
             It will handle the sequencing and ordering of the following modules:
             - Management Groups
             - Custom RBAC Role Definitions
             - Custom Policy Definitions
             - Logging
             - Policy Assignments
             - Subscription Placement
             - Hub Networking
             - Spoke Networking (corp connected)
             All as outlined in the Deployment Flow wiki page here: https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow
AUTHOR/S: jtracey93
VERSION: 1.0.0

*/

// **Parameters**
// Generic Parameters - Used in multiple modules
@description('The region to deploy all resoruces into. DEFAULTS TO = northeurope')
param parLocation string = 'northeurope'

// Subscriptions Parameters
@description('The Subscription ID for the Management Subscription (must already exists)')
@maxLength(36)
param parManagementSubscriptionId string

@description('The Subscription ID for the Connectivity Subscription (must already exists)')
@maxLength(36)
param parConnectivitySubscriptionId string

@description('The Subscription ID for the Identity Subscription (must already exists)')
@maxLength(36)
param parIdentitySubscriptionId string

// Management Group Module Parameters
@description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

// Logging Module Parameters
@description('Log Analytics Workspace name. - DEFAULT VALUE: alz-log-analytics')
param parLogAnalyticsWorkspaceName string = 'alz-log-analytics'

@minValue(30)
@maxValue(730)
@description('Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365')
param parLogAnalyticsWorkspaceLogRetentionInDays int = 365

@allowed([
  'AgentHealthAssessment'
  'AntiMalware'
  'AzureActivity'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAssessment'
  'Updates'
  'VMInsights'
])
@description('Solutions that will be added to the Log Analytics Workspace. - DEFAULT VALUE: [AgentHealthAssessment, AntiMalware, AzureActivity, ChangeTracking, Security, SecurityInsights, ServiceMap, SQLAssessment, Updates, VMInsights]')
param parLogAnalyticsWorkspaceSolutions array = [
  'AgentHealthAssessment'
  'AntiMalware'
  'AzureActivity'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAssessment'
  'Updates'
  'VMInsights'
]

@description('Automation account name. - DEFAULT VALUE: alz-automation-account')
param parAutomationAccountName string = 'alz-automation-account'

@description('Automation Account region name. - DEFAULT VALUE: resourceGroup().location')
param parAutomationAccountRegion string = resourceGroup().location

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
  baseSuffixManagementSubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parManagementSubscriptionId}'
  baseSuffixConnectivitySubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parConnectivitySubscriptionId}'
  baseSuffixIdentitySubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parIdentitySubscriptionId}'
}

var varModuleDeploymentNames = {
  modManagementGroups: take('${varDeploymentNameWrappers.basePrefix}-mgs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modCustomRBACRoleDefinitions: take('${varDeploymentNameWrappers.basePrefix}-rbacRoles-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modCustomPolicyDefinitions: take('${varDeploymentNameWrappers.basePrefix}-polDefs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modResourceGroupForLogging: take('${varDeploymentNameWrappers.basePrefix}-rsgLogging-${varDeploymentNameWrappers.baseSuffixManagementSubscription}', 64)
  modLogging: take('${varDeploymentNameWrappers.basePrefix}-rsgLogging-${varDeploymentNameWrappers.baseSuffixManagementSubscription}', 64)
}

// **Scope**
targetScope = 'tenant'

// **Modules**
// Module - Management Groups
module modManagementGroups '../../managementGroups/managementGroups.bicep' = {
  scope: tenant()
  name: varModuleDeploymentNames.modManagementGroups
  params: {
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parTopLevelManagementGroupDisplayName: parTopLevelManagementGroupDisplayName
  }
}

// Module - Custom RBAC Role Definitions - REMOVED AS ISSUES ON FRESH DEPLOYMENT AND NOT DONE IN ESLZ ARM TODAY
// ERROR: New-AzTenantDeployment: 17:25:33 - Error: Code=InvalidTemplate; Message=Deployment template validation failed: 'The deployment metadata 'MANAGEMENTGROUP' is not valid.'.
// module modCustomRBACRoleDefinitions '../../customRoleDefinitions/customRoleDefinitions.bicep' = {
//   dependsOn: [
//     modManagementGroups
//   ]
//   scope: managementGroup(parTopLevelManagementGroupPrefix)
//   name: varModuleDeploymentNames.modCustomRBACRoleDefinitions
//   params: {
//     parAssignableScopeManagementGroupId: parTopLevelManagementGroupPrefix
//   }
// }

// Module - Custom Policy Definitions and Initiatives
module modCustomPolicyDefinitions '../../policy/definitions/custom-policy-definitions.bicep' = {
  dependsOn: [
    modManagementGroups
  ]
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modCustomPolicyDefinitions
  params: {
    parTargetManagementGroupID: parTopLevelManagementGroupPrefix
  }
}

// // Resource - Resource Group - For Logging - https://github.com/Azure/bicep/issues/5151
resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  scope: subscription(parManagementSubscriptionId)
  location: parResourceGroupLocation
  name: parResourceGroupName
}

// Module - Logging, Automation & Sentinel
module modLogging '../../logging/logging.bicep' = {
  scope: subscription(parman)
  name: varModuleDeploymentNames.modLogging
  params: {
    parAutomationAccountName:
    parAutomationAccountRegion: parLocation
    parLogAnalyticsWorkspaceLogRetentionInDays:
    parLogAnalyticsWorkspaceName:
    parLogAnalyticsWorkspaceRegion:
    parLogAnalyticsWorkspaceSolutions:
  }
}
