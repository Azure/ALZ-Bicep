<#
SUMMARY: This PowerShell script helps with the authoring of the policy definiton module for Azure China by outputting information required for the variables within the module.
DESCRIPTION: This PowerShell script outputs the Name & Path to a Bicep strucutred .txt file named '_mc_policyDefinitionsBicepInput.txt' and '_mc_policySetDefinitionsBicepInput.txt' respectively. It also creates a parameters file for each of the policy set definitions. It also outputs the number of policies definition and set definition files to the console for easier reviewing as part of the PR process.
AUTHOR/S: faister, jtracey93
VERSION: 1.1
#>

# Policy Definitions

Write-Information "====> Creating/Emptying '_mc_policyDefinitionsBicepInput.txt' for Azure China" -InformationAction Continue
Set-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_definitions/_mc_policyDefinitionsBicepInput.txt" -Value $null -Encoding "utf8"

Write-Information "====> Looping Through Policy Definitions:" -InformationAction Continue
Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_definitions" -Filter "*.json" | ForEach-Object {
    $policyDef = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    $policyDefinitionName = $policyDef.name
    $fileName = $_.Name

    Write-Information "==> Adding '$policyDefinitionName' to '$PWD/_mc_policyDefinitionsBicepInput.txt'" -InformationAction Continue
    Add-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_definitions/_mc_policyDefinitionsBicepInput.txt" -Encoding "utf8" -Value "{`r`n`tname: '$policyDefinitionName'`r`n`tlibDefinition: json(loadTextContent('lib/china/policy_definitions/$fileName'))`r`n}"
}

$policyDefCount = Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_definitions" -Filter "*.json" | Measure-Object
$policyDefCountString = $policyDefCount.Count
Write-Information "====> Policy Definitions Total: $policyDefCountString" -InformationAction Continue

# Policy Set Definitions

Write-Information "====> Creating/Emptying '_mc_policySetDefinitionsBicepInput.txt'" -InformationAction Continue
Set-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/_mc_policySetDefinitionsBicepInput.txt" -Value $null -Encoding "utf8"

