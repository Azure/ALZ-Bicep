/*
SUMMARY: Sample Bicep file to show how to call a module from Azure Container Registry
DESCRIPTION:
  Sample deploys logging and hub network modules

AUTHOR/S: aultt
VERSION: 1.0.0
*/

module modLogging 'br:acrwa2dkdhgpzvsm.azurecr.io/bicep/modules/logging:V1' = {
  name : 'deploy-logging'
  params:{
  } 
}
module modHubNetwork 'br:acrwa2dkdhgpzvsm.azurecr.io/bicep/modules/hubnetworking:V1' = {
  name : 'deploy-hubnetworking'
  params:{
  } 
} 
