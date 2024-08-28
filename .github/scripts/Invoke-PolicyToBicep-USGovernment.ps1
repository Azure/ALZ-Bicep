<#
SUMMARY: This PowerShell script helps with the authoring of the policy definition module for Azure USGovernment by outputting information required for the variables within the module.
DESCRIPTION: This PowerShell script outputs the Name & Path to a Bicep structured .txt file named '_mg_policyDefinitionsBicepInput.txt' (definitionsTxtFileName) and '_mg_policySetDefinitionsBicepInput.txt' (definitionsSetTxtFileName) respectively. It also creates a parameters file for each of the policy set definitions. It also outputs the number of policy and policy set definition files to the console for easier reviewing as part of the PR process.
AUTHOR/S: faister, jtracey93, seseicht
VERSION: 2.0.0
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "False Positive")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseBOMForUnicodeEncodedFile", "", Justification = "False Positive")]

[CmdletBinding(SupportsShouldProcess)]
param (
  [Parameter()]
  [string]
  $rootPath = "./infra-as-code/bicep/modules/policy",
  [string]
  $definitionsRoot = "definitions",
  [string]
  $lineEnding = "unix",
  [string]
  $definitionsPath = "lib/usgovernment/policy_definitions",
  [string]
  $definitionsLongPath = "$definitionsRoot/$definitionsPath",
  [string]
  $definitionsSetPath = "lib/usgovernment/policy_set_definitions",
  [string]
  $definitionsSetLongPath = "$definitionsRoot/$definitionsSetPath",
  [string]
  $assignmentsRoot = "assignments",
  [string]
  $assignmentsPath = "lib/usgovernment/policy_assignments",
  [string]
  $assignmentsLongPath = "$assignmentsRoot/$assignmentsPath",
  [string]
  $definitionsTxtFileName = "_mg_policyDefinitionsBicepInput.txt",
  [string]
  $definitionsSetTxtFileName = "_mg_policySetDefinitionsBicepInput.txt",
  [string]
  $assignmentsTxtFileName = "_mg_policyAssignmentsBicepInput.txt",
  [array]
  $excludedPolicySetChildDefinitionsReferenceIds = @("defenderForOssDb", "defenderForCosmosDbs", "defenderForAppServices", "defenderForKeyVaults")
)

# This script relies on a custom set of classes and functions
# defined within the [ALZ-PowerShell-Module](https://github.com/Azure/Alz-powershell-module).
if (-not (Get-Module -ListAvailable -Name ALZ)) {
  # Module doesn't exist, so install it
  Write-Information "====> ALZ module isn't already installed. Installing..." -InformationAction Continue
  Install-Module -Name ALZ -Force -Scope CurrentUser -ErrorAction Stop
  Write-Information "====> ALZ module now installed." -InformationAction Continue
} else {
  Write-Information "====> ALZ module is already installed." -InformationAction Continue
}

# Line Endings function to be used in three functions below
function Update-FileLineEndingType {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [string]
    $filePath
  )

  (Get-Content $filePath | Edit-LineEndings -LineEnding $LineEnding) | Out-File $filePath
}

#region Policy Definitions
function New-PolicyDefinitionsBicepInputTxtFile {
  [CmdletBinding(SupportsShouldProcess)]
  param()

  Write-Information "====> Creating/Emptying '$definitionsTxtFileName'" -InformationAction Continue
  Set-Content -Path "$rootPath/$definitionsLongPath/$definitionsTxtFileName" -Value $null -Encoding "utf8"

  Write-Information "====> Looping Through Policy Definitions:" -InformationAction Continue
  Get-ChildItem -Recurse -Path "$rootPath/$definitionsLongPath" -Filter "*.json" | ForEach-Object {
    $policyDef = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    $policyDefinitionName = $policyDef.name
    $fileName = $_.Name
    $policyDefMetadataAlzCloudEnvironments = $policyDef.properties.metadata.alzCloudEnvironments

    if ($policyDefMetadataAlzCloudEnvironments -contains "AzureUSGovernment") {
      Write-Information "==> Adding '$policyDefinitionName' to '$PWD/$definitionsTxtFileName'" -InformationAction Continue
      Add-Content -Path "$rootPath/$definitionsLongPath/$definitionsTxtFileName" -Encoding "utf8" -Value "{`r`n`tname: '$policyDefinitionName'`r`n`tlibDefinition: loadJsonContent('$definitionsPath/$fileName')`r`n}"
    }
    else {
      Write-Information "==> Skipping '$policyDefinitionName' as metadata 'alzCloudEnvironments' does not contain 'AzureUSGovernment'" -InformationAction Continue
    }

  }

  Write-Information "====> Running '$definitionsTxtFileName' through Line Endings" -InformationAction Continue
  Update-FileLineEndingType -filePath "$rootPath/$definitionsLongPath/$definitionsTxtFileName"

  $policyDefCount = Get-ChildItem -Recurse -Path "$rootPath/$definitionsLongPath" -Filter "*.json" | Measure-Object
  $policyDefCountString = $policyDefCount.Count
  Write-Information "====> Policy Definitions Total: $policyDefCountString" -InformationAction Continue
}
#endregion

