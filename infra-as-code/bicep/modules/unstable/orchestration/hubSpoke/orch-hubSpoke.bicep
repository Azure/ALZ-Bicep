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

@description('An array of objects containing the Subscription IDs & CIDR VNET Address Spaces for Subscriptions to be placed into the Corp Management Group and peered back to the Hub Virtual Network (must already exists)')
@maxLength(36)
param parCorpSubscriptionIds array = []

@description('The Subscription IDs for Subscriptions to be placed into the Online Management Group (must already exists)')
@maxLength(36)
param parOnlineSubscriptionIds array = []

// Resource Group Modules Parameters - Used multiple times
@description('Name of Resource Group to be created to contain management resources like the central log analytics workspace.  Default: {parTopLevelManagementGroupPrefix}-logging')
param parResourceGroupNameForLogging string = '${parTopLevelManagementGroupPrefix}-logging'

@description('Name of Resource Group to be created to contain hub networking resources like the virtual network and ddos standard plan.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-hub-networking')
param parResourceGroupNameForHubNetworking string = '${parTopLevelManagementGroupPrefix}-${parLocation}-hub-networking'

@description('Name of Resource Group to be created to contain spoke networking resources like the virtual network.  Default: {parTopLevelManagementGroupPrefix}-{parLocation}-spoke-networking')
param parResourceGroupNameForSpokeNetworking string = '${parTopLevelManagementGroupPrefix}-${parLocation}-spoke-networking'

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

// Hub Networking Module Parameters
@description('Switch which allows Bastion deployment to be disabled. Default: true')
param parBastionEnabled bool = true

@description('Switch which allows DDOS deployment to be disabled. Default: true')
param parDdosEnabled bool = true

@description('DDOS Plan Name. Default: {parTopLevelManagementGroupPrefix}-ddos-plan')
param parDdosPlanName string = '${parTopLevelManagementGroupPrefix}-ddos-plan'

@description('Switch which allows Azure Firewall deployment to be disabled. Default: true')
param parAzureFirewallEnabled bool = true

@description('Switch which allos DNS Proxy to be enabled on the virtual network. Default: true')
param parNetworkDNSEnableProxy bool = true

@description('Switch which allows BGP Propagation to be disabled on the routes: Default: false')
param parDisableBGPRoutePropagation bool = false

