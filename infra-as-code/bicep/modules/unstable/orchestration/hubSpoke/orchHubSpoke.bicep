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
@description('Switch to enable/disable Azure Bastion deployment. Default: true')
param parAzBastionEnabled bool = true

@description('Switch to enable/disable DDoS Standard deployment. Default: true')
param parDdosEnabled bool = true

@description('DDoS Plan Name. Default: {parTopLevelManagementGroupPrefix}-ddos-plan')
param parDdosPlanName string = '${parTopLevelManagementGroupPrefix}-ddos-plan'

@description('Switch to enable/disable Azure Firewall deployment. Default: true')
param parAzFirewallEnabled bool = true

@description('Switch to enable/disable Azure Firewall DNS Proxy. Default: true')
param parAzFirewallDnsProxyEnabled bool = true

@description('Switch to enable/disable BGP Propagation on route table. Default: false')
param parDisableBgpRoutePropagation bool = false

@description('Switch to enable/disable Private DNS Zones deployment. Default: true')
param parPrivateDnsZonesEnabled bool = true

//ASN must be 65515 if deploying VPN & ER for co-existence to work: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations
@description('''Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e. 
"parVpnGatewayConfig": {
  "value": {}
}''')
param parVpnGatewayConfig object = {
    name: '${parTopLevelManagementGroupPrefix}-Vpn-Gateway'
    gatewayType: 'Vpn'
    sku: 'VpnGw1'
    vpnType: 'RouteBased'
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
  gatewayType: 'ExpressRoute'
  sku: 'ErGw1AZ'
  vpnType: 'RouteBased'
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
param parAzBastionSku string = 'Standard'

@description('Public IP Address SKU. Default: Standard')
@allowed([
  'Basic'
  'Standard'
])
param parPublicIpSku string = 'Standard'

@description('Tags you would like to be applied to all resources in this module. Default: empty array')
param parTags object = {}

@description('The IP address range for all virtual networks to use. Default: 10.10.0.0/16')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@description('Prefix Used for Hub Network. Default: {parTopLevelManagementGroupPrefix}-hub-{parLocation}')
param parHubNetworkName string = '${parTopLevelManagementGroupPrefix}-hub-${parLocation}'

@description('Azure Firewall Name. Default: {parTopLevelManagementGroupPrefix}-azure-firewall ')
param parAzFirewallName string = '${parTopLevelManagementGroupPrefix}-azure-firewall'

@description('Azure Firewall Tier associated with the Firewall to deploy. Default: Standard ')
@allowed([
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

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
param parAzBastionName string = '${parTopLevelManagementGroupPrefix}-bastion'

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
param parDnsServerIps array = []

// Policy Assignments Module Parameters
@description('An e-mail address that you want Azure Security Center alerts to be sent to.')
param parAscEmailSecurityContact string

// Spoke Networking Module Parameters
@description('The Name of the Spoke Virtual Network. Default: vnet-spoke')
param parSpokeNetworkName string = 'vnet-spoke'

@description('Switch which allows BGP Route Propagation to be disabled on the route table')
param parDisableBgpRoutePropagation bool = false

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
  modPolicyAssignmentIntRootDeployAscDfConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCDFConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAscMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResoruceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVmMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVmssMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMSSMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentConnEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyRdpFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyIpForwarding: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyRdpFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyStorageHttp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyStorageHttp-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployAksPolicy: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAKSPolicy-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPrivEscalationAks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivEscAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPrivContainersAks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivConAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceAksHttps: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAKSHTTPS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceTlsSsl: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceTLSSSL-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlDbAuditing: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLDBAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlThreat: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLThreat-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modResourceGroupForSpokeNetworking: take('${varDeploymentNameWrappers.basePrefix}-rsgSpokeNetworking-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokeNetworking: take('${varDeploymentNameWrappers.basePrefix}-modSpokeNetworking-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokePeeringToHub: take('${varDeploymentNameWrappers.basePrefix}-modSpokePeeringToHub-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
  modSpokePeeringFromHub: take('${varDeploymentNameWrappers.basePrefix}-modSpokePeeringToHub-${varDeploymentNameWrappers.baseSuffixCorpSubscriptions}', 61)
}

// Policy Assignments Modules Variables
var varPolicyAssignmentDenyAppGwWithoutWaf = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppGW-Without-WAF'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_appgw_without_waf.tmpl.json'))
}

var varPolicyAssignmentEnforceAksHttps = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_http_ingress_aks.tmpl.json'))
}

