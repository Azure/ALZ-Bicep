targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Custom Policy Defitions at Management Group Scope'
metadata description = 'This policy definition is used to deploy custom policy definitions at management group scope'

@sys.description('The management group scope to which the policy definitions are to be created at.')
param parTargetManagementGroupId string = 'alz'

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varTargetManagementGroupResourceId = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

// This variable contains a number of objects that load in the custom Azure Policy Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_definitions\_policyDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicyDefinitionsArray = [
  {
    name: 'Append-AppService-httpsonly'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Append-AppService-httpsonly.json')
  }
  {
    name: 'Append-AppService-latestTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Append-AppService-latestTLS.json')
  }
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Append-KV-SoftDelete.json')
  }
  {
    name: 'Append-Redis-disableNonSslPort'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Append-Redis-disableNonSslPort.json')
  }
  {
    name: 'Append-Redis-sslEnforcement'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Append-Redis-sslEnforcement.json')
  }
  {
    name: 'Audit-AzureHybridBenefit'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-AzureHybridBenefit.json')
  }
  {
    name: 'Audit-Disks-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-Disks-UnusedResourcesCostOptimization.json')
  }
  {
    name: 'Audit-MachineLearning-PrivateEndpointId'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-MachineLearning-PrivateEndpointId.json')
  }
  {
    name: 'Audit-PrivateLinkDnsZones'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-PrivateLinkDnsZones.json')
  }
  {
    name: 'Audit-PublicIpAddresses-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-PublicIpAddresses-UnusedResourcesCostOptimization.json')
  }
  {
    name: 'Audit-ServerFarms-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Audit-ServerFarms-UnusedResourcesCostOptimization.json')
  }
  {
    name: 'Deny-AA-child-resources'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-AA-child-resources.json')
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-AppGW-Without-WAF.json')
  }
  {
    name: 'Deny-AppServiceApiApp-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-AppServiceApiApp-http.json')
  }
  {
    name: 'Deny-AppServiceFunctionApp-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-AppServiceFunctionApp-http.json')
  }
  {
    name: 'Deny-AppServiceWebApp-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-AppServiceWebApp-http.json')
  }
  {
    name: 'Deny-Databricks-NoPublicIp'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Databricks-NoPublicIp.json')
  }
  {
    name: 'Deny-Databricks-Sku'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Databricks-Sku.json')
  }
  {
    name: 'Deny-Databricks-VirtualNetwork'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Databricks-VirtualNetwork.json')
  }
  {
    name: 'Deny-FileServices-InsecureAuth'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-FileServices-InsecureAuth.json')
  }
  {
    name: 'Deny-FileServices-InsecureKerberos'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-FileServices-InsecureKerberos.json')
  }
  {
    name: 'Deny-FileServices-InsecureSmbChannel'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-FileServices-InsecureSmbChannel.json')
  }
  {
    name: 'Deny-FileServices-InsecureSmbVersions'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-FileServices-InsecureSmbVersions.json')
  }
  {
    name: 'Deny-MachineLearning-Aks'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-Aks.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-SubnetId'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-Compute-SubnetId.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-VmSize'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-Compute-VmSize.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-Scale'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-ComputeCluster-Scale.json')
  }
  {
    name: 'Deny-MachineLearning-HbiWorkspace'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-HbiWorkspace.json')
  }
  {
    name: 'Deny-MachineLearning-PublicAccessWhenBehindVnet'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-PublicAccessWhenBehindVnet.json')
  }
  {
    name: 'Deny-MachineLearning-PublicNetworkAccess'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MachineLearning-PublicNetworkAccess.json')
  }
  {
    name: 'Deny-MgmtPorts-From-Internet'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MgmtPorts-From-Internet.json')
  }
  {
    name: 'Deny-MySql-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-MySql-http.json')
  }
  {
    name: 'Deny-PostgreSql-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-PostgreSql-http.json')
  }
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Private-DNS-Zones.json')
  }
  {
    name: 'Deny-PublicEndpoint-MariaDB'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-PublicEndpoint-MariaDB.json')
  }
  {
    name: 'Deny-PublicIP'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-PublicIP.json')
  }
  {
    name: 'Deny-RDP-From-Internet'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-RDP-From-Internet.json')
  }
  {
    name: 'Deny-Redis-http'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Redis-http.json')
  }
  {
    name: 'Deny-Sql-minTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Sql-minTLS.json')
  }
  {
    name: 'Deny-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-SqlMi-minTLS.json')
  }
  {
    name: 'Deny-Storage-minTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Storage-minTLS.json')
  }
  {
    name: 'Deny-Storage-SFTP'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Storage-SFTP.json')
  }
  {
    name: 'Deny-StorageAccount-CustomDomain'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-StorageAccount-CustomDomain.json')
  }
  {
    name: 'Deny-Subnet-Without-Nsg'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Subnet-Without-Nsg.json')
  }
  {
    name: 'Deny-Subnet-Without-Penp'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Subnet-Without-Penp.json')
  }
  {
    name: 'Deny-Subnet-Without-Udr'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-Subnet-Without-Udr.json')
  }
  {
    name: 'Deny-UDR-With-Specific-NextHop'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-UDR-With-Specific-NextHop.json')
  }
  {
    name: 'Deny-VNET-Peer-Cross-Sub'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-VNET-Peer-Cross-Sub.json')
  }
  {
    name: 'Deny-VNET-Peering-To-Non-Approved-VNETs'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-VNET-Peering-To-Non-Approved-VNETs.json')
  }
  {
    name: 'Deny-VNet-Peering'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deny-VNet-Peering.json')
  }
  {
    name: 'Deploy-ASC-SecurityContacts'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-ASC-SecurityContacts.json')
  }
  {
    name: 'Deploy-Budget'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Budget.json')
  }
  {
    name: 'Deploy-Custom-Route-Table'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Custom-Route-Table.json')
  }
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-DDoSProtection.json')
  }
  {
    name: 'Deploy-Diagnostics-AA'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-AA.json')
  }
  {
    name: 'Deploy-Diagnostics-ACI'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-ACI.json')
  }
  {
    name: 'Deploy-Diagnostics-ACR'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-ACR.json')
  }
  {
    name: 'Deploy-Diagnostics-AnalysisService'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-AnalysisService.json')
  }
  {
    name: 'Deploy-Diagnostics-ApiForFHIR'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-ApiForFHIR.json')
  }
  {
    name: 'Deploy-Diagnostics-APIMgmt'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-APIMgmt.json')
  }
  {
    name: 'Deploy-Diagnostics-ApplicationGateway'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-ApplicationGateway.json')
  }
  {
    name: 'Deploy-Diagnostics-AVDScalingPlans'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-AVDScalingPlans.json')
  }
  {
    name: 'Deploy-Diagnostics-Bastion'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Bastion.json')
  }
  {
    name: 'Deploy-Diagnostics-CDNEndpoints'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-CDNEndpoints.json')
  }
  {
    name: 'Deploy-Diagnostics-CognitiveServices'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-CognitiveServices.json')
  }
  {
    name: 'Deploy-Diagnostics-CosmosDB'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-CosmosDB.json')
  }
  {
    name: 'Deploy-Diagnostics-Databricks'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Databricks.json')
  }
  {
    name: 'Deploy-Diagnostics-DataExplorerCluster'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-DataExplorerCluster.json')
  }
  {
    name: 'Deploy-Diagnostics-DataFactory'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-DataFactory.json')
  }
  {
    name: 'Deploy-Diagnostics-DLAnalytics'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-DLAnalytics.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSub'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-EventGridSub.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSystemTopic'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-EventGridSystemTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridTopic'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-EventGridTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-ExpressRoute'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-ExpressRoute.json')
  }
  {
    name: 'Deploy-Diagnostics-Firewall'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Firewall.json')
  }
  {
    name: 'Deploy-Diagnostics-FrontDoor'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-FrontDoor.json')
  }
  {
    name: 'Deploy-Diagnostics-Function'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Function.json')
  }
  {
    name: 'Deploy-Diagnostics-HDInsight'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-HDInsight.json')
  }
  {
    name: 'Deploy-Diagnostics-iotHub'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-iotHub.json')
  }
  {
    name: 'Deploy-Diagnostics-LoadBalancer'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-LoadBalancer.json')
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-LogAnalytics.json')
  }
  {
    name: 'Deploy-Diagnostics-LogicAppsISE'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-LogicAppsISE.json')
  }
  {
    name: 'Deploy-Diagnostics-MariaDB'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-MariaDB.json')
  }
  {
    name: 'Deploy-Diagnostics-MediaService'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-MediaService.json')
  }
  {
    name: 'Deploy-Diagnostics-MlWorkspace'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-MlWorkspace.json')
  }
  {
    name: 'Deploy-Diagnostics-MySQL'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-MySQL.json')
  }
  {
    name: 'Deploy-Diagnostics-NetworkSecurityGroups'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-NetworkSecurityGroups.json')
  }
  {
    name: 'Deploy-Diagnostics-NIC'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-NIC.json')
  }
  {
    name: 'Deploy-Diagnostics-PostgreSQL'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-PostgreSQL.json')
  }
  {
    name: 'Deploy-Diagnostics-PowerBIEmbedded'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-PowerBIEmbedded.json')
  }
  {
    name: 'Deploy-Diagnostics-RedisCache'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-RedisCache.json')
  }
  {
    name: 'Deploy-Diagnostics-Relay'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Relay.json')
  }
  {
    name: 'Deploy-Diagnostics-SignalR'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-SignalR.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLElasticPools'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-SQLElasticPools.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLMI'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-SQLMI.json')
  }
  {
    name: 'Deploy-Diagnostics-TimeSeriesInsights'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-TimeSeriesInsights.json')
  }
  {
    name: 'Deploy-Diagnostics-TrafficManager'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-TrafficManager.json')
  }
  {
    name: 'Deploy-Diagnostics-VirtualNetwork'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-VirtualNetwork.json')
  }
  {
    name: 'Deploy-Diagnostics-VM'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-VM.json')
  }
  {
    name: 'Deploy-Diagnostics-VMSS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-VMSS.json')
  }
  {
    name: 'Deploy-Diagnostics-VNetGW'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-VNetGW.json')
  }
  {
    name: 'Deploy-Diagnostics-VWanS2SVPNGW'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-VWanS2SVPNGW.json')
  }
  {
    name: 'Deploy-Diagnostics-WebServerFarm'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-WebServerFarm.json')
  }
  {
    name: 'Deploy-Diagnostics-Website'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-Website.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDAppGroup'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-WVDAppGroup.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDHostPools'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-WVDHostPools.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDWorkspace'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Diagnostics-WVDWorkspace.json')
  }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-FirewallPolicy.json')
  }
  {
    name: 'Deploy-MySQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-MySQL-sslEnforcement.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs-to-LA'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Nsg-FlowLogs-to-LA.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Nsg-FlowLogs.json')
  }
  {
    name: 'Deploy-PostgreSQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-PostgreSQL-sslEnforcement.json')
  }
  {
    name: 'Deploy-Sql-AuditingSettings'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Sql-AuditingSettings.json')
  }
  {
    name: 'Deploy-SQL-minTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-SQL-minTLS.json')
  }
  {
    name: 'Deploy-Sql-SecurityAlertPolicies'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Sql-SecurityAlertPolicies.json')
  }
  {
    name: 'Deploy-Sql-Tde'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Sql-Tde.json')
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments_20230706'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Sql-vulnerabilityAssessments_20230706.json')
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Sql-vulnerabilityAssessments.json')
  }
  {
    name: 'Deploy-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-SqlMi-minTLS.json')
  }
  {
    name: 'Deploy-Storage-sslEnforcement'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Storage-sslEnforcement.json')
  }
  {
    name: 'Deploy-Vm-autoShutdown'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Vm-autoShutdown.json')
  }
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-VNET-HubSpoke.json')
  }
  {
    name: 'Deploy-Windows-DomainJoin'
    libDefinition: loadJsonContent('lib/policy_definitions/policy_definition_es_Deploy-Windows-DomainJoin.json')
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_set_definitions\_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
  {
    name: 'Audit-UnusedResourcesCostOptimization'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Audit-UnusedResourcesCostOptimization.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'AuditAzureHybridBenefitUnusedResourcesCostOptimization'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-AzureHybridBenefit'
        definitionParameters: varPolicySetDefinitionEsAuditUnusedResourcesCostOptimizationParameters.AuditAzureHybridBenefitUnusedResourcesCostOptimization.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AuditDisksUnusedResourcesCostOptimization'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-Disks-UnusedResourcesCostOptimization'
        definitionParameters: varPolicySetDefinitionEsAuditUnusedResourcesCostOptimizationParameters.AuditDisksUnusedResourcesCostOptimization.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AuditPublicIpAddressesUnusedResourcesCostOptimization'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-PublicIpAddresses-UnusedResourcesCostOptimization'
        definitionParameters: varPolicySetDefinitionEsAuditUnusedResourcesCostOptimizationParameters.AuditPublicIpAddressesUnusedResourcesCostOptimization.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AuditServerFarmsUnusedResourcesCostOptimization'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-ServerFarms-UnusedResourcesCostOptimization'
        definitionParameters: varPolicySetDefinitionEsAuditUnusedResourcesCostOptimizationParameters.AuditServerFarmsUnusedResourcesCostOptimization.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Deny-PublicPaaSEndpoints'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deny-PublicPaaSEndpoints.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0fdf0491-d080-4575-b627-ad0e843cba0f'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.ACRDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AFSDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/21a8cd35-125e-4d13-b82d-2e19b7208bb7'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AFSDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AKSDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AKSDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'ApiManDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/df73bd95-24da-4a4f-96b9-4e8b94b402bd'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.ApiManDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AppConfigDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3d9f5e4c-9947-4579-9539-2a7695fbc187'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AppConfigDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AsDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1b5ef780-c53c-4a64-87f3-bb9c8c8094ba'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AsDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AseDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2d048aca-6479-4923-88f5-e2ac295d9af3'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AseDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AutomationDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/955a914f-bf86-4f0e-acd5-e0766b0efcb6'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.AutomationDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'BatchDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/74c5a0ae-5e48-4738-b093-65e23a060488'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.BatchDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'BotServiceDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e8168db-69e3-4beb-9822-57cb59202a9d'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.BotServiceDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CosmosDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/797b37f7-06b8-444c-b1ad-fc62867f335a'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.CosmosDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FunctionDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/969ac98b-88a8-449f-883c-2e9adb123127'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.FunctionDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KeyVaultDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/405c5871-3e91-4644-8a63-58e19d68ff5b'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.KeyVaultDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MariaDbDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fdccbe47-f3e3-4213-ad5d-ea459b2fa077'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.MariaDbDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MlDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/438c38d2-3772-465a-a9cc-7a6666a275ce'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.MlDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MySQLFlexDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c9299215-ae47-4f50-9c54-8a392f68a052'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.MySQLFlexDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PostgreSQLFlexDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e1de0e3-42cb-4ebc-a86d-61d0c619ca48'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.PostgreSQLFlexDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RedisCacheDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/470baccb-7e51-4549-8b1a-3e5be069f663'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.RedisCacheDenyPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SqlServerDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.SqlServerDenyPaasPublicIP.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693'
        definitionParameters: varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters.StorageDenyPaasPublicIP.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Diagnostics-LogAnalytics.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACIDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACI'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.ACIDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'ACRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACR'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.ACRDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AKSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AKSDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AnalysisServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AnalysisService'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AnalysisServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'APIforFHIRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApiForFHIR'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.APIforFHIRDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'APIMgmtDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-APIMgmt'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.APIMgmtDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApplicationGateway'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AppServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WebServerFarm'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AppServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AppServiceWebappDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Website'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AppServiceWebappDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AutomationDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AutomationDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AVDScalingPlansDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AVDScalingPlans'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.AVDScalingPlansDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'BastionDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Bastion'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.BastionDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'BatchDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c84e5349-db6d-4769-805e-e14037dab9b5'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.BatchDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CDNEndpointsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CDNEndpoints'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.CDNEndpointsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CognitiveServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CognitiveServices'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.CognitiveServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CosmosDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CosmosDB'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.CosmosDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DatabricksDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Databricks'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.DatabricksDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataExplorerCluster'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DataFactoryDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataFactory'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.DataFactoryDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DLAnalytics'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DataLakeStoreDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d56a5a7c-72d7-42bc-8ceb-3baf4c0eae03'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.DataLakeStoreDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'EventGridSubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSub'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.EventGridSubDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'EventGridTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridTopic'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.EventGridTopicDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'EventHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f6e93e8-6b31-41b1-83f6-36e449a42579'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.EventHubDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'EventSystemTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSystemTopic'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.EventSystemTopicDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'ExpressRouteDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ExpressRoute'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.ExpressRouteDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FirewallDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.FirewallDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FrontDoorDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-FrontDoor'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.FrontDoorDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FunctionAppDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Function'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.FunctionAppDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'HDInsightDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-HDInsight'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.HDInsightDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'IotHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-iotHub'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.IotHubDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KeyVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.KeyVaultDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'LoadBalancerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LoadBalancer'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.LoadBalancerDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'LogAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogAnalytics'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.LogAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'LogicAppsISEDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogicAppsISE'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.LogicAppsISEDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'LogicAppsWFDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b889a06c-ec72-4b03-910a-cb169ee18721'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.LogicAppsWFDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MariaDBDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MariaDB'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.MariaDBDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MediaServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MediaService'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.MediaServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MlWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MlWorkspace'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.MlWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MySQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MySQL'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.MySQLDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'NetworkNICDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NIC'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.NetworkNICDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NetworkSecurityGroups'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PostgreSQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PostgreSQL'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.PostgreSQLDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PowerBIEmbedded'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RecoveryVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.RecoveryVaultDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RedisCacheDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-RedisCache'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.RedisCacheDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RelayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Relay'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.RelayDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SearchServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/08ba64b8-738f-4918-9686-730d2ed79c7d'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.SearchServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'ServiceBusDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/04d53d87-841c-4f23-8a5b-21564380b55e'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.ServiceBusDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SignalRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SignalR'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.SignalRDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLDatabaseDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b79fa14e-238a-4c2d-b376-442ce508fc84'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.SQLDatabaseDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLElasticPools'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLMDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLMI'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.SQLMDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageAccountBlobServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b4fe1a3b-0715-4c6c-a5ea-ffc33cf823cb'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StorageAccountBlobServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageAccountDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/59759c62-9a22-4cdf-ae64-074495983fef'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StorageAccountDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageAccountFileServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/25a70cc8-2bd4-47f1-90b6-1478e4662c96'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StorageAccountFileServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageAccountQueueServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7bd000e3-37c7-4928-9f31-86c4b77c5c45'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StorageAccountQueueServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageAccountTableServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2fb86bf3-d221-43d1-96d1-2434af34eaa0'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StorageAccountTableServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/237e0f7e-b0e8-4ec4-ad46-8c12cb66d673'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TimeSeriesInsights'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'TrafficManagerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TrafficManager'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.TrafficManagerDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'VirtualMachinesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VM'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.VirtualMachinesDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'VirtualNetworkDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VirtualNetwork'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.VirtualNetworkDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'VMSSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VMSS'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.VMSSDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'VNetGWDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VNetGW'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.VNetGWDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'VWanS2SVPNGWDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VWanS2SVPNGW'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.VWanS2SVPNGWDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WVDAppGroupDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDAppGroup'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.WVDAppGroupDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDHostPools'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDWorkspace'
        definitionParameters: varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters.WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Deploy-MDFC-Config'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-MDFC-Config.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ascExport'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.ascExport.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'azurePolicyForKubernetes'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.azurePolicyForKubernetes.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForApis'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e54d2be9-5f2e-4d65-98e4-4f0e670b23d6'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForApis.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForAppServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b40e7bcd-a1e5-47fe-b9cf-2f534d0bfb7d'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForAppServices.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForArm'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b7021b2b-08fd-4dc0-9de7-3c6ece09faf9'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForArm.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderforContainers'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c9ddb292-b203-4738-aead-18e2716e858f'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderforContainers.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForCosmosDbs'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/82bf5b87-728b-4a74-ba4d-6123845cf542'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForCosmosDbs.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForCspm'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/689f7782-ef2c-4270-a6d0-7664869076bd'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForCspm.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForDns'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2370a3c1-4a25-4283-a91a-c9c1a145fb2f'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForDns.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForKeyVaults'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f725891-01c0-420a-9059-4fa46cb770b7'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForKeyVaults.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderforKubernetes'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderforKubernetes.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForOssDb'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/44433aa3-7ec2-4002-93ea-65c65ff0310a'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForOssDb.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForSqlPaas'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b99b73e7-074b-4089-9395-b7236f094491'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForSqlPaas.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForSqlServerVirtualMachines'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/50ea7265-7d8c-429e-9a7d-ca1f410191c3'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForSqlServerVirtualMachines.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForStorageAccounts'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/74c30959-af11-47b3-9ed2-a26e03f427a3'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForStorageAccounts.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForVM'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e86a5b6-b9bd-49d1-8e21-4bb8a0862222'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForVM.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'defenderForVMVulnerabilityAssessment'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.defenderForVMVulnerabilityAssessment.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'securityEmailContact'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-SecurityContacts'
        definitionParameters: varPolicySetDefinitionEsDeployMDFCConfigParameters.securityEmailContact.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Deploy-Private-DNS-Zones'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Private-DNS-Zones.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ACR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e9585a95-5b8c-4d03-b193-dc7eb5ac4c32'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-ACR'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-App'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7a860e27-9ca2-4fc6-822d-c2d248c300df'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-App'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-AppServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-AppServices'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Automation-DSCHybrid'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6dd01e4f-1be1-4e80-9d0b-d109e04cb064'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Automation-DSCHybrid'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Automation-Webhook'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6dd01e4f-1be1-4e80-9d0b-d109e04cb064'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Automation-Webhook'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Batch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4ec38ebc-381f-45ee-81a4-acbc4be878f8'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Batch'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveSearch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fbc14a67-53e4-4932-abcc-2049c6706009'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-CognitiveSearch'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-CognitiveServices'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Cosmos-Cassandra'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Cosmos-Cassandra'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Cosmos-Gremlin'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Cosmos-Gremlin'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Cosmos-MongoDB'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Cosmos-MongoDB'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Cosmos-SQL'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Cosmos-SQL'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Cosmos-Table'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Cosmos-Table'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DataFactory'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86cd96e1-1745-420d-94d4-d3f2fe415aa4'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-DataFactory'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DataFactory-Portal'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86cd96e1-1745-420d-94d4-d3f2fe415aa4'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-DataFactory-Portal'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DiskAccess'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bc05b96c-0b36-4ca9-82f0-5c53f96ce05a'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-DiskAccess'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridDomains'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d389df0a-e0d7-4607-833c-75a6fdac2c2d'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventGridDomains'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridTopics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/baf19753-7502-405f-8745-370519b20483'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventGridTopics'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventHubNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ed66d4f5-8220-45dc-ab4a-20d1749c74e6'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-EventHubNamespace'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-File-Sync'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/06695360-db88-47f6-b976-7500d4297475'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-File-Sync'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-HDInsight'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/43d6e3bd-fc6a-4b44-8b4d-2151d8736a11'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-HDInsight'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoT'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/aaa64d2d-2fa3-45e5-b332-0b031b9b30e8'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-IoT'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoTHubs'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-IoTHubs'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-KeyVault'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-KeyVault'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MachineLearningWorkspace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ee40564d-486e-4f68-a5ca-7a621edae0fb'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-MachineLearningWorkspace'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MediaServices-Key'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b4a7f6c1-585e-4177-ad5b-c2c93f4bb991'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-MediaServices-Key'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MediaServices-Live'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b4a7f6c1-585e-4177-ad5b-c2c93f4bb991'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-MediaServices-Live'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MediaServices-Stream'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b4a7f6c1-585e-4177-ad5b-c2c93f4bb991'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-MediaServices-Stream'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Migrate'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7590a335-57cf-4c95-babd-ecbc8fafeb1f'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Migrate'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Monitor'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/437914ee-c176-4fff-8986-7e05eb971365'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Monitor'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-RedisCache'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e016b22b-e0eb-436d-8fd7-160c4eaed6e2'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-RedisCache'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ServiceBusNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0fcf93c-c063-4071-9668-c47474bd3564'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-ServiceBusNamespace'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-SignalR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b0e86710-7fb7-4a6c-a064-32e9b829509e'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-SignalR'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Site-Recovery'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/942bd215-1a66-44be-af65-6a1c0318dbe2'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Site-Recovery'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-Blob'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/75973700-529f-4de2-b794-fb9b6781b6b0'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-Blob'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-Blob-Sec'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d847d34b-9337-4e2d-99a5-767e5ac9c582'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-Blob-Sec'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-DFS'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83c6fe0f-2316-444a-99a1-1ecd8a7872ca'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-DFS'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-DFS-Sec'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/90bd4cb3-9f59-45f7-a6ca-f69db2726671'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-DFS-Sec'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-File'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6df98d03-368a-4438-8730-a93c4d7693d6'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-File'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-Queue'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bcff79fb-2b0d-47c9-97e5-3023479b00d1'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-Queue'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-Queue-Sec'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/da9b4ae8-5ddc-48c5-b9c0-25f8abf7a3d6'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-Queue-Sec'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-StaticWeb'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9adab2a5-05ba-4fbd-831a-5bf958d04218'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-StaticWeb'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Storage-StaticWeb-Sec'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d19ae5f1-b303-4b82-9ca8-7682749faf0c'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Storage-StaticWeb-Sec'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Synapse-Dev'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e5ed725-f16c-478b-bd4b-7bfa2f7940b9'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Synapse-Dev'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Synapse-SQL'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e5ed725-f16c-478b-bd4b-7bfa2f7940b9'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Synapse-SQL'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Synapse-SQL-OnDemand'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e5ed725-f16c-478b-bd4b-7bfa2f7940b9'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Synapse-SQL-OnDemand'].parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Web'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0b026355-49cb-467b-8ac4-f777874e175a'
        definitionParameters: varPolicySetDefinitionEsDeployPrivateDNSZonesParameters['DINE-Private-DNS-Azure-Web'].parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Deploy-Sql-Security'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Sql-Security.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'SqlDbAuditingSettingsDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
        definitionParameters: varPolicySetDefinitionEsDeploySqlSecurityParameters.SqlDbAuditingSettingsDeploySqlSecurity.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
        definitionParameters: varPolicySetDefinitionEsDeploySqlSecurityParameters.SqlDbSecurityAlertPoliciesDeploySqlSecurity.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SqlDbTdeDeploySqlSecurity'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
        definitionParameters: varPolicySetDefinitionEsDeploySqlSecurityParameters.SqlDbTdeDeploySqlSecurity.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments'
        definitionParameters: varPolicySetDefinitionEsDeploySqlSecurityParameters.SqlDbVulnerabilityAssessmentsDeploySqlSecurity.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-ACSB'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ACSB.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'GcIdentity'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3cf2ab00-13f1-4d0c-8971-2ac904541a7e'
        definitionParameters: varPolicySetDefinitionEsEnforceACSBParameters.GcIdentity.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'GcLinux'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/331e8ea8-378a-410f-a2e5-ae22f38bb0da'
        definitionParameters: varPolicySetDefinitionEsEnforceACSBParameters.GcLinux.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'GcWindows'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/385f5831-96d4-41db-9a3c-cd3af78aaae6'
        definitionParameters: varPolicySetDefinitionEsEnforceACSBParameters.GcWindows.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'LinAcsb'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fc9b3da7-8347-4380-8e70-0a0361d8dedd'
        definitionParameters: varPolicySetDefinitionEsEnforceACSBParameters.LinAcsb.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WinAcsb'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/72650e9f-97bc-4b2a-ab5f-9781a9fcecbc'
        definitionParameters: varPolicySetDefinitionEsEnforceACSBParameters.WinAcsb.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-ALZ-Decomm'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ALZ-Decomm.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'DecomDenyResources'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c'
        definitionParameters: varPolicySetDefinitionEsEnforceALZDecommParameters.DecomDenyResources.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DecomShutdownMachines'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Vm-autoShutdown'
        definitionParameters: varPolicySetDefinitionEsEnforceALZDecommParameters.DecomShutdownMachines.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-ALZ-Sandbox'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ALZ-Sandbox.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'SandboxDenyVnetPeering'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-VNET-Peer-Cross-Sub'
        definitionParameters: varPolicySetDefinitionEsEnforceALZSandboxParameters.SandboxDenyVnetPeering.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SandboxNotAllowed'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
        definitionParameters: varPolicySetDefinitionEsEnforceALZSandboxParameters.SandboxNotAllowed.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-Encryption-CMK'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-Encryption-CMK.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.ACRCmkDeny.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AksCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7d7be79c-23ba-4033-84dd-45e2a5ccdd67'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.AksCmkDeny.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AzureBatchCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/99e9ccd8-3db9-4592-b0d1-14b1715a4d8a'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.AzureBatchCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CognitiveServicesCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/67121cc7-ff39-4ab8-b7e3-95b84dab487d'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.CognitiveServicesCMK.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'CosmosCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f905d99-2ab7-462c-a6b0-f709acca6c8f'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.CosmosCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'DataBoxCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86efb160-8de7-451d-bc08-5d475b0aadae'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.DataBoxCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'EncryptedVMDisksEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.EncryptedVMDisksEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'HealthcareAPIsCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/051cba44-2429-45b9-9649-46cec11c7119'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.HealthcareAPIsCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MySQLCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83cef61d-dbd1-4b20-a4fc-5fbc7da10833'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.MySQLCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PostgreSQLCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/18adea5e-f416-4d0f-8aa8-d24321e3e274'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.PostgreSQLCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SqlServerTDECMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a370ff3-6cab-4e85-8995-295fd854c5b8'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.SqlServerTDECMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.StorageCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StreamAnalyticsCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/87ba29ef-1ab3-4d82-b763-87fcd4f531f7'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.StreamAnalyticsCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SynapseWorkspaceCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f7d52b2d-e161-4dfa-a82b-55e564167385'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.SynapseWorkspaceCMKEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WorkspaceCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ba769a63-b8cc-4b2d-abf6-ac33c7204be8'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptionCMKParameters.WorkspaceCMK.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-EncryptTransit'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-EncryptTransit.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.AKSIngressHttpsOnlyEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'APIAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.APIAppServiceHttpsEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AppServiceHttpEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.AppServiceHttpEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'AppServiceminTlsVersion'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.AppServiceminTlsVersion.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FunctionLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.FunctionLatestTlsEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'FunctionServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.FunctionServiceHttpsEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MySQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.MySQLEnableSSLDeployEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'MySQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.MySQLEnableSSLEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.PostgreSQLEnableSSLDeployEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.PostgreSQLEnableSSLEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RedisDenyhttps'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.RedisDenyhttps.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RedisdisableNonSslPort'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.RedisdisableNonSslPort.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'RedisTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.RedisTLSDeployEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.SQLManagedInstanceTLSDeployEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.SQLManagedInstanceTLSEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLServerTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.SQLServerTLSDeployEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'SQLServerTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.SQLServerTLSEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.StorageDeployHttpsEnabledEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'StorageHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.StorageHttpsEnabledEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WebAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.WebAppServiceHttpsEffect.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'WebAppServiceLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
        definitionParameters: varPolicySetDefinitionEsEnforceEncryptTransitParameters.WebAppServiceLatestTlsEffect.parameters
        definitionGroups: []
      }
    ]
  }
  {
    name: 'Enforce-Guardrails-KeyVault'
    libSetDefinition: loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-Guardrails-KeyVault.json')
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'KvCertLifetime'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/12ef42cb-9903-4e39-9c26-422d29570417'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvCertLifetime.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvFirewallEnabled'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvFirewallEnabled.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvKeysExpire'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvKeysExpire.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvKeysLifetime'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5ff38825-c5d8-47c5-b70e-069a21955146'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvKeysLifetime.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvPurgeProtection'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvPurgeProtection.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvSecretsExpire'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98728c90-32c7-4049-8429-847dc0f4fe37'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvSecretsExpire.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvSecretsLifetime'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b0eb591a-5e70-4534-a8bf-04b9c489584a'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvSecretsLifetime.parameters
        definitionGroups: []
      }
      {
        definitionReferenceId: 'KvSoftDelete'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d'
        definitionParameters: varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters.KvSoftDelete.parameters
        definitionGroups: []
      }
    ]
  }
]

