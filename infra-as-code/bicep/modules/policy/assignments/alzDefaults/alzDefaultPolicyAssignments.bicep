@description('Prefix for the management group hierarchy. DEFAULT VALUE = alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('The region where the Log Analytics Workspace & Automation Account are deployed. DEFAULT VALUE = eastus')
param parLogAnalyticsWorkSpaceAndAutomationAccountLocation string = 'eastus'

@description('Log Analytics Workspace Resource ID. - DEFAULT VALUE: Empty String ')
param parLogAnalyticsWorkspaceResourceId string = ''

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

var varLogAnalyticsWorkspaceName = split(parLogAnalyticsWorkspaceResourceId, '/')[8]

var varLogAnalyticsWorkspaceResourceGroupName = split(parLogAnalyticsWorkspaceResourceId, '/')[4]

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
  modPolicyAssignmentIntRootDeployMdfcConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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
  modPolicyAssignmentLzsDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
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
  modPolicyAssignmentLzsDenyDataBPip: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBPip-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyDataBSku: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBSku-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyDataBVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyDataBVnet-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

var varPolicyAssignmentDenyDataBPip = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-NoPublicIp'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_databricks_public_ip.tmpl.json'))
}

var varPolicyAssignmentDenyDataBSku = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-Sku'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_databricks_sku.tmpl.json'))
}

var varPolicyAssignmentDenyDataBVnet = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-VirtualNetwork'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_databricks_vnet.tmpl.json'))
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
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json'))
}

var varPolicyAssignmentDenyPublicIp = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json'))
}

var varPolicyAssignmentDenyRdpFromInternet = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rdp_from_internet.tmpl.json'))
}

var varPolicyAssignmentDenyStorageHttp = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json'))
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json'))
}


var varPolicyAssignmentDeployAksPolicy = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json'))
}

var varPolicyAssignmentDeployAscMonitoring = {
	definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json'))
}

var varPolicyAssignmentDeployAzActivityLog = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json'))
}

var varPolicyAssignmentDeployLogAnalytics = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json'))
}

var varPolicyAssignmentDeployMdfcConfig = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_config.tmpl.json'))
}

var varPolicyAssignmentDeployResourceDiag = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json'))
}

var varPolicyAssignmentDeploySqlDbAuditing = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_db_auditing.tmpl.json'))
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

var varPolicyAssignmentEnableDdosVnet = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
	libDefinition: json(loadTextContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json'))
}

var varPolicyAssignmentEnforceTlsSsl = {
	definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit'
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

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'

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
module modPolicyAssignmentIntRootDeployMdfcConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcConfig
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMdfcConfig.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMdfcConfig.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMdfcConfig.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMdfcConfig.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMdfcConfig.libDefinition.properties.parameters
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
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMdfcConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployMdfcConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring 
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitoring
module modPolicyAssignmentIntRootDeployVmMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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
        value: parLogAnalyticsWorkspaceResourceId
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
        value: parLogAnalyticsWorkspaceResourceId
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
module modPolicyAssignmentConnEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!empty(parDdosProtectionPlanId)) {
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
        value: parDdosProtectionPlanId
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

// Module - Policy Assignment - Deploy-VM-Backup 
module modPolicyAssignmentIdentDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Modules - Policy Assignments - Management Management Group 
// Module - Policy Assignment - Deploy-Log-Analytics
module modPolicyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group 
// Module - Policy Assignment - Deny-IP-Forwarding
module modPolicyAssignmentLzsDenyIpForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentLzsDenyRdpFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentLzsDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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
module modPolicyAssignmentLzsEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!empty(parDdosProtectionPlanId)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnableDdosVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDdosVnet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnableDdosVnet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDdosVnet.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: parDdosProtectionPlanId
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

// Module - Policy Assignment - Deny-Storage-http 
module modPolicyAssignmentLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deploy-AKS-Policy 
module modPolicyAssignmentLzsDeployAksPolicy '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deny-Priv-Escalation-AKS 
module modPolicyAssignmentLzsDenyPrivEscalationAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deny-Priv-Containers-AKS 
module modPolicyAssignmentLzsDenyPrivContainersAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Enforce-AKS-HTTPS 
module modPolicyAssignmentLzsEnforceAksHttps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deploy-SQL-DB-Auditing 
module modPolicyAssignmentLzsDeploySqlDbAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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

// Module - Policy Assignment - Deploy-SQL-Threat 
module modPolicyAssignmentLzsDeploySqlThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
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
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
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

// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentLzsDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
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

// Module - Policy Assignment - Deny-DataB-Pip
module modPolicyAssignmentLzsDenyDataBPip '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyDataBPip
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyDataBPip.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyDataBPip.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyDataBPip.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyDataBPip.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyDataBPip.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyDataBPip.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyDataBPip.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-DataB-Sku
module modPolicyAssignmentLzsDenyDataBSku '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyDataBSku
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyDataBSku.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyDataBSku.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyDataBSku.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyDataBSku.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyDataBSku.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyDataBSku.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyDataBSku.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-DataB-Vnet
module modPolicyAssignmentLzsDenyDataBVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyDataBVnet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyDataBVnet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyDataBVnet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyDataBVnet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyDataBVnet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyDataBVnet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyDataBVnet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyDataBVnet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
