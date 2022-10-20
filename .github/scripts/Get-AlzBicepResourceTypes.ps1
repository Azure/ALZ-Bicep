Get-ChildItem -Path '.\infra-as-code\bicep\modules' -Recurse -Filter '*.bicep' -Exclude 'callModuleFromACR.example.bicep', 'orchHubSpoke.bicep' | ForEach-Object {
  Write-Information "==> Attempting Bicep Build For File: $_" -InformationAction Continue
  $output = bicep build $_.FullName 2>&1
  if ($LastExitCode -ne 0) {
    throw $output
  }
  Else {
    Write-Output $output
  }
}

$resourceTypesFullList = @{}

Get-ChildItem -Path '.\infra-as-code\bicep\modules' -Recurse -Filter '*.json' -Exclude 'callModuleFromACR.example.json', 'orchHubSpoke.json', '*parameters*.json', 'bicepconfig.json', '*policy_*.json' | ForEach-Object {
  Write-Information "==> Reading Built ARM Template JSON File: $_" -InformationAction Continue
  $armTemplate = Get-Content $_.FullName | ConvertFrom-Json -Depth 100
  $armResourceTypes = $armTemplate.Resources
  $armResourceTypes | ForEach-Object {
    if (!$resourceTypesFullList.ContainsKey($_.Type)) {
      $resourceTypesFullList.Add($_.Type, 1)
    }
    else {
      $resourceTypesFullList[$_.Type] += 1
    }
  }
}

Write-Information "==> Remove nested deployments resource type" -InformationAction Continue
$resourceTypesFullList.Remove('Microsoft.Resources/Deployments')

Write-Information "==> List of resource types in ALZ-Bicep modules" -InformationAction Continue
$resourceTypesFullList.Keys | Sort-Object
