#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#
# Valid object schema for Export-LibraryArtifact function loop:
#
# @{
#     inputPath      = [String]
#     inputFilter    = [String]
#     typeFilter     = [String[]]
#     outputPath     = [String]
#     fileNamePrefix = [String]
#     fileNameSuffix = [String]
#     asTemplate     = [Boolean]
#     recurse        = [Boolean]
#     whatIf         = [Boolean]
# }
#

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()][String]$TargetModulePath = "$PWD/ALZ-Bicep",
    [Parameter()][String]$SourceModulePath = "$PWD/enterprise-scale",
    [Parameter()][Switch]$Reset,
    [Parameter()][Switch]$UseCacheFromModule
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
$esltModuleDirectory = $TargetModulePath + "/.github/scripts/EnterpriseScaleLibraryTools"
$esltModulePath = "$esltModuleDirectory/EnterpriseScaleLibraryTools.psm1"
Import-Module $esltModulePath -ErrorAction Stop

# To avoid needing to authenticate with Azure, the following
# code will preload the ProviderApiVersions cache from a
# stored state in the module if the UseCacheFromModule flag
# is set and the ProviderApiVersions.zip file is present.
if ($UseCacheFromModule -and (Test-Path "$esltModuleDirectory/ProviderApiVersions.zip")) {
    Write-Information "Pre-loading ProviderApiVersions from saved cache." -InformationAction Continue
    Invoke-UseCacheFromModule($esltModuleDirectory)
}

# The defaultConfig object provides a set of default values
# to reduce verbosity within the esltConfig object.
$defaultConfig = @{
    inputFilter    = "*.json"
    typeFilter     = @()
    outputPath     = $TargetModulePath + "/infra-as-code/bicep/modules/policy/definitions/lib"
    fileNamePrefix = ""
    fileNameSuffix = ".json"
    asTemplate     = $true
    recurse        = $false
}

# File locations from Enterprise-scale repository for
# resources, organised by type
$policyDefinitionFilePaths = "$SourceModulePath/eslzArm/managementGroupTemplates/policyDefinitions"
$policySetDefinitionFilePaths = "$SourceModulePath/eslzArm/managementGroupTemplates/policyDefinitions"

# The esltConfig array controls the foreach loop used to run
# Export-LibraryArtifact. Each object provides a set of values
# used to configure each run of Export-LibraryArtifact within
# the loop. If a value needed by Export-LibraryArtifact is
# missing, it will use the default value specified in the
# defaultConfig object.
$esltConfig = @()
# Add Policy Definition source files to $esltConfig
$esltConfig += $policyDefinitionFilePaths | ForEach-Object {
    [PsCustomObject]@{
        inputPath      = $_
        typeFilter     = "Microsoft.Authorization/policyDefinitions"
        fileNamePrefix = "policy_definitions/policy_definition_es_"
    }
}
# Add Policy Set Definition source files to $esltConfig
$esltConfig += $policySetDefinitionFilePaths | ForEach-Object {
    [PsCustomObject]@{
        inputPath      = $_
        typeFilter     = "Microsoft.Authorization/policySetDefinitions"
        fileNamePrefix = "policy_set_definitions/policy_set_definition_es_"
        fileNameSuffix = ".json"
    }
}

# If the -Reset parameter is set, delete all existing
# artefacts (by resource type) from the library
if ($Reset) {
    Write-Information "Deleting existing Policy Definitions from library." -InformationAction Continue
    Remove-Item -Path "$TargetModulePath/infra-as-code/bicep/modules/policy/definitions/lib/policy_definitions/" -Recurse -Force
    Write-Information "Deleting existing Policy Set Definitions from library." -InformationAction Continue
    Remove-Item -Path "$TargetModulePath/infra-as-code/bicep/modules/policy/definitions/lib/policy_set_definitions/" -Recurse -Force
}

# Process the files added to $esltConfig, to add content
# to the library
foreach ($config in $esltConfig) {
    Export-LibraryArtifact `
        -InputPath ($config.inputPath ?? $defaultConfig.inputPath) `
        -InputFilter ($config.inputFilter ?? $defaultConfig.inputFilter) `
        -TypeFilter ($config.typeFilter ?? $defaultConfig.typeFilter) `
        -OutputPath ($config.outputPath ?? $defaultConfig.outputPath) `
        -FileNamePrefix ($config.fileNamePrefix ?? $defaultConfig.fileNamePrefix) `
        -FileNameSuffix ($config.fileNameSuffix ?? $defaultConfig.fileNameSuffix) `
        -AsTemplate:($config.asTemplate ?? $defaultConfig.asTemplate) `
        -Recurse:($config.recurse ?? $defaultConfig.recurse) `
        -WhatIf:$WhatIfPreference
}