// Policy Set/Initiative Definition Parameter Variables

var varPolicySetDefinitionEsAuditUnusedResourcesCostOptimizationParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Audit-UnusedResourcesCostOptimization.parameters.json')

var varPolicySetDefinitionEsDenyPublicPaaSEndpointsParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deny-PublicPaaSEndpoints.parameters.json')

var varPolicySetDefinitionEsDeployDiagnosticsLogAnalyticsParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Diagnostics-LogAnalytics.parameters.json')

var varPolicySetDefinitionEsDeployMDFCConfigParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-MDFC-Config.parameters.json')

var varPolicySetDefinitionEsDeployPrivateDNSZonesParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Private-DNS-Zones.parameters.json')

var varPolicySetDefinitionEsDeploySqlSecurityParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Deploy-Sql-Security.parameters.json')

var varPolicySetDefinitionEsEnforceACSBParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ACSB.parameters.json')

var varPolicySetDefinitionEsEnforceALZDecommParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ALZ-Decomm.parameters.json')

var varPolicySetDefinitionEsEnforceALZSandboxParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-ALZ-Sandbox.parameters.json')

var varPolicySetDefinitionEsEnforceEncryptionCMKParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-Encryption-CMK.parameters.json')

var varPolicySetDefinitionEsEnforceEncryptTransitParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-EncryptTransit.parameters.json')

var varPolicySetDefinitionEsEnforceGuardrailsKeyVaultParameters = loadJsonContent('lib/policy_set_definitions/policy_set_definition_es_Enforce-Guardrails-KeyVault.parameters.json')

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
      groupNames: policySetDef.definitionGroups
    }]
    policyDefinitionGroups: policySet.libSetDefinition.properties.policyDefinitionGroups
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
