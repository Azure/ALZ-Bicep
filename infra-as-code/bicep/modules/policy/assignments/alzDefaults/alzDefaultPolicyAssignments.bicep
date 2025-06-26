metadata name = 'ALZ Bicep - Default Policy Assignments'
metadata description = 'Assigns ALZ Default Policies to the Management Group hierarchy'

@description('Prefix for management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Optional suffix for management group names/IDs.')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@description('Apply platform policies to Platform group or child groups.')
param parPlatformMgAlzDefaultsEnable bool = true

@description('Assign policies to Corp & Online Management Groups under Landing Zones.')
param parLandingZoneChildrenMgAlzDefaultsEnable bool = true

@description('Assign policies to Confidential Corp and Online groups under Landing Zones.')
param parLandingZoneMgConfidentialEnable bool = false

@description('Location of Log Analytics Workspace & Automation Account.')
param parLogAnalyticsWorkSpaceAndAutomationAccountLocation string = 'eastus'

@description('Resource ID of Log Analytics Workspace.')
param parLogAnalyticsWorkspaceResourceId string = ''

@sys.description('Category of logs for supported resource logging for Log Analytics Workspace.')
param parLogAnalyticsWorkspaceResourceCategory string = 'allLogs'

@description('Resource ID for VM Insights Data Collection Rule.')
param parDataCollectionRuleVMInsightsResourceId string = ''

@description('Resource ID for Change Tracking Data Collection Rule.')
param parDataCollectionRuleChangeTrackingResourceId string = ''

@description('Resource ID for MDFC SQL Data Collection Rule.')
param parDataCollectionRuleMDFCSQLResourceId string = ''

@description('Resource ID for User Assigned Managed Identity.')
param parUserAssignedManagedIdentityResourceId string = ''

@description('Number of days to retain logs in Log Analytics Workspace.')
param parLogAnalyticsWorkspaceLogRetentionInDays string = '365'

@description('Name of the Automation Account.')
param parAutomationAccountName string = 'alz-automation-account'

@description('Email address for Microsoft Defender for Cloud alerts.')
param parMsDefenderForCloudEmailSecurityContact string = ''

@description('Enable/disable DDoS Network Protection.')
param parDdosEnabled bool = true

@description('Resource ID of the DDoS Protection Plan for Virtual Networks.')
param parDdosProtectionPlanId string = ''

@description('Resource ID of the Resource Group for Private DNS Zones. Empty to skip assigning the Deploy-Private-DNS-Zones policy.')
param parPrivateDnsResourceGroupId string = ''

@description('Location of Private DNS Zones.')
param parPrivateDnsZonesLocation string = ''

@description('List of Private DNS Zones to audit under the Corp Management Group. This overwrites default values.')
param parPrivateDnsZonesNamesToAuditInCorp array = []

@description('Set the enforcement mode to DoNotEnforce for specific default ALZ policies.')
param parPolicyAssignmentsToDisableEnforcement array = []

@description('Set the enforcement mode to DoNotEnforce for all default ALZ policies.')
param parDisableAlzDefaultPolicies bool = false

@description('Tag name for excluding VMs from this policy scope.')
param parVmBackupExclusionTagName string = ''

@description('Tag value for excluding VMs from this policy scope.')
param parVmBackupExclusionTagValue array = []

@description('Names of policy assignments to exclude from the deployment entirely.')
param parExcludedPolicyAssignments array = []