Write-Information "====> Looping Through Policy Set/Initiative Definition:" -InformationAction Continue

Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions" -Filter "*.json" -Exclude "*.parameters.json" | ForEach-Object {
    $policyDef = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    # Load child Policy Set/Initiative Definitions
    $policyDefinitions = $policyDef.properties.policyDefinitions | Sort-Object -Property policyDefinitionReferenceId

    $policyDefinitionName = $policyDef.name
    $fileName = $_.Name

    # Construct file name for Policy Set/Initiative Definitions parameters files
    $parametersFileName = $fileName.Substring(0, $fileName.Length - 5) + ".parameters.json"

    # Create Policy Set/Initiative Definitions parameter file
    Write-Information "==> Creating/Emptying '$parametersFileName'" -InformationAction Continue
    Set-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/$parametersFileName" -Value $null -Encoding "utf8"

    # Loop through all Policy Set/Initiative Definitions Child Definitions and create parameters file for each of them
    [System.Collections.Hashtable]$definitionParametersOutputJSONObject = [ordered]@{}
    $policyDefinitions | Sort-Object | ForEach-Object {
        $definitionReferenceId = $_.policyDefinitionReferenceId
        $definitionParameters = $_.parameters

        $definitionParameters | Sort-Object | ForEach-Object {
            [System.Collections.Hashtable]$definitionParametersOutputArray = [ordered]@{}
            $definitionParametersOutputArray.Add("parameters", $_)
        }

        $definitionParametersOutputJSONObject.Add("$definitionReferenceId", $definitionParametersOutputArray)
    }
    Write-Information "==> Adding parameters to '$parametersFileName'" -InformationAction Continue
    Add-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/$parametersFileName" -Value ($definitionParametersOutputJSONObject | ConvertTo-Json -Depth 10) -Encoding "utf8"

    # Sort parameters file alphabetically to remove false git diffs
    Write-Information "==> Sorting parameters file '$parametersFileName' alphabetically" -InformationAction Continue
    $definitionParametersOutputJSONObjectSorted = New-Object PSCustomObject
    Get-Content -Raw -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/$parametersFileName" | ConvertFrom-Json -pv fromPipe -Depth 10 |
    Get-Member -Type NoteProperty | Sort-Object Name | ForEach-Object {
        Add-Member -InputObject $definitionParametersOutputJSONObjectSorted -Type NoteProperty -Name $_.Name -Value $fromPipe.$($_.Name)
    }
    Set-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/$parametersFileName" -Value ($definitionParametersOutputJSONObjectSorted | ConvertTo-Json -Depth 10) -Encoding "utf8"

    # Check if variable exists before trying to clear it
    if ($policySetDefinitionsOutputForBicep) {
        Clear-Variable -Name policySetDefinitionsOutputForBicep -ErrorAction Continue
    }

    # Create HashTable variable
    [System.Collections.Hashtable]$policySetDefinitionsOutputForBicep = [ordered]@{}

    # Loop through child Policy Set/Initiative Definitions if HashTable not == 0
    if (($policyDefinitions.Count) -ne 0) {
        $policyDefinitions | Sort-Object | ForEach-Object {
            $policySetDefinitionsOutputForBicep.Add($_.policyDefinitionReferenceId, $_.policyDefinitionId)
        }
    }

    # Start output file creation of Policy Set/Initiative Definitions for Bicep
    Write-Information "==> Adding '$policyDefinitionName' to '$PWD/_mc_policySetDefinitionsBicepInput.txt'" -InformationAction Continue
    Add-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/_mc_policySetDefinitionsBicepInput.txt" -Encoding "utf8" -Value "{`r`n`tname: '$policyDefinitionName'`r`n`tlibSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/$fileName'))`r`n`tlibSetChildDefinitions: ["

    # Loop through child Policy Set/Initiative Definitions for Bicep output if HashTable not == 0
    if (($policySetDefinitionsOutputForBicep.Count) -ne 0) {
        $policySetDefinitionsOutputForBicep.Keys | Sort-Object | ForEach-Object {
            $definitionReferenceId = $_
            $definitionId = $($policySetDefinitionsOutputForBicep[$_])
            # Add nested array of objects to each Policy Set/Initiative Definition in the Bicep variable
            Add-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/_mc_policySetDefinitionsBicepInput.txt" -Encoding "utf8" -Value "`t`t{`r`n`t`t`tdefinitionReferenceId: '$definitionReferenceId'`r`n`t`t`tdefinitionId: '$definitionId'`r`n`t`t`tdefinitionParameters: json(loadTextContent('lib/china/policy_set_definitions/$parametersFileName')).$definitionReferenceId.parameters`r`n`t`t}"
        }
    }

    # Finish output file creation of Policy Set/Initiative Definitions for Bicep
    Add-Content -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions/_mc_policySetDefinitionsBicepInput.txt" -Encoding "utf8" -Value "`t]`r`n}"

}

$policyDefCount = Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/definitions/lib/china/policy_set_definitions" -Filter "*.json" -Exclude "*.parameters.json" | Measure-Object
$policyDefCountString = $policyDefCount.Count
Write-Information "====> Policy Set/Initiative Definitions Total: $policyDefCountString" -InformationAction Continue

# Policy Asssignments - separate policy assignments for Azure China due to different policy definitions - missing built-in policies, and features

Write-Information "====> Creating/Emptying '_mc_policyAssignmentsBicepInput.txt'" -InformationAction Continue
Set-Content -Path "./infra-as-code/bicep/modules/policy/assignments/lib/china/policy_assignments/_mc_policyAssignmentsBicepInput.txt" -Value $null -Encoding "utf8"

Write-Information "====> Looping Through Policy Assignments:" -InformationAction Continue
Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/assignments/lib/china/policy_assignments" -Filter "*.json" | ForEach-Object {
    $policyAssignment = Get-Content $_.FullName | ConvertFrom-Json -Depth 100

    $policyAssignmentName = $policyAssignment.name
    $policyAssignmentDefinitionID = $policyAssignment.properties.policyDefinitionId
    $fileName = $_.Name

    # Remove hyphens from Policy Assignment Name
    $policyAssignmentNameNoHyphens = $policyAssignmentName.replace("-","")

    Write-Information "==> Adding '$policyAssignmentName' to '$PWD/_mc_policyAssignmentsBicepInput.txt'" -InformationAction Continue
    Add-Content -Path "./infra-as-code/bicep/modules/policy/assignments/lib/china/policy_assignments/_mc_policyAssignmentsBicepInput.txt" -Encoding "utf8" -Value "var varPolicyAssignment$policyAssignmentNameNoHyphens = {`r`n`tdefinitionID: '$policyAssignmentDefinitionID'`r`n`tlibDefinition: json(loadTextContent('../../policy/assignments/lib/china/policy_assignments/$fileName'))`r`n}`r`n"
}

$policyAssignmentCount = Get-ChildItem -Recurse -Path "./infra-as-code/bicep/modules/policy/assignments/lib/china/policy_assignments" -Filter "*.json" | Measure-Object
$policyAssignmentCountString = $policyAssignmentCount.Count
Write-Information "====> Policy Assignments Total: $policyAssignmentCountString" -InformationAction Continue
