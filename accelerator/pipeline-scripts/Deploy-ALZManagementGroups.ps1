param (
  [Parameter()]
  [String]$NonRootParentManagementGroupId = "$($env:NONROOTPARENTMANAGEMENTGROUPID)",

  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\modules\managementGroups\",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\managementGroups.parameters.all.json",

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment

if ($NonRootParentManagementGroupId -eq '') {
  $inputObject = @{
    DeploymentName        = -join ('alz-MGDeployment-{0}' -f (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63]
    Location              = $Location
    TemplateFile          = $TemplateFile + "managementGroups.bicep"
    TemplateParameterFile = $TemplateParameterFile
    WhatIf                = $WhatIfEnabled
    Verbose               = $true
  }

  New-AzTenantDeployment @inputObject
}

if ($NonRootParentManagementGroupId -ne '') {
  $inputObject = @{
    ManagementGroupId     = $NonRootParentManagementGroupId
    DeploymentName        = -join ('alz-MGDeployment-{0}' -f (Get-Date -Format 'yyyyMMddTHHMMssffffZ'))[0..63]
    Location              = $Location
    TemplateFile          = $TemplateFile + "managementGroupsScopeEscape.bicep"
    TemplateParameterFile = $TemplateParameterFile
    WhatIf                = $WhatIfEnabled
    Verbose               = $true
  }

  New-AzManagementGroupDeployment @inputObject
}
