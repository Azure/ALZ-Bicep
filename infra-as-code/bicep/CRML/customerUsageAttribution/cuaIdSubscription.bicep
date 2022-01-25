/*
SUMMARY: Module to add the customer usage attribution (PID) to Subscription deployments. 
DESCRIPTION: This module will create a deployment at the Subscription level which will add the unique PID and location as the deployment name
AUTHOR/S: shaunjacob
VERSION: 1.0.0
*/

targetScope = 'subscription'

// This is an empty deployment by design
// Reference:  https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution
