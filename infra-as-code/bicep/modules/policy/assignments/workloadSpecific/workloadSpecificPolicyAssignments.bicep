metadata name = 'ALZ Bicep - Workload Specific Policy Assignments and Exemptions'
metadata description = 'Assigns Workload Specific Policy Assignments and Exemptions to the Management Group hierarchy'

type policyAssignmentSovereigntyGlobalOptionsType = {
  @description('Enable/disable Sovereignty Baseline - Global Policies at root management group.')
  parTopLevelSovereigntyGlobalPoliciesEnable: bool

  @description('Allowed locations for resource deployment. Empty = deployment location only.')
  parListOfAllowedLocations: string[]

  @description('Effect for Sovereignty Baseline - Global Policies.')
  parPolicyEffect: ('Audit' | 'Deny' | 'Disabled' | 'AuditIfNotExists')
}

type policyAssignmentSovereigntyConfidentialOptionsType = {
  @description('Approved Azure resource types. Empty = allow all.')
  parAllowedResourceTypes: string[]

  @description('Allowed locations for resource deployment. Empty = deployment location only.')
  parListOfAllowedLocations: string[]

  @description('Approved VM SKUs for Azure Confidential Computing. Empty = allow all.')
  parAllowedVirtualMachineSKUs: string[]

  @description('Effect for Sovereignty Baseline - Confidential Policies.')
  parPolicyEffect: ('Audit' | 'Deny' | 'Disabled' | 'AuditIfNotExists')
}

@description('Prefix for management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Optional suffix for management group names/IDs.')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@description('Assign Sovereignty Baseline - Global Policies to root management group.')
param parTopLevelPolicyAssignmentSovereigntyGlobal policyAssignmentSovereigntyGlobalOptionsType = {
  parTopLevelSovereigntyGlobalPoliciesEnable: false
  parListOfAllowedLocations: []
  parPolicyEffect: 'Deny'
}

@description('Assign Sovereignty Baseline - Confidential Policies to confidential landing zone groups.')
param parPolicyAssignmentSovereigntyConfidential policyAssignmentSovereigntyConfidentialOptionsType = {
  parAllowedResourceTypes: []
  parListOfAllowedLocations: []
  parAllowedVirtualMachineSKUs: []
  parPolicyEffect: 'Deny'
}

@description('Assign policies to Confidential Corp and Online groups under Landing Zones.')
param parLandingZoneMgConfidentialEnable bool = false

@description('Set the enforcement mode to DoNotEnforce for all SLZ policies.')
param parDisableSlzDefaultPolicies bool = true

@description('Set the enforcement mode to DoNotEnforce for all workload specific policies.')
param parDisableWorkloadSpecificPolicies bool = true

@description('Names of policy assignments to exclude.')
param parExcludedPolicyAssignments array = []

@description('Opt out of deployment telemetry.')
param parTelemetryOptOut bool = false

// **Variables**
// Customer Usage Attribution Id Telemetry
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// ZTN Telemetry
var varZtnP1CuaId = '4eaba1fc-d30a-4e63-a57f-9e6c3d86a318'

// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZB'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModDepNames = {
  modPolAssiIntRootEnforceSovereigntyGlobal: take('${varDeploymentNameWrappers.basePrefix}-enforceSovGlob-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-enforceSovConf-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-enforceSovConf-confOnline-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceEncryptionCMK: take('${varDeploymentNameWrappers.basePrefix}-enforceEncCMK-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRAPIM: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAPIM-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRAppServices: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAppServices-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRAutomation: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAutomation-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRBotService: take('${varDeploymentNameWrappers.basePrefix}-enforceGRBotService-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRCognitiveServices: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCogServ-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRCompute: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCompute-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRContainerApps: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContApps-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRContainerInstance: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContInst-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRContainerRegistry: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContReg-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRCosmosDb: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCosmosDb-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRDataExplorer: take('${varDeploymentNameWrappers.basePrefix}-enforceGRDataExplorer-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRDataFactory: take('${varDeploymentNameWrappers.basePrefix}-enforceGRDataFactory-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGREventGrid: take('${varDeploymentNameWrappers.basePrefix}-enforceGREventGrid-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGREventHub: take('${varDeploymentNameWrappers.basePrefix}-enforceGREventHub-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRKeyVaultSup: take('${varDeploymentNameWrappers.basePrefix}-enforceGRKeyVaultSup-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRKubernetes: take('${varDeploymentNameWrappers.basePrefix}-enforceGRKubernetes-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRMachineLearning: take('${varDeploymentNameWrappers.basePrefix}-enforceGRMachineLearning-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRMySQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRMySQL-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRNetwork: take('${varDeploymentNameWrappers.basePrefix}-enforceGRNetwork-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGROpenAI: take('${varDeploymentNameWrappers.basePrefix}-enforceGROpenAI-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRPostgreSQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRPostgreSQL-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRSQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRSQL-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRServiceBus: take('${varDeploymentNameWrappers.basePrefix}-enforceGRServiceBus-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRStorage: take('${varDeploymentNameWrappers.basePrefix}-enforceGRStorage-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRSynapse: take('${varDeploymentNameWrappers.basePrefix}-enforceGRSynapse-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceGRVirtualDesktop: take('${varDeploymentNameWrappers.basePrefix}-enforceGRVirtualDesktop-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceEncryptionCMK: take('${varDeploymentNameWrappers.basePrefix}-enforceGREncCMK-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRAPIM: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAPIM-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRAppServices: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAppServices-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRAutomation: take('${varDeploymentNameWrappers.basePrefix}-enforceGRAutomation-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRBotService: take('${varDeploymentNameWrappers.basePrefix}-enforceGRBotService-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRCognitiveServices: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCogServ-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRCosmosDb: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCosmosDb-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRCompute: take('${varDeploymentNameWrappers.basePrefix}-enforceGRCompute-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRContainerApps: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContApps-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRContainerInstance: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContInst-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRContainerRegistry: take('${varDeploymentNameWrappers.basePrefix}-enforceGRContReg-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRDataExplorer: take('${varDeploymentNameWrappers.basePrefix}-enforceGRDataExplorer-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRDataFactory: take('${varDeploymentNameWrappers.basePrefix}-enforceGRDataFactory-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGREventGrid: take('${varDeploymentNameWrappers.basePrefix}-enforceGREventGrid-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGREventHub: take('${varDeploymentNameWrappers.basePrefix}-enforceGREventHub-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRKeyVaultSup: take('${varDeploymentNameWrappers.basePrefix}-enforceGRKeyVaultSup-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRKubernetes: take('${varDeploymentNameWrappers.basePrefix}-enforceGRKubernetes-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRMachineLearning: take('${varDeploymentNameWrappers.basePrefix}-enforceGRMachineLearning-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRMySQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRMySQL-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRNetwork: take('${varDeploymentNameWrappers.basePrefix}-enforceGRNetwork-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGROpenAI: take('${varDeploymentNameWrappers.basePrefix}-enforceGROpenAI-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRPostgreSQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRPostgreSQL-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRSQL: take('${varDeploymentNameWrappers.basePrefix}-enforceGRSQL-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRServiceBus: take('${varDeploymentNameWrappers.basePrefix}-enforceGRServiceBus-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRStorage: take('${varDeploymentNameWrappers.basePrefix}-enforceGRStorage-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRSynapse: take('${varDeploymentNameWrappers.basePrefix}-enforceGRSynapse-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiPlatformEnforceGRVirtualDesktop: take('${varDeploymentNameWrappers.basePrefix}-enforceGRVirtualDesktop-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

var varPolicyAssignmentEnforceSovereignConf = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/03de05a4-c324-4ccd-882f-a814ea8ab9ea'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_conf.tmpl.json')
}

var varPolicyAssignmentEnforceSovereignGlobal = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c1cbff38-87c0-4b9f-9f70-035c7a3b5523'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_global.tmpl.json')
}

var varPolicyAssignmentEnforceEncryptionCMK = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Encryption-CMK_20250218'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_encryption_cmk.tmpl.json')
}

var varPolicyAssignmentEnforceGRAPIM = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-APIM'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_apim.tmpl.json')
}

var varPolicyAssignmentEnforceGRAutomation = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Automation'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_automation.tmpl.json')
}

var varPolicyAssignmentEnforceGRAppServices = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-AppServices'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_appservices.tmpl.json')
}

var varPolicyAssignmentEnforceGRBotService = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-BotService'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_botservice.tmpl.json')
}

var varPolicyAssignmentEnforceGRCognitiveServices = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-CognitiveServices'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_cognitiveservices.tmpl.json')
}

var varPolicyAssignmentEnforceGRCompute = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Compute'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_compute.tmpl.json')
}

