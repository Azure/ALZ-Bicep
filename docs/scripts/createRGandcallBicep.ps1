
$azureResourceGroup='rsg-private-bicep-registry'
$azureLocation='eastus'

#Create resource group
New-AzResourceGroup -Name $azureResourceGroup -Location $azureLocation

#Deploy Container Registry into Resource Group
$deploymentOutput=New-AzResourceGroupDeployment  -TemplateFile infra-as-code/bicep/CRML/containerRegistry/containerRegistry.bicep -ResourceGroupName $azureResourceGroup -name deployACR

#Query the Deployment to get the login server to pass.
#https://docs.microsoft.com/en-us/cli/azure/query-azure-cli#get-a-single-value
$azureContainerRegistryName=$deploymentOutput.Outputs.outLoginServer.Value

#Leverage Powershell too loop through all bicep modules within the repository
#convert the filename to lower case as Azure Container Registry doesnt support Camelcase
#Leverage az bicep to publish module to Azure Container Registry created above
$files = $(Get-ChildItem -path "$pwd/infra-as-code/bicep/modules" -Recurse -Include *.bicep -exclude *orch-hubSpoke.bicep)

foreach ($file in $files)
{
  #Grab the Full Path and Name and Filename only and store as variables
  $filewithPath=$file.FullName
  $fileShortName=$file.Name
  #Grab bicep module name and set to lowercase for Container Registry support
  $filenamelower = $($fileShortName.Substring(0,$fileShortName.length-6)).toLower()
  Write-Output "Publishing $filewithPath to ACR: $azureContainerRegistryName"
  az bicep publish --file "$filewithPath" --target "br:$azureContainerRegistryName/bicep/modules/$($filenamelower):V1"
}
