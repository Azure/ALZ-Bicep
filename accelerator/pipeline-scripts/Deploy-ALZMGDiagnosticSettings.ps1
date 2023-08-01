param (
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TopLevelMGPrefix = "$($env:TOP_LEVEL_MG_PREFIX)",

  [Parameter()]
  [String]$ManagementSubscriptionId = "$($env:MANAGEMENT_SUBSCRIPTION_ID)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\orchestration\mgDiagSettingsAll\mgDiagSettingsAll.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\mgDiagSettingsAll.parameters.all.json",

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-MGDiagnosticSettings-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = $Location
  ManagementGroupId     = $TopLevelMGPrefix
  TemplateFile          = $TemplateFile
  TemplateParameterFile = $TemplateParameterFile
  WhatIf                = $WhatIfEnabled
  Verbose               = $true
}

# Registering 'Microsoft.Insights' resource provider on the Management subscription
Select-AzSubscription -SubscriptionId $ManagementSubscriptionId

$providers = @('Microsoft.insights')

foreach ($provider in $providers ){
  $providerStatus= (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $provider).registrationState
  if($providerStatus -ne 'Registered'){
    Write-Host "`n Registering the '$provider' provider"
    Register-AzResourceProvider -ProviderNamespace $provider
    do {
      $providerStatus= (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $provider).registrationState
      Write-Host "Waiting for the '$provider' provider registration to complete....waiting 10 seconds"
      Start-Sleep -Seconds 10
    } until ($providerStatus -eq 'Registered')
    Write-Host "`n The '$provider' has been registered successfully"
  }
}

New-AzManagementGroupDeployment @inputObject