var varPolicyAssignmentEnforceGRContainerApps = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-ContainerApps'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_containerapps.tmpl.json')
}

var varPolicyAssignmentEnforceGRContainerInstance = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-ContainerInstance'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_containerinstance.tmpl.json')
}

var varPolicyAssignmentEnforceGRContainerRegistry = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-ContainerRegistry'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_containerregistry.tmpl.json')
}

var varPolicyAssignmentEnforceGRCosmosDb = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-CosmosDb'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_cosmosdb.tmpl.json')
}

var varPolicyAssignmentEnforceGRDataExplorer = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-DataExplorer'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_dataexplorer.tmpl.json')
}

var varPolicyAssignmentEnforceGRDataFactory = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-DataFactory'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_datafactory.tmpl.json')
}

var varPolicyAssignmentEnforceGREventGrid = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-EventGrid'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_eventgrid.tmpl.json')
}

var varPolicyAssignmentEnforceGREventHub = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-EventHub'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_eventhub.tmpl.json')
}

var varPolicyAssignmentEnforceGRKeyVaultSup = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-KeyVault-Sup'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_keyvault_sup.tmpl.json')
}

var varPolicyAssignmentEnforceGRKubernetes = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Kubernetes'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_kubernetes.tmpl.json')
}

var varPolicyAssignmentEnforceGRMachineLearning = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-MachineLearning'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_machinelearning.tmpl.json')
}

var varPolicyAssignmentEnforceGRMySQL = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-MySQL'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_mysql.tmpl.json')
}

var varPolicyAssignmentEnforceGRNetwork = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Network_20250326'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_network.tmpl.json')
}

var varPolicyAssignmentEnforceGROpenAI = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-OpenAI'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_openai.tmpl.json')
}

var varPolicyAssignmentEnforceGRPostgreSQL = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-PostgreSQL'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_postgressql.tmpl.json')
}

var varPolicyAssignmentEnforceGRServiceBus = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-ServiceBus'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_servicebus.tmpl.json')
}

var varPolicyAssignmentEnforceGRSQL = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-SQL'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_sql.tmpl.json')
}

var varPolicyAssignmentEnforceGRStorage = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Storage'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_storage.tmpl.json')
}

var varPolicyAssignmentEnforceGRSynapse = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-Synapse'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_synapse.tmpl.json')
}

var varPolicyAssignmentEnforceGRVirtualDesktop = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-VirtualDesktop'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_virtualdesktop.tmpl.json')
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
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones${parTopLevelManagementGroupSuffix}'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp${parTopLevelManagementGroupSuffix}'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online${parTopLevelManagementGroupSuffix}'
  landingZonesConfidentialCorp: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-corp${parTopLevelManagementGroupSuffix}'
  landingZonesConfidentialOnline: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-online${parTopLevelManagementGroupSuffix}'
}

type typManagementGroupIdOverrides = {
  intRoot: string?
  platform: string?
  landingZones: string?
  landingZonesCorp: string?
  landingZonesOnline: string?
  landingZonesConfidentialCorp: string?
  landingZonesConfidentialOnline: string?
}

@description('Specify the ALZ Default Management Group IDs to override as specified in `varManagementGroupIds`. Useful for scenarios when renaming ALZ default management groups names and IDs but not their intent or hierarchy structure.')
param parManagementGroupIdOverrides typManagementGroupIdOverrides?

var varManagementGroupIdsUnioned = union(
  varManagementGroupIds,
  parManagementGroupIdOverrides ?? {}
)

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIdsUnioned.intRoot}'