@description('Switch which allows Private DNS Zones to be disabled. Default: true')
param parPrivateDNSZonesEnabled bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@description('''Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e. 
"parVpnGatewayConfig": {
  "value": {}
}''')
param parVpnGatewayConfig object = {
    name: '${parTopLevelManagementGroupPrefix}-Vpn-Gateway'
    gatewaytype: 'Vpn'
    sku: 'VpnGw1'
    vpntype: 'RouteBased'
    generation: 'Generation1'
    enableBgp: false
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

@description('''Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e. 
"parExpressRouteGatewayConfig": {
  "value": {}
}''')
param parExpressRouteGatewayConfig object = {
  name: '${parTopLevelManagementGroupPrefix}-ExpressRoute-Gateway'
  gatewaytype: 'ExpressRoute'
  sku: 'ErGw1AZ'
  vpntype: 'RouteBased'
  vpnGatewayGeneration: 'None'
  enableBgp: false
  activeActive: false
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  asn: '65515'
  bgpPeeringAddress: ''
  bgpsettings: {
    asn: '65515'
    bgpPeeringAddress: ''
    peerWeight: '5'
  }
}

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
param parAzureFirewallName string = '${parTopLevelManagementGroupPrefix}-azure-firewall'

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
param parPrivateDnsZones array = [
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
  'privatelink.azconfig.io'
  'privatelink.webpubsub.azure.com'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.azurecr.io'
  'privatelink.search.windows.net'
]

@description('Array of DNS Server IP addresses for VNet. Default: Empty Array')
param parDNSServerIPArray array = []

// Policy Assignments Module Parameters
@description('An e-mail address that you want Azure Security Center alerts to be sent to.')
param parASCEmailSecurityContact string

// Spoke Networking Module Parameters
@description('The Name of the Spoke Virtual Network. Default: vnet-spoke')
param parSpokeNetworkName string = 'vnet-spoke'

@description('Switch which allows BGP Route Propogation to be disabled on the route table')
param parBGPRoutePropogation bool = false

@description('Name of Route table to create for the default route of Hub. Default: rtb-spoke-to-hub')
param parSpoketoHubRouteTableName string = 'rtb-spoke-to-hub'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '50ad3b1a-f72c-4de4-8293-8a6399991beb'

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
  baseSuffixManagementSubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parManagementSubscriptionId}'
  baseSuffixConnectivitySubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parConnectivitySubscriptionId}'
  baseSuffixIdentitySubscription: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-${parIdentitySubscriptionId}'
  baseSuffixCorpSubscriptions: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}-corp-sub'
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
  modSubscriptionPlacementCorp: take('${varDeploymentNameWrappers.basePrefix}-sub-place-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modSubscriptionPlacementOnline: take('${varDeploymentNameWrappers.basePrefix}-sub-place-online-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployASCDFConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCDFConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployASCMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResoruceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVMMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVMSSMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMSSMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentConnEnableDDoSVNET: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIP: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyRDPFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNSG: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDeployVMBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyIPForwarding: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyPublicIP: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyRDPFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenySubnetWithoutNSG: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDeployVMBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsEnableDDoSVNET: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyStorageHttp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyStorageHttp-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDeployAKSPolicy: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAKSPolicy-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyPrivEscalationAKS: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivEscAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyPrivContainersAKS: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivConAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsEnforceAKSHTTPS: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAKSHTTPS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsEnforceTLSSSL: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceTLSSSL-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDeploySQLDBAuditing: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLDBAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDeploySQLThreat: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLThreat-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDeployPrivateDNSZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modResourceGroupForSpokeNetworking: take('${varDeploymentNameWrappers.basePrefix}-rsgSpokeNetworking-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokeNetworking: take('${varDeploymentNameWrappers.basePrefix}-modSpokeNetworking-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokePeeringToHub: take('${varDeploymentNameWrappers.basePrefix}-modSpokePeeringToHub-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokePeeringFromHub: take('${varDeploymentNameWrappers.basePrefix}-modSpokePeeringToHub-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
}

// Policy Assignments Modules Variables
var varPolicyAssignmentDenyAppGWWithoutWAF = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppGW-Without-WAF'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_appgw_without_waf.tmpl.json'))
}

var varPolicyAssignmentEnforceAKSHTTPS = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_http_ingress_aks.tmpl.json'))
}

var varPolicyAssignmentDenyIPForwarding = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_ip_forwarding.tmpl.json'))
}

var varPolicyAssignmentDenyPrivContainersAKS = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_containers_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPrivEscalationAKS = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_escalation_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPublicEndpoints = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json'))
}

var varPolicyAssignmentDenyPublicIP = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
}

var varPolicyAssignmentDenyRDPFromInternet = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rdp_from_internet.tmpl.json'))
}

var varPolicyAssignmentDenyResourceLocations = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_resource_locations.tmpl.json'))
}

var varPolicyAssignmentDenyResourceTypes = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_resource_types.tmpl.json'))
}

var varPolicyAssignmentDenyRSGLocations = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rsg_locations.tmpl.json'))
}

var varPolicyAssignmentDenyStoragehttp = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutUdr = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Udr'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_udr.tmpl.json'))
}

var varPolicyAssignmentDeployAKSPolicy = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json'))
}

var varPolicyAssignmentDeployASCMonitoring = {
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployASCDFConfig = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-ASCDF-Config'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_ascdf_config.tmpl.json'))
}

var varPolicyAssignmentDeployAzActivityLog = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json'))
}

var varPolicyAssignmentDeployLogAnalytics = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json'))
}

var varPolicyAssignmentDeployLXArcMonitoring = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/9d2b61b4-1d14-4a63-be30-d4498e7ad2cf'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_lx_arc_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployPrivateDNSZones = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_private_dns_zones.tmpl.json'))
}

var varPolicyAssignmentDeployResourceDiag = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json'))
}

var varPolicyAssignmentDeploySQLDBAuditing = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_db_auditing.tmpl.json'))
}

var varPolicyAssignmentDeploySQLSecurity = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_security.tmpl.json'))
}

var varPolicyAssignmentDeploySQLThreat = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_threat.tmpl.json'))
}

var varPolicyAssignmentDeployVMBackup = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_backup.tmpl.json'))
}

