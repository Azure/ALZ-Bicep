metadata name = 'ALZ Bicep - Default Policy Assignments'
metadata description = 'Assigns ALZ Default Policies to the Management Group hierarchy'

type policyAssignmentSovereigntyGlobalOptionsType = {
  @sys.description('Toggle to enable/disable deployment of Sovereignty Baseline - Global Policies at the intermediate root management group.')
  parTopLevelSovereigntyGlobalPoliciesEnable: bool

  @sys.description('List of allowed locations for resource deployment. If empty, only the deployment location is allowed.')
  parListOfAllowedLocations: string[]

  @sys.description('Effect type for Sovereignty Baseline - Global Policies.')
  parPolicyEffect: ('Audit' | 'Deny' | 'Disabled' | 'AuditIfNotExists')
}

type policyAssignmentSovereigntyConfidentialOptionsType = {
  @sys.description('List of approved Azure resource types (e.g., Confidential Computing SKUs or those not processing customer data). Leave empty to allow all relevant types.')
  parAllowedResourceTypes: string[]

  @sys.description('List of allowed locations for resource deployment. If empty, only the deployment location is allowed.')
  parListOfAllowedLocations: string[]

  @sys.description('List of approved VM SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs.')
  parAllowedVirtualMachineSKUs: string[]

  @sys.description('Effect type for Sovereignty Baseline - Confidential Policies.')
  parPolicyEffect: ('Audit' | 'Deny' | 'Disabled' | 'AuditIfNotExists')
}

@sys.description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Optional suffix for management group names/IDs. Include a dash if needed.')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('''Object used to assign Sovereignty Baseline - Global Policies to the intermediate root management group.'