@description('Opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

var varLogAnalyticsWorkspaceName = split(parLogAnalyticsWorkspaceResourceId, '/')[8]

var varLogAnalyticsWorkspaceResourceGroupName = split(parLogAnalyticsWorkspaceResourceId, '/')[4]

var varLogAnalyticsWorkspaceSubscription = split(parLogAnalyticsWorkspaceResourceId, '/')[2]

var varUserAssignedManagedIdentityResourceName = split(parUserAssignedManagedIdentityResourceId, '/')[8]

// Customer Usage Attribution Id Telemetry
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// ZTN Telemetry
var varZtnP1CuaId = '4eaba1fc-d30a-4e63-a57f-9e6c3d86a318'
var varZtnP1Trigger = ((!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyStoragehttp.libDefinition.name)))

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZB'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModDepNames = {
  modPolAssiIntRootDeployMdfcConfig: take('${varDeploymentNameWrappers.basePrefix}-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-deployAzActLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployAscMonitoring: take('${varDeploymentNameWrappers.basePrefix}-deployASCMon-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-deployResDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployMDEnpoints: take('${varDeploymentNameWrappers.basePrefix}-deployMDEnd-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployMDEnpointsAma: take('${varDeploymentNameWrappers.basePrefix}-deployMDEndAma-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootEnforceAcsb: take('${varDeploymentNameWrappers.basePrefix}-enforceAcsb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployMdfcOssDb: take('${varDeploymentNameWrappers.basePrefix}-deployMdfcOssDb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDeployMdfcSqlAtp: take('${varDeploymentNameWrappers.basePrefix}-deployMdfcSqlAtp-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootAuditLocationMatch: take('${varDeploymentNameWrappers.basePrefix}-auditLocMatch-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootAuditZoneResiliency: take('${varDeploymentNameWrappers.basePrefix}-auditZoneRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootAuditUnusedRes: take('${varDeploymentNameWrappers.basePrefix}-auditUnusedRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootAuditTrustedLaunch: take('${varDeploymentNameWrappers.basePrefix}-auditTrustLaunch-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDenyClassicRes: take('${varDeploymentNameWrappers.basePrefix}-denyClassicRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIntRootDenyUnmanagedDisks: take('${varDeploymentNameWrappers.basePrefix}-denyUnmgdDisks-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmArcTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmArcTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmChgTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmssChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmssChgTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmArcMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmArcMon-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmMon-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployVmssMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmssMon-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDeployMdfcDefSqlAma: take('${varDeploymentNameWrappers.basePrefix}-deployMdfcDefSqlAma-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformDenyDeleteUAMIAMA: take('${varDeploymentNameWrappers.basePrefix}-denyDelUamiAma-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceSubnetPrivate: take('${varDeploymentNameWrappers.basePrefix}-enforceSubnetPriv-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGrKeyVault: take('${varDeploymentNameWrappers.basePrefix}-enforceGrKeyVault-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceAsr: take('${varDeploymentNameWrappers.basePrefix}-enforceAsr-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceAumCheckUpdates: take('${varDeploymentNameWrappers.basePrefix}-enforceAumChkUpd-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiConnEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-enableDdosVnet-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIdentDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-denyPublicIp-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIdentDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-denyMgmtPortsInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIdentDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-denySubnetNoNsg-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiIdentDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-deployVmBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-deployLogAnalytics-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenyIpForwarding: take('${varDeploymentNameWrappers.basePrefix}-denyIpForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-denyMgmtPortsInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-denySubnetNoNsg-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-deployVmBackup-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-enableDdosVnet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenyStorageHttp: take('${varDeploymentNameWrappers.basePrefix}-denyStorageHttp-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenyPrivEscalationAks: take('${varDeploymentNameWrappers.basePrefix}-denyPrivEscAks-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDenyPrivContainersAks: take('${varDeploymentNameWrappers.basePrefix}-denyPrivConAks-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceAksHttps: take('${varDeploymentNameWrappers.basePrefix}-enforceAksHttps-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceTlsSsl: take('${varDeploymentNameWrappers.basePrefix}-enforceTlsSsl-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployAzSqlDbAuditing: take('${varDeploymentNameWrappers.basePrefix}-deployAzSqlDbAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeploySqlThreat: take('${varDeploymentNameWrappers.basePrefix}-deploySqlThreat-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeploySqlTde: take('${varDeploymentNameWrappers.basePrefix}-deploySqlTde-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmArcTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmArcTrack-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmChgTrack-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmssChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-deployVmssChgTrack-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmArcMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmArcMon-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmMon-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployVmssMonitor: take('${varDeploymentNameWrappers.basePrefix}-deployVmssMon-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsDeployMdfcDefSqlAma: take('${varDeploymentNameWrappers.basePrefix}-deployMdfcDefSqlAma-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceSubnetPrivate: take('${varDeploymentNameWrappers.basePrefix}-enforceSubnetPriv-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGrKeyVault: take('${varDeploymentNameWrappers.basePrefix}-enforceGrKeyVault-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceAsr: take('${varDeploymentNameWrappers.basePrefix}-enforceAsr-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsAumCheckUpdates: take('${varDeploymentNameWrappers.basePrefix}-aumChkUpd-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsAuditAppGwWaf: take('${varDeploymentNameWrappers.basePrefix}-auditAppGwWaf-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsCorpDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-denyPubEnd-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-denyPubEnd-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsCorpDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-deployPrivDns-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-deployPrivDns-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsCorpDenyPipOnNic: take('${varDeploymentNameWrappers.basePrefix}-denyPipNic-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpDenyPipOnNic: take('${varDeploymentNameWrappers.basePrefix}-denyPipNic-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsCorpDenyHybridNet: take('${varDeploymentNameWrappers.basePrefix}-denyHybridNet-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpDenyHybridNet: take('${varDeploymentNameWrappers.basePrefix}-denyHybridNet-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsCorpAuditPeDnsZones: take('${varDeploymentNameWrappers.basePrefix}-auditPeDns-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpAuditPeDnsZones: take('${varDeploymentNameWrappers.basePrefix}-auditPeDns-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiDecommEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-enforceAlz-decomm-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiSandboxEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-enforceAlz-sbox-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

var varPolicyAssignmentAuditAppGWWAF = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_appgw_waf.tmpl.json')
}

var varPolicyAssignmentAuditPeDnsZones = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-PrivateLinkDnsZones'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_pednszones.tmpl.json')
}

var varPolicyAssignmentAuditLocationMatch = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_res_location_match_rg_location.tmpl.json')
}

var varPolicyAssignmentAuditUnusedResources = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Audit-UnusedResourcesCostOptimization'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_unusedresources.tmpl.json')
}

var varPolicyAssignmentAuditTrustedLaunch = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Audit-TrustedLaunch'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_trustedlaunch.tmpl.json')
}

var varPolicyAssignmentAuditZoneResiliency = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/130fb88f-0fc9-4678-bfe1-31022d71c7d5'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_zoneresiliency.tmpl.json')
}

var varPolicyAssignmentDenyClassicResources = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_classic-resources.tmpl.json')
}

var varPolicyAssignmentEnforceAKSHTTPS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_http_ingress_aks.tmpl.json')
}

var varPolicyAssignmentDenyHybridNetworking = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_hybridnetworking.tmpl.json')
}

var varPolicyAssignmentDenyIPForwarding = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_ip_forwarding.tmpl.json')
}

var varPolicyAssignmentDenyMgmtPortsInternet = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MgmtPorts-From-Internet'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_mgmtports_internet.tmpl.json')
}

var varPolicyAssignmentDenyPrivContainersAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_containers_aks.tmpl.json')
}

var varPolicyAssignmentDenyPrivEscalationAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_escalation_aks.tmpl.json')
}

var varPolicyAssignmentDenyPublicEndpoints = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json')
}

var varPolicyAssignmentDenyPublicIPOnNIC = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip_on_nic.tmpl.json')
}

var varPolicyAssignmentDenyPublicIP = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json')
}

