targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Custom Policy Definitions at Management Group Scope'
metadata description = 'This policy definition is used to deploy custom policy definitions at management group scope'

@sys.description('The management group scope to which the policy definitions are to be created at.')
param parTargetManagementGroupId string = 'alz'

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varTargetManagementGroupResourceId = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

// This variable contains a number of objects that load in the custom Azure Policy Definitions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_definitions\_policyDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicyDefinitionsArray = [
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-KV-SoftDelete.json')
  }
  {
    name: 'Append-Redis-sslEnforcement'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-Redis-sslEnforcement.json')
  }
  {
    name: 'Audit-AzureHybridBenefit'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-AzureHybridBenefit.json')
  }
  {
    name: 'Audit-MachineLearning-PrivateEndpointId'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-MachineLearning-PrivateEndpointId.json')
  }
  {
    name: 'Audit-PrivateLinkDnsZones'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-PrivateLinkDnsZones.json')
  }
  {
    name: 'Deny-AA-child-resources'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AA-child-resources.json')
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppGW-Without-WAF.json')
  }
  {
    name: 'Deny-AzFw-Without-Policy'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AzFw-Without-Policy.json')
  }
  {
    name: 'Deny-CognitiveServices-NetworkAcls'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-CognitiveServices-NetworkAcls.json')
  }
  {
    name: 'Deny-CognitiveServices-Resource-Kinds'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-CognitiveServices-Resource-Kinds.json')
  }
  {
    name: 'Deny-CognitiveServices-RestrictOutboundNetworkAccess'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-CognitiveServices-RestrictOutboundNetworkAccess.json')
  }
  {
    name: 'Deny-Databricks-NoPublicIp'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Databricks-NoPublicIp.json')
  }
  {
    name: 'Deny-Databricks-Sku'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Databricks-Sku.json')
  }
  {
    name: 'Deny-Databricks-VirtualNetwork'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Databricks-VirtualNetwork.json')
  }
  {
    name: 'Deny-EH-Premium-CMK'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-EH-Premium-CMK.json')
  }
  {
    name: 'Deny-FileServices-InsecureAuth'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-FileServices-InsecureAuth.json')
  }
  {
    name: 'Deny-FileServices-InsecureKerberos'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-FileServices-InsecureKerberos.json')
  }
  {
    name: 'Deny-FileServices-InsecureSmbChannel'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-FileServices-InsecureSmbChannel.json')
  }
  {
    name: 'Deny-FileServices-InsecureSmbVersions'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-FileServices-InsecureSmbVersions.json')
  }
  {
    name: 'Deny-LogicApp-Public-Network'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-LogicApp-Public-Network.json')
  }
  {
    name: 'Deny-MachineLearning-Aks'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-Aks.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-SubnetId'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-Compute-SubnetId.json')
  }
  {
    name: 'Deny-MachineLearning-Compute-VmSize'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-Compute-VmSize.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess.json')
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-Scale'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-ComputeCluster-Scale.json')
  }
  {
    name: 'Deny-MachineLearning-HbiWorkspace'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-HbiWorkspace.json')
  }
  {
    name: 'Deny-MachineLearning-PublicAccessWhenBehindVnet'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-PublicAccessWhenBehindVnet.json')
  }
  {
    name: 'Deny-MachineLearning-PublicNetworkAccess'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MachineLearning-PublicNetworkAccess.json')
  }
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Private-DNS-Zones.json')
  }
  {
    name: 'Deny-PublicEndpoint-MariaDB'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-PublicEndpoint-MariaDB.json')
  }
  {
    name: 'Deny-PublicIP'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-PublicIP.json')
  }
  {
    name: 'Deny-RDP-From-Internet'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-RDP-From-Internet.json')
  }
  {
    name: 'Deny-Sql-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Sql-minTLS.json')
  }
  {
    name: 'Deny-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-SqlMi-minTLS.json')
  }
  {
    name: 'Deny-Storage-ResourceAccessRulesResourceId'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-ResourceAccessRulesResourceId.json')
  }
  {
    name: 'Deny-Storage-ResourceAccessRulesTenantId'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-ResourceAccessRulesTenantId.json')
  }
  {
    name: 'Deny-StorageAccount-CustomDomain'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-StorageAccount-CustomDomain.json')
  }
  {
    name: 'Deny-Subnet-Without-Penp'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Subnet-Without-Penp.json')
  }
  {
    name: 'Deny-UDR-With-Specific-NextHop'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-UDR-With-Specific-NextHop.json')
  }
  {
    name: 'Deny-VNET-Peering-To-Non-Approved-VNETs'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-VNET-Peering-To-Non-Approved-VNETs.json')
  }
  {
    name: 'Deny-VNet-Peering'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-VNet-Peering.json')
  }
  {
    name: 'DenyAction-ActivityLogs'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_DenyAction-ActivityLogs.json')
  }
  {
    name: 'DenyAction-DeleteResources'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_DenyAction-DeleteResources.json')
  }
  {
    name: 'DenyAction-DiagnosticLogs'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_DenyAction-DiagnosticLogs.json')
  }
  {
    name: 'Deploy-ASC-SecurityContacts'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-ASC-SecurityContacts.json')
  }
  {
    name: 'Deploy-Budget'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Budget.json')
  }
  {
    name: 'Deploy-Custom-Route-Table'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Custom-Route-Table.json')
  }
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-DDoSProtection.json')
  }
  {
    name: 'Deploy-Diagnostics-AA'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-AA.json')
  }
  {
    name: 'Deploy-Diagnostics-ACI'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-ACI.json')
  }
  {
    name: 'Deploy-Diagnostics-ACR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-ACR.json')
  }
  {
    name: 'Deploy-Diagnostics-AnalysisService'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-AnalysisService.json')
  }
  {
    name: 'Deploy-Diagnostics-ApiForFHIR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-ApiForFHIR.json')
  }
  {
    name: 'Deploy-Diagnostics-APIMgmt'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-APIMgmt.json')
  }
  {
    name: 'Deploy-Diagnostics-ApplicationGateway'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-ApplicationGateway.json')
  }
  {
    name: 'Deploy-Diagnostics-AVDScalingPlans'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-AVDScalingPlans.json')
  }
  {
    name: 'Deploy-Diagnostics-Bastion'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Bastion.json')
  }
  {
    name: 'Deploy-Diagnostics-CDNEndpoints'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-CDNEndpoints.json')
  }
  {
    name: 'Deploy-Diagnostics-CognitiveServices'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-CognitiveServices.json')
  }
  {
    name: 'Deploy-Diagnostics-CosmosDB'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-CosmosDB.json')
  }
  {
    name: 'Deploy-Diagnostics-Databricks'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Databricks.json')
  }
  {
    name: 'Deploy-Diagnostics-DataExplorerCluster'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-DataExplorerCluster.json')
  }
  {
    name: 'Deploy-Diagnostics-DataFactory'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-DataFactory.json')
  }
  {
    name: 'Deploy-Diagnostics-DLAnalytics'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-DLAnalytics.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSub'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-EventGridSub.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridSystemTopic'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-EventGridSystemTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-EventGridTopic'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-EventGridTopic.json')
  }
  {
    name: 'Deploy-Diagnostics-ExpressRoute'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-ExpressRoute.json')
  }
  {
    name: 'Deploy-Diagnostics-Firewall'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Firewall.json')
  }
  {
    name: 'Deploy-Diagnostics-FrontDoor'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-FrontDoor.json')
  }
  {
    name: 'Deploy-Diagnostics-Function'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Function.json')
  }
  {
    name: 'Deploy-Diagnostics-HDInsight'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-HDInsight.json')
  }
  {
    name: 'Deploy-Diagnostics-iotHub'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-iotHub.json')
  }
  {
    name: 'Deploy-Diagnostics-LoadBalancer'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-LoadBalancer.json')
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-LogAnalytics.json')
  }
  {
    name: 'Deploy-Diagnostics-LogicAppsISE'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-LogicAppsISE.json')
  }
  {
    name: 'Deploy-Diagnostics-MariaDB'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-MariaDB.json')
  }
  {
    name: 'Deploy-Diagnostics-MediaService'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-MediaService.json')
  }
  {
    name: 'Deploy-Diagnostics-MlWorkspace'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-MlWorkspace.json')
  }
  {
    name: 'Deploy-Diagnostics-MySQL'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-MySQL.json')
  }
  {
    name: 'Deploy-Diagnostics-NetworkSecurityGroups'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-NetworkSecurityGroups.json')
  }
  {
    name: 'Deploy-Diagnostics-NIC'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-NIC.json')
  }
  {
    name: 'Deploy-Diagnostics-PostgreSQL'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-PostgreSQL.json')
  }
  {
    name: 'Deploy-Diagnostics-PowerBIEmbedded'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-PowerBIEmbedded.json')
  }
  {
    name: 'Deploy-Diagnostics-RedisCache'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-RedisCache.json')
  }
  {
    name: 'Deploy-Diagnostics-Relay'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Relay.json')
  }
  {
    name: 'Deploy-Diagnostics-SignalR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-SignalR.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLElasticPools'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-SQLElasticPools.json')
  }
  {
    name: 'Deploy-Diagnostics-SQLMI'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-SQLMI.json')
  }
  {
    name: 'Deploy-Diagnostics-TimeSeriesInsights'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-TimeSeriesInsights.json')
  }
  {
    name: 'Deploy-Diagnostics-TrafficManager'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-TrafficManager.json')
  }
  {
    name: 'Deploy-Diagnostics-VirtualNetwork'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-VirtualNetwork.json')
  }
  {
    name: 'Deploy-Diagnostics-VM'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-VM.json')
  }
  {
    name: 'Deploy-Diagnostics-VMSS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-VMSS.json')
  }
  {
    name: 'Deploy-Diagnostics-VNetGW'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-VNetGW.json')
  }
  {
    name: 'Deploy-Diagnostics-VWanS2SVPNGW'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-VWanS2SVPNGW.json')
  }
  {
    name: 'Deploy-Diagnostics-WebServerFarm'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-WebServerFarm.json')
  }
  {
    name: 'Deploy-Diagnostics-Website'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-Website.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDAppGroup'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-WVDAppGroup.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDHostPools'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-WVDHostPools.json')
  }
  {
    name: 'Deploy-Diagnostics-WVDWorkspace'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Diagnostics-WVDWorkspace.json')
  }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-FirewallPolicy.json')
  }
  {
    name: 'Deploy-LogicApp-TLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-LogicApp-TLS.json')
  }
  {
    name: 'Deploy-MDFC-Arc-SQL-DCR-Association'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MDFC-Arc-SQL-DCR-Association.json')
  }
  {
    name: 'Deploy-MDFC-Arc-Sql-DefenderSQL-DCR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MDFC-Arc-Sql-DefenderSQL-DCR.json')
  }
  {
    name: 'Deploy-MDFC-SQL-AMA'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MDFC-SQL-AMA.json')
  }
  {
    name: 'Deploy-MDFC-SQL-DefenderSQL-DCR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MDFC-SQL-DefenderSQL-DCR.json')
  }
  {
    name: 'Deploy-MDFC-SQL-DefenderSQL'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MDFC-SQL-DefenderSQL.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs-to-LA'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Nsg-FlowLogs-to-LA.json')
  }
  {
    name: 'Deploy-Nsg-FlowLogs'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Nsg-FlowLogs.json')
  }
  {
    name: 'Deploy-Private-DNS-Generic'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Private-DNS-Generic.json')
  }
    {
    name: 'Deploy-UserAssignedManagedIdentity-VMInsights'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-UserAssignedManagedIdentity-VMInsights.json')
  }
  {
    name: 'Deploy-Vm-autoShutdown'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Vm-autoShutdown.json')
  }
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-VNET-HubSpoke.json')
  }
  {
    name: 'Deploy-Windows-DomainJoin'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Windows-DomainJoin.json')
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Definitions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_set_definitions\_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
	{
		name: 'Audit-UnusedResourcesCostOptimization'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Audit-UnusedResourcesCostOptimization.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'AuditAzureHybridBenefitUnusedResourcesCostOptimization'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-AzureHybridBenefit'
				definitionParameters: varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters.AuditAzureHybridBenefitUnusedResourcesCostOptimization.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'DenyAction-DeleteProtection'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_DenyAction-DeleteProtection.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'DenyActionDelete-ActivityLogSettings'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/DenyAction-ActivityLogs'
				definitionParameters: varPolicySetDefinitionEsMgDenyActionDeleteProtectionParameters['DenyActionDelete-ActivityLogSettings'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DenyActionDelete-DiagnosticSettings'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/DenyAction-DiagnosticLogs'
				definitionParameters: varPolicySetDefinitionEsMgDenyActionDeleteProtectionParameters['DenyActionDelete-DiagnosticSettings'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-ALZ-Decomm'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Decomm.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'DecomShutdownMachines'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Vm-autoShutdown'
				definitionParameters: varPolicySetDefinitionEsMgEnforceALZDecommParameters.DecomShutdownMachines.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-CosmosDb'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-CosmosDb.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Append-CosmosDb-Metadata'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4750c32b-89c0-46af-bfcb-2e4541a818d5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Append-CosmosDb-Metadata'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Network'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Network.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Ip-Forwarding'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Ip-Forwarding'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Nsg-GW-subnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/35f9c03a-cc27-418e-9c0c-539ff999d010'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Nsg-GW-subnet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-vNic-Pip'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-vNic-Pip'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-SQL'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-SQL.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Dine-Sql-Adv-Data'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6134c3db-786f-471e-87bc-8f479dc890f6'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Dine-Sql-Adv-Data'].parameters
				definitionGroups: []
			}
		]
	}
]


// Policy Set/Initiative Definition Parameter Variables

var varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Audit-UnusedResourcesCostOptimization.parameters.json')

var varPolicySetDefinitionEsMgDenyActionDeleteProtectionParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_DenyAction-DeleteProtection.parameters.json')

var varPolicySetDefinitionEsMgEnforceALZDecommParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Decomm.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-CosmosDb.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Network.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-SQL.parameters.json')

// Customer Usage Attribution Id
var varCuaid = '2b136786-9881-412e-84ba-f4c2822e1ac9'

resource resPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2023-04-01' = [for policy in varCustomPolicyDefinitionsArray: {
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

resource resPolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = [for policySet in varCustomPolicySetDefinitionsArray: {
  dependsOn: [
    resPolicyDefinitions // Must wait for policy definitions to be deployed before starting the creation of Policy Set/Initiative Definitions
  ]
  name: policySet.libSetDefinition.name
  properties: {
    description: policySet.libSetDefinition.properties.description
    displayName: policySet.libSetDefinition.properties.displayName
    metadata: policySet.libSetDefinition.properties.metadata
    //parameters: policySet.libSetDefinition.properties.parameters
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
