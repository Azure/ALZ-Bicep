#!/bin/bash

azureResourceGroup='rsg-private-bicep-registry'
azureLocation='eastus'

#Create resource group
az group create --name $azureResourceGroup --location $azureLocation

#Deploy Container Registry into Resource Group
az deployment group create --template-file infra-as-code/bicep/CRML/containerRegistry/containerRegistry.bicep  --resource-group $azureResourceGroup --name deployACR

#Query the Deployment to get the login server to pass.
#https://docs.microsoft.com/en-us/cli/azure/query-azure-cli#get-a-single-value
azureContainerRegistryName=$(az deployment group show -n deployACR -g $azureResourceGroup --query properties.outputs.outLoginServer.value -o tsv)

#Leverage Bash utilities too loop through all bicep modules within the repository
#convert the filename to lower case as Azure Container Registry doesnt support Camelcase
#Leverage az bicep to publish module to Azure Container Registry created above
for file in $(find ./infra-as-code/bicep/modules -type f -name "*.bicep" ! -path "./infra-as-code/bicep/modules/unstable*")
do
  f=$(echo "${file##*/}");
  filename=$(echo $f| cut  -d'.' -f 1| tr '[:upper:]' '[:lower:]')
  echo "Publishing $filename.bicep to ACR: $azureContainerRegistryName"
  az bicep publish --file $file --target "br:$azureContainerRegistryName/bicep/modules/$filename:V1"
done       
