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
    name: 'Append-AppService-httpsonly'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-AppService-httpsonly.json')
  }
  {
    name: 'Append-AppService-latestTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-AppService-latestTLS.json')
  }
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-KV-SoftDelete.json')
  }
  {
    name: 'Append-Redis-disableNonSslPort'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Append-Redis-disableNonSslPort.json')
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
    name: 'Audit-Disks-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-Disks-UnusedResourcesCostOptimization.json')
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
    name: 'Audit-PublicIpAddresses-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-PublicIpAddresses-UnusedResourcesCostOptimization.json')
  }
  {
    name: 'Audit-ServerFarms-UnusedResourcesCostOptimization'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Audit-ServerFarms-UnusedResourcesCostOptimization.json')
  }
  {
    name: 'Deny-AA-child-resources'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AA-child-resources.json')
  }
  {
    name: 'Deny-APIM-TLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-APIM-TLS.json')
  }
  {
    name: 'Deny-AppGw-Without-Tls'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppGw-Without-Tls.json')
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppGW-Without-WAF.json')
  }
  {
    name: 'Deny-AppService-without-BYOC'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppService-without-BYOC.json')
  }
  {
    name: 'Deny-AppServiceApiApp-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppServiceApiApp-http.json')
  }
  {
    name: 'Deny-AppServiceFunctionApp-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppServiceFunctionApp-http.json')
  }
  {
    name: 'Deny-AppServiceWebApp-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-AppServiceWebApp-http.json')
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
    name: 'Deny-EH-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-EH-minTLS.json')
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
    name: 'Deny-LogicApps-Without-Https'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-LogicApps-Without-Https.json')
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
    name: 'Deny-MgmtPorts-From-Internet'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MgmtPorts-From-Internet.json')
  }
  {
    name: 'Deny-MySql-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-MySql-http.json')
  }
  {
    name: 'Deny-PostgreSql-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-PostgreSql-http.json')
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
    name: 'Deny-Redis-http'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Redis-http.json')
  }
  {
    name: 'Deny-Service-Endpoints'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Service-Endpoints.json')
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
    name: 'Deny-Storage-ContainerDeleteRetentionPolicy'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-ContainerDeleteRetentionPolicy.json')
  }
  {
    name: 'Deny-Storage-CopyScope'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-CopyScope.json')
  }
  {
    name: 'Deny-Storage-CorsRules'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-CorsRules.json')
  }
  {
    name: 'Deny-Storage-LocalUser'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-LocalUser.json')
  }
  {
    name: 'Deny-Storage-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-minTLS.json')
  }
  {
    name: 'Deny-Storage-NetworkAclsBypass'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-NetworkAclsBypass.json')
  }
  {
    name: 'Deny-Storage-NetworkAclsVirtualNetworkRules'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-NetworkAclsVirtualNetworkRules.json')
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
    name: 'Deny-Storage-ServicesEncryption'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-ServicesEncryption.json')
  }
  {
    name: 'Deny-Storage-SFTP'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Storage-SFTP.json')
  }
  {
    name: 'Deny-StorageAccount-CustomDomain'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-StorageAccount-CustomDomain.json')
  }
  {
    name: 'Deny-Subnet-Without-Nsg'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Subnet-Without-Nsg.json')
  }
  {
    name: 'Deny-Subnet-Without-Penp'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Subnet-Without-Penp.json')
  }
  {
    name: 'Deny-Subnet-Without-Udr'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-Subnet-Without-Udr.json')
  }
  {
    name: 'Deny-UDR-With-Specific-NextHop'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-UDR-With-Specific-NextHop.json')
  }
  {
    name: 'Deny-VNET-Peer-Cross-Sub'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deny-VNET-Peer-Cross-Sub.json')
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
    name: 'Deploy-MySQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-MySQL-sslEnforcement.json')
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
    name: 'Deploy-PostgreSQL-sslEnforcement'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-PostgreSQL-sslEnforcement.json')
  }
  {
    name: 'Deploy-Private-DNS-Generic'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Private-DNS-Generic.json')
  }
  {
    name: 'Deploy-Sql-AuditingSettings'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Sql-AuditingSettings.json')
  }
  {
    name: 'Deploy-SQL-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-SQL-minTLS.json')
  }
  {
    name: 'Deploy-Sql-SecurityAlertPolicies'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Sql-SecurityAlertPolicies.json')
  }
  {
    name: 'Deploy-Sql-Tde'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Sql-Tde.json')
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments_20230706'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Sql-vulnerabilityAssessments_20230706.json')
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Sql-vulnerabilityAssessments.json')
  }
  {
    name: 'Deploy-SqlMi-minTLS'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-SqlMi-minTLS.json')
  }
  {
    name: 'Deploy-Storage-sslEnforcement'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Deploy-Storage-sslEnforcement.json')
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
  {
    name: 'Modify-NSG'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Modify-NSG.json')
  }
  {
    name: 'Modify-UDR'
    libDefinition: loadJsonContent('lib/usgovernment/policy_definitions/policy_definition_es_mg_Modify-UDR.json')
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Definitions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_set_definitions\_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
	{
		name: 'Audit-TrustedLaunch'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Audit-TrustedLaunch.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'AuditDisksOsTrustedLaunch'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b03bb370-5249-4ea4-9fce-2552e87e45fa'
				definitionParameters: varPolicySetDefinitionEsMgAuditTrustedLaunchParameters.AuditDisksOsTrustedLaunch.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AuditTrustedLaunchEnabled'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c95b54ad-0614-4633-ab29-104b01235cbf'
				definitionParameters: varPolicySetDefinitionEsMgAuditTrustedLaunchParameters.AuditTrustedLaunchEnabled.parameters
				definitionGroups: []
			}
		]
	}
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
			{
				definitionReferenceId: 'AuditDisksUnusedResourcesCostOptimization'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-Disks-UnusedResourcesCostOptimization'
				definitionParameters: varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters.AuditDisksUnusedResourcesCostOptimization.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AuditPublicIpAddressesUnusedResourcesCostOptimization'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-PublicIpAddresses-UnusedResourcesCostOptimization'
				definitionParameters: varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters.AuditPublicIpAddressesUnusedResourcesCostOptimization.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AuditServerFarmsUnusedResourcesCostOptimization'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-ServerFarms-UnusedResourcesCostOptimization'
				definitionParameters: varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters.AuditServerFarmsUnusedResourcesCostOptimization.parameters
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
		name: 'Deploy-Sql-Security_20240529'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Deploy-Sql-Security_20240529.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'SqlDbAuditingSettingsDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurity_20240529Parameters.SqlDbAuditingSettingsDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurity_20240529Parameters.SqlDbSecurityAlertPoliciesDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbTdeDeploySqlSecurity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurity_20240529Parameters.SqlDbTdeDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments_20230706'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurity_20240529Parameters.SqlDbVulnerabilityAssessmentsDeploySqlSecurity.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Deploy-Sql-Security'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Deploy-Sql-Security.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'SqlDbAuditingSettingsDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurityParameters.SqlDbAuditingSettingsDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurityParameters.SqlDbSecurityAlertPoliciesDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbTdeDeploySqlSecurity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurityParameters.SqlDbTdeDeploySqlSecurity.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments'
				definitionParameters: varPolicySetDefinitionEsMgDeploySqlSecurityParameters.SqlDbVulnerabilityAssessmentsDeploySqlSecurity.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-ALZ-Decomm'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Decomm.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'DecomDenyResources'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceALZDecommParameters.DecomDenyResources.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DecomShutdownMachines'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Vm-autoShutdown'
				definitionParameters: varPolicySetDefinitionEsMgEnforceALZDecommParameters.DecomShutdownMachines.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-ALZ-Sandbox'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Sandbox.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'SandboxDenyVnetPeering'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-VNET-Peer-Cross-Sub'
				definitionParameters: varPolicySetDefinitionEsMgEnforceALZSandboxParameters.SandboxDenyVnetPeering.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SandboxNotAllowed'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
				definitionParameters: varPolicySetDefinitionEsMgEnforceALZSandboxParameters.SandboxNotAllowed.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Backup'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Backup.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'BackupBVault-Immutability'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2514263b-bc0d-4b06-ac3e-f262c0979018'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupBVault-Immutability'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'BackupBVault-MUA'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c58e083e-7982-4e24-afdc-be14d312389e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupBVault-MUA'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'BackupBVault-SoftDelete'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9798d31d-6028-4dee-8643-46102185c016'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupBVault-SoftDelete'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'BackupRVault-Immutability'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d6f6f560-14b7-49a4-9fc8-d2c3a9807868'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupRVault-Immutability'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'BackupRVault-MUA'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c7031eab-0fc0-4cd9-acd0-4497bd66d91a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupRVault-MUA'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'BackupRVault-SoftDelete'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/31b8092a-36b8-434b-9af7-5ec844364148'
				definitionParameters: varPolicySetDefinitionEsMgEnforceBackupParameters['BackupRVault-SoftDelete'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-EncryptTransit_20240509'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-EncryptTransit_20240509.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.AKSIngressHttpsOnlyEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'APIAppServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.APIAppServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AppServiceHttpEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.AppServiceHttpEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AppServiceminTlsVersion'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.AppServiceminTlsVersion.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'ContainerAppsHttpsOnlyEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0e80e269-43a4-4ae9-b5bc-178126b8a5cb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.ContainerAppsHttpsOnlyEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Apps-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a4af4a39-4135-47fb-b175-47fbdf85311d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-AppService-Apps-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Slots-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ae1b9a8c-dfce-4605-bd91-69213b4a26fc'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-AppService-Slots-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d6545c6b-dd9d-4265-91e6-0b451e2f1c50'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-AppService-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerApps-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0e80e269-43a4-4ae9-b5bc-178126b8a5cb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-ContainerApps-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-EH-minTLS'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-EH-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-EH-minTLS'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FuncAppSlots-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e5dbe3f-2702-4ffc-8b1e-0cae008a5c71'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-FuncAppSlots-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FunctionApp-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6d555dd1-86f2-4f1c-8ed7-5abae7c6cbab'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-FunctionApp-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-LogicApp-Without-Https'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-LogicApps-Without-Https'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-LogicApp-Without-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Sql-Db-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/32e6bbec-16b6-44c2-be37-c5b672d103cf'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-Sql-Db-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Sql-Managed-Tls-Version'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8793640-60f7-487c-b5c3-1d37215905c4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-Sql-Managed-Tls-Version'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-Storage-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Synapse-Tls-Version'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/cb3738a6-82a2-4a18-b87b-15217b9deff4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deny-Synapse-Tls-Version'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deploy-LogicApp-TLS'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-LogicApp-TLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Deploy-LogicApp-TLS'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-AppService-Apps-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ae44c1d1-0df2-4ca9-98fa-a3d3ae5b409d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Dine-AppService-Apps-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DINE-AppService-AppSlotTls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/014664e7-e348-41a3-aeb9-566e4ff6a9df'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['DINE-AppService-AppSlotTls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Function-Apps-Slots-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fa3a6357-c6d6-4120-8429-855577ec0063'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Dine-Function-Apps-Slots-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-FunctionApp-Tls'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f01f1c7-539c-49b5-9ef4-d4ffa37d22e0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters['Dine-FunctionApp-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'FunctionLatestTlsEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.FunctionLatestTlsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'FunctionServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.FunctionServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'MySQLEnableSSLDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.MySQLEnableSSLDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'MySQLEnableSSLEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.MySQLEnableSSLEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.PostgreSQLEnableSSLDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'PostgreSQLEnableSSLEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.PostgreSQLEnableSSLEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisDenyhttps'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.RedisDenyhttps.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisdisableNonSslPort'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.RedisdisableNonSslPort.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.RedisTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.SQLManagedInstanceTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLManagedInstanceTLSEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.SQLManagedInstanceTLSEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLServerTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.SQLServerTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLServerTLSEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.SQLServerTLSEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.StorageDeployHttpsEnabledEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'WebAppServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.WebAppServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'WebAppServiceLatestTlsEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters.WebAppServiceLatestTlsEffect.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-EncryptTransit'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-EncryptTransit.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.AKSIngressHttpsOnlyEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'APIAppServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.APIAppServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AppServiceHttpEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.AppServiceHttpEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'AppServiceminTlsVersion'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.AppServiceminTlsVersion.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'ContainerAppsHttpsOnlyEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0e80e269-43a4-4ae9-b5bc-178126b8a5cb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.ContainerAppsHttpsOnlyEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'FunctionLatestTlsEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.FunctionLatestTlsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'FunctionServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.FunctionServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'MySQLEnableSSLDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.MySQLEnableSSLDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'MySQLEnableSSLEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.MySQLEnableSSLEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.PostgreSQLEnableSSLDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'PostgreSQLEnableSSLEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.PostgreSQLEnableSSLEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisDenyhttps'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.RedisDenyhttps.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisdisableNonSslPort'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.RedisdisableNonSslPort.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'RedisTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.RedisTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.SQLManagedInstanceTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLManagedInstanceTLSEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.SQLManagedInstanceTLSEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLServerTLSDeployEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.SQLServerTLSDeployEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'SQLServerTLSEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.SQLServerTLSEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.StorageDeployHttpsEnabledEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'StorageHttpsEnabledEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.StorageHttpsEnabledEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'WebAppServiceHttpsEffect'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.WebAppServiceHttpsEffect.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'WebAppServiceLatestTlsEffect'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceEncryptTransitParameters.WebAppServiceLatestTlsEffect.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-APIM'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-APIM.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Api-subscription-scope'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3aa03346-d8c5-4994-a5bc-7652c2a2aef1'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Api-subscription-scope'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Authn'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c15dcc82-b93c-4dcb-9332-fbf121685b54'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Authn'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Cert-Validation'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/92bb331d-ac71-416a-8c91-02f2cb734ce4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Cert-Validation'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Direct-Endpoint'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b741306c-968e-4b67-b916-5675e5c709f4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Direct-Endpoint'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Protocols'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ee7495e7-3ba7-40b6-bfee-c29e22cc75d4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Protocols'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Sku-Vnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/73ef9241-5d81-4cd4-b483-8443d1730fe5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Sku-Vnet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-APIM-TLS'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-APIM-TLS'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-APIM-TLS'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-Version'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/549814b6-3212-4203-bdc8-1548d342fb67'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-Version'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-without-Kv'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f1cc7827-022c-473e-836e-5a51cae0b249'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-without-Kv'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Apim-without-Vnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ef619a2c-cc4d-4d03-b2ba-8c94a834d85b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Deny-Apim-without-Vnet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Apim-Public-NetworkAccess'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7ca8c8ac-3a6e-493d-99ba-c5fa35347ff2'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters['Dine-Apim-Public-NetworkAccess'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-AppServices'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-AppServices.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-AppServ-FtpAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/572e342c-c920-4ef5-be2e-1ed3c6a51dc5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppServ-FtpAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppServ-Routing'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5747353b-1ca9-42c1-a4dd-b874b894f3d4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppServ-Routing'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppServ-SkuPl'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/546fe8d2-368d-4029-a418-6af48a7f61e5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppServ-SkuPl'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Byoc'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppService-without-BYOC'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppService-Byoc'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Latest-Version'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/eb4d34ab-0929-491c-bbf3-61e13da19f9a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppService-Latest-Version'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Rfc'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f5c0bfb3-acea-47b1-b477-b0edcdf6edc1'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppService-Rfc'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Slots-Remote-Debugging'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/cca5adfe-626b-4cc6-8522-f5b6ed2391bd'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppService-Slots-Remote-Debugging'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppService-Vnet-Routing'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/801543d1-1953-4a90-b8b0-8cf6d41473a5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppService-Vnet-Routing'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppServiceApps-Rfc'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a691eacb-474d-47e4-b287-b4813ca44222'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Deny-AppServiceApps-Rfc'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-AppService-Apps-Remote-Debugging'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a5e3fe8f-f6cd-4f1d-bbf6-c749754a724b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Dine-AppService-Apps-Remote-Debugging'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DINE-AppService-Debugging'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/25a5046c-c423-4805-9235-e844ae9ef49b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['DINE-AppService-Debugging'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DINE-AppService-LocalAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2c034a29-2a5f-4857-b120-f800fe5549ae'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['DINE-AppService-LocalAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DINE-AppService-ScmAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e97b776-f380-4722-a9a3-e7f0be029e79'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['DINE-AppService-ScmAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'DINE-FuncApp-Debugging'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/70adbb40-e092-42d5-a6f8-71c540a5efdb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['DINE-FuncApp-Debugging'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-AppService-App-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c6c3e00e-d414-4ca4-914f-406699bb8eee'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Modify-AppService-App-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-AppService-Apps-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2374605e-3e0b-492b-9046-229af202562c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Modify-AppService-Apps-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-AppService-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0f98368e-36bc-4716-8ac2-8f8067203b63'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Modify-AppService-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Function-Apps-Slots-Https'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/08cf2974-d178-48a0-b26d-f6b8e555748b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Modify-Function-Apps-Slots-Https'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Function-Apps-Slots-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/242222f3-4985-4e99-b5ef-086d6a6cb01c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters['Modify-Function-Apps-Slots-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Automation'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Automation.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Aa-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/48c5f1cb-14ad-4797-8e3b-f78ab3f8d700'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Deny-Aa-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aa-Managed-Identity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/dea83a72-443c-4292-83d5-54a2f98749c0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Deny-Aa-Managed-Identity'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aa-Variables-Encrypt'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3657f5a0-770e-44a3-b44e-9431ba1e9735'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Deny-Aa-Variables-Encrypt'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Windows-Vm-HotPatch'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6d02d2f7-e38b-4bdc-96f3-adc0a8726abc'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Deny-Windows-Vm-HotPatch'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Aa-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/30d1d58e-8f96-47a5-8564-499a3f3cca81'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Modify-Aa-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Aa-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/23b36a7c-9d26-4288-a8fd-c1d2fa284d8c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters['Modify-Aa-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-CognitiveServices'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-CognitiveServices.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-CognitiveSearch-SKU'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a049bf77-880b-470f-ba6d-9f21c530cf83'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters['Deny-CognitiveSearch-SKU'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-CongitiveSearch-LocalAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6300012e-e9a4-4649-b41f-a85f5c43be91'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters['Deny-CongitiveSearch-LocalAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Cognitive-Services-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/47ba1dd7-28d9-4b07-a8d5-9813bed64e0c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters['Modify-Cognitive-Services-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-CognitiveSearch-LocalAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4eb216f2-9dba-4979-86e6-5d7e63ce3b75'
				// This is misspelled upstream
				// cSpell:disable-next-line
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters['Modify-CogntiveSearch-LocalAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-CognitiveSearch-PublicEndpoint'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9cee519f-d9c1-4fd9-9f79-24ec3449ed30'
				// This is misspelled upstream
				// cSpell:disable-next-line
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters['Modify-CogntiveSearch-PublicEndpoint'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Compute'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Compute.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Disk-Double-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ca91455f-eace-4f96-be59-e6e2c35b4816'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsComputeParameters['Deny-Disk-Double-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-VmAndVmss-Encryption-Host'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fc4d8e41-e223-45ea-9bf5-eada37891d87'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsComputeParameters['Deny-VmAndVmss-Encryption-Host'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-ContainerApps'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerApps.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-ContainerApp-Vnet-Injection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8b346db6-85af-419b-8557-92cee2c0f9bb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerAppsParameters['Deny-ContainerApp-Vnet-Injection'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerApps-Managed-Identity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b874ab2d-72dd-47f1-8cb5-4a306478a4e7'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerAppsParameters['Deny-ContainerApps-Managed-Identity'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-ContainerInstance'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerInstance.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-ContainerInstance-Vnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8af8f826-edcb-4178-b35f-851ea6fea615'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerInstanceParameters['Deny-ContainerInstance-Vnet'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-ContainerRegistry'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerRegistry.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Anonymous-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9f2dea28-e834-476c-99c5-3507b4728395'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Anonymous-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Arm-Audience'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/42781ec6-6127-4c30-bdfa-fb423a0047d3'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Arm-Audience'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Exports'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/524b0254-c285-4903-bee6-bb8126cde579'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Exports'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/dc921057-6b28-4fbe-9b83-f7bec05db6c2'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Repo-Token'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ff05e24e-195c-447e-b322-5e90c9f9f366'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Repo-Token'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Sku-PrivateLink'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bd560fc0-3c69-498a-ae9f-aa8eb7de0e13'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Sku-PrivateLink'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ContainerRegistry-Unrestricted-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d0793b48-0edc-4296-a390-4c75d1bdfd71'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Deny-ContainerRegistry-Unrestricted-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ContainerRegistry-Anonymous-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/cced2946-b08a-44fe-9fd9-e4ed8a779897'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Modify-ContainerRegistry-Anonymous-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ContainerRegistry-Arm-Audience'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/785596ed-054f-41bc-aaec-7f3d0ba05725'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Modify-ContainerRegistry-Arm-Audience'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ContainerRegistry-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/79fdfe03-ffcb-4e55-b4d0-b925b8241759'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Modify-ContainerRegistry-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ContainerRegistry-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a3701552-92ea-433e-9d17-33b7f1208fc9'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Modify-ContainerRegistry-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ContainerRegistry-Repo-Token'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a9b426fe-8856-4945-8600-18c5dd1cca2a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters['Modify-ContainerRegistry-Repo-Token'].parameters
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
			{
				definitionReferenceId: 'Deny-CosmosDb-Fw-Rules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/862e97cf-49fc-4a5c-9de4-40d4e2e7c8eb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Deny-CosmosDb-Fw-Rules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-CosmosDb-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5450f5bd-9c72-4390-a9c4-a7aba4edfdd2'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Deny-CosmosDb-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-CosmosDb-Atp'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b5f04e03-92a3-4b09-9410-2cc5e5047656'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Dine-CosmosDb-Atp'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-CosmosDb-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/dc2d41d1-4ab1-4666-a3e1-3d51c43e0049'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Modify-CosmosDb-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-CosmosDb-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/da69ba51-aaf1-41e5-8651-607cd0b37088'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters['Modify-CosmosDb-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-DataExplorer'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-DataExplorer.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-ADX-Double-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ec068d99-e9c7-401f-8cef-5bdde4e6ccf1'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataExplorerParameters['Deny-ADX-Double-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ADX-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f4b53539-8df9-40e4-86c6-6b607703bd4e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataExplorerParameters['Deny-ADX-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ADX-Sku-without-PL-Support'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1fec9658-933f-4b3e-bc95-913ed22d012b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataExplorerParameters['Deny-ADX-Sku-without-PL-Support'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ADX-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7b32f193-cb28-4e15-9a98-b9556db0bafa'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataExplorerParameters['Modify-ADX-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-DataFactory'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-DataFactory.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Adf-Git'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/77d40665-3120-4348-b539-3192ec808307'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters['Deny-Adf-Git'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Adf-Linked-Service-Key-Vault'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/127ef6d7-242f-43b3-9eef-947faf1725d0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters['Deny-Adf-Linked-Service-Key-Vault'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Adf-Managed-Identity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f78ccdb4-7bf4-4106-8647-270491d2978a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters['Deny-Adf-Managed-Identity'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Adf-Sql-Integration'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0088bc63-6dee-4a9c-9d29-91cfdc848952'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters['Deny-Adf-Sql-Integration'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Adf-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/08b1442b-7789-4130-8506-4f99a97226a7'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters['Modify-Adf-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-EventGrid'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-EventGrid.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-EventGrid-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8bfadddb-ee1c-4639-8911-a38cb8e0b3bd'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Deny-EventGrid-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-EventGrid-Partner-Namespace-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8632b003-3545-4b29-85e6-b2b96773df1e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Deny-EventGrid-Partner-Namespace-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-EventGrid-Topic-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ae9fb87f-8a17-4428-94a4-8135d431055c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Deny-EventGrid-Topic-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EventGrid-Domain-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8ac2748f-3bf1-4c02-a3b6-92ae68cf75b1'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Modify-EventGrid-Domain-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EventGrid-Domain-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/898e9824-104c-4965-8e0e-5197588fa5d4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Modify-EventGrid-Domain-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EventGrid-Partner-Namespace-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2dd0e8b9-4289-4bb0-b813-1883298e9924'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Modify-EventGrid-Partner-Namespace-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EventGrid-Topic-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c8144d9-746a-4501-b08c-093c8d29ad04'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Modify-EventGrid-Topic-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EventGrid-Topic-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/36ea4b4b-0f7f-4a54-89fa-ab18f555a172'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters['Modify-EventGrid-Topic-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-EventHub'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-EventHub.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-EH-Auth-Rules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b278e460-7cfc-4451-8294-cccc40a940d7'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventHubParameters['Deny-EH-Auth-Rules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-EH-Double-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/836cd60e-87f3-4e6a-a27c-29d687f01a4c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventHubParameters['Deny-EH-Double-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-EH-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5d4e3c65-4873-47be-94f3-6f8b953a3598'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventHubParameters['Deny-EH-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-EH-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/57f35901-8389-40bb-ac49-3ba4f86d889d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsEventHubParameters['Modify-EH-Local-Auth'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-KeyVault-Sup'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-KeyVault-Sup.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Modify-KV-Fw'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01dc'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultSupParameters['Modify-KV-Fw'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-KV-PublicNetworkAccess'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/84d327c3-164a-4685-b453-900478614456'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultSupParameters['Modify-KV-PublicNetworkAccess'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-KeyVault'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-KeyVault.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-keyVaultManagedHsm-RSA-Keys-without-MinKeySize'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86810a98-8e91-4a44-8386-ec66d0de5d57'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-keyVaultManagedHsm-RSA-Keys-without-MinKeySize'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Cert-Expiration-Within-Specific-Number-Days'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f772fb64-8e40-40ad-87bc-7706e1949427'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Cert-Expiration-Within-Specific-Number-Days'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Cert-Period'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a075868-4c26-42ef-914c-5bc007359560'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Cert-Period'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Cryptographic-Type'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/75c4f823-d65c-4f29-a733-01d0077fdbcb'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Cryptographic-Type'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Curve-Names'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ff25f3c8-b739-4538-9d07-3d6d25cfb255'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Curve-Names'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Elliptic-Curve'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bd78111f-4953-4367-9fd5-7e08808b54bf'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Elliptic-Curve'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Hms-Key-Expire'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1d478a74-21ba-4b9f-9d8f-8e6fced0eec5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Hms-Key-Expire'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Hms-PurgeProtection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c39ba22d-4428-4149-b981-70acb31fc383'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Hms-PurgeProtection'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Hsm-Curve-Names'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e58fd0c1-feac-4d12-92db-0a7e9421f53e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Hsm-Curve-Names'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Hsm-MinimumDays-Before-Expiration'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ad27588c-0198-4c84-81ef-08efd0274653'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Hsm-MinimumDays-Before-Expiration'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Integrated-Ca'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e826246-c976-48f6-b03e-619bb92b3d82'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Integrated-Ca'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Key-Active'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c26e4b24-cf98-4c67-b48b-5a25c4c69eb9'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Key-Active'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Key-Types'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1151cede-290b-4ba0-8b38-0ad145ac888f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Key-Types'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Keys-Expire'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/49a22571-d204-4c91-a7b6-09b1a586fbc9'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Keys-Expire'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Non-Integrated-Ca'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a22f4a40-01d3-4c7d-8071-da157eeff341'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Non-Integrated-Ca'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-RSA-Keys-without-MinCertSize'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/cee51871-e572-4576-855c-047c820360f0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-RSA-Keys-without-MinCertSize'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-RSA-Keys-without-MinKeySize'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/82067dbb-e53b-4e06-b631-546d197452d9'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-RSA-Keys-without-MinKeySize'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Secret-ActiveDays'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e8d99835-8a06-45ae-a8e0-87a91941ccfe'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Secret-ActiveDays'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Kv-Secret-Content-Type'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/75262d3e-ba4a-4f43-85f8-9f72c090e5e3'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-Kv-Secret-Content-Type'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-Secrets-ValidityDays'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/342e8053-e12e-4c44-be01-c3c2f318400f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-Secrets-ValidityDays'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-KV-without-ArmRbac'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/12d4fa5e-1f9f-4c21-97a9-b99b3c6611b5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters['Deny-KV-without-ArmRbac'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvCertLifetime'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/12ef42cb-9903-4e39-9c26-422d29570417'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvCertLifetime.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvFirewallEnabled'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvFirewallEnabled.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvKeysExpire'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvKeysExpire.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvKeysLifetime'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5ff38825-c5d8-47c5-b70e-069a21955146'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvKeysLifetime.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvPurgeProtection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvPurgeProtection.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvSecretsExpire'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98728c90-32c7-4049-8429-847dc0f4fe37'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvSecretsExpire.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvSecretsLifetime'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b0eb591a-5e70-4534-a8bf-04b9c489584a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvSecretsLifetime.parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'KvSoftDelete'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters.KvSoftDelete.parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Kubernetes'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Kubernetes.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Aks-Allowed-Capabilities'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c26596ff-4d70-4e6a-9a30-c2506bd2f80c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Allowed-Capabilities'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Cni'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/46238e2f-3f6f-4589-9f3f-77bed4116e67'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Cni'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Default-Namespace'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/9f061a12-e40d-4183-a00e-171812443373'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Default-Namespace'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Internal-Lb'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Internal-Lb'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Kms'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/dbbdc317-9734-4dd8-9074-993b29c69008'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Kms'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/993c2fcd-2b29-49d2-9eb0-df2c3a730c32'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Naked-Pods'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/65280eef-c8b4-425e-9aec-af55e55bf581'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Naked-Pods'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Priv-Containers'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Priv-Containers'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Priv-Escalation'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Priv-Escalation'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Private-Cluster'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Private-Cluster'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-ReadinessOrLiveness-Probes'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b1a9997f-2883-4f12-bdff-2280f99b5915'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-ReadinessOrLiveness-Probes'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Shared-Host-Process-Namespace'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Shared-Host-Process-Namespace'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Temp-Disk-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/41425d9f-d1a5-499a-9932-f8ed8453932c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Temp-Disk-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Aks-Windows-Container-Administrator'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5485eac0-7e8f-4964-998b-a44f4f0c1e75'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Deny-Aks-Windows-Container-Administrator'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Aks-Command-Invoke'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1b708b0a-3380-40e9-8b79-821f9fa224cc'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Dine-Aks-Command-Invoke'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Aks-Policy'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters['Dine-Aks-Policy'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-MachineLearning'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-MachineLearning.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-ML-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e96a9a5f-07ca-471b-9bc5-6a0f33cbd68f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters['Deny-ML-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ML-Outdated-Os'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f110a506-2dcb-422e-bcea-d533fc8c35e2'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters['Deny-ML-Outdated-Os'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-ML-User-Assigned-Identity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5f0c7d88-c7de-45b8-ac49-db49e72eaa78'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters['Deny-ML-User-Assigned-Identity'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ML-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a6f9a2d0-cff7-4855-83ad-4cd750666512'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters['Modify-ML-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-ML-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a10ee784-7409-4941-b091-663697637c0f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters['Modify-ML-Public-Network-Access'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-MySQL'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-MySQL.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-MySql-Infra-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3a58212a-c829-4f13-9872-6371df2fd0b4'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMySQLParameters['Deny-MySql-Infra-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-MySql-Adv-Threat-Protection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/80ed5239-4122-41ed-b54a-6f1fa7552816'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsMySQLParameters['Dine-MySql-Adv-Threat-Protection'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Network'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Network.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-AppGw-Without-Tls'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppGw-Without-Tls'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-AppGw-Without-Tls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-AppGw-Without-Waf'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-AppGw-Without-Waf'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FW-AllIDPSS'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/610b6183-5f00-4d68-86d2-4ab4cb3a67a5'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-FW-AllIDPSS'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FW-EmpIDPSBypass'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f516dc7a-4543-4d40-aad6-98f76a706b50'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-FW-EmpIDPSBypass'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FW-TLS-AllApp'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a58ac66d-92cb-409c-94b8-8e48d7a96596'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-FW-TLS-AllApp'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-FW-TLS-Inspection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/711c24bb-7f18-4578-b192-81a6161e1f17'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-FW-TLS-Inspection'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Ip-Forwarding'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Ip-Forwarding'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Mgmt-From-Internet'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MgmtPorts-From-Internet'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Mgmt-From-Internet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Nsg-GW-subnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/35f9c03a-cc27-418e-9c0c-539ff999d010'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Nsg-GW-subnet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Subnet-with-Service-Endpoints'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Service-Endpoints'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Subnet-with-Service-Endpoints'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Subnet-Without-NSG'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Subnet-Without-NSG'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Subnet-Without-Udr'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Udr'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Subnet-Without-Udr'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-vNic-Pip'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-vNic-Pip'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-VPN-AzureAD'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/21a6bc25-125e-4d13-b82d-2e19b7208ab7'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-VPN-AzureAD'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Waf-Afd-Enabled'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/055aa869-bc98-4af8-bafc-23f1ab6ffe2c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Waf-Afd-Enabled'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Waf-AppGw-mode'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/12430be1-6cc8-4527-a9a8-e3d38f250096'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Waf-AppGw-mode'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Waf-Fw-rules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/632d3993-e2c0-44ea-a7db-2eca131f356d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Waf-Fw-rules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Waf-IDPS'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6484db87-a62d-4327-9f07-80a2cbdf333a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Waf-IDPS'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Waf-mode'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/425bea59-a659-4cbb-8d31-34499bd030b8'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Deny-Waf-mode'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Nsg'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Modify-NSG'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Modify-Nsg'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Udr'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Modify-UDR'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Modify-Udr'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-vNet-DDoS'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters['Modify-vNet-DDoS'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-OpenAI'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-OpenAI.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Cognitive-Services-Cust-Storage'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/46aa9b05-0e60-4eae-a88b-1e9d374fa515'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Deny-Cognitive-Services-Cust-Storage'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Cognitive-Services-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/71ef260a-8f18-47b7-abcb-62d0673d94dc'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Deny-Cognitive-Services-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Cognitive-Services-Managed-Identity'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fe3fd216-4f83-4fc1-8984-2bbec80a3418'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Deny-Cognitive-Services-Managed-Identity'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-OpenAi-NetworkAcls'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-CognitiveServices-NetworkAcls'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Deny-OpenAi-NetworkAcls'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-OpenAi-OutboundNetworkAccess'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-CognitiveServices-RestrictOutboundNetworkAccess'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Deny-OpenAi-OutboundNetworkAccess'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Cognitive-Services-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/14de9e63-1b31-492e-a5a3-c3f7fd57f555'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters['Modify-Cognitive-Services-Local-Auth'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-PostgreSQL'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-PostgreSQL.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Dine-PostgreSql-Adv-Threat-Protection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/db048e65-913c-49f9-bb5f-1084184671d3'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsPostgreSQLParameters['Dine-PostgreSql-Adv-Threat-Protection'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-ServiceBus'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ServiceBus.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Sb-Authz-Rules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a1817ec0-a368-432a-8057-8371e17ac6ee'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsServiceBusParameters['Deny-Sb-Authz-Rules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Sb-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ebaf4f25-a4e8-415f-86a8-42d9155bef0b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsServiceBusParameters['Deny-Sb-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Sb-LocalAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/cfb11c26-f069-4c14-8e36-56c394dae5af'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsServiceBusParameters['Deny-Sb-LocalAuth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Sb-LocalAuth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/910711a6-8aa2-4f15-ae62-1e5b2ed3ef9e'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsServiceBusParameters['Modify-Sb-LocalAuth'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-SQL'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-SQL.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Sql-Aad-Only'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/abda6d70-9778-44e7-84a8-06713e6db027'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Deny-Sql-Aad-Only'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Sql-Managed-Aad-Only'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/78215662-041e-49ed-a9dd-5385911b3a1f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Deny-Sql-Managed-Aad-Only'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Sql-Adv-Data'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6134c3db-786f-471e-87bc-8f479dc890f6'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Dine-Sql-Adv-Data'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Sql-Managed-Defender'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c5a62eb0-c65a-4220-8a4d-f70dd4ca95dd'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Dine-Sql-Managed-Defender'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Sql-PublicNetworkAccess'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/28b0b1e5-17ba-4963-a7a4-5a1ab4400a0b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters['Modify-Sql-PublicNetworkAccess'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Storage'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Storage.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Storage-Account-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bfecdea6-31c4-4045-ad42-71b9dc87247d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Account-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Account-Keys-Expire'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/044985bb-afe1-42cd-8a36-9d5d42424537'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Account-Keys-Expire'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Classic'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/37e0d2fe-28a5-43d6-a273-67d37d1f5606'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Classic'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-ContainerDeleteRetentionPolicy'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-ContainerDeleteRetentionPolicy'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-ContainerDeleteRetentionPolicy'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-CopyScope'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-CopyScope'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-CopyScope'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-CorsRules'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-CorsRules'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-CorsRules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Cross-Tenant'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/92a89a79-6c52-4a7e-a03f-61306fc49312'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Cross-Tenant'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Infra-Encryption'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4733ea7b-a883-42fe-8cac-97454c2a9e4a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Infra-Encryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-LocalUser'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-LocalUser'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-LocalUser'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-NetworkAclsBypass'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-NetworkAclsBypass'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-NetworkAclsBypass'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-NetworkAclsVirtualNetworkRules'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-NetworkAclsVirtualNetworkRules'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-NetworkAclsVirtualNetworkRules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-NetworkRules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-NetworkRules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-ResourceAccessRulesResourceId'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-ResourceAccessRulesResourceId'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-ResourceAccessRulesResourceId'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-ResourceAccessRulesTenantId'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-ResourceAccessRulesTenantId'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-ResourceAccessRulesTenantId'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Restrict-NetworkRules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Restrict-NetworkRules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-ServicesEncryption'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-ServicesEncryption'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-ServicesEncryption'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-SFTP'
				definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-SFTP'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-SFTP'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Storage-Shared-Key'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8c6a50c6-9ffd-4ae7-986f-5fa6111f9a54'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Deny-Storage-Shared-Key'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Storage-Threat-Protection'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/361c2074-3595-4e5d-8cab-4f21dffc835c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Dine-Storage-Threat-Protection'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Blob-Storage-Account-PublicEndpoint'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/13502221-8df0-4414-9937-de9c5c4e396b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Modify-Blob-Storage-Account-PublicEndpoint'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Storage-Account-PublicEndpoint'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a06d0189-92e8-4dba-b0c4-08d7669fce7d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Modify-Storage-Account-PublicEndpoint'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Storage-FileSync-PublicEndpoint'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0e07b2e9-6cd9-4c40-9ccb-52817b95133b'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters['Modify-Storage-FileSync-PublicEndpoint'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-Synapse'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Synapse.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Deny-Synapse-Data-Traffic'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3484ce98-c0c5-4c83-994b-c5ac24785218'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Deny-Synapse-Data-Traffic'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Synapse-Fw-Rules'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/56fd377d-098c-4f02-8406-81eb055902b8'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Deny-Synapse-Fw-Rules'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Synapse-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2158ddbe-fefa-408e-b43f-d4faef8ff3b8'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Deny-Synapse-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Synapse-Managed-Vnet'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2d9dbfa3-927b-4cf0-9d0f-08747f971650'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Deny-Synapse-Managed-Vnet'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Deny-Synapse-Tenant-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/3a003702-13d2-4679-941b-937e58c443f0'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Deny-Synapse-Tenant-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Dine-Synapse-Defender'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/951c1558-50a5-4ca3-abb6-a93e3e2367a6'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Dine-Synapse-Defender'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Synapse-Local-Auth'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c3624673-d2ff-48e0-b28c-5de1c6767c3c'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Modify-Synapse-Local-Auth'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Synapse-Public-Network-Access'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5c8cad01-ef30-4891-b230-652dadb4876a'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Modify-Synapse-Public-Network-Access'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Synapse-Tls-Version'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8b5c654c-fb07-471b-aa8f-15fea733f140'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters['Modify-Synapse-Tls-Version'].parameters
				definitionGroups: []
			}
		]
	}
	{
		name: 'Enforce-Guardrails-VirtualDesktop'
		libSetDefinition: loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-VirtualDesktop.json')
		libSetChildDefinitions: [
			{
				definitionReferenceId: 'Modify-Hostpool-PublicNetworkAccess'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2a0913ff-51e7-47b8-97bb-ea17127f7c8d'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsVirtualDesktopParameters['Modify-Hostpool-PublicNetworkAccess'].parameters
				definitionGroups: []
			}
			{
				definitionReferenceId: 'Modify-Workspace-PublicNetworkAccess'
				definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ce6ebf1d-0b94-4df9-9257-d8cacc238b4f'
				definitionParameters: varPolicySetDefinitionEsMgEnforceGuardrailsVirtualDesktopParameters['Modify-Workspace-PublicNetworkAccess'].parameters
				definitionGroups: []
			}
		]
	}
]


// Policy Set/Initiative Definition Parameter Variables

var varPolicySetDefinitionEsMgAuditTrustedLaunchParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Audit-TrustedLaunch.parameters.json')

var varPolicySetDefinitionEsMgAuditUnusedResourcesCostOptimizationParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Audit-UnusedResourcesCostOptimization.parameters.json')

var varPolicySetDefinitionEsMgDenyActionDeleteProtectionParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_DenyAction-DeleteProtection.parameters.json')

var varPolicySetDefinitionEsMgDeploySqlSecurity_20240529Parameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Deploy-Sql-Security_20240529.parameters.json')

var varPolicySetDefinitionEsMgDeploySqlSecurityParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Deploy-Sql-Security.parameters.json')

var varPolicySetDefinitionEsMgEnforceALZDecommParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Decomm.parameters.json')

var varPolicySetDefinitionEsMgEnforceALZSandboxParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-ALZ-Sandbox.parameters.json')

var varPolicySetDefinitionEsMgEnforceBackupParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Backup.parameters.json')

var varPolicySetDefinitionEsMgEnforceEncryptTransit_20240509Parameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-EncryptTransit_20240509.parameters.json')

var varPolicySetDefinitionEsMgEnforceEncryptTransitParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-EncryptTransit.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsAPIMParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-APIM.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsAppServicesParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-AppServices.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsAutomationParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Automation.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsCognitiveServicesParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-CognitiveServices.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsComputeParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Compute.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsContainerAppsParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerApps.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsContainerInstanceParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerInstance.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsContainerRegistryParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ContainerRegistry.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsCosmosDbParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-CosmosDb.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsDataExplorerParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-DataExplorer.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsDataFactoryParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-DataFactory.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsEventGridParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-EventGrid.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsEventHubParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-EventHub.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultSupParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-KeyVault-Sup.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsKeyVaultParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-KeyVault.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsKubernetesParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Kubernetes.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsMachineLearningParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-MachineLearning.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsMySQLParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-MySQL.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsNetworkParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Network.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsOpenAIParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-OpenAI.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsPostgreSQLParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-PostgreSQL.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsServiceBusParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-ServiceBus.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsSQLParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-SQL.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsStorageParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Storage.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsSynapseParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-Synapse.parameters.json')

var varPolicySetDefinitionEsMgEnforceGuardrailsVirtualDesktopParameters = loadJsonContent('lib/usgovernment/policy_set_definitions/policy_set_definition_es_mg_Enforce-Guardrails-VirtualDesktop.parameters.json')

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
