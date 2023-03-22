param (
  [Parameter()]
  [String]$ConnectivitySubscriptionId = "$($env:CONNECTIVITY_SUBSCRIPTION_ID)",

  [Parameter()]
  [String]$TopLevelMGPrefix = "$($env:TOP_LEVEL_MG_PREFIX)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\modules\vwanConnectivity\vwanConnectivity.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\vwanConnectivity.parameters.all.json"
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-VWAN-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = "rg-$TopLevelMGPrefix-hub-networking-001"
  TemplateFile          = $TemplateFile
  TemplateParameterFile = $TemplateParameterFile
  Verbose               = $true
}

Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

New-AzResourceGroupDeployment @inputObject
