param (

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\orchestration\hubPeeredSpoke\hubPeeredSpoke.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\hubPeeredSpoke.*.parameters.all.json",

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Get all parameter files
$parameterFiles = Get-Item -Path $TemplateParameterFile

# exit if there are no parameter files
if ($parameterFiles.Count -eq 0) {
  Write-Host "No parameter files found at $TemplateParameterFile - Skip deployment"
  exit 0
}

# Loop through each parameter file and deploy
$parameterFiles.ForEach({

  # Extract name of spoke
  $_.Name -match '(?<=hubPeeredSpoke\.).*(?=\.parameters\.all\.json)' | Out-Null
  $spokeName = $Matches[0]

  write-host "##[group] Deploy spoke: $spokeName"

  # Read the parameters file
  $parameters = Get-Content $_.FullName | ConvertFrom-Json
  $topLevelManagementGroupPrefix = $parameters.parameters.parTopLevelManagementGroupPrefix.value
  $location = $parameters.parameters.parLocation.value

  # Deploy the spoke
  $inputObject = @{
    DeploymentName        = 'alz-HubPeeredSpoke-{0}-{1}' -f $spokeName,(-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
    Location              = $location
    ManagementGroupId     = $topLevelManagementGroupPrefix
    TemplateFile          = $TemplateFile
    TemplateParameterFile = $_.FullName
  }
  
  New-AzManagementGroupDeployment @inputObject

  write-host "##[endgroup]"
})