// **Scope**
targetScope = 'managementGroup'

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

module modCustomerUsageAttributionZtnP1 '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varZtnP1CuaId}-${uniqueString(deployment().location)}'
  params: {}
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Enforce-Sovereign-Global
module modPolAssiIntRootEnforceSovereigntyGlobal '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignGlobal.libDefinition.name) && parTopLevelPolicyAssignmentSovereigntyGlobal.parTopLevelSovereigntyGlobalPoliciesEnable) {
  scope: managementGroup(varManagementGroupIdsUnioned.intRoot)
  name: varModDepNames.modPolAssiIntRootEnforceSovereigntyGlobal
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

// Modules - Policy Assignments - Platform Management Group
// Module - Policy Assignment - Enforce-Encryption-CMK
module modPolAssiPlatformEnforceEncryptionCMK '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceEncryptionCMK.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceEncryptionCMK
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceEncryptionCMK.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-APIM
module modPolAssiPlatformEnforceGRAPIM '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAPIM.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRAPIM
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAPIM.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAPIM.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAPIM.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-AppServices
module modPolAssiPlatformEnforceGRAppServices '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAppServices.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRAppServices
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAppServices.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAppServices.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAppServices.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Automation
module modPolAssiPlatformEnforceGRAutomation '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAutomation.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRAutomation
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAutomation.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAutomation.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAutomation.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-BotService
module modPolAssiPlatformEnforceGRBotService '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRBotService.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRBotService
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRBotService.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRBotService.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRBotService.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRBotService.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-CognitiveServices
module modPolAssiPlatformEnforceGRCognitiveServices '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRCognitiveServices
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCognitiveServices.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Compute
module modPolAssiPlatformEnforceGRCompute '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCompute.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRCompute
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCompute.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCompute.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCompute.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCompute.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerApps
module modPolAssiPlatformEnforceGRContainerApps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerApps.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRContainerApps
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerApps.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerApps.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerApps.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerInstance
module modPolAssiPlatformEnforceGRContainerInstance '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerInstance.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRContainerInstance
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerInstance.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerRegistry
module modPolAssiPlatformEnforceGRContainerRegistry '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRContainerRegistry
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerRegistry.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-CosmosDb
module modPolAssiPlatformEnforceGRCosmosDb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCosmosDb.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRCosmosDb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCosmosDb.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-DataExplorer
module modPolAssiPlatformEnforceGRDataExplorer '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRDataExplorer.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRDataExplorer
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRDataExplorer.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-DataFactory
module modPolAssiPlatformEnforceGRDataFactory '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRDataFactory.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRDataFactory
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRDataFactory.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRDataFactory.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRDataFactory.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-EventGrid
module modPolAssiPlatformEnforceGREventGrid '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGREventGrid.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGREventGrid
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGREventGrid.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGREventGrid.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGREventGrid.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-EventHub
module modPolAssiPlatformEnforceGREventHub '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGREventHub.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGREventHub
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGREventHub.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGREventHub.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGREventHub.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGREventHub.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVaultSup
module modPolAssiPlatformEnforceGRKeyVaultSup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRKeyVaultSup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVaultSup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Kubernetes
module modPolAssiPlatformEnforceGRKubernetes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKubernetes.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRKubernetes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKubernetes.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKubernetes.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKubernetes.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-MachineLearning
module modPolAssiPlatformEnforceGRMachineLearning '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRMachineLearning.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRMachineLearning
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRMachineLearning.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-MySQL
module modPolAssiPlatformEnforceGRMySQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRMySQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRMySQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRMySQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRMySQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRMySQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Network
module modPolAssiPlatformEnforceGRNetwork '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRNetwork.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRNetwork
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRNetwork.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRNetwork.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRNetwork.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-OpenAI
module modPolAssiPlatformEnforceGROpenAI '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGROpenAI.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGROpenAI
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGROpenAI.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGROpenAI.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGROpenAI.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-PostgreSQL
module modPolAssiPlatformEnforceGRPostgreSQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRPostgreSQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRPostgreSQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ServiceBus
module modPolAssiPlatformEnforceGRServiceBus '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRServiceBus.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRServiceBus
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRServiceBus.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRServiceBus.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRServiceBus.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-SQL
module modPolAssiPlatformEnforceGRSQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRSQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRSQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRSQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRSQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRSQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRSQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Storage
module modPolAssiPlatformEnforceGRStorage '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRStorage.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRStorage
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRStorage.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRStorage.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRStorage.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRStorage.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Synapse
module modPolAssiPlatformEnforceGRSynapse '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRSynapse.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRSynapse
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRSynapse.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRSynapse.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRSynapse.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-VirtualDesktop
module modPolAssiPlatformEnforceGRVirtualDesktop '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.platform)
  name: varModDepNames.modPolAssiPlatformEnforceGRVirtualDesktop
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRVirtualDesktop.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Enforce-Encryption-CMK
module modPolAssiLzsEnforceEncryptionCMK '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceEncryptionCMK.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceEncryptionCMK
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceEncryptionCMK.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-APIM
module modPolAssiLzsEnforceGRAPIM '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAPIM.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRAPIM
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAPIM.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAPIM.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAPIM.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAPIM.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-AppServices
module modPolAssiLzsEnforceGRAppServices '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAppServices.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRAppServices
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAppServices.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAppServices.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAppServices.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAppServices.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Automation
module modPolAssiLzsEnforceGRAutomation '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRAutomation.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRAutomation
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRAutomation.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRAutomation.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRAutomation.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRAutomation.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-BotService
module modPolAssiLzsEnforceGRBotService '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRBotService.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRBotService
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRBotService.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRBotService.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRBotService.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRBotService.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRBotService.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-CognitiveServices
module modPolAssiLzsEnforceGRCognitiveServices '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRCognitiveServices
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCognitiveServices.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCognitiveServices.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Compute
module modPolAssiLzsEnforceGRCompute '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCompute.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRCompute
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCompute.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCompute.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCompute.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCompute.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCompute.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerApps
module modPolAssiLzsEnforceGRContainerApps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerApps.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRContainerApps
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerApps.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerApps.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerApps.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerApps.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerInstance
module modPolAssiLzsEnforceGRContainerInstance '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerInstance.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRContainerInstance
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerInstance.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerInstance.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerInstance.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ContainerRegistry
module modPolAssiLzsEnforceGRContainerRegistry '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRContainerRegistry
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRContainerRegistry.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRContainerRegistry.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-CosmosDB
module varPolAssiLzsEnforceGRCosmosDb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRCosmosDb.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRCosmosDb
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRCosmosDb.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRCosmosDb.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRCosmosDb.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-DataExplorer
module modPolAssiLzsEnforceGRDataExplorer '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRDataExplorer.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRDataExplorer
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRDataExplorer.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRDataExplorer.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRDataExplorer.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-DataFactory
module modPolAssiLzsEnforceGRDataFactory '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRDataFactory.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRDataFactory
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRDataFactory.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRDataFactory.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRDataFactory.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRDataFactory.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-EventGrid
module modPolAssiLzsEnforceGREventGrid '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGREventGrid.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGREventGrid
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGREventGrid.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGREventGrid.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGREventGrid.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGREventGrid.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-EventHub
module modPolAssiLzsEnforceGREventHub '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGREventHub.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGREventHub
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGREventHub.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGREventHub.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGREventHub.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGREventHub.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGREventHub.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVaultSup
module modPolAssiLzsEnforceGRKeyVaultSup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRKeyVaultSup
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVaultSup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRKeyVaultSup.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Kubernetes
module modPolAssiLzsEnforceGRKubernetes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKubernetes.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRKubernetes
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKubernetes.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKubernetes.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKubernetes.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRKubernetes.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-MachineLearning
module modPolAssiLzsEnforceGRMachineLearning '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRMachineLearning.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRMachineLearning
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRMachineLearning.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRMachineLearning.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRMachineLearning.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-MySQL
module modPolAssiLzsEnforceGRMySQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRMySQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRMySQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRMySQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRMySQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRMySQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRMySQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Network
module modPolAssiLzsEnforceGRNetwork '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRNetwork.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRNetwork
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRNetwork.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRNetwork.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRNetwork.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRNetwork.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-OpenAI
module modPolAssiLzsEnforceGROpenAI '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGROpenAI.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGROpenAI
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGROpenAI.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGROpenAI.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGROpenAI.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGROpenAI.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-PostgreSQL
module modPolAssiLzsEnforceGRPostgreSQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRPostgreSQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRPostgreSQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRPostgreSQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-ServiceBus
module modPolAssiLzsEnforceGRServiceBus '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRServiceBus.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRServiceBus
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRServiceBus.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRServiceBus.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRServiceBus.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRServiceBus.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-SQL
module modPolAssiLzsEnforceGRSQL '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRSQL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRSQL
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRSQL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRSQL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRSQL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRSQL.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRSQL.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Storage
module modPolAssiLzsEnforceGRStorage '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRStorage.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRStorage
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRStorage.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRStorage.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRStorage.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRStorage.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRStorage.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-Synapse
module modPolAssiLzsEnforceGRSynapse '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRSynapse.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRSynapse
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRSynapse.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRSynapse.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRSynapse.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRSynapse.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-VirtualDesktop
module modPolAssiLzsEnforceGRVirtualDesktop '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZones)
  name: varModDepNames.modPolAssiLzsEnforceGRVirtualDesktop
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRVirtualDesktop.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableWorkloadSpecificPolicies ? 'DoNotEnforce': varPolicyAssignmentEnforceGRVirtualDesktop.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Confidential Online Management Group
// Module - Policy Assignment - Enforce-Sovereign-Conf
module modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignConf.libDefinition.name) && parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZonesConfidentialOnline)
  name: varModDepNames.modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf
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
module modPolAssiLzsConfidentialCorpEnforceSovereigntyConf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignConf.libDefinition.name) && parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZonesConfidentialCorp)
  name: varModDepNames.modPolAssiLzsConfidentialCorpEnforceSovereigntyConf
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

