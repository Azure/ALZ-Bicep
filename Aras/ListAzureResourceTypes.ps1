# From "List Azure Resource Types" in .github/workflows/bicep-build-to-validate.yml
function Add-ToResourceTypesList {
  param (
    [Parameter(Mandatory = $true)]
    [string] $Type
  )
  if (!$resourceTypesFullList.ContainsKey($Type)) {
    $resourceTypesFullList.Add($Type, 1)
  }
  else {
    $resourceTypesFullList[$Type] += 1
  }
}

$resourceTypesFullList = @{}
Get-ChildItem -Path '.\infra-as-code\bicep\modules' -Recurse -Filter '*.json' -Exclude 'callModuleFromACR.example.json', 'orchHubSpoke.json', '*parameters*.json', 'bicepconfig.json', '*policy_*.json' | ForEach-Object {
  Write-Information "==> Reading Built ARM Template JSON File: $_" -InformationAction Continue
  $armTemplate = Get-Content $_.FullName | ConvertFrom-Json -Depth 100
  $armResourceTypes = $armTemplate.Resources
  $armResourceTypes | ForEach-Object {
    if ($null -eq $_.Type) {
      $_.PSObject.Properties | ForEach-Object {
        Add-ToResourceTypesList -Type $_.Value.Type
      }
    }
    else {
      Add-ToResourceTypesList -Type $_.Type
    }
  }
}

Write-Information "==> Remove nested deployments resource type" -InformationAction Continue
$resourceTypesFullList.Remove('Microsoft.Resources/Deployments')

Write-Information "***** List of resource types in ALZ-Bicep modules *****" -InformationAction Continue
$resourceTypesFullList.Keys | Sort-Object