var varPolicyAssignmentDenyIpForwarding = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_ip_forwarding.tmpl.json'))
}

var varPolicyAssignmentDenyPrivContainersAks = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_containers_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPrivEscalationAks = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_escalation_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPublicEndpoints = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json'))
}

var varPolicyAssignmentDenyPublicIp = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
}

var varPolicyAssignmentDenyRdpFromInternet = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rdp_from_internet.tmpl.json'))
}

var varPolicyAssignmentDenyResourceLocations = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_resource_locations.tmpl.json'))
}

var varPolicyAssignmentDenyResourceTypes = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_resource_types.tmpl.json'))
}

var varPolicyAssignmentDenyRsgLocations = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rsg_locations.tmpl.json'))
}

var varPolicyAssignmentDenyStorageHttp = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutUdr = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Udr'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_udr.tmpl.json'))
}

var varPolicyAssignmentDeployAksPolicy = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json'))
}

var varPolicyAssignmentDeployAscMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json'))
}

// var varPolicyAssignmentDeployASCDFConfig = {
//   definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-ASCDF-Config'
//   libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_ascdf_config.tmpl.json'))
// }

var varPolicyAssignmentDeployAzActivityLog = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json'))
}

var varPolicyAssignmentDeployLogAnalytics = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json'))
}

var varPolicyAssignmentDeployLxArcMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9d2b61b4-1d14-4a63-be30-d4498e7ad2cf'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_lx_arc_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployPrivateDnzZones = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_private_dns_zones.tmpl.json'))
}

var varPolicyAssignmentDeployResourceDiag = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json'))
}

var varPolicyAssignmentDeploySqlDbAuditing = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_db_auditing.tmpl.json'))
}

var varPolicyAssignmentDeploySqlSecurity = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_security.tmpl.json'))
}

var varPolicyAssignmentDeploySqlThreat = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_threat.tmpl.json'))
}

var varPolicyAssignmentDeployVmBackup = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_backup.tmpl.json'))
}

var varPolicyAssignmentDeployVmMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployVmssMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployWsArcMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/69af7d4a-7b18-4044-93a9-2651498ef203'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_ws_arc_monitoring.tmpl.json'))
}

var varPolicyAssignmentEnableDdosVnet = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json'))
}

var varPolicyAssignmentEnforceTlsSsl = {
  definitionId: '${modManagementGroups.outputs.outTopLevelManagementGroupId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit'
  libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_tls_ssl.tmpl.json'))
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var varRbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
}

