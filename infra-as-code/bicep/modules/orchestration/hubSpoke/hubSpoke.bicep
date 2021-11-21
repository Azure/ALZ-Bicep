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

// Resource Group Modules Parameters - Used multiple times
@description('Name of Resource Group to be created to contain management resources like the central log analytics workspace.  Default: {parTopLevelManagementGroupPrefix}-logging')
param parResourceGroupNameForLogging string = '${parTopLevelManagementGroupPrefix}-logging'

@description('Name of Resource Group to be created to contain hub networking resources like the virtual network and ddos standard plan.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-hub-networking')
param parResourceGroupNameForHubNetworking string = '${parTopLevelManagementGroupPrefix}-${parLocation}-hub-networking'

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

//Hub Networking Module Parameters
@description('Switch which allows Bastion deployment to be disabled. Default: true')
param parBastionEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled. Default: true')
param parDDoSEnabled bool = true

@description('DDOS Plan Name. Default: {parTopLevelManagementGroupPrefix}-DDos-Plan')
param parDDoSPlanName string = '${parTopLevelManagementGroupPrefix}-DDoS-Plan'

@description('Switch which allows Azure Firewall deployment to be disabled. Default: true')
param parAzureFirewallEnabled bool = true

@description('Switch which allos DNS Proxy to be enabled on the virtual network. Default: true')
param parNetworkDNSEnableProxy bool = true

@description('Switch which allows BGP Propagation to be disabled on the routes: Default: false')
param  parDisableBGPRoutePropagation bool = false

@description('Switch which allows Private DNS Zones to be disabled. Default: true')
param parPrivateDNSZonesEnabled bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@description('Array of Gateways to be deployed. Array will consist of one or two items.  Specifically Vpn and/or ExpressRoute Default: Vpn')
param parGatewayArray array = [
  {
    name: '${parTopLevelManagementGroupPrefix}-vpn-gateway'
    gatewaytype: 'Vpn'
    sku: 'VpnGw1'
    vpntype: 'RouteBased'
    generation: 'Generation2'
    enableBgp: true
    activeActive: false
    enableBgpRouteTranslationForNat: false
    enableDnsForwarding: false
    asn: 65515
    bgpPeeringAddress: ''
    bgpsettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
  }
  {
    name: '${parTopLevelManagementGroupPrefix}-exr-gateway'
    gatewaytype: 'ExpressRoute'
    sku: 'ErGw1AZ'
    vpntype: 'RouteBased'
    generation: 'None'
    enableBgp: true
    activeActive: false
    enableBgpRouteTranslationForNat: false
    enableDnsForwarding: false
    asn: 65515
    bgpPeeringAddress: ''
    bgpsettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
  }

]

@description('Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard. Default: Standard')
param parBastionSku string = 'Standard'

@description('Public IP Address SKU. Default: Standard')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIPSku string = 'Standard'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('The IP address range for all virtual networks to use. Default: 10.10.0.0/16')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network. Default: {parTopLevelManagementGroupPrefix}-hub-{parLocation}')
param parHubNetworkName string = '${parTopLevelManagementGroupPrefix}-hub-${parLocation}'

@description('Azure Firewall Name. Default: {parTopLevelManagementGroupPrefix}-azure-firewall ')
param parAzureFirewallName string ='${parTopLevelManagementGroupPrefix}-azure-firewall'

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parAzureFirewallTier string = 'Standard'

@description('Name of Route table to create for the default route of Hub. Default: {parTopLevelManagementGroupPrefix}-hub-routetable')
param parHubRouteTableName string = '${parTopLevelManagementGroupPrefix}-hub-routetable'

@description('The name and IP address range for each subnet in the virtual networks. Default: AzureBastionSubnet, GatewaySubnet, AzureFirewall Subnet')
param parSubnets array = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.10.15.0/24' 
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.10.252.0/24'
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.10.254.0/24'
  }
]

@description('Name Associated with Bastion Service:  Default: {parTopLevelManagementGroupPrefix}-bastion')
param parBastionName string = '${parTopLevelManagementGroupPrefix}-bastion'

