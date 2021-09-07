/*
SUMMARY: This module deploys the custom Azure Policy Definitions & Initiatives supplied by the Enterprise Scale conceptual architecture and reference implementation to a specified Management Group.
DESCRIPTION: This module deploys the custom Azure Policy Definitions & Initiatives supplied by the Enterprise Scale conceptual architecture and reference implementation defined here (https://aka.ms/enterprisescale) to a specified Management Group.
AUTHOR/S: jtracey93
VERSION: 1.0.0
*/

targetScope = 'managementGroup'

@description('The management group scope to which the policy definitions are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupId string = 'alz'

var varTargetManagementGroupResoruceID = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

// This variable contains a number of objects that load in the custom Azure Policy Defintions that are provided as part of the ESLZ/ALZ reference implementation
var varCustomPolicyDefinitionsArray = [
  {
    name: 'Append-AppService-httpsonly'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_append_appservice_httpsonly.json'))
  }
  {
    name: 'Append-AppService-latestTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_append_appservice_latesttls.json'))
  }
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_append_kv_softdelete.json'))
  }
  {
    name: 'Append-Redis-disableNonSslPort'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_append_redis_disablenonsslport.json'))
  }
  {
    name: 'Append-Redis-sslEnforcement'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_append_redis_sslenforcement.json'))
  }
  {
    name: 'Audit-MachineLearning-PrivateEndpointId'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_audit_machinelearning_privateendpointid.json'))
  }
  {
    name: 'Deny-AA-child-resources'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_aa_child_resources.json'))
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_appgw_without_waf.json'))
  }
  {
    name: 'Deny-AppServiceApiApp-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_appserviceapiapp_http.json'))
  }
  {
    name: 'Deny-AppServiceFunctionApp-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_appservicefunctionapp_http.json'))
  }
  {
    name: 'Deny-AppServiceWebApp-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_appservicewebapp_http.json'))
  }
  {
    name: 'Deny-Databricks-NoPublicIp'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_databricks_nopublicip.json'))
  }
  {
    name: 'Deny-Databricks-Sku'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_databricks_sku.json'))
  }
  {
    name: 'Deny-Databricks-VirtualNetwork'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_databricks_virtualnetwork.json'))
  }
  {
    name: 'Deny-MachineLearning-Aks'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_aks.json'))
  }
  {
    name: 'Deny-MachineLearning-Compute-SubnetId'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_compute_subnetid.json'))
  }
  {
    name: 'Deny-MachineLearning-Compute-VmSize'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_compute_vmsize.json'))
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-RemoteLoginPortPublicAccess'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_computecluster_remoteloginportpublicaccess.json'))
  }
  {
    name: 'Deny-MachineLearning-ComputeCluster-Scale'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_computecluster_scale.json'))
  }
  {
    name: 'Deny-MachineLearning-HbiWorkspace'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_hbiworkspace.json'))
  }
  {
    name: 'Deny-MachineLearning-PublicAccessWhenBehindVnet'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_machinelearning_publicaccesswhenbehindvnet.json'))
  }
  {
    name: 'Deny-MySql-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_mysql_http.json'))
  }
  {
    name: 'Deny-PostgreSql-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_postgresql_http.json'))
  }
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_private_dns_zones.json'))
  }
  {
    name: 'Deny-PublicEndpoint-MariaDB'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_publicendpoint_mariadb.json'))
  }
  {
    name: 'Deny-PublicIP'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_publicip.json'))
  }
  {
    name: 'Deny-RDP-From-Internet'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_rdp_from_internet.json'))
  }
  {
    name: 'Deny-Redis-http'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_redis_http.json'))
  }
  {
    name: 'Deny-Sql-minTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_sql_mintls.json'))
  }
  {
    name: 'Deny-SqlMi-minTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_sqlmi_mintls.json'))
  }
  {
    name: 'Deny-Storage-minTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_storage_mintls.json'))
  }
  {
    name: 'Deny-Subnet-Without-Nsg'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_subnet_without_nsg.json'))
  }
  {
    name: 'Deny-Subnet-Without-Udr'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_subnet_without_udr.json'))
  }
  {
    name: 'Deny-VNET-Peer-Cross-Sub'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_vnet_peer_cross_sub.json'))
  }
  {
    name: 'Deny-VNet-Peering'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deny_vnet_peering.json'))
  }
  {
    name: 'Deploy-ASC-Defender-ACR'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_acr.json'))
  }
  {
    name: 'Deploy-ASC-Defender-AKS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_aks.json'))
  }
  {
    name: 'Deploy-ASC-Defender-AKV'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_akv.json'))
  }
  {
    name: 'Deploy-ASC-Defender-AppSrv'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_appsrv.json'))
  }
  {
    name: 'Deploy-ASC-Defender-ARM'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_arm.json'))
  }
  {
    name: 'Deploy-ASC-Defender-DNS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_dns.json'))
  }
  {
    name: 'Deploy-ASC-Defender-SA'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_sa.json'))
  }
  {
    name: 'Deploy-ASC-Defender-Sql'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_sql.json'))
  }
  {
    name: 'Deploy-ASC-Defender-SQLVM'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_sqlvm.json'))
  }
  {
    name: 'Deploy-ASC-Defender-VMs'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_defender_vms.json'))
  }
  {
    name: 'Deploy-ASC-SecurityContacts'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_asc_securitycontacts.json'))
  }
  {
    name: 'Deploy-Budget'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_budget.json'))
  }
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_ddosprotection.json'))
  }
  {
    name: 'Deploy-Default-Udr'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_default_udr.json'))
  }
  {
    name: 'Deploy-Diagnostics-AA'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_aa.json'))
  }
  {
    name: 'Deploy-Diagnostics-ACI'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_aci.json'))
  }
  {
    name: 'Deploy-Diagnostics-ACR'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_acr.json'))
  }
  {
    name: 'Deploy-Diagnostics-AnalysisService'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_analysisservice.json'))
  }
  {
    name: 'Deploy-Diagnostics-ApiForFHIR'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_apiforfhir.json'))
  }
  {
    name: 'Deploy-Diagnostics-APIMgmt'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_apimgmt.json'))
  }
  {
    name: 'Deploy-Diagnostics-ApplicationGateway'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_applicationgateway.json'))
  }
  {
    name: 'Deploy-Diagnostics-CDNEndpoints'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_cdnendpoints.json'))
  }
  {
    name: 'Deploy-Diagnostics-CognitiveServices'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_cognitiveservices.json'))
  }
  {
    name: 'Deploy-Diagnostics-CosmosDB'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_cosmosdb.json'))
  }
  {
    name: 'Deploy-Diagnostics-Databricks'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_databricks.json'))
  }
  {
    name: 'Deploy-Diagnostics-DataExplorerCluster'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_dataexplorercluster.json'))
  }
  {
    name: 'Deploy-Diagnostics-DataFactory'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_datafactory.json'))
  }
  {
    name: 'Deploy-Diagnostics-DLAnalytics'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_dlanalytics.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridSub'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_eventgridsub.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridSystemTopic'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_eventgridsystemtopic.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridTopic'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_eventgridtopic.json'))
  }
  {
    name: 'Deploy-Diagnostics-ExpressRoute'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_expressroute.json'))
  }
  {
    name: 'Deploy-Diagnostics-Firewall'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_firewall.json'))
  }
  {
    name: 'Deploy-Diagnostics-FrontDoor'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_frontdoor.json'))
  }
  {
    name: 'Deploy-Diagnostics-Function'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_function.json'))
  }
  {
    name: 'Deploy-Diagnostics-HDInsight'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_hdinsight.json'))
  }
  {
    name: 'Deploy-Diagnostics-iotHub'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_iothub.json'))
  }
  {
    name: 'Deploy-Diagnostics-LoadBalancer'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_loadbalancer.json'))
  }
  {
    name: 'Deploy-Diagnostics-LogicAppsISE'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_logicappsise.json'))
  }
  {
    name: 'Deploy-Diagnostics-MariaDB'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_mariadb.json'))
  }
  {
    name: 'Deploy-Diagnostics-MediaService'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_mediaservice.json'))
  }
  {
    name: 'Deploy-Diagnostics-MlWorkspace'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_mlworkspace.json'))
  }
  {
    name: 'Deploy-Diagnostics-MySQL'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_mysql.json'))
  }
  {
    name: 'Deploy-Diagnostics-NetworkSecurityGroups'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_networksecuritygroups.json'))
  }
  {
    name: 'Deploy-Diagnostics-NIC'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_nic.json'))
  }
  {
    name: 'Deploy-Diagnostics-PostgreSQL'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_postgresql.json'))
  }
  {
    name: 'Deploy-Diagnostics-PowerBIEmbedded'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_powerbiembedded.json'))
  }
  {
    name: 'Deploy-Diagnostics-RedisCache'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_rediscache.json'))
  }
  {
    name: 'Deploy-Diagnostics-Relay'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_relay.json'))
  }
  {
    name: 'Deploy-Diagnostics-SignalR'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_signalr.json'))
  }
  {
    name: 'Deploy-Diagnostics-SQLElasticPools'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_sqlelasticpools.json'))
  }
  {
    name: 'Deploy-Diagnostics-SQLMI'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_sqlmi.json'))
  }
  {
    name: 'Deploy-Diagnostics-TimeSeriesInsights'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_timeseriesinsights.json'))
  }
  {
    name: 'Deploy-Diagnostics-TrafficManager'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_trafficmanager.json'))
  }
  {
    name: 'Deploy-Diagnostics-VirtualNetwork'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_virtualnetwork.json'))
  }
  {
    name: 'Deploy-Diagnostics-VM'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_vm.json'))
  }
  {
    name: 'Deploy-Diagnostics-VMSS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_vmss.json'))
  }
  {
    name: 'Deploy-Diagnostics-VNetGW'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_vnetgw.json'))
  }
  {
    name: 'Deploy-Diagnostics-WebServerFarm'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_webserverfarm.json'))
  }
  {
    name: 'Deploy-Diagnostics-Website'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_website.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDAppGroup'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_wvdappgroup.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDHostPools'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_wvdhostpools.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDWorkspace'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_diagnostics_wvdworkspace.json'))
  }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_firewallpolicy.json'))
  }
  {
    name: 'Deploy-MySQL-sslEnforcement'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_mysql_sslenforcement.json'))
  }
  {
    name: 'Deploy-Nsg-FlowLogs-to-LA'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_nsg_flowlogs_to_la.json'))
  }
  {
    name: 'Deploy-Nsg-FlowLogs'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_nsg_flowlogs.json'))
  }
  {
    name: 'Deploy-PostgreSQL-sslEnforcement'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_postgresql_sslenforcement.json'))
  }
  {
    name: 'Deploy-Sql-AuditingSettings'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sql_auditingsettings.json'))
  }
  {
    name: 'Deploy-SQL-minTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sql_mintls.json'))
  }
  {
    name: 'Deploy-Sql-SecurityAlertPolicies'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sql_securityalertpolicies.json'))
  }
  {
    name: 'Deploy-Sql-Tde'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sql_tde.json'))
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sql_vulnerabilityassessments.json'))
  }
  {
    name: 'Deploy-SqlMi-minTLS'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_sqlmi_mintls.json'))
  }
  {
    name: 'Deploy-Storage-sslEnforcement'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_storage_sslenforcement.json'))
  }
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_vnet_hubspoke.json'))
  }
  {
    name: 'Deploy-Windows-DomainJoin'
    libDefinition: json(loadTextContent('lib/policy_definitions/policy_definition_es_deploy_windows_domainjoin.json'))
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Defintions that are provided as part of the ESLZ/ALZ reference implementation
var varCustomPolicySetDefinitionsArray = [
  {
    name: 'Deny-PublicPaaSEndpoints'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_deny_publicpaasendpoints.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0fdf0491-d080-4575-b627-ad0e843cba0f'
      }
      {
        definitionReferenceId: 'AFSDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/21a8cd35-125e-4d13-b82d-2e19b7208bb7'
      }
      {
        definitionReferenceId: 'AKSDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
      }
      {
        definitionReferenceId: 'BatchDenyPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/74c5a0ae-5e48-4738-b093-65e23a060488'
      }
      {
        definitionReferenceId: 'CosmosDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/797b37f7-06b8-444c-b1ad-fc62867f335a'
      }
      {
        definitionReferenceId: 'KeyVaultDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/55615ac9-af46-4a59-874e-391cc3dfb490'
      }
      {
        definitionReferenceId: 'MySQLFlexDenyPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c9299215-ae47-4f50-9c54-8a392f68a052'
      }
      {
        definitionReferenceId: 'PostgreSQLFlexDenyPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/5e1de0e3-42cb-4ebc-a86d-61d0c619ca48'
      }
      {
        definitionReferenceId: 'SqlServerDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780'
      }
      {
        definitionReferenceId: 'StorageDenyPaasPublicIP'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c'
      }
    ]
  }
  {
    name: 'Deploy-ASC-Config'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_deploy_asc_config.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ascExport'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9'
      }
      {
        definitionReferenceId: 'defenderForAppServices'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-AppSrv'
      }
      {
        definitionReferenceId: 'defenderForArm'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-ARM'
      }
      {
        definitionReferenceId: 'defenderForContainerRegistry'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-ACR'
      }
      {
        definitionReferenceId: 'defenderForDns'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-DNS'
      }
      {
        definitionReferenceId: 'defenderForKeyVaults'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-AKV'
      }
      {
        definitionReferenceId: 'defenderForKubernetesService'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-AKS'
      }
      {
        definitionReferenceId: 'defenderForSqlServers'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-Sql'
      }
      {
        definitionReferenceId: 'defenderForSqlServerVirtualMachines'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-SQLVM'
      }
      {
        definitionReferenceId: 'defenderForStorageAccounts'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-SA'
      }
      {
        definitionReferenceId: 'defenderForVM'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-Defender-VMs'
      }
      {
        definitionReferenceId: 'securityEmailContact'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-SecurityContacts'
      }
    ]
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_deploy_diagnostics_loganalytics.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACIDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACI'
      }
      {
        definitionReferenceId: 'ACRDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACR'
      }
      {
        definitionReferenceId: 'AKSDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
      }
      {
        definitionReferenceId: 'AnalysisServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AnalysisService'
      }
      {
        definitionReferenceId: 'APIforFHIRDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApiForFHIR'
      }
      {
        definitionReferenceId: 'APIMgmtDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-APIMgmt'
      }
      {
        definitionReferenceId: 'ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApplicationGateway'
      }
      {
        definitionReferenceId: 'AppServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WebServerFarm'
      }
      {
        definitionReferenceId: 'AppServiceWebappDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Website'
      }
      {
        definitionReferenceId: 'AutomationDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA'
      }
      {
        definitionReferenceId: 'BatchDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c84e5349-db6d-4769-805e-e14037dab9b5'
      }
      {
        definitionReferenceId: 'CDNEndpointsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CDNEndpoints'
      }
      {
        definitionReferenceId: 'CognitiveServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CognitiveServices'
      }
      {
        definitionReferenceId: 'CosmosDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CosmosDB'
      }
      {
        definitionReferenceId: 'DatabricksDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Databricks'
      }
      {
        definitionReferenceId: 'DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataExplorerCluster'
      }
      {
        definitionReferenceId: 'DataFactoryDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataFactory'
      }
      {
        definitionReferenceId: 'DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DLAnalytics'
      }
      {
        definitionReferenceId: 'DataLakeStoreDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/d56a5a7c-72d7-42bc-8ceb-3baf4c0eae03'
      }
      {
        definitionReferenceId: 'EventGridSubDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSub'
      }
      {
        definitionReferenceId: 'EventGridTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridTopic'
      }
      {
        definitionReferenceId: 'EventHubDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1f6e93e8-6b31-41b1-83f6-36e449a42579'
      }
      {
        definitionReferenceId: 'EventSystemTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSystemTopic'
      }
      {
        definitionReferenceId: 'ExpressRouteDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ExpressRoute'
      }
      {
        definitionReferenceId: 'FirewallDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
      }
      {
        definitionReferenceId: 'FrontDoorDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-FrontDoor'
      }
      {
        definitionReferenceId: 'FunctionAppDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Function'
      }
      {
        definitionReferenceId: 'HDInsightDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-HDInsight'
      }
      {
        definitionReferenceId: 'IotHubDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-iotHub'
      }
      {
        definitionReferenceId: 'KeyVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47'
      }
      {
        definitionReferenceId: 'LoadBalancerDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LoadBalancer'
      }
      {
        definitionReferenceId: 'LogicAppsISEDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogicAppsISE'
      }
      {
        definitionReferenceId: 'LogicAppsWFDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b889a06c-ec72-4b03-910a-cb169ee18721'
      }
      {
        definitionReferenceId: 'MariaDBDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MariaDB'
      }
      {
        definitionReferenceId: 'MediaServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MediaService'
      }
      {
        definitionReferenceId: 'MlWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MlWorkspace'
      }
      {
        definitionReferenceId: 'MySQLDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MySQL'
      }
      {
        definitionReferenceId: 'NetworkNICDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NIC'
      }
      {
        definitionReferenceId: 'NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
      }
      {
        definitionReferenceId: 'NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NetworkSecurityGroups'
      }
      {
        definitionReferenceId: 'PostgreSQLDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PostgreSQL'
      }
      {
        definitionReferenceId: 'PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PowerBIEmbedded'
      }
      {
        definitionReferenceId: 'RecoveryVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3'
      }
      {
        definitionReferenceId: 'RedisCacheDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-RedisCache'
      }
      {
        definitionReferenceId: 'RelayDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Relay'
      }
      {
        definitionReferenceId: 'SearchServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/08ba64b8-738f-4918-9686-730d2ed79c7d'
      }
      {
        definitionReferenceId: 'ServiceBusDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/04d53d87-841c-4f23-8a5b-21564380b55e'
      }
      {
        definitionReferenceId: 'SignalRDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SignalR'
      }
      {
        definitionReferenceId: 'SQLDatabaseDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b79fa14e-238a-4c2d-b376-442ce508fc84'
      }
      {
        definitionReferenceId: 'SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLElasticPools'
      }
      {
        definitionReferenceId: 'SQLMDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLMI'
      }
      {
        definitionReferenceId: 'StorageAccountDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6f8f98a4-f108-47cb-8e98-91a0d85cd474'
      }
      {
        definitionReferenceId: 'StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/237e0f7e-b0e8-4ec4-ad46-8c12cb66d673'
      }
      {
        definitionReferenceId: 'TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TimeSeriesInsights'
      }
      {
        definitionReferenceId: 'TrafficManagerDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TrafficManager'
      }
      {
        definitionReferenceId: 'VirtualMachinesDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VM'
      }
      {
        definitionReferenceId: 'VirtualNetworkDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VirtualNetwork'
      }
      {
        definitionReferenceId: 'VMSSDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VMSS'
      }
      {
        definitionReferenceId: 'VNetGWDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VNetGW'
      }
      {
        definitionReferenceId: 'WVDAppGroupDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDAppGroup'
      }
      {
        definitionReferenceId: 'WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDHostPools'
      }
      {
        definitionReferenceId: 'WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDWorkspace'
      }
    ]
  }
  {
    name: 'Deploy-Private-DNS-Zones'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_deploy_private_dns_zones.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ACR'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e9585a95-5b8c-4d03-b193-dc7eb5ac4c32'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-App'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/7a860e27-9ca2-4fc6-822d-c2d248c300df'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-AppServices'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Batch'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/4ec38ebc-381f-45ee-81a4-acbc4be878f8'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveSearch'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/fbc14a67-53e4-4932-abcc-2049c6706009'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveServices'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DiskAccess'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/bc05b96c-0b36-4ca9-82f0-5c53f96ce05a'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridDomains'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/d389df0a-e0d7-4607-833c-75a6fdac2c2d'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridTopics'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/baf19753-7502-405f-8745-370519b20483'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventHubNamespace'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ed66d4f5-8220-45dc-ab4a-20d1749c74e6'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-File-Sync'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/06695360-db88-47f6-b976-7500d4297475'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoT'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/aaa64d2d-2fa3-45e5-b332-0b031b9b30e8'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoTHubs'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-KeyVault'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ac673a9a-f77d-4846-b2d8-a57f8e1c01d4'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MachineLearningWorkspace'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ee40564d-486e-4f68-a5ca-7a621edae0fb'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-RedisCache'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e016b22b-e0eb-436d-8fd7-160c4eaed6e2'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ServiceBusNamespace'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f0fcf93c-c063-4071-9668-c47474bd3564'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-SignalR'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b0e86710-7fb7-4a6c-a064-32e9b829509e'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Site-Recovery'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/942bd215-1a66-44be-af65-6a1c0318dbe2'
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Web'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0b026355-49cb-467b-8ac4-f777874e175a'
      }
    ]
  }
  {
    name: 'Deploy-Sql-Security'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_deploy_sql_security.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'SqlDbAuditingSettingsDeploySqlSecurity'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
      }
      {
        definitionReferenceId: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
      }
      {
        definitionReferenceId: 'SqlDbTdeDeploySqlSecurity'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-Tde'
      }
      {
        definitionReferenceId: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments'
      }
    ]
  }
  {
    name: 'Enforce-Encryption-CMK'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_enforce_encryption_cmk.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRCmkDeny'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580'
      }
      {
        definitionReferenceId: 'AksCmkDeny'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/7d7be79c-23ba-4033-84dd-45e2a5ccdd67'
      }
      {
        definitionReferenceId: 'AzureBatchCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/99e9ccd8-3db9-4592-b0d1-14b1715a4d8a'
      }
      {
        definitionReferenceId: 'CognitiveServicesCMK'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/67121cc7-ff39-4ab8-b7e3-95b84dab487d'
      }
      {
        definitionReferenceId: 'CosmosCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1f905d99-2ab7-462c-a6b0-f709acca6c8f'
      }
      {
        definitionReferenceId: 'DataBoxCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/86efb160-8de7-451d-bc08-5d475b0aadae'
      }
      {
        definitionReferenceId: 'EncryptedVMDisksEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
      }
      {
        definitionReferenceId: 'HealthcareAPIsCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/051cba44-2429-45b9-9649-46cec11c7119'
      }
      {
        definitionReferenceId: 'MySQLCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/83cef61d-dbd1-4b20-a4fc-5fbc7da10833'
      }
      {
        definitionReferenceId: 'PostgreSQLCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/18adea5e-f416-4d0f-8aa8-d24321e3e274'
      }
      {
        definitionReferenceId: 'SqlServerTDECMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0d134df8-db83-46fb-ad72-fe0c9428c8dd'
      }
      {
        definitionReferenceId: 'StorageCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25'
      }
      {
        definitionReferenceId: 'StreamAnalyticsCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/87ba29ef-1ab3-4d82-b763-87fcd4f531f7'
      }
      {
        definitionReferenceId: 'SynapseWorkspaceCMKEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f7d52b2d-e161-4dfa-a82b-55e564167385'
      }
      {
        definitionReferenceId: 'WorkspaceCMK'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ba769a63-b8cc-4b2d-abf6-ac33c7204be8'
      }
    ]
  }
  {
    name: 'Enforce-EncryptTransit'
    libDefinition: json(loadTextContent('lib/policy_set_definitions/policy_set_definition_es_enforce_encrypttransit.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
      }
      {
        definitionReferenceId: 'APIAppServiceHttpsEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
      }
      {
        definitionReferenceId: 'APIAppServiceLatestTlsEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/8cb6aa8b-9e41-4f4e-aa25-089a7ac2581e'
      }
      {
        definitionReferenceId: 'AppServiceHttpEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
      }
      {
        definitionReferenceId: 'AppServiceminTlsVersion'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
      }
      {
        definitionReferenceId: 'FunctionLatestTlsEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
      }
      {
        definitionReferenceId: 'FunctionServiceHttpsEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
      }
      {
        definitionReferenceId: 'MySQLEnableSSLDeployEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
      }
      {
        definitionReferenceId: 'MySQLEnableSSLEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
      }
      {
        definitionReferenceId: 'RedisDenyhttps'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
      }
      {
        definitionReferenceId: 'RedisdisableNonSslPort'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
      }
      {
        definitionReferenceId: 'RedisTLSDeployEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
      }
      {
        definitionReferenceId: 'SQLServerTLSDeployEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
      }
      {
        definitionReferenceId: 'SQLServerTLSEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
      }
      {
        definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
      }
      {
        definitionReferenceId: 'StorageHttpsEnabledEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
      }
      {
        definitionReferenceId: 'WebAppServiceHttpsEffect'
        definitionID: '${varTargetManagementGroupResoruceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
      }
      {
        definitionReferenceId: 'WebAppServiceLatestTlsEffect'
        definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
      }
    ]
  }
]

resource resPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2020-09-01' = [for policy in varCustomPolicyDefinitionsArray: {
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

resource resPolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = [for policySet in varCustomPolicySetDefinitionsArray: {
  dependsOn: [
    resPolicyDefinitions // Must wait for policy definitons to be deployed before starting the creation of Policy Set/Initiative Defininitions
  ]
  name: policySet.libDefinition.name
  properties: {
    description: policySet.libDefinition.properties.description
    displayName: policySet.libDefinition.properties.displayName
    metadata: policySet.libDefinition.properties.metadata
    parameters: policySet.libDefinition.properties.parameters
    policyType: policySet.libDefinition.properties.policyType
    policyDefinitions: [for policySetDef in policySet.libSetChildDefinitions: {
      policyDefinitionReferenceId: policySetDef.definitionReferenceId
      policyDefinitionId: '${varTargetManagementGroupResoruceID}${policySetDef.definitionID}'
    }]
    policyDefinitionGroups: policySet.libDefinition.properties.policyDefinitionGroups
  }
}]