// Modules - Policy Exemptions - Confidential Online Management Group
// Module - Policy Exemption - Enforce-Sovereign-Global
module modPolicyExemptionsConfidentialOnline '../../exemptions/policyExemptions.bicep' = if (parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZonesConfidentialOnline)
  name: take('${parTopLevelManagementGroupPrefix}-deploy-policy-exemptions${parTopLevelManagementGroupSuffix}', 64)
  params: {
    parPolicyAssignmentId: modPolAssiIntRootEnforceSovereigntyGlobal.outputs.outPolicyAssignmentId
    parPolicyDefinitionReferenceIds: ['AllowedLocationsForResourceGroups', 'AllowedLocations']
    parExemptionName: 'Confidential-Online-Location-Exemption'
    parExemptionDisplayName: 'Confidential Online Location Exemption'
    parDescription: 'Exempt the confidential online management group from the SLZ Global location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included.'
  }
  dependsOn: [modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf]
}

// Modules - Policy Exemptions - Confidential Corp Management Group
// Module - Policy Exemption - Enforce-Sovereign-Global
module modPolicyExemptionsConfidentialCorp '../../exemptions/policyExemptions.bicep' = if (parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIdsUnioned.landingZonesConfidentialCorp)
  name: take('${parTopLevelManagementGroupPrefix}-deploy-policy-exemptions${parTopLevelManagementGroupSuffix}', 64)
  params: {
    parPolicyAssignmentId: modPolAssiIntRootEnforceSovereigntyGlobal.outputs.outPolicyAssignmentId
    parPolicyDefinitionReferenceIds: ['AllowedLocationsForResourceGroups', 'AllowedLocations']
    parExemptionName: 'Confidential-Corp-Location-Exemption'
    parExemptionDisplayName: 'Confidential Corp Location Exemption'
    parDescription: 'Exempt the confidential corp management group from the SLZ Global Policies location policies. The confidential management groups have their own location restrictions and this may result in a conflict if both sets are included.'
  }
  dependsOn: [modPolAssiLzsConfidentialCorpEnforceSovereigntyConf]
}