#region Policy Set Definitions
function New-PolicySetDefinitionsBicepInputTxtFile {
  [CmdletBinding(SupportsShouldProcess)]
  param()

  Write-Information "====> Creating/Emptying '$definitionsSetTxtFileName'" -InformationAction Continue
  Set-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Value $null -Encoding "utf8"
  Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Value "var varCustomPolicySetDefinitionsArray = [" -Encoding "utf8"

  Write-Information "====> Looping Through Policy Set/Initiative Definition:" -InformationAction Continue

  $policySetDefParamVarList = @()

  Get-ChildItem -Recurse -Path "$rootPath/$definitionsSetLongPath" -Filter "*.json" -Exclude "*.parameters.json" | ForEach-Object {
    $policyDef = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    # Load child Policy Set/Initiative Definitions
    $policyDefinitions = $policyDef.properties.policyDefinitions | Sort-Object -Property policyDefinitionReferenceId

    $policyDefinitionName = $policyDef.name
    $fileName = $_.Name

    $policyDefMetadataAlzCloudEnvironments = $policyDef.properties.metadata.alzCloudEnvironments

    if ($policyDefMetadataAlzCloudEnvironments -contains "AzureUSGovernment") {

      # Construct file name for Policy Set/Initiative Definitions parameters files
      $parametersFileName = $fileName.Substring(0, $fileName.Length - 5) + ".parameters.json"

      # Create Policy Set/Initiative Definitions parameter file
      Write-Information "==> Creating/Emptying '$parametersFileName'" -InformationAction Continue
      Set-Content -Path "$rootPath/$definitionsSetLongPath/$parametersFileName" -Value $null -Encoding "utf8"

      # Loop through all Policy Set/Initiative Definitions Child Definitions and create parameters file for each of them
      [System.Collections.Hashtable]$definitionParametersOutputJSONObject = [ordered]@{}
      $policyDefinitions | Sort-Object | ForEach-Object {
        $definitionReferenceId = $_.policyDefinitionReferenceId
        $definitionParameters = $_.parameters

        if ($definitionReferenceId -notin $excludedPolicySetChildDefinitionsReferenceIds) {

          if ($definitionParameters) {
            $definitionParameters | Sort-Object | ForEach-Object {
              [System.Collections.Hashtable]$definitionParametersOutputArray = [ordered]@{}
              $definitionParametersOutputArray.Add("parameters", $_)
            }
          }
          else {
            [System.Collections.Hashtable]$definitionParametersOutputArray = [ordered]@{}
            $definitionParametersOutputArray.Add("parameters", @{})
          }

          $definitionParametersOutputJSONObject.Add("$definitionReferenceId", $definitionParametersOutputArray)
        }
        else {
          Write-Information "==> Skipping '$definitionReferenceId' as it is in the excluded list" -InformationAction Continue
        }
      }

      Write-Information "==> Adding parameters to '$parametersFileName'" -InformationAction Continue
      Add-Content -Path "$rootPath/$definitionsSetLongPath/$parametersFileName" -Value ($definitionParametersOutputJSONObject | ConvertTo-Json -Depth 10) -Encoding "utf8"

      # Sort parameters file alphabetically to remove false git diffs
      Write-Information "==> Sorting parameters file '$parametersFileName' alphabetically" -InformationAction Continue
      $definitionParametersOutputJSONObjectSorted = New-Object PSCustomObject
      Get-Content -Raw -Path "$rootPath/$definitionsSetLongPath/$parametersFileName" | ConvertFrom-Json -pv fromPipe -Depth 10 |
      Get-Member -Type NoteProperty | Sort-Object Name | ForEach-Object {
        Add-Member -InputObject $definitionParametersOutputJSONObjectSorted -Type NoteProperty -Name $_.Name -Value $fromPipe.$($_.Name)
      }
      Set-Content -Path "$rootPath/$definitionsSetLongPath/$parametersFileName" -Value ($definitionParametersOutputJSONObjectSorted | ConvertTo-Json -Depth 10) -Encoding "utf8"

      # Check if variable exists before trying to clear it
      if ($policySetDefinitionsOutputForBicep) {
        Clear-Variable -Name policySetDefinitionsOutputForBicep -ErrorAction Continue
      }

      # Create HashTable variable
      [System.Collections.Hashtable]$policySetDefinitionsOutputForBicep = [ordered]@{}

      # Loop through child Policy Set/Initiative Definitions if HashTable not == 0
      if (($policyDefinitions.Count) -ne 0) {
        $policyDefinitions | Sort-Object | ForEach-Object {
          if ($null -ne $_.groupNames -and $_.groupNames.Count -ne 0) {
            $joinedGroupNames = "'" + ($_.groupNames -join "','" ) + "'"
            $policySetDefinitionsOutputForBicep.Add($_.policyDefinitionReferenceId, @($_.policyDefinitionId, $joinedGroupNames))
          }
          else {
            $policySetDefinitionsOutputForBicep.Add($_.policyDefinitionReferenceId, @($_.policyDefinitionId, ""))
          }
        }
      }

      # Add Policy Set/Initiative Definition Parameter Variables to Bicep Input File
      $policySetDefParamVarTrimJsonExt = $parametersFileName.TrimEnd("json").Replace('.', '_')
      $policySetDefParamVarCreation = "var" + ($policySetDefParamVarTrimJsonExt -replace '(?:^|_|-)(\p{L})', { $_.Groups[1].Value.ToUpper() }).TrimEnd('_')
      $policySetDefParamVar = "var " + $policySetDefParamVarCreation + " = " + "loadJsonContent('$definitionsSetPath/$parametersFileName')"
      $policySetDefParamVarList += $policySetDefParamVar

      # Start output file creation of Policy Set/Initiative Definitions for Bicep
      Write-Information "==> Adding '$policyDefinitionName' to '$PWD/$definitionsSetTxtFileName'" -InformationAction Continue
      Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "`t{`r`n`t`tname: '$policyDefinitionName'`r`n`t`tlibSetDefinition: loadJsonContent('$definitionsSetPath/$fileName')`r`n`t`tlibSetChildDefinitions: ["

      # Loop through child Policy Set/Initiative Definitions for Bicep output if HashTable not == 0
      if (($policySetDefinitionsOutputForBicep.Count) -ne 0) {
        $policySetDefinitionsOutputForBicep.Keys | Sort-Object | ForEach-Object {
          $definitionReferenceId = $_
          $definitionReferenceIdForParameters = $_
          $definitionId = $($policySetDefinitionsOutputForBicep[$_][0])
          $groups = $($policySetDefinitionsOutputForBicep[$_][1])

          if ($definitionReferenceId -notin $excludedPolicySetChildDefinitionsReferenceIds) {

            # If definitionReferenceId or definitionReferenceIdForParameters contains apostrophes, replace that apostrophe with a backslash and an apostrophe for Bicep string escaping
            if ($definitionReferenceId.Contains("'")) {
              $definitionReferenceId = $definitionReferenceId.Replace("'", "\'")
            }

            if ($definitionReferenceIdForParameters.Contains("'")) {
              $definitionReferenceIdForParameters = $definitionReferenceIdForParameters.Replace("'", "\'")
            }

            # If definitionReferenceId contains, then wrap in definitionReferenceId value in [] to comply with bicep formatting
            if ($definitionReferenceIdForParameters.Contains("-") -or $definitionReferenceIdForParameters.Contains(" ") -or $definitionReferenceIdForParameters.Contains("\'") -or $definitionReferenceIdForParameters -match '^[0-9].+') {
              $definitionReferenceIdForParameters = "['$definitionReferenceIdForParameters']"

              # Add nested array of objects to each Policy Set/Initiative Definition in the Bicep variable, without the '.' before the definitionReferenceId to make it an accessor
              Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "`t`t`t{`r`n`t`t`t`tdefinitionReferenceId: '$definitionReferenceId'`r`n`t`t`t`tdefinitionId: '$definitionId'`r`n`t`t`t`tdefinitionParameters: $policySetDefParamVarCreation$definitionReferenceIdForParameters.parameters`r`n`t`t`t`tdefinitionGroups: [$groups]`r`n`t`t`t}"
            }
            else {
              # Add nested array of objects to each Policy Set/Initiative Definition in the Bicep variable
              Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "`t`t`t{`r`n`t`t`t`tdefinitionReferenceId: '$definitionReferenceId'`r`n`t`t`t`tdefinitionId: '$definitionId'`r`n`t`t`t`tdefinitionParameters: $policySetDefParamVarCreation.$definitionReferenceIdForParameters.parameters`r`n`t`t`t`tdefinitionGroups: [$groups]`r`n`t`t`t}"
            }
          }
          else {
            Write-Information "==> Skipping '$definitionReferenceId' as it is in the excluded list" -InformationAction Continue
          }
        }
      }

      # Finish output file creation of Policy Set/Initiative Definitions for Bicep
      Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "`t`t]`r`n`t}"
    }
    else {
      Write-Information "==> Skipping '$policyDefinitionName' as metadata 'alzCloudEnvironments' does not contain 'AzureUSGovernment'" -InformationAction Continue
    }
  }

  Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "]`r`n"

  # Add Policy Set/Initiative Definition Parameter Variables to Bicep Input File
  Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "`r`n// Policy Set/Initiative Definition Parameter Variables`r`n"
  $policySetDefParamVarList | ForEach-Object {
    Add-Content -Path "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName" -Encoding "utf8" -Value "$_`r`n"
  }

  Write-Information "====> Running '$definitionsSetTxtFileName' through Line Endings" -InformationAction Continue
  Update-FileLineEndingType -filePath "$rootPath/$definitionsSetLongPath/$definitionsSetTxtFileName"

  $policyDefCount = Get-ChildItem -Recurse -Path "$rootPath/$definitionsSetLongPath" -Filter "*.json" -Exclude "*.parameters.json" | Measure-Object
  $policyDefCountString = $policyDefCount.Count
  Write-Information "====> Policy Set/Initiative Definitions Total: $policyDefCountString" -InformationAction Continue
}
#endregion

