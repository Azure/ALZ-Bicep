#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library for Azure USGovernment in terraform-azurerm-caf-enterprise-scale repository
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
  [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
  [Parameter()][String]$TargetPath = "$PWD/ALZ-Bicep",
  [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
  [Parameter()][String]$LineEnding = "unix",
  [Parameter()][Switch]$Reset,
  [Parameter()][Switch]$UpdateProviderApiVersions
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

# To avoid needing to authenticate with Azure, the following
# code will preload the ProviderApiVersions cache from a
# stored state in the module if the UseCacheFromModule flag
# is set and the ProviderApiVersions.zip file is present.
if (!$UpdateProviderApiVersions -and (Test-Path "$AlzToolsPath/ProviderApiVersions.zip")) {
  Write-Information "Pre-loading ProviderApiVersions from saved cache." -InformationAction Continue
  Invoke-UseCacheFromModule($AlzToolsPath)
}

# The defaultConfig object provides a set of default values
# to reduce verbosity within the esltConfig object.
$defaultConfig = @{
  inputFilter        = "*.json"
  resourceTypeFilter = @()
  outputPath         = $TargetPath + "/infra-as-code/bicep/modules/policy/definitions/lib/usgovernment"
  fileNamePrefix     = ""
  fileNameSuffix     = ".json"
  exportFormat       = "Bicep"
  recurse            = $false
}

# File locations from Enterprise-scale repository for
# resources, organized by type
$policyDefinitionFilePaths = (
    Get-ChildItem -Path "$SourcePath/src/resources/Microsoft.Authorization/policyDefinitions/*" `
        -File `
        -Include "*.json", "*.AzureUSGovernment.json" `
        -Exclude "*.AzureChinaCloud.json"
).FullName
$policySetDefinitionFilePaths = (
    Get-ChildItem -Path "$SourcePath/src/resources/Microsoft.Authorization/policySetDefinitions/*" `
        -File `
        -Include "*.json", "*.AzureUSGovernment.json" `
        -Exclude "*.AzureChinaCloud.json"
).FullName
# The exportConfig array controls the foreach loop used to run
# Export-LibraryArtifact. Each object provides a set of values
# used to configure each run of Export-LibraryArtifact within
# the loop. If a value needed by Export-LibraryArtifact is
# missing, it will use the default value specified in the
# defaultConfig object.
$exportConfig = @()
# Add Policy Definition source files to $esltConfig
$exportConfig += $policyDefinitionFilePaths | ForEach-Object {
  [PsCustomObject]@{
    inputPath          = $_
    resourceTypeFilter = "Microsoft.Authorization/policyDefinitions"
    fileNamePrefix     = "policy_definitions/policy_definition_es_mg_"
  }
}
# Add Policy Set Definition source files to $esltConfig
$exportConfig += $policySetDefinitionFilePaths | ForEach-Object {
  [PsCustomObject]@{
    inputPath          = $_
    resourceTypeFilter = "Microsoft.Authorization/policySetDefinitions"
    fileNamePrefix     = "policy_set_definitions/policy_set_definition_es_mg_"
    fileNameSuffix     = ".json"
  }
}

# If the -Reset parameter is set, delete all existing
# artifacts (by resource type) from the library
if ($Reset) {
  Write-Information "Deleting existing Policy Definitions from library." -InformationAction Continue
  Remove-Item -Path "$TargetPath/infra-as-code/bicep/modules/policy/definitions/lib/usgovernment/policy_definitions/" -Recurse -Force
  Write-Information "Deleting existing Policy Set Definitions from library." -InformationAction Continue
  Remove-Item -Path "$TargetPath/infra-as-code/bicep/modules/policy/definitions/lib/usgovernment/policy_set_definitions/" -Recurse -Force
}

# Process the files added to $exportConfig, to add content
# to the library
foreach ($config in $exportConfig) {
  Export-LibraryArtifact `
    -InputPath ($config.inputPath ?? $defaultConfig.inputPath) `
    -InputFilter ($config.inputFilter ?? $defaultConfig.inputFilter) `
    -ResourceTypeFilter ($config.resourceTypeFilter ?? $defaultConfig.resourceTypeFilter) `
    -OutputPath ($config.outputPath ?? $defaultConfig.outputPath) `
    -FileNamePrefix ($config.fileNamePrefix ?? $defaultConfig.fileNamePrefix) `
    -FileNameSuffix ($config.fileNameSuffix ?? $defaultConfig.fileNameSuffix) `
    -ExportFormat:($config.exportFormat ?? $defaultConfig.exportFormat) `
    -Recurse:($config.recurse ?? $defaultConfig.recurse) `
    -LineEnding $LineEnding `
    -WhatIf:$WhatIfPreference
}
