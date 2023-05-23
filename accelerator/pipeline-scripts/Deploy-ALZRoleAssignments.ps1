param (
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TopLevelMGPrefix = "$($env:TOP_LEVEL_MG_PREFIX)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\modules\roleAssignments\roleAssignmentManagementGroupMany.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\roleAssignmentManagementGroupMany.servicePrincipal.parameters.all.json",

  [Parameter()]
  [Boolean]$WhatIf
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-RoleAssignmentsDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = $Location
  ManagementGroupId     = $TopLevelMGPrefix
  TemplateFile          = $TemplateFile
  TemplateParameterFile = $TemplateParameterFile
  Verbose               = $true
  WhatIf                = $WhatIf
}

New-AzManagementGroupDeployment @inputObject