#region Policy Assignments - separate policy assignments for Azure USGovernment due to different policy definitions - missing built-in policies, and featuresets
function New-PolicyAssignmentsBicepInputTxtFile {
  [CmdletBinding(SupportsShouldProcess)]
  param()

  Write-Information "====> Creating/Emptying '$assignmentsTxtFileName  '" -InformationAction Continue
  Set-Content -Path "$rootPath/$assignmentsLongPath/$assignmentsTxtFileName" -Value $null -Encoding "utf8"

  Write-Information "====> Looping Through Policy Assignments:" -InformationAction Continue
  Get-ChildItem -Recurse -Path "$rootPath/$assignmentsLongPath" -Filter "*.json" | ForEach-Object {
    $policyAssignment = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    $policyAssignmentName = $policyAssignment.name
    $policyAssignmentDefinitionID = $policyAssignment.properties.policyDefinitionId
    $fileName = $_.Name

    # Remove hyphens from Policy Assignment Name
    $policyAssignmentNameNoHyphens = $policyAssignmentName.replace("-", "")

    Write-Information "==> Adding '$policyAssignmentName' to '$PWD/$assignmentsTxtFileName'" -InformationAction Continue
    Add-Content -Path "$rootPath/$assignmentsLongPath/$assignmentsTxtFileName" -Encoding "utf8" -Value "var varPolicyAssignment$policyAssignmentNameNoHyphens = {`r`n`tdefinitionId: '$policyAssignmentDefinitionID'`r`n`tlibDefinition: loadJsonContent('../../../policy/$assignmentsLongPath/$fileName')`r`n}`r`n"
  }

  Write-Information "====> Running '$assignmentsTxtFileName' through Line Endings" -InformationAction Continue
  Update-FileLineEndingType -filePath "$rootPath/$assignmentsLongPath/$assignmentsTxtFileName"

  $policyAssignmentCount = Get-ChildItem -Recurse -Path "$rootPath/$assignmentsLongPath" -Filter "*.json" | Measure-Object
  $policyAssignmentCountString = $policyAssignmentCount.Count
  Write-Information "====> Policy Assignments Total: $policyAssignmentCountString" -InformationAction Continue
}
#endregion

New-PolicyDefinitionsBicepInputTxtFile
New-PolicySetDefinitionsBicepInputTxtFile
New-PolicyAssignmentsBicepInputTxtFile