var varPolicyAssignmentEnforceAumCheckUpdates= {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-AUM-CheckUpdates'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_aum_checkupdates.tmpl.json')
}

var varPolicyAssignmentDenyStoragehttp = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json')
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json')
}

var varPolicyAssignmentDenyUnmanagedDisk = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_unmanageddisk.tmpl.json')
}

var varPolicyAssignmentDeployASCMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json')
}

var varPolicyAssignmentDeployAzActivityLog = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json')
}

var varPolicyAssignmentDeployAzSqlDbAuditing = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/25da7dfb-0666-4a15-a8f5-402127efd8bb'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azsql_db_auditing.tmpl.json')
}

var varPolicyAssignmentDeployLogAnalytics = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json')
}

var varPolicyAssignmentDeployMDEndpoints = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e20d08c5-6d64-656d-6465-ce9e37fd0ebc'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdeendpoints.tmpl.json')
}

var varPolicyAssignmentDeployMDEndpointsAma = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/77b391e3-2d5d-40c3-83bf-65c846b3c6a3'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_md_endpoints_ama.tmpl.json')
}

var varPolicyAssignmentDeployMDFCConfig = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config_20240319'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_config.tmpl.json')
}

var varPolicyAssignmentDeployMDFCOssDb = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e77fc0b3-f7e9-4c58-bc13-cb753ed8e46e'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_ossdb.tmpl.json')
}

var varPolicyAssignmentDeployMDFCSqlAtp = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/9cb3cc7a-b39b-4b82-bc89-e5a5d9ff7b97'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_sqlatp.tmpl.json')
}

var varPolicyAssignmentDeployPrivateDNSZones = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_private_dns_zones.tmpl.json')
}

var varPolicyAssignmentDeployResourceDiag = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/0884adba-2312-4468-abeb-5422caed1038'
  conditionalDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/f5b29bc4-feca-4cc6-a58a-772dd5e290a5'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json')
}

var varPolicyAssignmentDeploySQLTDE = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_tde.tmpl.json')
}

var varPolicyAssignmentDeploySQLThreat = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_threat.tmpl.json')
}

var varPolicyAssignmentDeployVMBackup = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_backup.tmpl.json')
}

var varPolicyAssignmentDeployVmArcChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/53448c70-089b-4f52-8f38-89196d7f2de1'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_arc_changetrack.tmpl.json')
}

var varPolicyAssignmentDeployVmChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/92a36f05-ebc9-4bba-9128-b47ad2ea3354'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_changetrack.tmpl.json')
}

var varPolicyAssignmentDeployVmssChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c4a70814-96be-461c-889f-2b27429120dc'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_changetrack.tmpl.json')
}

var varPolicyAssignmentDeployvmHybrMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/2b00397d-c309-49c4-aa5a-f0b2c5bc6321'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_arc_monitor.tmpl.json')
}

var varPolicyAssignmentDeployVMMonitor24 = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/924bfe3a-762f-40e7-86dd-5c8b95eb09e6'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_monitor.tmpl.json')
}

var varPolicyAssignmentDeployVMSSMonitor24 = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/f5bf694c-cca7-4033-b883-3a23327d5485'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_monitor.tmpl.json')
}

var varPolicyAssignmentDeployMdfcDefSqlAma = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/de01d381-bae9-4670-8870-786f89f49e26'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_sql-ama.tmpl.json')
}

var varPolicyAssignmentDenyActionDeleteUAMIAMA = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/DenyAction-DeleteResources'
	libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_deleteuamiama.tmlp.json')
}

var varPolicyAssignmentEnableDDoSVNET = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json')
}

var varPolicyAssignmentEnforceSubnetPrivate = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7bca8353-aa3b-429b-904a-9229c4385837'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_subnet_private.tmpl.json')
}

var varPolicyAssignmentEnforceACSB = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ACSB'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_acsb.tmpl.json')
}

var varPolicyAssignmentEnforceAsr = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Backup'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_backup.json')
}

var varPolicyAssignmentEnforceALZDecomm = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Decomm'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_alz_decomm.tmpl.json')
}

var varPolicyAssignmentEnforceALZSandbox = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Sandbox'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_alz_sandbox.tmpl.json')
}

var varPolicyAssignmentEnforceGRKeyVault = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-KeyVault'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_keyvault.tmpl.json')
}

var varPolicyAssignmentEnforceTLSSSL = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit_20241211'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_tls_ssl.tmpl.json')
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var varRbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
  logAnalyticsContributor: '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  sqlSecurityManager: '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  vmContributor: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  monitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  aksPolicyAddon: '18ed5180-3e48-46fd-8541-4ea054d57064'
  sqlDbContributor: '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  backupContributor: '5e467623-bb1f-42f4-a55d-6e525e11384b'
  rbacSecurityAdmin: 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  managedIdentityOperator: 'f1a07417-d97a-45cb-824c-7a7467783830'
  connectedMachineResourceAdministrator: 'cd570a14-e51a-42ad-bac8-bafd67325302'
}