// Managment Groups Varaibles - Used For Policy Assignments
var varManagementGroupIds = {
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
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Module - Management Groups
module modManagementGroups '../../../managementGroups/managementGroups.bicep' = {
  scope: tenant()
  name: varModuleDeploymentNames.modManagementGroups
  params: {
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parTopLevelManagementGroupDisplayName: parTopLevelManagementGroupDisplayName
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Custom RBAC Role Definitions - https://github.com/Azure/bicep/issues/5371
module modCustomRBACRoleDefinitions '../../../customRoleDefinitions/customRoleDefinitions.bicep' = {
  dependsOn: [
    modManagementGroups
  ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modCustomRBACRoleDefinitions
  params: {
    parAssignableScopeManagementGroupId: parTopLevelManagementGroupPrefix
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Custom Policy Definitions and Initiatives
module modCustomPolicyDefinitions '../../../policy/definitions/customPolicyDefinitions.bicep' = {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modCustomPolicyDefinitions
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outTopLevelManagementGroupName
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Resource - Resource Group - For Logging - https://github.com/Azure/bicep/issues/5151 & https://github.com/Azure/bicep/issues/4992
module modResourceGroupForLogging '../../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parManagementSubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForLogging
  params: {
    parLocation: parLocation
    parResourceGroupName: parResourceGroupNameForLogging
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Logging, Automation & Sentinel
module modLogging '../../../logging/logging.bicep' = {
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
module modResourceGroupForHubNetworking '../../../resourceGroup/resourceGroup.bicep' = {
  scope: subscription(parConnectivitySubscriptionId)
  name: varModuleDeploymentNames.modResourceGroupForHubNetworking
  params: {
    parLocation: parLocation
    parResourceGroupName: parResourceGroupNameForHubNetworking
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Hub Virtual Networking
module modHubNetworking '../../../hubNetworking/hubNetworking.bicep' = {
  dependsOn: [
    modResourceGroupForHubNetworking
  ]
  scope: resourceGroup(parConnectivitySubscriptionId, parResourceGroupNameForHubNetworking)
  name: varModuleDeploymentNames.modHubNetworking
  params: {
    parAzBastionEnabled: parAzBastionEnabled
    parDdosEnabled: parDdosEnabled
    parDdosPlanName: parDdosPlanName
    parAzFirewallEnabled: parAzFirewallEnabled
    parAzFirewallDnsProxyEnabled: parAzFirewallDnsProxyEnabled
    parDisableBgpRoutePropagation: parDisableBgpRoutePropagation
    parPrivateDnsZonesEnabled: parPrivateDnsZonesEnabled
    parExpressRouteGatewayConfig: parExpressRouteGatewayConfig
    parVpnGatewayConfig: parVpnGatewayConfig
    parCompanyPrefix: parTopLevelManagementGroupPrefix
    parAzBastionSku: parAzBastionSku
    parPublicIpSku: parPublicIpSku
    parTags: parTags
    parHubNetworkAddressPrefix: parHubNetworkAddressPrefix
    parHubNetworkName: parHubNetworkName
    parAzFirewallName: parAzFirewallName
    parAzFirewallTier: parAzFirewallTier
    parHubRouteTableName: parHubRouteTableName
    parSubnets: parSubnets
    parAzBastionName: parAzBastionName
    parPrivateDnsZones: parPrivateDnsZones
    parDnsServerIps: parDnsServerIps
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Subscription Placements Into Management Group Hierarchy
// Module - Subscription Placement - Management
module modSubscriptionPlacementManagement '../../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformManagement)
  name: varModuleDeploymentNames.modSubscriptionPlacementManagement
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformManagementManagementGroupName
    parSubscriptionIds: [
      parManagementSubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Connectivity
module modSubscriptionPlacementConnectivity '../../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: varModuleDeploymentNames.modSubscriptionPlacementConnectivity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformConnectivityManagementGroupName
    parSubscriptionIds: [
      parConnectivitySubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Identity
module modSubscriptionPlacementIdentity '../../../subscriptionPlacement/subscriptionPlacement.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modSubscriptionPlacementIdentity
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outPlatformIdentityManagementGroupName
    parSubscriptionIds: [
      parIdentitySubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Corp
module modSubscriptionPlacementCorp '../../../subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parCorpSubscriptionIds)) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modSubscriptionPlacementCorp
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outLandingZonesCorpManagementGroupName
    parSubscriptionIds: [
      parCorpSubscriptionIds
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Subscription Placement - Online
module modSubscriptionPlacementOnline '../../../subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(parOnlineSubscriptionIds)) {
  scope: managementGroup(varManagementGroupIds.landingZonesOnline)
  name: varModuleDeploymentNames.modSubscriptionPlacementOnline
  params: {
    parTargetManagementGroupId: modManagementGroups.outputs.outLandingZonesOnlineManagementGroupName
    parSubscriptionIds: [
      parOnlineSubscriptionIds
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-ASCDF-Config
// module modPolicyAssignmentIntRootDeployAscDfConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
//   dependsOn: [
//     modCustomPolicyDefinitions
//   ]
//   scope: managementGroup(varManagementGroupIds.intRoot)
//   name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAscDfConfig
//   params: {
//     parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCDFConfig.definitionId
//     parPolicyAssignmentName: varPolicyAssignmentDeployASCDFConfig.libDefinition.name
//     parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.displayName
//     parPolicyAssignmentDescription: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.description
//     parPolicyAssignmentParameters: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.parameters
//     parPolicyAssignmentParameterOverrides: {
//       emailSecurityContact: {
//         value: parAscEmailSecurityContact
//       }
//       ascExportResourceGroupLocation: {
//         value: parLocation
//       }
//       logAnalytics: {
//         value: modLogging.outputs.outLogAnalyticsWorkspaceId
//       }
//     }
//     parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCDFConfig.libDefinition.identity.type
//     parPolicyAssignmentIdentityRoleDefinitionIds: [
//       varRbacRoleDefinitionIds.owner
//     ]
//     parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployASCDFConfig.libDefinition.properties.enforcementMode
//     parTelemetryOptOut: parTelemetryOptOut
//   }
// }

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAzActivityLog
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzActivityLog.definitionId
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
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentIntRootDeployAscMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  // dependsOn: [
  //   modCustomPolicyDefinitions
  // ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAscMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAscMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAscMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAscMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAscMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAscMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAscMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAscMonitoring.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// // Module - Policy Assignment - Deploy-Resource-Diag
module modPolicyAssignmentIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployResourceDiag.definitionId
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
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitoring
module modPolicyAssignmentIntRootDeployVmMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVmMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVmMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitoring
module modPolicyAssignmentIntRootDeployVmssMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVmssMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmssMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmssMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmssMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmssMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmssMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: modLogging.outputs.outLogAnalyticsWorkspaceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmssMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVmssMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// // Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentConnEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentConnEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDdosVnet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnableDdosVnet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: modHubNetworking.outputs.outDdosPlanResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDdosVnet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentIdentDenyRdpFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyRdpFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRdpFromInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyRdpFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRdpFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentIdentDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
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
module modPolicyAssignmentIdentDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmBackup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVmBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group - https://github.com/Azure/bicep/issues/5371
// Module - Policy Assignment - Deploy-Log-Analytics - ISSUES
module modPolicyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployLogAnalytics.definitionId
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
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group - https://github.com/Azure/bicep/issues/5371
// Module - Policy Assignment - Deny-IP-Forwarding - ISSUES
module modPolicyAssignmentLzsDenyIpForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyIpForwarding
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyIpForwarding.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyIpForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIpForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIpForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIpForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIpForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyIpForwarding.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Public-IP - NOT DONE IN ARM?????
module modPolicyAssignmentLzsDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPublicIp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentLzsDenyRdpFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyRdpFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRdpFromInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyRdpFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRdpFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRdpFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentLzsDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
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
module modPolicyAssignmentLzsDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmBackup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVmBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentLzsEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDdosVnet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnableDdosVnet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: modHubNetworking.outputs.outDdosPlanResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDdosVnet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStorageHttp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyStorageHttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStorageHttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStorageHttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStorageHttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStorageHttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyStorageHttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDeployAksPolicy '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployAksPolicy
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAksPolicy.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAksPolicy.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAksPolicy.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAksPolicy.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAksPolicy.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAksPolicy.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAksPolicy.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.aksContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDenyPrivEscalationAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivEscalationAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivEscalationAks.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivEscalationAks.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDenyPrivContainersAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivContainersAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivContainersAks.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAks.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAks.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAks.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAks.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAks.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivContainersAks.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsEnforceAksHttps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceAksHttps
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAksHttps.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAksHttps.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAksHttps.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAksHttps.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAksHttps.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAksHttps.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceAksHttps.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL
module modPolicyAssignmentLzsEnforceTlsSsl '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceTlsSsl
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceTlsSsl.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceTlsSsl.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTlsSsl.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTlsSsl.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTlsSsl.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTlsSsl.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceTlsSsl.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-DB-Auditing - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDeploySqlDbAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlDbAuditing
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySqlDbAuditing.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySqlDbAuditing.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat - https://github.com/Azure/bicep/issues/5371
module modPolicyAssignmentLzsDeploySqlThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlThreat
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySqlThreat.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySqlThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySqlThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySqlThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySqlThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySqlThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySqlThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolicyAssignmentLzsDenyPublicEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPublicEndpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicEndpoints.definitionId
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
module modPolicyAssignmentLzsDeployPrivateDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  dependsOn: [
    modCustomPolicyDefinitions
  ]
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployPrivateDnsZones
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployPrivateDnzZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.properties.parameters
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
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployPrivateDnzZones.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Resource - Resource Group - For Spoke Networking - https://github.com/Azure/bicep/issues/5151
module modResourceGroupForSpokeNetworking '../../../resourceGroup/resourceGroup.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: subscription(corpSub.subID)
  name: '${varModuleDeploymentNames.modResourceGroupForSpokeNetworking}-${i}'
  params: {
    parLocation: parLocation
    parResourceGroupName: parResourceGroupNameForSpokeNetworking
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Corp Spoke Virtual Networks
module modSpokeNetworking '../../../spokeNetworking/spokeNetworking.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: resourceGroup(corpSub.subID, parResourceGroupNameForSpokeNetworking)
  name: '${varModuleDeploymentNames.modSpokeNetworking}-${i}'
  params: {
    parSpokeNetworkName: '${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parSpokeNetworkAddressPrefix: corpSub.vnetCIDR
    parDdosEnabled: parDDoSEnabled
    parDdosProtectionPlanId: modHubNetworking.outputs.outDdosPlanResourceId
    parAzFirewallDnsProxyEnabled: parAzFirewallDnsProxyEnabled
    parHubNVAEnabled: parAzFirewallEnabled
    parDnsServerIps: parDnsServerIps
    parNextHopIpAddress: parAzFirewallEnabled ? modHubNetworking.outputs.outAzFirewallPrivateIp : ''
    parSpoketoHubRouteTableName: parSpoketoHubRouteTableName
    parDisableBgpRoutePropagation: parDisableBgpRoutePropagation
    parTags: parTags
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Corp Spoke Virtual Network Peering - Spoke To Hub
module modSpokePeeringToHub '../../../virtualNetworkPeer/virtualNetworkPeer.bicep' = [for (corpSub, i) in parCorpSubscriptionIds: if (!empty(parCorpSubscriptionIds)) {
  scope: resourceGroup(corpSub.subID, parResourceGroupNameForSpokeNetworking)
  name: '${varModuleDeploymentNames.modSpokePeeringToHub}-${i}'
  params: {
    parDestinationVirtualNetworkId: modHubNetworking.outputs.outHubVirtualNetworkId
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
    parDestinationVirtualNetworkId: '/subscriptions/${corpSub.subID}/resourceGroups/${parResourceGroupNameForSpokeNetworking}/providers/Microsoft.Network/virtualNetworks/${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parDestinationVirtualNetworkName: '${take('vnet-spoke-corp-${uniqueString(corpSub.subID)}', 64)}'
    parSourceVirtualNetworkName: modHubNetworking.outputs.outHubVirtualNetworkName
    parAllowForwardedTraffic: true
    parAllowGatewayTransit: true
    parAllowVirtualNetworkAccess: true
    parTelemetryOptOut: parTelemetryOptOut
  }
}]
