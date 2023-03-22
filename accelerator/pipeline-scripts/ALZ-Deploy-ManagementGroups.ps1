param (
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\modules\managementGroups\managementGroups.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\managementGroups.parameters.all.json"
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-MGDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = $Location
  TemplateFile          = $TemplateFile
  TemplateParameterFile = $TemplateParameterFile
  Verbose               = $true
}

New-AzTenantDeployment @inputObject
