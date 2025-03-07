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

@description('Apply platform policies to Platform group or child groups.')
param parPlatformMgAlzDefaultsEnable bool = true

@description('Assign policies to Confidential Corp and Online groups under Landing Zones.')
param parLandingZoneMgConfidentialEnable bool = false

@description('Disable all default sovereign policies.')
param parDisableSlzDefaultPolicies bool = false

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
  modPolAssiPlatformEnforceEncryptionCMK: take('${varDeploymentNameWrappers.basePrefix}-enforceEncCMK-platform-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsEnforceEncryptionCMK: take('${varDeploymentNameWrappers.basePrefix}-enforceEncCMK-lzs-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-enforceSovConf-confOnline-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolAssiLzsConfidentialCorpEnforceSovereigntyConf: take('${varDeploymentNameWrappers.basePrefix}-enforceSovConf-confCorp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables
var varPolicyAssignmentEnforceSovereignConf = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/03de05a4-c324-4ccd-882f-a814ea8ab9ea'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_conf.tmpl.json')
}

var varPolicyAssignmentEnforceSovereignGlobal = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c1cbff38-87c0-4b9f-9f70-035c7a3b5523'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_sovereignty_baseline_global.tmpl.json')
}

var varPolicyAssignmentEnforceEncryptionCMK = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Encryption-CMK_20250218'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_encryption_cmk.tmpl.json')
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

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'

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
  scope: managementGroup(varManagementGroupIds.intRoot)
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
  scope: managementGroup(varManagementGroupIds.platform)
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Enforce-Encryption-CMK
module modPolAssiLzsEnforceEncryptionCMK '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceEncryptionCMK.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platform)
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
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentEnforceEncryptionCMK.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}


// Modules - Policy Assignments - Confidential Online Management Group
// Module - Policy Assignment - Enforce-Sovereign-Conf
module modPolAssiLzsConfidentialOnlineEnforceSovereigntyConf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceSovereignConf.libDefinition.name) && parLandingZoneMgConfidentialEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialOnline)
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
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialCorp)
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
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialOnline)
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
  scope: managementGroup(varManagementGroupIds.landingZonesConfidentialCorp)
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
