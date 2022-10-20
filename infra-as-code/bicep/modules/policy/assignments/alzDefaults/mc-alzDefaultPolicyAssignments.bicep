@description('Prefix for the management group hierarchy. DEFAULT VALUE = alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('The region where the Log Analytics Workspace & Automation Account are deployed. DEFAULT VALUE = chinaeast2')
param parLogAnalyticsWorkSpaceAndAutomationAccountLocation string = 'chinaeast2'

@description('Log Analytics Workspace Resource ID. - DEFAULT VALUE: Empty String ')
param parLogAnalyticsWorkspaceResourceID string = ''

@description('Number of days of log retention for Log Analytics Workspace. - DEFAULT VALUE: 365')
param parLogAnalyticsWorkspaceLogRetentionInDays string = '365'

@description('Automation account name. - DEFAULT VALUE: alz-automation-account')
param parAutomationAccountName string = 'alz-automation-account'

@description('An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.')
param parMsDefenderForCloudEmailSecurityContact string = 'security_contact@replace_me.com'

@description('ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues. Default: Empty String')
param parDdosProtectionPlanId string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varLogAnalyticsWorkspaceName = split(parLogAnalyticsWorkspaceResourceID, '/')[8]

var varLogAnalyticsWorkspaceResourceGroupName = split(parLogAnalyticsWorkspaceResourceID, '/')[4]

// Customer Usage Attribution Id
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modPolicyAssignmentIntRootDeployMDFCConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployASCMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResourceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVMMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVMSSMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMSSMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentConnEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIP: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyRDPFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNSG: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDeployVMBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyIPForwarding: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyPublicIP: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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
  modPolicyAssignmentLZsDenyDataBPip: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBPip-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyDataBSku: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBSku-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLZsDenyDataBVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBVnet-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

var varPolicyAssignmentEnforceAKSHTTPS = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_http_ingress_aks.tmpl.json'))
}

var varPolicyAssignmentDenyIPForwarding = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_ip_forwarding.tmpl.json'))
}

var varPolicyAssignmentDenyPrivContainersAKS = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_priv_containers_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPrivEscalationAKS = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_priv_escalation_aks.tmpl.json'))
}

var varPolicyAssignmentDenyPublicEndpoints = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json'))
}

var varPolicyAssignmentDenyPublicIP = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
}

var varPolicyAssignmentDenyRDPFromInternet = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_rdp_from_internet.tmpl.json'))
}

var varPolicyAssignmentDenyStoragehttp = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json'))
}

var varPolicyAssignmentDeployAKSPolicy = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json'))
}

var varPolicyAssignmentDeployASCMonitoring = {
	definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployLogAnalytics = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json'))
}

var varPolicyAssignmentDeployMDFCConfig = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_mdfc_config.tmpl.json'))
}

var varPolicyAssignmentDeployResourceDiag = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json'))
}

var varPolicyAssignmentDeploySQLDBAuditing = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_sql_db_auditing.tmpl.json'))
}

var varPolicyAssignmentDeploySQLThreat = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_sql_threat.tmpl.json'))
}

var varPolicyAssignmentDeployVMBackup = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_vm_backup.tmpl.json'))
}

var varPolicyAssignmentDeployVMMonitoring = {
	definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_vm_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployVMSSMonitoring = {
	definitionID: '/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_deploy_vmss_monitoring.tmpl.json'))
}

var varPolicyAssignmentEnableDDoSVNET = {
	definitionID: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json'))
}

var varPolicyAssignmentEnforceTLSSSL = {
	definitionID: '${varTopLevelManagementGroupResourceID}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/china/policy_assignments/policy_assignment_es_enforce_tls_ssl.tmpl.json'))
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

var varTopLevelManagementGroupResourceID = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIDs.intRoot}'

// **Scope**
targetScope = 'managementGroup'

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-MDFC-Config
module modPolicyAssignmentIntRootDeployMDFCConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMDFCConfig
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCConfig.definitionID
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
        value: parLogAnalyticsWorkspaceResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring 
module modPolicyAssignmentIntRootDeployASCMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  // dependsOn: [
  //   modCustomPolicyDefinitions
  // ]
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployASCMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCMonitoring.definitionID
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
module modPolicyAssignmentIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployResourceDiag.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployResourceDiag.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitoring
module modPolicyAssignmentIntRootDeployVMMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVMMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitoring.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: parLogAnalyticsWorkspaceResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitoring
module modPolicyAssignmentIntRootDeployVMSSMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVMSSMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitoring.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: parLogAnalyticsWorkspaceResourceID
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// // Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentConnEnableDDoSVNET '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!empty(parDdosProtectionPlanId)) {
  scope: managementGroup(varManagementGroupIDs.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentConnEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionID
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIP '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIP
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionID
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
module modPolicyAssignmentIdentDenyRDPFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyRDPFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRDPFromInternet.definitionID
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
module modPolicyAssignmentIdentDenySubnetWithoutNSG '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNSG
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup 
module modPolicyAssignmentIdentDeployVMBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDeployVMBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group 
// Module - Policy Assignment - Deploy-Log-Analytics
module modPolicyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.platformManagement)
  name: varModuleDeploymentNames.modPolicyAssignmentMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployLogAnalytics.definitionID
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group 
// Module - Policy Assignment - Deny-IP-Forwarding
module modPolicyAssignmentLZsDenyIPForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyIPForwarding
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyIPForwarding.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyIPForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIPForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentLZstDenyRDPFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyRDPFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRDPFromInternet.definitionID
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
module modPolicyAssignmentLZsDenySubnetWithoutNSG '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenySubnetWithoutNSG
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentLZsDeployVMBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeployVMBackup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentLZsEnableDDoSVNET '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!empty(parDdosProtectionPlanId)) {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnableDDoSVNET
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionID
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.networkContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http 
module modPolicyAssignmentLZsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStoragehttp.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy 
module modPolicyAssignmentLZsDeployAKSPolicy '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeployAKSPolicy
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAKSPolicy.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeployAKSPolicy.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAKSPolicy.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.aksContributor
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS 
module modPolicyAssignmentLZsDenyPrivEscalationAKS '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPrivEscalationAKS
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivEscalationAKS.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS 
module modPolicyAssignmentLZsDenyPrivContainersAKS '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPrivContainersAKS
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivContainersAKS.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS 
module modPolicyAssignmentLZsEnforceAKSHTTPS '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnforceAKSHTTPS
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAKSHTTPS.definitionID
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
module modPolicyAssignmentLZsEnforceTLSSSL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsEnforceTLSSSL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceTLSSSL.definitionID
    parPolicyAssignmentName: varPolicyAssignmentEnforceTLSSSL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTLSSSL.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-DB-Auditing 
module modPolicyAssignmentLZsDeploySQLDBAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeploySQLDBAuditing
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLDBAuditing.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySQLDBAuditing.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat 
module modPolicyAssignmentLZsDeploySQLThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDeploySQLThreat
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLThreat.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRBACRoleDefinitionIDs.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolicyAssignmentLZsDenyPublicEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPublicEndpoints
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicEndpoints.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentLZsDenyPublicIP '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIDs.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLZsDenyPublicIP
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionID
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