// Management Groups Variables - Used For Policy Assignments
var varManagementGroupIds = {
  intRoot: '${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}'
  platform: '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformManagement: parPlatformMgAlzDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-management${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformConnectivity: parPlatformMgAlzDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-connectivity${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformIdentity: parPlatformMgAlzDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-identity${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones${parTopLevelManagementGroupSuffix}'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp${parTopLevelManagementGroupSuffix}'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online${parTopLevelManagementGroupSuffix}'
  landingZonesConfidentialCorp: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-corp${parTopLevelManagementGroupSuffix}'
  landingZonesConfidentialOnline: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-online${parTopLevelManagementGroupSuffix}'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned${parTopLevelManagementGroupSuffix}'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox${parTopLevelManagementGroupSuffix}'
}

type typManagementGroupIdOverrides = {
  intRoot: string?
  platform: string?
  platformManagement: string?
  platformConnectivity: string?
  platformIdentity: string?
  landingZones: string?
  landingZonesCorp: string?
  landingZonesOnline: string?
  landingZonesConfidentialCorp: string?
  landingZonesConfidentialOnline: string?
  decommissioned: string?
  sandbox: string?
}

@description('Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.')
param parManagementGroupIdOverrides typManagementGroupIdOverrides?

var varManagementGroupIdsUnioned = union(
  varManagementGroupIds,
  parManagementGroupIdOverrides ?? {}
)

var varCorpManagementGroupIds = [
  varManagementGroupIdsUnioned.landingZonesCorp
  varManagementGroupIdsUnioned.landingZonesConfidentialCorp
]

var varCorpManagementGroupIdsFiltered = parLandingZoneMgConfidentialEnable ? varCorpManagementGroupIds : filter(varCorpManagementGroupIds, mg => !contains(toLower(mg), 'confidential'))

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIdsUnioned.intRoot}'

// Deploy-Private-DNS-Zones Variables

var varPrivateDnsZonesResourceGroupSubscriptionId = !empty(parPrivateDnsResourceGroupId) ? split(parPrivateDnsResourceGroupId, '/')[2] : ''

var varPrivateDnsZonesBaseResourceId = '${parPrivateDnsResourceGroupId}/providers/Microsoft.Network/privateDnsZones/'

var varGeoCodes = {
  australiacentral: 'acl'
  australiacentral2: 'acl2'
  australiaeast: 'ae'
  australiasoutheast: 'ase'
  brazilsoutheast: 'bse'
  brazilsouth: 'brs'
  canadacentral: 'cnc'
  canadaeast: 'cne'
  centralindia: 'inc'
  centralus: 'cus'
  centraluseuap: 'ccy'
  chilecentral: 'clc'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'ecy'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  israelcentral: 'ilc'
  italynorth: 'itn'
  japaneast: 'jpe'
  japanwest: 'jpw'
  koreacentral: 'krc'
  koreasouth: 'krs'
  malaysiasouth: 'mys'
  malaysiawest: 'myw'
  mexicocentral: 'mxc'
  newzealandnorth: 'nzn'
  northcentralus: 'ncus'
  northeurope: 'ne'
  norwayeast: 'nwe'
  norwaywest: 'nww'
  polandcentral: 'plc'
  qatarcentral: 'qac'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southeastasia: 'sea'
  southindia: 'ins'
  spaincentral: 'spc'
  swedencentral: 'sdc'
  swedensouth: 'sds'
  switzerlandnorth: 'szn'
  switzerlandwest: 'szw'
  taiwannorth: 'twn'
  uaecentral: 'uac'
  uaenorth: 'uan'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'we'
  westindia: 'inw'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
}

var varSelectedGeoCode = !empty(parPrivateDnsZonesLocation) ? varGeoCodes[parPrivateDnsZonesLocation] : null