var varPolicyAssignmentDeployVMMonitoring = {
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployVMSSMonitoring = {
  definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployWSArcMonitoring = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/69af7d4a-7b18-4044-93a9-2651498ef203'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_ws_arc_monitoring.tmpl.json'))
}

var varPolicyAssignmentEnableDDoSVNET = {
  definitionID: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json'))
}

var varPolicyAssignmentEnforceTLSSSL = {
  definitionID: '${modManagementGroups.outputs.outTopLevelMGId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit'
  libDefinition: json(loadTextContent('../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_tls_ssl.tmpl.json'))
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var varRBACRoleDefinitionIDs = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
}

// Managment Groups Varaibles - Used For Policy Assignments
var varManagementGroupIDs = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox'
}

// **Scope**
targetScope = 'tenant'

// **Modules**
// Module - Customer Usage Attribution - Telemtry
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Module - Management Groups
module modManagementGroups '../../managementGroups/managementGroups.bicep' = {
  scope: tenant()
  name: varModuleDeploymentNames.modManagementGroups
  params: {
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parTopLevelManagementGroupDisplayName: parTopLevelManagementGroupDisplayName
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Custom RBAC Role Definitions - https://github.com/Azure/bicep/issues/5371
module modCustomRBACRoleDefinitions '../../customRoleDefinitions/customRoleDefinitions.bicep' = {
  dependsOn: [
    modManagementGroups
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modCustomRBACRoleDefinitions
  params: {
    parAssignableScopeManagementGroupId: parTopLevelManagementGroupPrefix
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Custom Policy Definitions and Initiatives
module modCustomPolicyDefinitions '../../policy/definitions/custom-policy-definitions.bicep' = {
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modCustomPolicyDefinitions
  params: {
    parTargetManagementGroupID: modManagementGroups.outputs.outTopLevelMGName
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Resource - Resource Group - For Logging - https://github.com/Azure/bicep/issues/5151 & https://github.com/Azure/bicep/issues/4992
module modResourceGroupForLogging '../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parManagementSubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForLogging
  params: {
    parResourceGroupLocation: parLocation
    parResourceGroupName: parResourceGroupNameForLogging
    parTelemetryOptOut: parTelemetryOptOut
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
    parAutomationAccountLocation: parLocation
    parLogAnalyticsWorkspaceLogRetentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
    parLogAnalyticsWorkspaceName: parLogAnalyticsWorkspaceName
    parLogAnalyticsWorkspaceLocation: parLocation
    parLogAnalyticsWorkspaceSolutions: parLogAnalyticsWorkspaceSolutions
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Resource - Resource Group - For Hub Networking - https://github.com/Azure/bicep/issues/5151
module modResourceGroupForHubNetworking '../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parConnectivitySubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForHubNetworking
  params: {
    parResourceGroupLocation: parLocation
    parResourceGroupName: parResourceGroupNameForHubNetworking
    parTelemetryOptOut: parTelemetryOptOut
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
    parExpressRouteGatewayConfig: parExpressRouteGatewayConfig
    parVpnGatewayConfig: parVpnGatewayConfig
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
    parDNSServerIPArray: parDNSServerIPArray
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Subscription Placements Into Management Group Hierarchy
// Module - Subscription Placement - Management
module modSubscriptionPlacementManagement '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformManagement)
  name: varModuleDeploymentNames.modSubscriptionPlacementManagement
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformManagementMGName
    parSubscriptionIds: [
      parManagementSubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Connectivity
module modSubscriptionPlacementConnectivity '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformConnectivity)
  name: varModuleDeploymentNames.modSubscriptionPlacementConnectivity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformConnectivityMGName
    parSubscriptionIds: [
      parConnectivitySubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Identity
module modSubscriptionPlacementIdentity '../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modSubscriptionPlacementIdentity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformIdentityMGName
    parSubscriptionIds: [
      parIdentitySubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Corp
module modSubscriptionPlacementCorp '../../subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parCorpSubscriptionIds)) {
  scope: managementGroup(varManagementGroupIDs.landingZonesCorp)
  name: varModuleDeploymentNames.modSubscriptionPlacementCorp
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outLandingZonesCorpMGName
    parSubscriptionIds: [
      parCorpSubscriptionIds
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Online
module modSubscriptionPlacementOnline '../../subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parOnlineSubscriptionIds)) {
  scope: managementGroup(varManagementGroupIDs.landingZonesOnline)
  name: varModuleDeploymentNames.modSubscriptionPlacementOnline
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outLandingZonesOnlineMGName
    parSubscriptionIds: [
      parOnlineSubscriptionIds
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-ASCDF-Config
module modPolicyAssignmentIntRootDeployASCDFConfig '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployASCDFConfig
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployASCDFConfig.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployASCDFConfig.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      emailSecurityContact: {
        value: parASCEmailSecurityContact
      }
      ascExportResourceGroupLocation: {
        value: parLocation
      }
      logAnalytics: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCDFConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAzActivityLog
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployAzActivityLog.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployAzActivityLog.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzActivityLog.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentIntRootDeployASCMonitoring '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  // dependsOn: [
  //   modCustomPolicyDefinitions
  // ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployASCMonitoring
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployASCMonitoring.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployASCMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// // Module - Policy Assignment - Deploy-Resource-Diag
module modPolicyAssignmentIntRootDeployResourceDiag '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployResourceDiag.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployResourceDiag.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitoring
module modPolicyAssignmentIntRootDeployVMMonitoring '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVMMonitoring
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployVMMonitoring.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitoring
module modPolicyAssignmentIntRootDeployVMSSMonitoring '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVMSSMonitoring
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployVMSSMonitoring.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// // Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentConnEnableDDoSVNET '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentConnEnableDDoSVNET
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentEnableDDoSVNET.definitionID
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: modHubNetworking.outputs.outDdosPlanResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIP '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIP
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPublicIP.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentIdentDenyRDPFromInternet '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyRDPFromInternet
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyRDPFromInternet.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRDPFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentIdentDenySubnetWithoutNSG '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNSG
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenySubnetWithoutNsg.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentIdentDeployVMBackup '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDeployVMBackup
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployVMBackup.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group - https://github.com/Azure/bicep/issues/5371
// Module - Policy Assignment - Deploy-Log-Analytics - ISSUES
module modPolicyAssignmentMgmtDeployLogAnalytics '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployLogAnalytics.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployLogAnalytics.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      rgName: {
        value: parResourceGroupNameForLogging
      }
      workspaceName: {
        value: parLogAnalyticsWorkspaceName
      }
      workspaceRegion: {
        value: parLocation
      }
      dataRetention: {
        value: parLogAnalyticsWorkspaceLogRetentionInDays
      }
      automationAccountName: {
        value: parAutomationAccountName
      }
      automationRegion: {
        value: parLocation
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployLogAnalytics.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group - https://github.com/Azure/bicep/issues/5371
// Module - Policy Assignment - Deny-IP-Forwarding - ISSUES
module modPolicyAssignmentLZsDenyIPForwarding '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyIPForwarding
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyIPForwarding.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyIPForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIPForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Public-IP - NOT DONE IN ARM?????
module modPolicyAssignmentLZsDenyPublicIP '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPublicIP
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPublicIP.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentLZstDenyRDPFromInternet '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyRDPFromInternet
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyRDPFromInternet.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRDPFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentLZsDenySubnetWithoutNSG '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenySubnetWithoutNSG
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenySubnetWithoutNsg.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup - https://github.com/Azure/bicep/issues/5371 
module modPolicyAssignmentLZsDeployVMBackup '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeployVMBackup
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployVMBackup.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentLZsEnableDDoSVNET '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnableDDoSVNET
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentEnableDDoSVNET.definitionID
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: modHubNetworking.outputs.outDDoSPlanResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDenyStorageHttp '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyStoragehttp.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDeployAKSPolicy '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeployAKSPolicy
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployAKSPolicy.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployAKSPolicy.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAKSPolicy.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.aksContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDenyPrivEscalationAKS '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPrivEscalationAKS
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPrivEscalationAKS.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDenyPrivContainersAKS '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPrivContainersAKS
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPrivContainersAKS.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsEnforceAKSHTTPS '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnforceAKSHTTPS
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentEnforceAKSHTTPS.definitionID
    parPolicyAssignmentName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL
module modPolicyAssignmentLZsEnforceTLSSSL '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnforceTLSSSL
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentEnforceTLSSSL.definitionID
    parPolicyAssignmentName: varPolicyAssignmentEnforceTLSSSL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTLSSSL.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-DB-Auditing - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDeploySQLDBAuditing '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeploySQLDBAuditing
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeploySQLDBAuditing.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLZsDeploySQLThreat '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeploySQLThreat
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeploySQLThreat.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolicyAssignmentLZsDenyPublicEndpoints '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPublicEndpoints
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDenyPublicEndpoints.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Private-DNS-Zones
module modPolicyAssignmentLZsDeployPrivateDNSZones '../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeployPrivateDNSZones
  params: {
    parPolicyAssignmentDefinitionID: varPolicyAssignmentDeployPrivateDNSZones.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      azureFilePrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[29].id
      }
      azureWebPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[37].id
      }
      azureBatchPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[15].id
      }
      azureAppPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[36].id
      }
      azureAsrPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[21].id
      }
      azureIoTPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[38].id
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[19].id
      }
      azureSignalRPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[28].id
      }
      azureAppServicesPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[25].id
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[24].id
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[4].id
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[39].id
      }
      azureIotHubsPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[23].id
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[24].id
      }
      azureRedisCachePrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[32].id
      }
      azureAcrPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[40].id
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[22].id
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[26].id
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[22].id
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: modHubNetworking.outputs.outPrivateDnsZones[41].id
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIDs: [
      varRBACRoleDefinitionIDs.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Resource - Resource Group - For Spoke Networking - https://github.com/Azure/bicep/issues/5151
module modResourceGroupForSpokeNetworking '../../resourceGroup/resourceGroup.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: subscription(corpSub.subID)
  name: '${varModuleDeploymentNames.modResourceGroupForSpokeNetworking}-${i}'
  params: {
    parResourceGroupLocation: parLocation
    parResourceGroupName: parResourceGroupNameForSpokeNetworking
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Corp Spoke Virtual Networks
module modSpokeNetworking '../../spokeNetworking/spokeNetworking.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: resourceGroup(corpSub.subID, parResourceGroupNameForSpokeNetworking)
  name: '${varModuleDeploymentNames.modSpokeNetworking}-${i}'
  params: {
    parSpokeNetworkName: '${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parSpokeNetworkAddressPrefix: corpSub.vnetCIDR
    parDdosEnabled: parDDoSEnabled
    parDdosProtectionPlanId: modHubNetworking.outputs.outDDoSPlanResourceID
    parNetworkDNSEnableProxy: parNetworkDNSEnableProxy
    parHubNVAEnabled: parAzureFirewallEnabled
    parDNSServerIPArray: parDNSServerIPArray
    parNextHopIPAddress: parAzureFirewallEnabled ? modHubNetworking.outputs.outAzureFirewallPrivateIP : ''
    parSpoketoHubRouteTableName: parSpoketoHubRouteTableName
    parBGPRoutePropogation: parBGPRoutePropogation
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Corp Spoke Virtual Network Peering - Spoke To Hub
module modSpokePeeringToHub '../../virtualNetworkPeer/virtualNetworkPeer.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: resourceGroup(corpSub.subID, parResourceGroupNameForSpokeNetworking)
  name: '${varModuleDeploymentNames.modSpokePeeringToHub}-${i}'
  params: {
    parDestinationVirtualNetworkID: modHubNetworking.outputs.outHubVirtualNetworkID
    parDestinationVirtualNetworkName: modHubNetworking.outputs.outHubVirtualNetworkName
    parSourceVirtualNetworkName: '${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parAllowForwardedTraffic: true
    parAllowGatewayTransit: true
    parAllowVirtualNetworkAccess: true
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Corp Spoke Virtual Network Peering - Hub To Spoke
module modSpokePeeringFromHub '../../virtualNetworkPeer/virtualNetworkPeer.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: resourceGroup(parConnectivitySubscriptionId, parResourceGroupNameForHubNetworking)
  name: '${varModuleDeploymentNames.modSpokePeeringFromHub}-${i}'
  params: {
    parDestinationVirtualNetworkID: '/subscriptions/${corpSub.subID}/resourceGroups/${parResourceGroupNameForSpokeNetworking}/providers/Microsoft.Network/virtualNetworks/${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parDestinationVirtualNetworkName: '${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parSourceVirtualNetworkName: modHubNetworking.outputs.outHubVirtualNetworkName
    parAllowForwardedTraffic: true
    parAllowGatewayTransit: true
    parAllowVirtualNetworkAccess: true
    parTelemetryOptOut: parTelemetryOptOut
  }
}]