- `parTopLevelSovereignGlobalPoliciesEnable` - Switch to enable/disable deployment of the Sovereignty Baseline - Global Policies Assignment to the intermediate root management group.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parPolicyEffect` - The effect type for the Sovereignty Baseline - Global Policies Assignment.

''')
param parTopLevelPolicyAssignmentSovereigntyGlobal policyAssignmentSovereigntyGlobalOptionsType = {
  parTopLevelSovereigntyGlobalPoliciesEnable: false
  parListOfAllowedLocations: []
  parPolicyEffect: 'Deny'
}

@sys.description('''Object used to assign Sovereignty Baseline - Confidential Policies to the confidential landing zone management groups.'

- `parAllowedResourceTypes` - The list of Azure resource types approved for usage, which is the set of resource types that have a SKU backed by Azure Confidential Computing or resource types that do not process customer data. Leave empty to allow all relevant resource types.
- `parListOfAllowedLocations` - The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
- `parallowedVirtualMachineSKUs` - The list of VM SKUs approved approved for usage, which is the set of SKUs backed by Azure Confidential Computing. Leave empty to allow all relevant SKUs.
- `parPolicyEffect` - The effect type for the Sovereignty Baseline - Confidential Policies Assignment.

''')
param parPolicyAssignmentSovereigntyConfidential policyAssignmentSovereigntyConfidentialOptionsType = {
  parAllowedResourceTypes: []
  parListOfAllowedLocations: []
  parAllowedVirtualMachineSKUs: []
  parPolicyEffect: 'Deny'
}

@sys.description('Toggle to apply platform policies to the Platform group or child groups.')
param parPlatformMgAlzDefaultsEnable bool = true

@sys.description('Toggle to assign policies to Corp & Online Management Groups under Landing Zones.')
param parLandingZoneChildrenMgAlzDefaultsEnable bool = true

@sys.description('Toggle to assign policies to Confidential Corp and Online groups under Landing Zones.')
param parLandingZoneMgConfidentialEnable bool = false

@sys.description('Location of Log Analytics Workspace & Automation Account.')
param parLogAnalyticsWorkSpaceAndAutomationAccountLocation string = 'eastus'

@sys.description('Resource ID of Log Analytics Workspace.')
param parLogAnalyticsWorkspaceResourceId string = ''

@sys.description('Resource ID for VM Insights Data Collection Rule.')
param parDataCollectionRuleVMInsightsResourceId string = ''

@sys.description('Resource ID for Change Tracking Data Collection Rule.')
param parDataCollectionRuleChangeTrackingResourceId string = ''

@sys.description('Resource ID for MDFC SQL Data Collection Rule.')
param parDataCollectionRuleMDFCSQLResourceId string = ''

@sys.description('Resource ID for User Assigned Managed Identity.')
param parUserAssignedManagedIdentityResourceId string = ''

@sys.description('Number of days to retain logs in Log Analytics Workspace.')
param parLogAnalyticsWorkspaceLogRetentionInDays string = '365'

@sys.description('Name of the Automation Account.')
param parAutomationAccountName string = 'alz-automation-account'

@sys.description('Email address for Microsoft Defender for Cloud alerts.')
param parMsDefenderForCloudEmailSecurityContact string = 'security_contact@replace_me.com'

@sys.description('Toggle to enable/disable DDoS Network Protection deployment. True enforces the Enable-DDoS-VNET policy at connectivity or landing zone groups; false does not.')
param parDdosEnabled bool = true

@sys.description('Resource ID of the DDoS Protection Plan applied to Virtual Networks.')
param parDdosProtectionPlanId string = ''

@sys.description('Resource ID of the Resource Group containing Private DNS Zones. Leave empty to skip assigning the Deploy-Private-DNS-Zones policy to the Corp Management Group.')
param parPrivateDnsResourceGroupId string = ''

@sys.description('List of Private DNS Zones to audit if deployed in Subscriptions under the Corp Management Group. Include all zones, as this parameter overwrites default values. Retrieve names from the outPrivateDnsZonesNames output in the Hub Networking or Private DNS Zone modules.')
param parPrivateDnsZonesNamesToAuditInCorp array = []

@sys.description('Set to true to disable enforcement of all default ALZ policies.')
param parDisableAlzDefaultPolicies bool = false

@sys.description('Set to true to disable enforcement of all default sovereign policies.')
param parDisableSlzDefaultPolicies bool = false

@sys.description('Tag name for excluding VMs from this policy’s scope. Use with the Exclusion Tag Value parameter.')
param parVmBackupExclusionTagName string = ''

@sys.description('Tag value for excluding VMs from this policy’s scope (use a comma-separated list for multiple values). Use with the Exclusion Tag Name parameter.')
param parVmBackupExclusionTagValue array = []

@sys.description('Add assignment definition names to exclude specific policies. Find values in the Assigning Policies documentation.')
param parExcludedPolicyAssignments array = []

@sys.description('Set to true to opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

var varLogAnalyticsWorkspaceName = split(parLogAnalyticsWorkspaceResourceId, '/')[8]

var varLogAnalyticsWorkspaceResourceGroupName = split(parLogAnalyticsWorkspaceResourceId, '/')[4]

var varLogAnalyticsWorkspaceSubscription = split(parLogAnalyticsWorkspaceResourceId, '/')[2]

var varUserAssignedManagedIdentityResourceName = split(parUserAssignedManagedIdentityResourceId, '/')[8]

// Customer Usage Attribution Id Telemetry
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// ZTN Telemetry
var varZtnP1CuaId = '4eaba1fc-d30a-4e63-a57f-9e6c3d86a318'
var varZtnP1Trigger = ((!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyStoragehttp.libDefinition.name))) ? true : false

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modPolicyAssignmentIntRootEnforceSovereigntyGlobal: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyGlobal-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMdfcConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAscMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResourceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMDEnpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDEndpoints-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMDEnpointsAma: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDEndpointsAma-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootEnforceAcsb: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAcsb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMdfcOssDb: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMdfcOssDb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMdfcSqlAtp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMdfcSqlAtp-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootAuditLocationMatch: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditLocationMatch-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootAuditZoneResiliency: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditZoneResiliency-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootAuditUnusedRes: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditUnusedRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootAuditTrustedLaunch: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditTrustedLaunch-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDenyClassicRes: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyClassicRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDenyUnmanagedDisks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyUnmanagedDisks-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmArcTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmArcChangeTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmChangeTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmssChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmssChangeTrack-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmArcMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmArcMonitor-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmMonitor-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployVmssMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmssMonitor-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDeployMdfcDefSqlAma: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDeleteUamiAma-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformDenyDeleteUAMIAMA: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deny-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformEnforceGrKeyVault: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceGrKeyVault-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformEnforceAsr: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployEnforceBackup-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentPlatformEnforceAumCheckUpdates: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployEnforceAumCheckUpdates-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentConnEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyIpForwarding: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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
  modPolicyAssignmentLzsDeployAzSqlDbAuditing: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzSQLDBAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlThreat: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLThreat-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlTde: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLTde-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmArcTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmArcChangeTrack-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmChangeTrack-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmssChangeTrack: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmssChangeTrack-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmArcMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmArcMonitor-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmMonitor-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmssMonitor: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVmssMonitor-Lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployMdfcDefSqlAma: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMdfcDefSqlAma-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceGrKeyVault: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceGrKeyVault-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceAsr: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployEnforceBackup-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsAumCheckUpdates: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployEnforceAumCheckUpdates-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsAuditAppGwWaf: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditAppGwWaf-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialOnlineEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyConf-confidential-online-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyConf-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDenyPipOnNic: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPipOnNic-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpDenyPipOnNic: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPipOnNic-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDenyHybridNet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyHybridNet-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpDenyHybridNet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyHybridNet-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpAuditPeDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditPeDnsZones-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsConfidentialCorpAuditPeDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditPeDnsZones-confidential-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentDecommEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAlz-decomm-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentSandboxEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAlz-sbox-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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

var varPolicyAssignmentEnforceSovereignConf = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/03de05a4-c324-4ccd-882f-a814ea8ab9ea'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_conf.tmpl.json')
}

var varPolicyAssignmentEnforceSovereignGlobal = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c1cbff38-87c0-4b9f-9f70-035c7a3b5523'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_global.tmpl.json')
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

var varPolicyAssignmentDeployAKSPolicy = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json')
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

var varPolicyAssignmentDeployVMMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/924bfe3a-762f-40e7-86dd-5c8b95eb09e6'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_monitor.tmpl.json')
}

var varPolicyAssignmentDeployVMSSMonitoring = {
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
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit_20240509'
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

var varCorpManagementGroupIds = [
  varManagementGroupIds.landingZonesCorp
  varManagementGroupIds.landingZonesConfidentialCorp
]

var varCorpManagementGroupIdsFiltered = parLandingZoneMgConfidentialEnable ? varCorpManagementGroupIds : filter(varCorpManagementGroupIds, mg => !contains(toLower(mg), 'confidential'))

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'

// Deploy-Private-DNS-Zones Variables

var varPrivateDnsZonesResourceGroupSubscriptionId = !empty(parPrivateDnsResourceGroupId) ? split(parPrivateDnsResourceGroupId, '/')[2] : ''

var varPrivateDnsZonesBaseResourceId = '${parPrivateDnsResourceGroupId}/providers/Microsoft.Network/privateDnsZones/'

var varPrivateDnsZonesFinalResourceIds = {
  azureFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.afs.azure.net'
  azureAutomationWebhookPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureAutomationDSCHybridPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureCosmosSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.documents.azure.com'
  azureCosmosMongoPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.mongo.cosmos.azure.com'
  azureCosmosCassandraPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cassandra.cosmos.azure.com'
  azureCosmosGremlinPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.gremlin.cosmos.azure.com'
  azureCosmosTablePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.table.cosmos.azure.com'
  azureDataFactoryPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.datafactory.azure.net'
  azureDataFactoryPortalPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.adf.azure.com'
  azureDatabricksPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azuredatabricks.net'
  azureHDInsightPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurehdinsight.net'
  azureMigratePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.prod.migration.windowsazure.com'
  azureStorageBlobPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageBlobSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageQueuePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageQueueSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.file.core.windows.net'
  azureStorageStaticWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageStaticWebSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageDFSPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageDFSSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureSynapseSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseSQLODPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseDevPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dev.azuresynapse.net'
  azureMediaServicesKeyPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesLivePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesStreamPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMonitorPrivateDnsZoneId1: '${varPrivateDnsZonesBaseResourceId}privatelink.monitor.azure.com'
  azureMonitorPrivateDnsZoneId2: '${varPrivateDnsZonesBaseResourceId}privatelink.oms.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId3: '${varPrivateDnsZonesBaseResourceId}privatelink.ods.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId4: '${varPrivateDnsZonesBaseResourceId}privatelink.agentsvc.azure-automation.net'
  azureMonitorPrivateDnsZoneId5: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.webpubsub.azure.com'
  azureBatchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.batch.azure.com'
  azureAppPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azconfig.io'
  azureAsrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.siterecovery.windowsazure.com'
  azureIotPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices-provisioning.net'
  azureKeyVaultPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.vaultcore.azure.net'
  azureSignalRPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.service.signalr.net'
  azureAppServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurewebsites.net'
  azureEventGridTopicsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureDiskAccessPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureCognitiveServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cognitiveservices.azure.com'
  azureIotHubsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureEventGridDomainsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureRedisCachePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.redis.cache.windows.net'
  azureAcrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurecr.io'
  azureEventHubNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureMachineLearningWorkspacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.api.azureml.ms'
  azureMachineLearningWorkspaceSecondPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.notebooks.azure.net'
  azureServiceBusNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureCognitiveSearchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.search.windows.net'
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
// Module - Policy Assignment - Enforce-Sovereign-Global
module modPolicyAssignmentIntRootEnforceSovereigntyGlobal '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignGlobal.libDefinition.name) && parTopLevelPolicyAssignmentSovereigntyGlobal.parTopLevelSovereigntyGlobalPoliciesEnable) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootEnforceSovereigntyGlobal
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceSovereignGlobal.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceSovereignGlobal.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceSovereignGlobal.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceSovereignGlobal.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceSovereignGlobal.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      listOfAllowedLocations: {
        #disable-next-line no-loc-expr-outside-params
        value: !(empty(parTopLevelPolicyAssignmentSovereigntyGlobal.parListOfAllowedLocations)) ? parTopLevelPolicyAssignmentSovereigntyGlobal.parListOfAllowedLocations : array(deployment().location)
      }
      effect: {
        value: parTopLevelPolicyAssignmentSovereigntyGlobal.parPolicyEffect
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceSovereignGlobal.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableSlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceSovereignGlobal.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-Config-H224
module modPolicyAssignmentIntRootDeployMdfcConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCConfig.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcConfig
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpoints
module modPolicyAssignmentIntRootDeployMDEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDEndpoints.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMDEnpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDEndpoints.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDEndpoints.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpointsAMA
module modPolicyAssignmentIntRootDeployMDEndpointsAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDEndpointsAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMDEnpointsAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDEndpointsAma.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDEndpointsAma.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.rbacSecurityAdmin
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDEndpointsAma.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzActivityLog.libDefinition.name)) {
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
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzActivityLog.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring
module modPolicyAssignmentIntRootDeployAscMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployASCMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAscMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployASCMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Diag-Logs
module modPolicyAssignmentIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployResourceDiag.libDefinition.name)) {
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
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.monitoringContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ACSB
module modPolicyAssignmentIntRootEnforceAcsb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceACSB.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootEnforceAcsb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceACSB.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceACSB.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceACSB.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceACSB.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceACSB.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceACSB.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceACSB.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-OssDb
module modPolicyAssignmentIntRootDeployMdfcOssDb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCOssDb.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcOssDb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCOssDb.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCOssDb.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-SqlAtp
module modPolicyAssignmentIntRootDeployMdfcSqlAtp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcSqlAtp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCSqlAtp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Location Match
module modPolicyAssignmentIntRootAuditLocationMatch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditLocationMatch.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootAuditLocationMatch
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditLocationMatch.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditLocationMatch.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditLocationMatch.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditLocationMatch.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditLocationMatch.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Zone Resiliency
module modPolicyAssignmentIntRootAuditZoneResiliency '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditZoneResiliency.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootAuditZoneResiliency
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditZoneResiliency.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditZoneResiliency.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditZoneResiliency.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditZoneResiliency.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit-UnusedResources
module modPolicyAssignmentIntRootAuditUnusedRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditUnusedResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootAuditUnusedRes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditUnusedResources.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditUnusedResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditUnusedResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditUnusedResources.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit Trusted Launch
module modPolicyAssignmentIntRootAuditTrustedLaunch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditTrustedLaunch.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootAuditTrustedLaunch
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditTrustedLaunch.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditTrustedLaunch.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditTrustedLaunch.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditTrustedLaunch.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-UnmanagedDisk
module modPolicyAssignmentIntRootDenyUnmanagedDisks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDenyUnmanagedDisks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyUnmanagedDisk.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.enforcementMode
    parPolicyAssignmentOverrides: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.overrides
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Classic-Resources
module modPolicyAssignmentIntRootDenyClassicRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyClassicResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDenyClassicRes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyClassicResources.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyClassicResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyClassicResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyClassicResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyClassicResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyClassicResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyClassicResources.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Platform Management Group
// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module modPolicyAssignmentPlatformDeployVmArcChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmArcTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmArcChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentPlatformDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentPlatformDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmssChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmssChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentPlatformDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmArcMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployvmHybrMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
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

// Module - Policy Assignment - Deploy-VM-Monitor-24
module modPolicyAssignmentPlatformDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentPlatformDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployMdfcDefSqlAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMdfcDefSqlAma.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.enforcementMode
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

module modPolicyAssignmentPlatformDenyDeleteUAMIAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDenyDeleteUAMIAMA
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyActionDeleteUAMIAMA.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      resourceName: {
        value: varUserAssignedManagedIdentityResourceName
      }
    }
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module modPolicyAssignmentPlatformDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformDeployVmssMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.enforcementMode
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

// Module - Policy Assignment - Enforce-GR-KeyVault
module modPolicyAssignmentPlatformEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformEnforceGrKeyVault
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVault.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module modPolicyAssignmentPlatformEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAsr.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformEnforceAsr
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAsr.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAsr.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAsr.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAsr.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAsr.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAsr.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAsr.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module modPolicyAssignmentPlatformEnforceAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
  name: varModuleDeploymentNames.modPolicyAssignmentPlatformEnforceAumCheckUpdates
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAumCheckUpdates.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentConnEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentConnEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
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
    parPolicyAssignmentEnforcementMode: !parDdosEnabled || parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIP.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolicyAssignmentIdentDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentIdentDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentIdentDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.backupContributor
      varRbacRoleDefinitionIds.vmContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group
// Module - Policy Assignment - Deploy-Log-Analytics
module modPolicyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployLogAnalytics.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformManagement)
  name: varModuleDeploymentNames.modPolicyAssignmentMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployLogAnalytics.definitionId
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Deny-IP-Forwarding
module modPolicyAssignmentLzsDenyIpForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyIPForwarding.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyIpForwarding
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyIPForwarding.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyIPForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIPForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolicyAssignmentLzsDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentLzsDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentLzsDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentLzsEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
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
    parPolicyAssignmentEnforcementMode: !parDdosEnabled || parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http
module modPolicyAssignmentLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyStoragehttp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStoragehttp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy
module modPolicyAssignmentLzsDeployAksPolicy '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAKSPolicy.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployAksPolicy
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAKSPolicy.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAKSPolicy.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAKSPolicy.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.aksContributor
      varRbacRoleDefinitionIds.aksPolicyAddon
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS
module modPolicyAssignmentLzsDenyPrivEscalationAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivEscalationAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivEscalationAKS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS
module modPolicyAssignmentLzsDenyPrivContainersAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivContainersAks
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivContainersAKS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS
module modPolicyAssignmentLzsEnforceAksHttps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceAksHttps
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAKSHTTPS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL
module modPolicyAssignmentLzsEnforceTlsSsl '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceTLSSSL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceTlsSsl
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceTLSSSL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceTLSSSL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTLSSSL.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzSqlDb-Auditing
module modPolicyAssignmentLzsDeployAzSqlDbAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(parLogAnalyticsWorkspaceResourceId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployAzSqlDbAuditing
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzSqlDbAuditing.definitionId
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentLzsDeploySqlThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLThreat.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlThreat
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLThreat.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-TDE
module modPolicyAssignmentLzsDeploySqlTde '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLTDE.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlTde
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLTDE.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLTDE.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLTDE.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLTDE.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlDbContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module modPolicyAssignmentLzsDeployVmArcTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmArcTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmArcChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmArcChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentLzsDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentLzsDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmssChangeTrack
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVmssChangeTrack.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVmssChangeTrack.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVmssChangeTrack.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentLzsDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmArcMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployvmHybrMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: parDataCollectionRuleVMInsightsResourceId
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

// Module - Policy Assignment - Deploy-VM-Monitor-24
module modPolicyAssignmentLzsDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.enforcementMode
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

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module modPolicyAssignmentLzsDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmssMonitor
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.enforcementMode
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

// Module - Policy Assignment - Deploy-MDFC-DefSQL-AMA
module modPolicyAssignmentLzsmDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployMdfcDefSqlAma
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMdfcDefSqlAma.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMdfcDefSqlAma.libDefinition.properties.enforcementMode
    parPolicyAssignmentParameterOverrides: {
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

// Module - Policy Assignment - Enforce-GR-KeyVault
module modPolicyAssignmentLzsEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceGrKeyVault
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVault.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module modPolicyAssignmentLzsEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAsr.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceAsr
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAsr.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAsr.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAsr.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAsr.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAsr.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAsr.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAsr.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module modPolicyAssignmentLzsAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsAumCheckUpdates
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAumCheckUpdates.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAumCheckUpdates.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
      varRbacRoleDefinitionIds.connectedMachineResourceAdministrator
      varRbacRoleDefinitionIds.managedIdentityOperator
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Audit-AppGW-WAF
module modPolicyAssignmentLzsAuditAppGwWaf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditAppGWWAF.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsAuditAppGwWaf
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditAppGWWAF.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditAppGWWAF.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditAppGWWAF.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolicyAssignmentLzsDenyPublicEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicEndpoints.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpDenyPublicEndpoints : varModuleDeploymentNames.modPolicyAssignmentLzsCorpDenyPublicEndpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicEndpoints.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Deploy-Private-DNS-Zones
module modPolicyAssignmentConnDeployPrivateDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if ((!empty(varPrivateDnsZonesResourceGroupSubscriptionId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name)) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpDeployPrivateDnsZones : varModuleDeploymentNames.modPolicyAssignmentLzsCorpDeployPrivateDnsZones
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployPrivateDNSZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      azureFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureFilePrivateDnsZoneId
      }
      azureAutomationWebhookPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationWebhookPrivateDnsZoneId
      }
      azureAutomationDSCHybridPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationDSCHybridPrivateDnsZoneId
      }
      azureCosmosSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosSQLPrivateDnsZoneId
      }
      azureCosmosMongoPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosMongoPrivateDnsZoneId
      }
      azureCosmosCassandraPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosCassandraPrivateDnsZoneId
      }
      azureCosmosGremlinPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosGremlinPrivateDnsZoneId
      }
      azureCosmosTablePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosTablePrivateDnsZoneId
      }
      azureDataFactoryPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPrivateDnsZoneId
      }
      azureDataFactoryPortalPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPortalPrivateDnsZoneId
      }
      azureDatabricksPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDatabricksPrivateDnsZoneId
      }
      azureHDInsightPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureHDInsightPrivateDnsZoneId
      }
      azureMigratePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMigratePrivateDnsZoneId
      }
      azureStorageBlobPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobPrivateDnsZoneId
      }
      azureStorageBlobSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobSecPrivateDnsZoneId
      }
      azureStorageQueuePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueuePrivateDnsZoneId
      }
      azureStorageQueueSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueueSecPrivateDnsZoneId
      }
      azureStorageFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageFilePrivateDnsZoneId
      }
      azureStorageStaticWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebPrivateDnsZoneId
      }
      azureStorageStaticWebSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebSecPrivateDnsZoneId
      }
      azureStorageDFSPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSPrivateDnsZoneId
      }
      azureStorageDFSSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSSecPrivateDnsZoneId
      }
      azureSynapseSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLPrivateDnsZoneId
      }
      azureSynapseSQLODPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLODPrivateDnsZoneId
      }
      azureSynapseDevPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseDevPrivateDnsZoneId
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
      azureWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureWebPrivateDnsZoneId
      }
      azureBatchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureBatchPrivateDnsZoneId
      }
      azureAppPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppPrivateDnsZoneId
      }
      azureAsrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAsrPrivateDnsZoneId
      }
      azureIotPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotPrivateDnsZoneId
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureKeyVaultPrivateDnsZoneId
      }
      azureSignalRPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSignalRPrivateDnsZoneId
      }
      azureAppServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppServicesPrivateDnsZoneId
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridTopicsPrivateDnsZoneId
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDiskAccessPrivateDnsZoneId
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveServicesPrivateDnsZoneId
      }
      azureIotHubsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotHubsPrivateDnsZoneId
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridDomainsPrivateDnsZoneId
      }
      azureRedisCachePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureRedisCachePrivateDnsZoneId
      }
      azureAcrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAcrPrivateDnsZoneId
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventHubNamespacePrivateDnsZoneId
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMachineLearningWorkspacePrivateDnsZoneId
      }
      azureMachineLearningWorkspaceSecondPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMachineLearningWorkspaceSecondPrivateDnsZoneId
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureServiceBusNamespacePrivateDnsZoneId
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveSearchPrivateDnsZoneId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.enforcementMode
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
module modPolicyAssignmentLzsCorpDenyPipOnNic '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpDenyPipOnNic : varModuleDeploymentNames.modPolicyAssignmentLzsCorpDenyPipOnNic
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIPOnNIC.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Deny-HybridNetworking
module modPolicyAssignmentLzsCorpDenyHybridNet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyHybridNetworking.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpDenyHybridNet : varModuleDeploymentNames.modPolicyAssignmentLzsCorpDenyHybridNet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyHybridNetworking.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyHybridNetworking.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyHybridNetworking.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Module - Policy Assignment - Audit-PeDnsZones
module modPolicyAssignmentLzsCorpAuditPeDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = [for mgScope in varCorpManagementGroupIdsFiltered: if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditPeDnsZones.libDefinition.name) && parLandingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(mgScope)
  name: contains(mgScope, 'confidential') ? varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpAuditPeDnsZones : varModuleDeploymentNames.modPolicyAssignmentLzsCorpAuditPeDnsZones
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
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}]

// Modules - Policy Assignments - Confidential Online Management Group
// Module - Policy Assignment - Enforce-Sovereign-Conf
module modPolicyAssignmentLzsConfidentialOnlineEnforceSovereigntyConf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignConf.libDefinition.name) && parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialOnline)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialOnlineEnforceSovereigntyConf
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceSovereignConf.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceSovereignConf.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      allowedResourceTypes: {
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parAllowedResourceTypes)) ? parPolicyAssignmentSovereigntyConfidential.parAllowedResourceTypes : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters.allowedResourceTypes.value
      }
      listOfAllowedLocations: {
        #disable-next-line no-loc-expr-outside-params
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parListOfAllowedLocations)) ? parPolicyAssignmentSovereigntyConfidential.parListOfAllowedLocations : array(deployment().location)
      }
      allowedVirtualMachineSKUs: {
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parAllowedVirtualMachineSKUs)) ? parPolicyAssignmentSovereigntyConfidential.parAllowedVirtualMachineSKUs : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters.allowedVirtualMachineSKUs.value
      }
      effect: {
        value: parPolicyAssignmentSovereigntyConfidential.parPolicyEffect
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceSovereignConf.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableSlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Confidential Corp Management Group
// Module - Policy Assignment - Enforce-Sovereign-Conf
module modPolicyAssignmentLzsConfidentialCorpEnforceSovereigntyConf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignConf.libDefinition.name) && parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsConfidentialCorpEnforceSovereigntyConf
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceSovereignConf.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceSovereignConf.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      allowedResourceTypes: {
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parAllowedResourceTypes)) ? parPolicyAssignmentSovereigntyConfidential.parAllowedResourceTypes : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters.allowedResourceTypes.value
      }
      listOfAllowedLocations: {
        #disable-next-line no-loc-expr-outside-params
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parListOfAllowedLocations)) ? parPolicyAssignmentSovereigntyConfidential.parListOfAllowedLocations : array(deployment().location)
      }
      allowedVirtualMachineSKUs: {
        value: !(empty(parPolicyAssignmentSovereigntyConfidential.parAllowedVirtualMachineSKUs)) ? parPolicyAssignmentSovereigntyConfidential.parAllowedVirtualMachineSKUs : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.parameters.allowedVirtualMachineSKUs.value
      }
      effect: {
        value: parPolicyAssignmentSovereigntyConfidential.parPolicyEffect
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceSovereignConf.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableSlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceSovereignConf.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Decommissioned Management Group
// Module - Policy Assignment - Enforce-ALZ-Decomm
module modPolicyAssignmentDecommEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZDecomm.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.decommissioned)
  name: varModuleDeploymentNames.modPolicyAssignmentDecommEnforceAlz
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZDecomm.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZDecomm.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZDecomm.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Sandbox Management Group
// Module - Policy Assignment - Enforce-ALZ-Sandbox
module modPolicyAssignmentSandboxEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZSandbox.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.sandbox)
  name: varModuleDeploymentNames.modPolicyAssignmentSandboxEnforceAlz
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZSandbox.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZSandbox.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZSandbox.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// The following module is used to deploy the policy exemptions
module modPolicyExemptionsConfidentialOnline '../../exemptions/policyExemptions.bicep' = if (parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialOnline)
  name: take('${parTopLevelManagementGroupPrefix}-deploy-policy-exemptions${parTopLevelManagementGroupSuffix}', 64)
  params: {
    parPolicyAssignmentId: modPolicyAssignmentIntRootEnforceSovereigntyGlobal.outputs.outPolicyAssignmentId
    parPolicyDefinitionReferenceIds: ['AllowedLocationsForResourceGroups', 'AllowedLocations']
    parExemptionName: 'Confidential-Online-Location-Exemption'
    parExemptionDisplayName: 'Confidential Online Location Exemption'
    parDescription: 'Exempt the confidential online management group from the SLZ Global location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included.'
  }
  dependsOn: [modPolicyAssignmentLzsConfidentialOnlineEnforceSovereigntyConf]
}

// The following module is used to deploy the policy exemptions
module modPolicyExemptionsConfidentialCorp '../../exemptions/policyExemptions.bicep' = if (parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialCorp)
  name: take('${parTopLevelManagementGroupPrefix}-deploy-policy-exemptions${parTopLevelManagementGroupSuffix}', 64)
  params: {
    parPolicyAssignmentId: modPolicyAssignmentIntRootEnforceSovereigntyGlobal.outputs.outPolicyAssignmentId
    parPolicyDefinitionReferenceIds: ['AllowedLocationsForResourceGroups', 'AllowedLocations']
    parExemptionName: 'Confidential-Corp-Location-Exemption'
    parExemptionDisplayName: 'Confidential Corp Location Exemption'
    parDescription: 'Exempt the confidential corp management group from the SLZ Global Policies location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included.'
  }
  dependsOn: [modPolicyAssignmentLzsConfidentialCorpEnforceSovereigntyConf]
}