var varPrivateDnsZonesFinalResourceIds = {
  azureAcrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurecr.io'
  azureAppPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azconfig.io'
  azureAppServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurewebsites.net'
  azureArcGuestconfigurationPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.guestconfiguration.azure.com'
  azureArcHybridResourceProviderPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.his.arc.azure.com'
  azureArcKubernetesConfigurationPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dp.kubernetesconfiguration.azure.com'
  azureAsrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.siterecovery.windowsazure.com'
  azureAutomationDSCHybridPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureAutomationWebhookPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureBatchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.batch.azure.com'
  azureBotServicePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.directline.botframework.com'
  azureCognitiveSearchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.search.windows.net'
  azureCognitiveServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cognitiveservices.azure.com'
  azureCosmosCassandraPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cassandra.cosmos.azure.com'
  azureCosmosGremlinPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.gremlin.cosmos.azure.com'
  azureCosmosMongoPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.mongo.cosmos.azure.com'
  azureCosmosSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.documents.azure.com'
  azureCosmosTablePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.table.cosmos.azure.com'
  azureDataFactoryPortalPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.adf.azure.com'
  azureDataFactoryPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.datafactory.azure.net'
  azureDatabricksPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azuredatabricks.net'
  azureDiskAccessPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureEventGridDomainsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureEventGridTopicsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureEventHubNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.afs.azure.net'
  azureHDInsightPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurehdinsight.net'
  azureIotCentralPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azureiotcentral.com'
  azureIotDeviceupdatePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureIotHubsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureIotPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices-provisioning.net'
  azureKeyVaultPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.vaultcore.azure.net'
  azureMachineLearningWorkspacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.api.azureml.ms'
  azureMachineLearningWorkspaceSecondPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.notebooks.azure.net'
  azureManagedGrafanaWorkspacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.grafana.azure.com'
  azureMediaServicesKeyPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesLivePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesStreamPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMigratePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.prod.migration.windowsazure.com'
  azureMonitorPrivateDnsZoneId1: '${varPrivateDnsZonesBaseResourceId}privatelink.monitor.azure.com'
  azureMonitorPrivateDnsZoneId2: '${varPrivateDnsZonesBaseResourceId}privatelink.oms.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId3: '${varPrivateDnsZonesBaseResourceId}privatelink.ods.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId4: '${varPrivateDnsZonesBaseResourceId}privatelink.agentsvc.azure-automation.net'
  azureMonitorPrivateDnsZoneId5: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureRedisCachePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.redis.cache.windows.net'
  azureServiceBusNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureSignalRPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.service.signalr.net'
  azureSiteRecoveryBackupPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.${varSelectedGeoCode}.backup.windowsazure.com'
  azureSiteRecoveryBlobPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureSiteRecoveryQueuePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageBlobPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageBlobSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageDFSPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageDFSSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.file.core.windows.net'
  azureStorageQueuePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageQueueSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageStaticWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageStaticWebSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageTablePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.table.core.windows.net'
  azureStorageTableSecondaryPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.table.core.windows.net'
  azureSynapseDevPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dev.azuresynapse.net'
  azureSynapseSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseSQLODPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureVirtualDesktopHostpoolPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.wvd.microsoft.com'
  azureVirtualDesktopWorkspacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.wvd.microsoft.com'
  azureWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.webpubsub.azure.com'
}

// **Scope**
targetScope = 'managementGroup'

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

module modCustomerUsageAttributionZtnP1 '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut && varZtnP1Trigger) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varZtnP1CuaId}-${uniqueString(deployment().location)}'
  params: {}
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-MDFC-Config-H224
module modPolAssiIntRootDeployMdfcConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCConfig.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployMdfcConfig
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCConfig.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCConfig.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      emailSecurityContact: {
        value: parMsDefenderForCloudEmailSecurityContact
      }
      ascExportResourceGroupLocation: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMDFCConfig.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpoints
module modPolAssiIntRootDeployMDEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDEndpoints.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployMDEnpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDEndpoints.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMDEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDEndpoints.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMDEndpoints.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpointsAMA
module modPolAssiIntRootDeployMDEndpointsAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDEndpointsAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployMDEnpointsAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDEndpointsAma.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.rbacSecurityAdmin
    ]
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMDEndpointsAma.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolAssiIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzActivityLog.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployAzActivityLog
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzActivityLog.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployAzActivityLog.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzActivityLog.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
    ]
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployAzActivityLog.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring
module modPolAssiIntRootDeployAscMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployASCMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployAscMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployASCMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployASCMonitoring.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Diag-Logs
module modPolAssiIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployResourceDiag.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentDefinitionId: parLogAnalyticsWorkspaceResourceCategory =~ 'allLogs' ? varPolicyAssignmentDeployResourceDiag.definitionId : varPolicyAssignmentDeployResourceDiag.conditionalDefinitionId
    parPolicyAssignmentDefinitionVersion: parLogAnalyticsWorkspaceResourceCategory =~ 'allLogs' ? varPolicyAssignmentDeployResourceDiag.libDefinition.properties.definitionVersion : varPolicyAssignmentDeployResourceDiag.libDefinition.properties.conditionalDefinitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployResourceDiag.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployResourceDiag.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ACSB
