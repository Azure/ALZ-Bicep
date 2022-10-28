targetScope = 'managementGroup'

@sys.description('The management group scope to which the policy definitions are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupId string = 'alz'

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varTargetManagementGroupResourceId = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

// This variable contains a number of objects that load in the custom Azure Policy Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\china\policy_definitions\_mc_policyDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicyDefinitionsArray = [ {
    name: 'Append-AppService-httpsonly'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Append-AppService-httpsonly.json')
  }
  {
    name: 'Append-AppService-latestTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Append-AppService-latestTLS.json')
  }
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Append-KV-SoftDelete.json')
  }
  {
    name: 'Append-Redis-disableNonSslPort'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Append-Redis-disableNonSslPort.json')
  }
  {
    name: 'Append-Redis-sslEnforcement'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Append-Redis-sslEnforcement.json')
  }
  {
    name: 'Audit-MachineLearning-PrivateEndpointId'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Audit-MachineLearning-PrivateEndpointId.json')
  }
  {
    name: 'Deny-AA-child-resources'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AA-child-resources.json')
  }
  {
    name: 'Deny-AFSPaasPublicIP'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AFSPaasPublicIP.json')
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AppGW-Without-WAF.json')
  }
  {
    name: 'Deny-AppServiceApiApp-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AppServiceApiApp-http.json')
  }
  {
    name: 'Deny-AppServiceFunctionApp-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AppServiceFunctionApp-http.json')
  }
  {
    name: 'Deny-AppServiceWebApp-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-AppServiceWebApp-http.json')
  }
  {
    name: 'Deny-Databricks-NoPublicIp'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Databricks-NoPublicIp.json')
  }
  {
    name: 'Deny-Databricks-Sku'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Databricks-Sku.json')
  }
  {
    name: 'Deny-Databricks-VirtualNetwork'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Databricks-VirtualNetwork.json')
  }
  {
    name: 'Deny-KeyVaultPaasPublicIP'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-KeyVaultPaasPublicIP.json')
  }
  {
    name: 'Deny-MachineLearning-Aks'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-Aks.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-SubnetId'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-Compute-SubnetId.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-VmSize'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-Compute-VmSize.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-Scale'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-ComputeCluster-Scale.json')
  }
  {
    name: 'Deny-MachineLearning-HbiWorkspace'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-HbiWorkspace.json')
  }
  {
    name: 'Deny-MachineLearning-PublicAccessWhenBehindVnet'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-PublicAccessWhenBehindVnet.json')
  }
  {
    name: 'Deny-MachineLearning-PublicNetworkAccess'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MachineLearning-PublicNetworkAccess.json')
  }
  {
    name: 'Deny-MySql-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-MySql-http.json')
  }
  {
    name: 'Deny-PostgreSql-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-PostgreSql-http.json')
  }
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Private-DNS-Zones.json')
  }
  {
    name: 'Deny-PublicEndpoint-MariaDB'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-PublicEndpoint-MariaDB.json')
  }
  {
    name: 'Deny-PublicIP'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-PublicIP.json')
  }
  {
    name: 'Deny-RDP-From-Internet'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-RDP-From-Internet.json')
  }
  {
    name: 'Deny-Redis-http'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Redis-http.json')
  }
  {
    name: 'Deny-Sql-minTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Sql-minTLS.json')
  }
  {
    name: 'Deny-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-SqlMi-minTLS.json')
  }
  {
    name: 'Deny-Storage-minTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Storage-minTLS.json')
  }
  {
    name: 'Deny-Subnet-Without-Nsg'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Subnet-Without-Nsg.json')
  }
  {
    name: 'Deny-Subnet-Without-Udr'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-Subnet-Without-Udr.json')
  }
  {
    name: 'Deny-VNET-Peer-Cross-Sub'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-VNET-Peer-Cross-Sub.json')
  }
  {
    name: 'Deny-VNET-Peering-To-Non-Approved-VNETs'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-VNET-Peering-To-Non-Approved-VNETs.json')
  }
  {
    name: 'Deny-VNet-Peering'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deny-VNet-Peering.json')
  }
  {
    name: 'Deploy-ActivityLogs-to-LA-workspace'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-ActivityLogs-to-LA-workspace.json')
  }
  {
    name: 'Deploy-ASC-SecurityContacts'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-ASC-SecurityContacts.json')
  }
  {
    name: 'Deploy-Budget'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Budget.json')
  }
  {
    name: 'Deploy-Custom-Route-Table'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Custom-Route-Table.json')
  }
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-DDoSProtection.json')
  }
  {
    name: 'Deploy-Default-Udr'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Default-Udr.json')
  }
  {
    name: 'Deploy-Diagnostics-AA'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-AA.json')
  }
  {
    name: 'Deploy-Diagnostics-ACI'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-ACI.json')
  }
  {
    name: 'Deploy-Diagnostics-ACR'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-ACR.json')
  }
  {
    name: 'Deploy-Diagnostics-AnalysisService'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-AnalysisService.json')
  }
  {
    name: 'Deploy-Diagnostics-ApiForFHIR'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-ApiForFHIR.json')
  }
  {
    name: 'Deploy-Diagnostics-APIMgmt'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-APIMgmt.json')
  }
  {
    name: 'Deploy-Diagnostics-ApplicationGateway'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-ApplicationGateway.json')
  }
  {
    name: 'Deploy-Diagnostics-AVDScalingPlans'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-AVDScalingPlans.json')
  }
  {
    name: 'Deploy-Diagnostics-Bastion'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Bastion.json')
  }
  {
    name: 'Deploy-Diagnostics-CDNEndpoints'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-CDNEndpoints.json')
  }
  {
    name: 'Deploy-Diagnostics-CognitiveServices'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-CognitiveServices.json')
  }
  {
    name: 'Deploy-Diagnostics-CosmosDB'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-CosmosDB.json')
  }
  {
    name: 'Deploy-Diagnostics-Databricks'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Databricks.json')
  }
  {
    name: 'Deploy-Diagnostics-DataExplorerCluster'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-DataExplorerCluster.json')
  }
  {
    name: 'Deploy-Diagnostics-DataFactory'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-DataFactory.json')
  }
  {
    name: 'Deploy-Diagnostics-DLAnalytics'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-DLAnalytics.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSub'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-EventGridSub.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSystemTopic'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-EventGridSystemTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridTopic'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-EventGridTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-ExpressRoute'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-ExpressRoute.json')
  }
  {
    name: 'Deploy-Diagnostics-Firewall'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Firewall.json')
  }
  {
    name: 'Deploy-Diagnostics-FrontDoor'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-FrontDoor.json')
  }
  {
    name: 'Deploy-Diagnostics-Function'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Function.json')
  }
  {
    name: 'Deploy-Diagnostics-HDInsight'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-HDInsight.json')
  }
  {
    name: 'Deploy-Diagnostics-iotHub'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-iotHub.json')
  }
  {
    name: 'Deploy-Diagnostics-LoadBalancer'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-LoadBalancer.json')
  }
  {
    name: 'Deploy-Diagnostics-LogicAppsISE'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-LogicAppsISE.json')
  }
  {
    name: 'Deploy-Diagnostics-MariaDB'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-MariaDB.json')
  }
  {
    name: 'Deploy-Diagnostics-MediaService'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-MediaService.json')
  }
  {
    name: 'Deploy-Diagnostics-MlWorkspace'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-MlWorkspace.json')
  }
  {
    name: 'Deploy-Diagnostics-MySQL'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-MySQL.json')
  }
  {
    name: 'Deploy-Diagnostics-NetworkSecurityGroups'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-NetworkSecurityGroups.json')
  }
  {
    name: 'Deploy-Diagnostics-NIC'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-NIC.json')
  }
  {
    name: 'Deploy-Diagnostics-PostgreSQL'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-PostgreSQL.json')
  }
  {
    name: 'Deploy-Diagnostics-PowerBIEmbedded'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-PowerBIEmbedded.json')
  }
  {
    name: 'Deploy-Diagnostics-RedisCache'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-RedisCache.json')
  }
  {
    name: 'Deploy-Diagnostics-Relay'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Relay.json')
  }
  {
    name: 'Deploy-Diagnostics-SignalR'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-SignalR.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLElasticPools'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-SQLElasticPools.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLMI'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-SQLMI.json')
  }
  {
    name: 'Deploy-Diagnostics-TimeSeriesInsights'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-TimeSeriesInsights.json')
  }
  {
    name: 'Deploy-Diagnostics-TrafficManager'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-TrafficManager.json')
  }
  {
    name: 'Deploy-Diagnostics-VirtualNetwork'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-VirtualNetwork.json')
  }
  {
    name: 'Deploy-Diagnostics-VM'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-VM.json')
  }
  {
    name: 'Deploy-Diagnostics-VMSS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-VMSS.json')
  }
  {
    name: 'Deploy-Diagnostics-VNetGW'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-VNetGW.json')
  }
  {
    name: 'Deploy-Diagnostics-WebServerFarm'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-WebServerFarm.json')
  }
  {
    name: 'Deploy-Diagnostics-Website'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-Website.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDAppGroup'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-WVDAppGroup.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDHostPools'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-WVDHostPools.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDWorkspace'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Diagnostics-WVDWorkspace.json')
  }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-FirewallPolicy.json')
  }
  {
    name: 'Deploy-MySQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-MySQL-sslEnforcement.json')
  }
  {
    name: 'Deploy-MySQLCMKEffect'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-MySQLCMKEffect.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs-to-LA'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Nsg-FlowLogs-to-LA.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Nsg-FlowLogs.json')
  }
  {
    name: 'Deploy-PostgreSQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-PostgreSQL-sslEnforcement.json')
  }
  {
    name: 'Deploy-PostgreSQLCMKEffect'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-PostgreSQLCMKEffect.json')
  }
  {
    name: 'Deploy-Private-DNS-Azure-File-Sync'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Private-DNS-Azure-File-Sync.json')
  }
  {
    name: 'Deploy-Private-DNS-Azure-KeyVault'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Private-DNS-Azure-KeyVault.json')
  }
  {
    name: 'Deploy-Private-DNS-Azure-Web'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Private-DNS-Azure-Web.json')
  }
  {
    name: 'Deploy-Sql-AuditingSettings'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Sql-AuditingSettings.json')
  }
  {
    name: 'Deploy-SQL-minTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-SQL-minTLS.json')
  }
  {
    name: 'Deploy-Sql-SecurityAlertPolicies'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Sql-SecurityAlertPolicies.json')
  }
  {
    name: 'Deploy-Sql-Tde'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Sql-Tde.json')
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Sql-vulnerabilityAssessments.json')
  }
  {
    name: 'Deploy-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-SqlMi-minTLS.json')
  }
  {
    name: 'Deploy-Storage-sslEnforcement'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Storage-sslEnforcement.json')
  }
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-VNET-HubSpoke.json')
  }
  {
    name: 'Deploy-Windows-DomainJoin'
    libDefinition: loadJsonContent('lib/china/policy_definitions/policy_definition_es_mc_Deploy-Windows-DomainJoin.json')
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\china\policy_set_definitions\_mc_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
  {
    name: 'Deny-PublicPaaSEndpoints'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deny-PublicPaaSEndpoints.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0fdf0491-d080-4575-b627-ad0e843cba0f'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.ACRDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'AFSDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/21a8cd35-125e-4d13-b82d-2e19b7208bb7'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.AFSDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'AKSDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.AKSDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'BatchDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/74c5a0ae-5e48-4738-b093-65e23a060488'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.BatchDenyPublicIP.parameters
      }
      {
        definitionReferenceId: 'CosmosDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/797b37f7-06b8-444c-b1ad-fc62867f335a'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.CosmosDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'KeyVaultDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.KeyVaultDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'MySQLFlexDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c9299215-ae47-4f50-9c54-8a392f68a052'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.MySQLFlexDenyPublicIP.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLFlexDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e1de0e3-42cb-4ebc-a86d-61d0c619ca48'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.PostgreSQLFlexDenyPublicIP.parameters
      }
      {
        definitionReferenceId: 'SqlServerDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.SqlServerDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'StorageDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters.StorageDenyPaasPublicIP.parameters
      }
    ]
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Diagnostics-LogAnalytics.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACIDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACI'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.ACIDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ACRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.ACRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AKSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AKSDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AnalysisServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AnalysisService'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AnalysisServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'APIforFHIRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApiForFHIR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.APIforFHIRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'APIMgmtDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-APIMgmt'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.APIMgmtDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApplicationGateway'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AppServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WebServerFarm'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AppServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AppServiceWebappDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Website'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AppServiceWebappDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AutomationDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AutomationDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AVDScalingPlansDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AVDScalingPlans'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.AVDScalingPlansDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'BastionDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Bastion'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.BastionDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'BatchDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c84e5349-db6d-4769-805e-e14037dab9b5'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.BatchDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CDNEndpointsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CDNEndpoints'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.CDNEndpointsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CognitiveServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CognitiveServices'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.CognitiveServicesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CosmosDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CosmosDB'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.CosmosDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DatabricksDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Databricks'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.DatabricksDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataExplorerCluster'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataFactoryDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataFactory'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.DataFactoryDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DLAnalytics'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataLakeStoreDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d56a5a7c-72d7-42bc-8ceb-3baf4c0eae03'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.DataLakeStoreDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventGridSubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSub'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.EventGridSubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventGridTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridTopic'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.EventGridTopicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f6e93e8-6b31-41b1-83f6-36e449a42579'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.EventHubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventSystemTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSystemTopic'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.EventSystemTopicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ExpressRouteDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ExpressRoute'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.ExpressRouteDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FirewallDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.FirewallDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FrontDoorDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-FrontDoor'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.FrontDoorDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FunctionAppDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Function'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.FunctionAppDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'HDInsightDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-HDInsight'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.HDInsightDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'IotHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-iotHub'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.IotHubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'KeyVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.KeyVaultDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LoadBalancerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LoadBalancer'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.LoadBalancerDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LogicAppsISEDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogicAppsISE'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.LogicAppsISEDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LogicAppsWFDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b889a06c-ec72-4b03-910a-cb169ee18721'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.LogicAppsWFDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MariaDBDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MariaDB'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.MariaDBDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MediaServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MediaService'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.MediaServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MlWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MlWorkspace'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.MlWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MySQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MySQL'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.MySQLDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkNICDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NIC'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.NetworkNICDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NetworkSecurityGroups'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PostgreSQL'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.PostgreSQLDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PowerBIEmbedded'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RecoveryVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.RecoveryVaultDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RedisCacheDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-RedisCache'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.RedisCacheDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RelayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Relay'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.RelayDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SearchServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/08ba64b8-738f-4918-9686-730d2ed79c7d'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.SearchServicesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ServiceBusDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/04d53d87-841c-4f23-8a5b-21564380b55e'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.ServiceBusDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SignalRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SignalR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.SignalRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLDatabaseDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b79fa14e-238a-4c2d-b376-442ce508fc84'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.SQLDatabaseDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLElasticPools'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLMDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLMI'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.SQLMDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'StorageAccountDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6f8f98a4-f108-47cb-8e98-91a0d85cd474'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.StorageAccountDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/237e0f7e-b0e8-4ec4-ad46-8c12cb66d673'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TimeSeriesInsights'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'TrafficManagerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TrafficManager'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.TrafficManagerDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VirtualMachinesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VM'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.VirtualMachinesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VirtualNetworkDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VirtualNetwork'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.VirtualNetworkDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VMSSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VMSS'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.VMSSDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VNetGWDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VNetGW'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.VNetGWDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'WVDAppGroupDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDAppGroup'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.WVDAppGroupDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDHostPools'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDWorkspace'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters.WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
    ]
  }
  {
    name: 'Deploy-MDFC-Config'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-MDFC-Config.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ascExport'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.ascExport.parameters
      }
      {
        definitionReferenceId: 'defenderForAppServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b40e7bcd-a1e5-47fe-b9cf-2f534d0bfb7d'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForAppServices.parameters
      }
      {
        definitionReferenceId: 'defenderForArm'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b7021b2b-08fd-4dc0-9de7-3c6ece09faf9'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForArm.parameters
      }
      {
        definitionReferenceId: 'defenderforContainers'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c9ddb292-b203-4738-aead-18e2716e858f'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderforContainers.parameters
      }
      {
        definitionReferenceId: 'defenderForDns'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2370a3c1-4a25-4283-a91a-c9c1a145fb2f'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForDns.parameters
      }
      {
        definitionReferenceId: 'defenderForKeyVaults'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f725891-01c0-420a-9059-4fa46cb770b7'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForKeyVaults.parameters
      }
      {
        definitionReferenceId: 'defenderForOssDb'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/44433aa3-7ec2-4002-93ea-65c65ff0310a'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForOssDb.parameters
      }
      {
        definitionReferenceId: 'defenderForSqlPaas'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b99b73e7-074b-4089-9395-b7236f094491'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForSqlPaas.parameters
      }
      {
        definitionReferenceId: 'defenderForSqlServerVirtualMachines'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/50ea7265-7d8c-429e-9a7d-ca1f410191c3'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForSqlServerVirtualMachines.parameters
      }
      {
        definitionReferenceId: 'defenderForStorageAccounts'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/74c30959-af11-47b3-9ed2-a26e03f427a3'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForStorageAccounts.parameters
      }
      {
        definitionReferenceId: 'defenderForVM'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e86a5b6-b9bd-49d1-8e21-4bb8a0862222'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.defenderForVM.parameters
      }
      {
        definitionReferenceId: 'securityEmailContact'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-SecurityContacts'
        definitionParameters: varPolicySetDefinitionEsMcDeployMDFCConfigParameters.securityEmailContact.parameters
      }
    ]
  }
  {
    name: 'Deploy-Private-DNS-Zones'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Private-DNS-Zones.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ACR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e9585a95-5b8c-4d03-b193-dc7eb5ac4c32'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-ACR'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-App'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7a860e27-9ca2-4fc6-822d-c2d248c300df'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-App'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-AppServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-AppServices'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Batch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4ec38ebc-381f-45ee-81a4-acbc4be878f8'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Batch'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveSearch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fbc14a67-53e4-4932-abcc-2049c6706009'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-CognitiveSearch'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-CognitiveServices'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DiskAccess'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bc05b96c-0b36-4ca9-82f0-5c53f96ce05a'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-DiskAccess'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridDomains'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d389df0a-e0d7-4607-833c-75a6fdac2c2d'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventGridDomains'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridTopics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/baf19753-7502-405f-8745-370519b20483'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventGridTopics'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventHubNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ed66d4f5-8220-45dc-ab4a-20d1749c74e6'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventHubNamespace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-File-Sync'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/06695360-db88-47f6-b976-7500d4297475'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-File-Sync'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoT'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/aaa64d2d-2fa3-45e5-b332-0b031b9b30e8'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-IoT'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoTHubs'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-IoTHubs'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-KeyVault'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-KeyVault'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MachineLearningWorkspace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ee40564d-486e-4f68-a5ca-7a621edae0fb'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-MachineLearningWorkspace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-RedisCache'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e016b22b-e0eb-436d-8fd7-160c4eaed6e2'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-RedisCache'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ServiceBusNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0fcf93c-c063-4071-9668-c47474bd3564'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-ServiceBusNamespace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-SignalR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b0e86710-7fb7-4a6c-a064-32e9b829509e'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-SignalR'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Site-Recovery'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/942bd215-1a66-44be-af65-6a1c0318dbe2'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Site-Recovery'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Web'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0b026355-49cb-467b-8ac4-f777874e175a'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Web'].parameters
      }
    ]
  }
  {
    name: 'Deploy-Sql-Security'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Sql-Security.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'SqlDbAuditingSettingsDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
        definitionParameters: varPolicySetDefinitionEsMcDeploySqlSecurityParameters.SqlDbAuditingSettingsDeploySqlSecurity.parameters
      }
      {
        definitionReferenceId: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
        definitionParameters: varPolicySetDefinitionEsMcDeploySqlSecurityParameters.SqlDbSecurityAlertPoliciesDeploySqlSecurity.parameters
      }
      {
        definitionReferenceId: 'SqlDbTdeDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-Tde'
        definitionParameters: varPolicySetDefinitionEsMcDeploySqlSecurityParameters.SqlDbTdeDeploySqlSecurity.parameters
      }
      {
        definitionReferenceId: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments'
        definitionParameters: varPolicySetDefinitionEsMcDeploySqlSecurityParameters.SqlDbVulnerabilityAssessmentsDeploySqlSecurity.parameters
      }
    ]
  }
  {
    name: 'Enforce-Encryption-CMK'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Enforce-Encryption-CMK.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.ACRCmkDeny.parameters
      }
      {
        definitionReferenceId: 'AksCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7d7be79c-23ba-4033-84dd-45e2a5ccdd67'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.AksCmkDeny.parameters
      }
      {
        definitionReferenceId: 'AzureBatchCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/99e9ccd8-3db9-4592-b0d1-14b1715a4d8a'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.AzureBatchCMKEffect.parameters
      }
      {
        definitionReferenceId: 'CognitiveServicesCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/67121cc7-ff39-4ab8-b7e3-95b84dab487d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.CognitiveServicesCMK.parameters
      }
      {
        definitionReferenceId: 'CosmosCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f905d99-2ab7-462c-a6b0-f709acca6c8f'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.CosmosCMKEffect.parameters
      }
      {
        definitionReferenceId: 'DataBoxCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86efb160-8de7-451d-bc08-5d475b0aadae'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.DataBoxCMKEffect.parameters
      }
      {
        definitionReferenceId: 'EncryptedVMDisksEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.EncryptedVMDisksEffect.parameters
      }
      {
        definitionReferenceId: 'HealthcareAPIsCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/051cba44-2429-45b9-9649-46cec11c7119'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.HealthcareAPIsCMKEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83cef61d-dbd1-4b20-a4fc-5fbc7da10833'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.MySQLCMKEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/18adea5e-f416-4d0f-8aa8-d24321e3e274'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.PostgreSQLCMKEffect.parameters
      }
      {
        definitionReferenceId: 'SqlServerTDECMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0d134df8-db83-46fb-ad72-fe0c9428c8dd'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.SqlServerTDECMKEffect.parameters
      }
      {
        definitionReferenceId: 'StorageCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.StorageCMKEffect.parameters
      }
      {
        definitionReferenceId: 'StreamAnalyticsCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/87ba29ef-1ab3-4d82-b763-87fcd4f531f7'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.StreamAnalyticsCMKEffect.parameters
      }
      {
        definitionReferenceId: 'SynapseWorkspaceCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f7d52b2d-e161-4dfa-a82b-55e564167385'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.SynapseWorkspaceCMKEffect.parameters
      }
      {
        definitionReferenceId: 'WorkspaceCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ba769a63-b8cc-4b2d-abf6-ac33c7204be8'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters.WorkspaceCMK.parameters
      }
    ]
  }
  {
    name: 'Enforce-EncryptTransit'
    libSetDefinition: loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Enforce-EncryptTransit.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.AKSIngressHttpsOnlyEffect.parameters
      }
      {
        definitionReferenceId: 'APIAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.APIAppServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'APIAppServiceLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8cb6aa8b-9e41-4f4e-aa25-089a7ac2581e'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.APIAppServiceLatestTlsEffect.parameters
      }
      {
        definitionReferenceId: 'AppServiceHttpEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.AppServiceHttpEffect.parameters
      }
      {
        definitionReferenceId: 'AppServiceminTlsVersion'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.AppServiceminTlsVersion.parameters
      }
      {
        definitionReferenceId: 'FunctionLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.FunctionLatestTlsEffect.parameters
      }
      {
        definitionReferenceId: 'FunctionServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.FunctionServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.MySQLEnableSSLDeployEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.MySQLEnableSSLEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.PostgreSQLEnableSSLDeployEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.PostgreSQLEnableSSLEffect.parameters
      }
      {
        definitionReferenceId: 'RedisDenyhttps'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.RedisDenyhttps.parameters
      }
      {
        definitionReferenceId: 'RedisdisableNonSslPort'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.RedisdisableNonSslPort.parameters
      }
      {
        definitionReferenceId: 'RedisTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.RedisTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.SQLManagedInstanceTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.SQLManagedInstanceTLSEffect.parameters
      }
      {
        definitionReferenceId: 'SQLServerTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.SQLServerTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLServerTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.SQLServerTLSEffect.parameters
      }
      {
        definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.StorageDeployHttpsEnabledEffect.parameters
      }
      {
        definitionReferenceId: 'StorageHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.StorageHttpsEnabledEffect.parameters
      }
      {
        definitionReferenceId: 'WebAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.WebAppServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'WebAppServiceLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptTransitParameters.WebAppServiceLatestTlsEffect.parameters
      }
    ]
  }
]

