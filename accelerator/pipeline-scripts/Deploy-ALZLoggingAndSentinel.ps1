param (
  [Parameter()]
  [String]$ManagementSubscriptionId = "$($env:MANAGEMENT_SUBSCRIPTION_ID)",

  [Parameter()]
  [String]$LoggingResourceGroup = "$($env:LOGGING_RESOURCE_GROUP)",

  [Parameter()]
  [String]$TemplateFile = "upstream-releases\$($env:UPSTREAM_RELEASE_VERSION)\infra-as-code\bicep\modules\logging\logging.bicep",

  [Parameter()]
  [String]$TemplateParameterFile = "config\custom-parameters\logging.parameters.all.json"
)

# Parameters necessary for deployment
$inputObject = @{
  DeploymentName        = 'alz-LoggingDeploy-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ResourceGroupName     = $LoggingResourceGroup
  TemplateFile          = $TemplateFile
  TemplateParameterFile = $TemplateParameterFile
  Verbose               = $true
}

Select-AzSubscription -SubscriptionId $ManagementSubscriptionId

New-AzResourceGroupDeployment @inputObject