module modPolAssiIntRootEnforceAcsb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceACSB.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootEnforceAcsb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceACSB.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceACSB.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceACSB.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceACSB.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceACSB.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceACSB.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceACSB.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceACSB.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-OssDb
module modPolAssiIntRootDeployMdfcOssDb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCOssDb.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployMdfcOssDb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCOssDb.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCOssDb.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMDFCOssDb.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-SqlAtp
module modPolAssiIntRootDeployMdfcSqlAtp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDeployMdfcSqlAtp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCSqlAtp.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Location Match
module modPolAssiIntRootAuditLocationMatch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditLocationMatch.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootAuditLocationMatch
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditLocationMatch.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentAuditLocationMatch.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditLocationMatch.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditLocationMatch.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditLocationMatch.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Zone Resiliency
module modPolAssiIntRootAuditZoneResiliency '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditZoneResiliency.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootAuditZoneResiliency
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditZoneResiliency.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentAuditZoneResiliency.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditZoneResiliency.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditZoneResiliency.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit-UnusedResources
module modPolAssiIntRootAuditUnusedRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditUnusedResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootAuditUnusedRes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditUnusedResources.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditUnusedResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditUnusedResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditUnusedResources.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditUnusedResources.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Trusted Launch
module modPolAssiIntRootAuditTrustedLaunch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditTrustedLaunch.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootAuditTrustedLaunch
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditTrustedLaunch.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditTrustedLaunch.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditTrustedLaunch.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditTrustedLaunch.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-UnmanagedDisk
module modPolAssiIntRootDenyUnmanagedDisks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDenyUnmanagedDisks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyUnmanagedDisk.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.enforcementMode
    parPolicyAssignmentOverrides: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.overrides
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Classic-Resources
module modPolAssiIntRootDenyClassicRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyClassicResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootDenyClassicRes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyClassicResources.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyClassicResources.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyClassicResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyClassicResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyClassicResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyClassicResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyClassicResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyClassicResources.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyClassicResources.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Platform Management Group
// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module modPolAssiPlatformDeployVmArcChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmArcTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmArcChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-ChangeTrack
module modPolAssiPlatformDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-ChangeTrack
module modPolAssiPlatformDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmssChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmssChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmHybr-Monitoring
module modPolAssiPlatformDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmArcMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployvmHybrMonitoring.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.reader
      varRbacRoleDefinitionIds.connectedMachineResourceAdministrator
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitor-24
module modPolAssiPlatformDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMMonitor24.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitor24.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitor24.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitor24.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMMonitor24.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-DefSQL-AMA
module modPolAssiPlatformDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployMdfcDefSqlAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMdfcDefSqlAma.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      userWorkspaceResourceId: {
        value: parLogAnalyticsWorkspaceResourceId
      }
      dcrResourceId: {
        value: parDataCollectionRuleMDFCSQLResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

module modPolAssiPlatformDenyDeleteUAMIAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDenyDeleteUAMIAMA
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyActionDeleteUAMIAMA.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      resourceName: {
        value: varUserAssignedManagedIdentityResourceName
      }
    }
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module modPolAssiPlatformDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformDeployVmssMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitor24.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}
// Module - Policy Assignment - Enforce-Subnet-Private
module modPolAssiPlatformEnforceSubnetPrivate '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceSubnetPrivate
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceSubnetPrivate.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVault
module modPolAssiPlatformEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGrKeyVault
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVault.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module modPolAssiPlatformEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAsr.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceAsr
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAsr.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAsr.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAsr.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAsr.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAsr.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAsr.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceAsr.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceAsr.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module modPolAssiPlatformEnforceAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceAumCheckUpdates
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAumCheckUpdates.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.connectedMachineResourceAdministrator
      varRbacRoleDefinitionIds.managedIdentityOperator
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module modPolAssiConnEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformConnectivity)
  name: varModDepNames.modPolAssiConnEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: parDdosProtectionPlanId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (!parDdosEnabled || parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnableDDoSVNET.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolAssiIdentDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIP.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformIdentity)
  name: varModDepNames.modPolAssiIdentDenyPublicIp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyPublicIP.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyPublicIP.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolAssiIdentDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformIdentity)
  name: varModDepNames.modPolAssiIdentDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolAssiIdentDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformIdentity)
  name: varModDepNames.modPolAssiIdentDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolAssiIdentDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformIdentity)
  name: varModDepNames.modPolAssiIdentDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMBackup.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: parVmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: parVmBackupExclusionTagValue
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMBackup.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.backupContributor
      varRbacRoleDefinitionIds.vmContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group
// Module - Policy Assignment - Deploy-Log-Analytics
module modPolAssiMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployLogAnalytics.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platformManagement)
  name: varModDepNames.modPolAssiMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployLogAnalytics.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployLogAnalytics.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      rgName: {
        value: varLogAnalyticsWorkspaceResourceGroupName
      }
      workspaceName: {
        value: varLogAnalyticsWorkspaceName
      }
      workspaceRegion: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      dataRetention: {
        value: parLogAnalyticsWorkspaceLogRetentionInDays
      }
      automationAccountName: {
        value: parAutomationAccountName
      }
      automationRegion: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployLogAnalytics.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployLogAnalytics.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Deny-IP-Forwarding
module modPolAssiLzsDenyIpForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyIPForwarding.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenyIpForwarding
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyIPForwarding.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyIPForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIPForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyIPForwarding.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolAssiLzsDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolAssiLzsDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolAssiLzsDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMBackup.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: parVmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: parVmBackupExclusionTagValue
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMBackup.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolAssiLzsEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: parDdosProtectionPlanId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (!parDdosEnabled || parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnableDDoSVNET.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http
module modPolAssiLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyStoragehttp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStoragehttp.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyStoragehttp.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS
module modPolAssiLzsDenyPrivEscalationAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenyPrivEscalationAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivEscalationAKS.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS
module modPolAssiLzsDenyPrivContainersAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDenyPrivContainersAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivContainersAKS.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS
module modPolAssiLzsEnforceAksHttps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceAksHttps
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAKSHTTPS.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL-H224
module modPolAssiLzsEnforceTlsSsl '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceTLSSSL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceTlsSsl
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceTLSSSL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceTLSSSL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTLSSSL.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceTLSSSL.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzSqlDb-Auditing
module modPolAssiLzsDeployAzSqlDbAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parLogAnalyticsWorkspaceResourceId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployAzSqlDbAuditing
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzSqlDbAuditing.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalyticsWorkspaceId: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parPolicyAssignmentIdentityRoleAssignmentsSubs: [
      varLogAnalyticsWorkspaceSubscription
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat
module modPolAssiLzsDeploySqlThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLThreat.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeploySqlThreat
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLThreat.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeploySQLThreat.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-TDE
module modPolAssiLzsDeploySqlTde '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLTDE.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeploySqlTde
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLTDE.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLTDE.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLTDE.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeploySQLTDE.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLTDE.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlDbContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module modPolAssiLzsDeployVmArcTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmArcTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmArcChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-ChangeTrack
module modPolAssiLzsDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-ChangeTrack
module modPolAssiLzsDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmssChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmssChangeTrack.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmHybr-Monitoring
module modPolAssiLzsDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmArcMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployvmHybrMonitoring.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.reader
      varRbacRoleDefinitionIds.connectedMachineResourceAdministrator
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitor-24
module modPolAssiLzsDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMMonitor24.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitor24.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitor24.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitor24.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMMonitor24.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMMonitor24.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module modPolAssiLzsDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployVmssMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitor24.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitor24.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployVMSSMonitor24.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployVMSSMonitor24.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-DefSQL-AMA
module modPolAssiLzsmDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsDeployMdfcDefSqlAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMdfcDefSqlAma.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      userWorkspaceResourceId: {
        value: parLogAnalyticsWorkspaceResourceId
      }
      dcrResourceId: {
        value: parDataCollectionRuleMDFCSQLResourceId
      }
      userAssignedIdentityResourceId: {
        value: parUserAssignedManagedIdentityResourceId
      }
    }
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
      varRbacRoleDefinitionIds.managedIdentityOperator
      varRbacRoleDefinitionIds.reader
    ]
    parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs: [
      string(varManagementGroupIdsUnioned.platform)
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-Subnet-Private
module modPolAssiLzsEnforceSubnetPrivate '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceSubnetPrivate
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceSubnetPrivate.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceSubnetPrivate.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceSubnetPrivate.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceSubnetPrivate.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVault
module modPolAssiLzsEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGrKeyVault
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVault.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module modPolAssiLzsEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAsr.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceAsr
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAsr.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAsr.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAsr.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAsr.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAsr.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAsr.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceAsr.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceAsr.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module modPolAssiLzsAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsAumCheckUpdates
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAumCheckUpdates.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.connectedMachineResourceAdministrator
      varRbacRoleDefinitionIds.managedIdentityOperator
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit-AppGW-WAF
module modPolAssiLzsAuditAppGwWaf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditAppGWWAF.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsAuditAppGwWaf
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditAppGWWAF.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentAuditAppGWWAF.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditAppGWWAF.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditAppGWWAF.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolAssiLzsDenyPublicEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicEndpoints.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModDepNames.modPolAssiLzsConfidentialCorpDenyPublicEndpoints : varModDepNames.modPolAssiLzsCorpDenyPublicEndpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicEndpoints.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyPublicEndpoints.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Deploy-Private-DNS-Zones
module modPolAssiConnDeployPrivateDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if ((!empty(varPrivateDnsZonesResourceGroupSubscriptionId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name)) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModDepNames.modPolAssiLzsConfidentialCorpDeployPrivateDnsZones : varModDepNames.modPolAssiLzsCorpDeployPrivateDnsZones
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployPrivateDNSZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      azureAcrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAcrPrivateDnsZoneId
      }
      azureAppPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppPrivateDnsZoneId
      }
      azureAppServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppServicesPrivateDnsZoneId
      }
      azureArcGuestconfigurationPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureArcGuestconfigurationPrivateDnsZoneId
      }
      azureArcHybridResourceProviderPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureArcHybridResourceProviderPrivateDnsZoneId
      }
      azureArcKubernetesConfigurationPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureArcKubernetesConfigurationPrivateDnsZoneId
      }
      azureAsrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAsrPrivateDnsZoneId
      }
      azureAutomationDSCHybridPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationDSCHybridPrivateDnsZoneId
      }
      azureAutomationWebhookPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationWebhookPrivateDnsZoneId
      }
      azureBatchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureBatchPrivateDnsZoneId
      }
      azureBotServicePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureBotServicePrivateDnsZoneId
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveSearchPrivateDnsZoneId
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveServicesPrivateDnsZoneId
      }
      azureCosmosCassandraPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosCassandraPrivateDnsZoneId
      }
      azureCosmosGremlinPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosGremlinPrivateDnsZoneId
      }
      azureCosmosMongoPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosMongoPrivateDnsZoneId
      }
      azureCosmosSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosSQLPrivateDnsZoneId
      }
      azureCosmosTablePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosTablePrivateDnsZoneId
      }
      azureDataFactoryPortalPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPortalPrivateDnsZoneId
      }
      azureDataFactoryPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPrivateDnsZoneId
      }
      azureDatabricksPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDatabricksPrivateDnsZoneId
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDiskAccessPrivateDnsZoneId
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridDomainsPrivateDnsZoneId
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridTopicsPrivateDnsZoneId
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventHubNamespacePrivateDnsZoneId
      }
      azureFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureFilePrivateDnsZoneId
      }
      azureHDInsightPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureHDInsightPrivateDnsZoneId
      }
      azureIotCentralPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotCentralPrivateDnsZoneId
      }
      azureIotDeviceupdatePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotDeviceupdatePrivateDnsZoneId
      }
      azureIotHubsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotHubsPrivateDnsZoneId
      }
      azureIotPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotPrivateDnsZoneId
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureKeyVaultPrivateDnsZoneId
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMachineLearningWorkspacePrivateDnsZoneId
      }
      azureMachineLearningWorkspaceSecondPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMachineLearningWorkspaceSecondPrivateDnsZoneId
      }
      azureManagedGrafanaWorkspacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureManagedGrafanaWorkspacePrivateDnsZoneId
      }
      azureMediaServicesKeyPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesKeyPrivateDnsZoneId
      }
      azureMediaServicesLivePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesLivePrivateDnsZoneId
      }
      azureMediaServicesStreamPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesStreamPrivateDnsZoneId
      }
      azureMigratePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMigratePrivateDnsZoneId
      }
      azureMonitorPrivateDnsZoneId1: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId1
      }
      azureMonitorPrivateDnsZoneId2: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId2
      }
      azureMonitorPrivateDnsZoneId3: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId3
      }
      azureMonitorPrivateDnsZoneId4: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId4
      }
      azureMonitorPrivateDnsZoneId5: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId5
      }
      azureRedisCachePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureRedisCachePrivateDnsZoneId
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureServiceBusNamespacePrivateDnsZoneId
      }
      azureSignalRPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSignalRPrivateDnsZoneId
      }
      azureSiteRecoveryBackupPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSiteRecoveryBackupPrivateDnsZoneId
      }
      azureSiteRecoveryBlobPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSiteRecoveryBlobPrivateDnsZoneId
      }
      azureSiteRecoveryQueuePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSiteRecoveryQueuePrivateDnsZoneId
      }
      azureStorageBlobPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobPrivateDnsZoneId
      }
      azureStorageBlobSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobSecPrivateDnsZoneId
      }
      azureStorageDFSPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSPrivateDnsZoneId
      }
      azureStorageDFSSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSSecPrivateDnsZoneId
      }
      azureStorageFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageFilePrivateDnsZoneId
      }
      azureStorageQueuePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueuePrivateDnsZoneId
      }
      azureStorageQueueSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueueSecPrivateDnsZoneId
      }
      azureStorageStaticWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebPrivateDnsZoneId
      }
      azureStorageStaticWebSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebSecPrivateDnsZoneId
      }
      azureStorageTablePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageTablePrivateDnsZoneId
      }
      azureStorageTableSecondaryPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageTableSecondaryPrivateDnsZoneId
      }
      azureSynapseDevPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseDevPrivateDnsZoneId
      }
      azureSynapseSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLPrivateDnsZoneId
      }
      azureSynapseSQLODPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLODPrivateDnsZoneId
      }
      azureVirtualDesktopHostpoolPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureVirtualDesktopHostpoolPrivateDnsZoneId
      }
      azureVirtualDesktopWorkspacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureVirtualDesktopWorkspacePrivateDnsZoneId
      }
      azureWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureWebPrivateDnsZoneId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parPolicyAssignmentIdentityRoleAssignmentsSubs: [
      varPrivateDnsZonesResourceGroupSubscriptionId
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Deny-Public-IP-On-NIC
module modPolAssiLzsCorpDenyPipOnNic '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModDepNames.modPolAssiLzsConfidentialCorpDenyPipOnNic : varModDepNames.modPolAssiLzsCorpDenyPipOnNic
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIPOnNIC.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Deny-HybridNetworking
module modPolAssiLzsCorpDenyHybridNet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyHybridNetworking.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModDepNames.modPolAssiLzsConfidentialCorpDenyHybridNet : varModDepNames.modPolAssiLzsCorpDenyHybridNet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyHybridNetworking.definitionId
    parPolicyAssignmentDefinitionVersion: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.definitionVersion
    parPolicyAssignmentName: varPolicyAssignmentDenyHybridNetworking.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyHybridNetworking.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentDenyHybridNetworking.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Audit-PeDnsZones
module modPolAssiLzsCorpAuditPeDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditPeDnsZones.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModDepNames.modPolAssiLzsConfidentialCorpAuditPeDnsZones : varModDepNames.modPolAssiLzsCorpAuditPeDnsZones
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditPeDnsZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditPeDnsZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: empty(parPrivateDnsZonesNamesToAuditInCorp) ? {} : {
      privateLinkDnsZones: {
        value: parPrivateDnsZonesNamesToAuditInCorp
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditPeDnsZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentAuditPeDnsZones.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Modules - Policy Assignments - Decommissioned Management Group
// Module - Policy Assignment - Enforce-ALZ-Decomm
module modPolAssiDecommEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZDecomm.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.decommissioned)
  name: varModDepNames.modPolAssiDecommEnforceAlz
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZDecomm.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZDecomm.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZDecomm.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceALZDecomm.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Sandbox Management Group
// Module - Policy Assignment - Enforce-ALZ-Sandbox
module modPolAssiSandboxEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZSandbox.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.sandbox)
  name: varModDepNames.modPolAssiSandboxEnforceAlz
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZSandbox.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZSandbox.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZSandbox.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: (parDisableAlzDefaultPolicies || contains(parPolicyAssignmentsToDisableEnforcement, varPolicyAssignmentEnforceALZSandbox.libDefinition.name)) ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