// Policy Set/Initiative Definition Parameter Variables

var varPolicySetDefinitionEsMcDenyPublicPaaSEndpointsParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deny-PublicPaaSEndpoints.parameters.json')

var varPolicySetDefinitionEsMcDeployDiagnosticsLogAnalyticsParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Diagnostics-LogAnalytics.parameters.json')

var varPolicySetDefinitionEsMcDeployMDFCConfigParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-MDFC-Config.parameters.json')

var varPolicySetDefinitionEsMcDeployPrivateDNSZonesParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Private-DNS-Zones.parameters.json')

var varPolicySetDefinitionEsMcDeploySqlSecurityParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Deploy-Sql-Security.parameters.json')

var varPolicySetDefinitionEsMcEnforceEncryptionCMKParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Enforce-Encryption-CMK.parameters.json')

var varPolicySetDefinitionEsMcEnforceEncryptTransitParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_Enforce-EncryptTransit.parameters.json')

// Customer Usage Attribution Id
var varCuaid = '2b136786-9881-412e-84ba-f4c2822e1ac9'

resource resPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [for policy in varCustomPolicyDefinitionsArray: {
  name: policy.libDefinition.name
  properties: {
    description: policy.libDefinition.properties.description
    displayName: policy.libDefinition.properties.displayName
    metadata: policy.libDefinition.properties.metadata
    mode: policy.libDefinition.properties.mode
    parameters: policy.libDefinition.properties.parameters
    policyType: policy.libDefinition.properties.policyType
    policyRule: policy.libDefinition.properties.policyRule
  }
}]

resource resPolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = [for policySet in varCustomPolicySetDefinitionsArray: {
  dependsOn: [
    resPolicyDefinitions // Must wait for policy definitons to be deployed before starting the creation of Policy Set/Initiative Defininitions
  ]
  name: policySet.libSetDefinition.name
  properties: {
    description: policySet.libSetDefinition.properties.description
    displayName: policySet.libSetDefinition.properties.displayName
    metadata: policySet.libSetDefinition.properties.metadata
    parameters: policySet.libSetDefinition.properties.parameters
    policyType: policySet.libSetDefinition.properties.policyType
    policyDefinitions: [for policySetDef in policySet.libSetChildDefinitions: {
      policyDefinitionReferenceId: policySetDef.definitionReferenceId
      policyDefinitionId: policySetDef.definitionId
      parameters: policySetDef.definitionParameters
    }]
    policyDefinitionGroups: policySet.libSetDefinition.properties.policyDefinitionGroups
  }
}]

module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