@description('Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Privatezones')
param parPrivateDnsZones array =[
  'privatelink.azure-automation.net'
  'privatelink.database.windows.net'
  'privatelink.sql.azuresynapse.net'
  'privatelink.azuresynapse.net'
  'privatelink.blob.core.windows.net'
  'privatelink.table.core.windows.net'
  'privatelink.queue.core.windows.net'
  'privatelink.file.core.windows.net'
  'privatelink.web.core.windows.net'
  'privatelink.dfs.core.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.table.cosmos.azure.com'
  'privatelink.${parLocation}.batch.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.mariadb.database.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.${parLocation}.azmk8s.io'
  '${parLocation}.privatelink.siterecovery.windowsazure.com'
  'privatelink.servicebus.windows.net'
  'privatelink.azure-devices.net'
  'privatelink.eventgrid.azure.net'
  'privatelink.azurewebsites.net'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.service.signalr.net'
  'privatelink.afs.azure.net'
  'privatelink.datafactory.azure.net'
  'privatelink.adf.azure.com'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.purview.azure.com'
  'privatelink.digitaltwins.azure.net'
]

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
  modLogging: take('${varDeploymentNameWrappers.basePrefix}-logging-${varDeploymentNameWrappers.baseSuffixManagementSubscription}', 64)
  modResourceGroupForHubNetworking: take('${varDeploymentNameWrappers.basePrefix}-rsgHubNetworking-${varDeploymentNameWrappers.baseSuffixConnectivitySubscription}', 64)
  modHubNetworking: take('${varDeploymentNameWrappers.basePrefix}-hubNetworking-${varDeploymentNameWrappers.baseSuffixConnectivitySubscription}', 64)
  modSubscriptionPlacementManagement: take('${varDeploymentNameWrappers.basePrefix}-sub-place-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modSubscriptionPlacementConnectivity: take('${varDeploymentNameWrappers.basePrefix}-sub-place-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modSubscriptionPlacementIdentity: take('${varDeploymentNameWrappers.basePrefix}-sub-place-idnt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modCustomPolicyDefinitions
  params: {
    parTargetManagementGroupID: modManagementGroups.outputs.outTopLevelMGName
  }
}

// Resource - Resource Group - For Logging - https://github.com/Azure/bicep/issues/5151 & https://github.com/Azure/bicep/issues/4992
module modResourceGroupForLogging '../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parManagementSubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForLogging
  params: {
    parResourceGroupLocation: parLocation
    parResourceGroupName: parResourceGroupNameForLogging
  }
}

// Module - Logging, Automation & Sentinel
module modLogging '../../logging/logging.bicep' = {
  dependsOn: [
    modResourceGroupForLogging
  ]
  scope: resourceGroup(parManagementSubscriptionId, parResourceGroupNameForLogging)
  name: varModuleDeploymentNames.modLogging
  params: {
    parAutomationAccountName: parAutomationAccountName
    parAutomationAccountRegion: parLocation
    parLogAnalyticsWorkspaceLogRetentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
    parLogAnalyticsWorkspaceName: parLogAnalyticsWorkspaceName
    parLogAnalyticsWorkspaceRegion: parLocation
    parLogAnalyticsWorkspaceSolutions: parLogAnalyticsWorkspaceSolutions
  }
}

// Resource - Resource Group - For Logging - https://github.com/Azure/bicep/issues/5151
module modResourceGroupForHubNetworking '../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parConnectivitySubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForHubNetworking
  params: {
    parResourceGroupLocation: parLocation
    parResourceGroupName: parResourceGroupNameForHubNetworking
  }
}

// Module - Hub Virtual Networking
module modHubNetworking '../../hubNetworking/hubNetworking.bicep' = {
  dependsOn: [
    modResourceGroupForHubNetworking
  ]
  scope: resourceGroup(parConnectivitySubscriptionId, parResourceGroupNameForHubNetworking)
  name: varModuleDeploymentNames.modHubNetworking
  params: {
    parBastionEnabled: parBastionEnabled
    parDDoSEnabled: parDDoSEnabled
    parDDoSPlanName: parDDoSPlanName
    parAzureFirewallEnabled: parAzureFirewallEnabled
    parNetworkDNSEnableProxy: parNetworkDNSEnableProxy
    parDisableBGPRoutePropagation: parDisableBGPRoutePropagation
    parPrivateDNSZonesEnabled: parPrivateDNSZonesEnabled
    parGatewayArray: parGatewayArray
    parCompanyPrefix: parTopLevelManagementGroupPrefix
    parBastionSku: parBastionSku
    parPublicIPSku: parPublicIPSku
    parTags: parTags
    parHubNetworkAddressPrefix: parHubNetworkAddressPrefix
    parHubNetworkName: parHubNetworkName
    parAzureFirewallName: parAzureFirewallName
    parAzureFirewallTier: parAzureFirewallTier
    parHubRouteTableName: parHubRouteTableName
    parSubnets: parSubnets
    parBastionName: parBastionName
    parPrivateDnsZones: parPrivateDnsZones    
  }
}

// Subscription Placements Into Management Group Hierarchy
// Module - Subscription Placement - Management
module modSubscriptionPlacementManagement '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modSubscriptionPlacementManagement
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformManagementMGName
    parSubscriptionIds: [
      parManagementSubscriptionId
    ]
  }
}

// Module - Subscription Placement - Connectivity
module modSubscriptionPlacementConnectivity '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modSubscriptionPlacementConnectivity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformConnectivityMGName
    parSubscriptionIds: [
      parConnectivitySubscriptionId
    ]
  }
}

// Module - Subscription Placement - Identity
module modSubscriptionPlacementIdentity '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(parTopLevelManagementGroupPrefix)
  name: varModuleDeploymentNames.modSubscriptionPlacementIdentity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformIdentityMGName
    parSubscriptionIds: [
      parIdentitySubscriptionId
    ]
  }
}
