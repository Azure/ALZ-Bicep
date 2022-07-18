targetScope = 'managementGroup'

@description('The management group scope to which the policy definitions are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupId string = 'alz'

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varTargetManagementGroupResourceId = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupId)

// This variable contains a number of objects that load in the custom Azure Policy Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\china\policy_definitions\_mc_policyDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable. 
var varCustomPolicyDefinitionsArray = [
  {
    name: 'Append-AppService-httpsonly'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_append_appservice_httpsonly.json'))
  }
  {
    name: 'Append-AppService-latestTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_append_appservice_latesttls.json'))
  }
  {
    name: 'Append-KV-SoftDelete'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_append_kv_softdelete.json'))
  }
  {
    name: 'Append-Redis-disableNonSslPort'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_append_redis_disablenonsslport.json'))
  }
  {
    name: 'Append-Redis-sslEnforcement'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_append_redis_sslenforcement.json'))
  }
  {
    name: 'Deny-AFSPaasPublicIP'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_afspaaspublicip.json'))
  }
  {
    name: 'Deny-AppGW-Without-WAF'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_appgw_without_waf.json'))
  }
  {
    name: 'Deny-AppServiceApiApp-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_appserviceapiapp_http.json'))
  }
  {
    name: 'Deny-AppServiceFunctionApp-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_appservicefunctionapp_http.json'))
  }
  {
    name: 'Deny-AppServiceWebApp-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_appservicewebapp_http.json'))
  }
  {
    name: 'Deny-KeyVaultPaasPublicIP'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_keyvaultpaaspublicip.json'))
  }
  {
    name: 'Deny-MySql-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_mysql_http.json'))
  }
  {
    name: 'Deny-PostgreSql-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_postgresql_http.json'))
  }
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_private_dns_zones.json'))
  }
  {
    name: 'Deny-PublicEndpoint-MariaDB'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_publicendpoint_mariadb.json'))
  }
  {
    name: 'Deny-PublicIP'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_publicip.json'))
  }
  {
    name: 'Deny-RDP-From-Internet'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_rdp_from_internet.json'))
  }
  {
    name: 'Deny-Redis-http'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_redis_http.json'))
  }
  {
    name: 'Deny-Sql-minTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_sql_mintls.json'))
  }
  {
    name: 'Deny-SqlMi-minTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_sqlmi_mintls.json'))
  }
  {
    name: 'Deny-Storage-minTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_storage_mintls.json'))
  }
  {
    name: 'Deny-Subnet-Without-Nsg'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_subnet_without_nsg.json'))
  }
  {
    name: 'Deny-Subnet-Without-Udr'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_subnet_without_udr.json'))
  }
  {
    name: 'Deny-VNET-Peer-Cross-Sub'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_vnet_peer_cross_sub.json'))
  }
  {
    name: 'Deny-VNET-Peering-To-Non-Approved-VNETs'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_vnet_peering_to_non_approved_vnets.json'))
  }
  {
    name: 'Deny-VNet-Peering'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deny_vnet_peering.json'))
  }
  {
    name: 'Deploy-ActivityLogs-to-LA-workspace'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_activitylogs_to_la_workspace.json'))
  }
  {
    name: 'Deploy-ASC-SecurityContacts'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_asc_securitycontacts.json'))
  }
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_ddosprotection.json'))
  }
  {
    name: 'Deploy-Default-Udr'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_default_udr.json'))
  }
  {
    name: 'Deploy-Diagnostics-AA'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_aa.json'))
  }
  {
    name: 'Deploy-Diagnostics-ACI'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_aci.json'))
  }
  {
    name: 'Deploy-Diagnostics-ACR'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_acr.json'))
  }
  {
    name: 'Deploy-Diagnostics-AnalysisService'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_analysisservice.json'))
  }
  {
    name: 'Deploy-Diagnostics-ApiForFHIR'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_apiforfhir.json'))
  }
  {
    name: 'Deploy-Diagnostics-APIMgmt'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_apimgmt.json'))
  }
  {
    name: 'Deploy-Diagnostics-ApplicationGateway'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_applicationgateway.json'))
  }
  {
    name: 'Deploy-Diagnostics-Bastion'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_bastion.json'))
  }
  {
    name: 'Deploy-Diagnostics-CDNEndpoints'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_cdnendpoints.json'))
  }
  {
    name: 'Deploy-Diagnostics-CognitiveServices'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_cognitiveservices.json'))
  }
  {
    name: 'Deploy-Diagnostics-CosmosDB'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_cosmosdb.json'))
  }
  {
    name: 'Deploy-Diagnostics-Databricks'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_databricks.json'))
  }
  {
    name: 'Deploy-Diagnostics-DataExplorerCluster'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_dataexplorercluster.json'))
  }
  {
    name: 'Deploy-Diagnostics-DataFactory'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_datafactory.json'))
  }
  {
    name: 'Deploy-Diagnostics-DLAnalytics'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_dlanalytics.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridSub'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_eventgridsub.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridSystemTopic'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_eventgridsystemtopic.json'))
  }
  {
    name: 'Deploy-Diagnostics-EventGridTopic'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_eventgridtopic.json'))
  }
  {
    name: 'Deploy-Diagnostics-ExpressRoute'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_expressroute.json'))
  }
  {
    name: 'Deploy-Diagnostics-Firewall'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_firewall.json'))
  }
  {
    name: 'Deploy-Diagnostics-FrontDoor'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_frontdoor.json'))
  }
  {
    name: 'Deploy-Diagnostics-Function'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_function.json'))
  }
  {
    name: 'Deploy-Diagnostics-HDInsight'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_hdinsight.json'))
  }
  {
    name: 'Deploy-Diagnostics-iotHub'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_iothub.json'))
  }
  {
    name: 'Deploy-Diagnostics-LoadBalancer'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_loadbalancer.json'))
  }
  {
    name: 'Deploy-Diagnostics-LogicAppsISE'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_logicappsise.json'))
  }
  {
    name: 'Deploy-Diagnostics-MariaDB'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_mariadb.json'))
  }
  {
    name: 'Deploy-Diagnostics-MediaService'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_mediaservice.json'))
  }
  {
    name: 'Deploy-Diagnostics-MlWorkspace'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_mlworkspace.json'))
  }
  {
    name: 'Deploy-Diagnostics-MySQL'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_mysql.json'))
  }
  {
    name: 'Deploy-Diagnostics-NetworkSecurityGroups'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_networksecuritygroups.json'))
  }
  {
    name: 'Deploy-Diagnostics-NIC'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_nic.json'))
  }
  {
    name: 'Deploy-Diagnostics-PostgreSQL'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_postgresql.json'))
  }
  {
    name: 'Deploy-Diagnostics-PowerBIEmbedded'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_powerbiembedded.json'))
  }
  {
    name: 'Deploy-Diagnostics-RedisCache'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_rediscache.json'))
  }
  {
    name: 'Deploy-Diagnostics-Relay'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_relay.json'))
  }
  {
    name: 'Deploy-Diagnostics-SignalR'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_signalr.json'))
  }
  {
    name: 'Deploy-Diagnostics-SQLElasticPools'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_sqlelasticpools.json'))
  }
  {
    name: 'Deploy-Diagnostics-SQLMI'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_sqlmi.json'))
  }
  {
    name: 'Deploy-Diagnostics-TimeSeriesInsights'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_timeseriesinsights.json'))
  }
  {
    name: 'Deploy-Diagnostics-TrafficManager'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_trafficmanager.json'))
  }
  {
    name: 'Deploy-Diagnostics-VirtualNetwork'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_virtualnetwork.json'))
  }
  {
    name: 'Deploy-Diagnostics-VM'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_vm.json'))
  }
  {
    name: 'Deploy-Diagnostics-VMSS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_vmss.json'))
  }
  {
    name: 'Deploy-Diagnostics-VNetGW'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_vnetgw.json'))
  }
  {
    name: 'Deploy-Diagnostics-WebServerFarm'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_webserverfarm.json'))
  }
  {
    name: 'Deploy-Diagnostics-Website'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_website.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDAppGroup'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_wvdappgroup.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDHostPools'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_wvdhostpools.json'))
  }
  {
    name: 'Deploy-Diagnostics-WVDWorkspace'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_diagnostics_wvdworkspace.json'))
  }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_firewallpolicy.json'))
  }
  {
    name: 'Deploy-MySQL-sslEnforcement'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_mysql_sslenforcement.json'))
  }
  {
    name: 'Deploy-MySQLCMKEffect'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_mysqlcmkeffect.json'))
  }
  {
    name: 'Deploy-Nsg-FlowLogs-to-LA'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_nsg_flowlogs_to_la.json'))
  }
  {
    name: 'Deploy-Nsg-FlowLogs'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_nsg_flowlogs.json'))
  }
  {
    name: 'Deploy-PostgreSQL-sslEnforcement'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_postgresql_sslenforcement.json'))
  }
  {
    name: 'Deploy-PostgreSQLCMKEffect'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_postgresqlcmkeffect.json'))
  }
  {
    name: 'Deploy-Private-DNS-Azure-File-Sync'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_private_dns_azure_file_sync.json'))
  }
  {
    name: 'Deploy-Private-DNS-Azure-KeyVault'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_private_dns_azure_keyvault.json'))
  }
  {
    name: 'Deploy-Private-DNS-Azure-Web'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_private_dns_azure_web.json'))
  }
  {
    name: 'Deploy-Sql-AuditingSettings'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sql_auditingsettings.json'))
  }
  {
    name: 'Deploy-SQL-minTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sql_mintls.json'))
  }
  {
    name: 'Deploy-Sql-SecurityAlertPolicies'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sql_securityalertpolicies.json'))
  }
  {
    name: 'Deploy-Sql-Tde'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sql_tde.json'))
  }
  {
    name: 'Deploy-Sql-vulnerabilityAssessments'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sql_vulnerabilityassessments.json'))
  }
  {
    name: 'Deploy-SqlMi-minTLS'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_sqlmi_mintls.json'))
  }
  {
    name: 'Deploy-Storage-sslEnforcement'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_storage_sslenforcement.json'))
  }
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_vnet_hubspoke.json'))
  }
  {
    name: 'Deploy-Windows-DomainJoin'
    libDefinition: json(loadTextContent('lib/china/policy_definitions/policy_definition_es_mc_deploy_windows_domainjoin.json'))
  }
]

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\china\policy_set_definitions\_mc_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
  {
    name: 'Deny-PublicPaaSEndpoints'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0fdf0491-d080-4575-b627-ad0e843cba0f'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.ACRDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'AFSDenyPaasPublicIP'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AFSPaasPublicIP'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.AFSDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'AKSDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.AKSDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'BatchDenyPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/74c5a0ae-5e48-4738-b093-65e23a060488'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.BatchDenyPublicIP.parameters
      }
      {
        definitionReferenceId: 'CosmosDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/797b37f7-06b8-444c-b1ad-fc62867f335a'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.CosmosDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'KeyVaultDenyPaasPublicIP'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-KeyVaultPaasPublicIP'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.KeyVaultDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'SqlServerDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.SqlServerDenyPaasPublicIP.parameters
      }
      {
        definitionReferenceId: 'StorageDenyPaasPublicIP'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c'
        definitionParameters: varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters.StorageDenyPaasPublicIP.parameters
      }
    ]
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACIDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACI'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.ACIDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ACRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.ACRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AKSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AKSDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AnalysisServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AnalysisService'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AnalysisServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'APIforFHIRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApiForFHIR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.APIforFHIRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'APIMgmtDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-APIMgmt'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.APIMgmtDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApplicationGateway'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AppServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WebServerFarm'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AppServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AppServiceWebappDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Website'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AppServiceWebappDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AutomationDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AutomationDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'AVDHostPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDHostPools'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.AVDHostPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'BastionDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Bastion'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.BastionDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'BatchDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c84e5349-db6d-4769-805e-e14037dab9b5'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.BatchDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CDNEndpointsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CDNEndpoints'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.CDNEndpointsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CognitiveServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CognitiveServices'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.CognitiveServicesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'CosmosDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CosmosDB'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.CosmosDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DatabricksDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Databricks'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.DatabricksDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataExplorerCluster'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataFactoryDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataFactory'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.DataFactoryDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DLAnalytics'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'DataLakeStoreDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d56a5a7c-72d7-42bc-8ceb-3baf4c0eae03'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.DataLakeStoreDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventGridSubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSub'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.EventGridSubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventGridTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridTopic'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.EventGridTopicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f6e93e8-6b31-41b1-83f6-36e449a42579'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.EventHubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'EventSystemTopicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSystemTopic'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.EventSystemTopicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ExpressRouteDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ExpressRoute'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.ExpressRouteDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FirewallDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.FirewallDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FrontDoorDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-FrontDoor'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.FrontDoorDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'FunctionAppDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Function'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.FunctionAppDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'HDInsightDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-HDInsight'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.HDInsightDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'IotHubDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-iotHub'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.IotHubDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'KeyVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.KeyVaultDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LoadBalancerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LoadBalancer'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.LoadBalancerDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LogicAppsISEDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogicAppsISE'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.LogicAppsISEDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'LogicAppsWFDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b889a06c-ec72-4b03-910a-cb169ee18721'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.LogicAppsWFDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MariaDBDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MariaDB'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.MariaDBDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MediaServiceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MediaService'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.MediaServiceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MlWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MlWorkspace'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.MlWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'MySQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MySQL'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.MySQLDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkNICDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NIC'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.NetworkNICDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NetworkSecurityGroups'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PostgreSQL'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.PostgreSQLDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PowerBIEmbedded'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RecoveryVaultDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.RecoveryVaultDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RedisCacheDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-RedisCache'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.RedisCacheDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'RelayDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Relay'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.RelayDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SearchServicesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/08ba64b8-738f-4918-9686-730d2ed79c7d'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.SearchServicesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'ServiceBusDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/04d53d87-841c-4f23-8a5b-21564380b55e'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.ServiceBusDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SignalRDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SignalR'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.SignalRDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLDatabaseDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b79fa14e-238a-4c2d-b376-442ce508fc84'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.SQLDatabaseDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLElasticPools'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'SQLMDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLMI'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.SQLMDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'StorageAccountDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6f8f98a4-f108-47cb-8e98-91a0d85cd474'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.StorageAccountDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/237e0f7e-b0e8-4ec4-ad46-8c12cb66d673'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TimeSeriesInsights'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'TrafficManagerDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TrafficManager'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.TrafficManagerDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VirtualMachinesDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VM'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.VirtualMachinesDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VirtualNetworkDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VirtualNetwork'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.VirtualNetworkDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VMSSDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VMSS'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.VMSSDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'VNetGWDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VNetGW'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.VNetGWDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'WVDAppGroupDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDAppGroup'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.WVDAppGroupDeployDiagnosticLogDeployLogAnalytics.parameters
      }
      {
        definitionReferenceId: 'WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDWorkspace'
        definitionParameters: varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters.WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
      }
    ]
  }
  {
    name: 'Deploy-MDFC-Config'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_mdfc_config.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ascExport'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9'
        definitionParameters: varPolicySetDefinitionEsMcDeployMdfcConfigParameters.ascExport.parameters
      }
      {
        definitionReferenceId: 'defenderForContainers'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c9ddb292-b203-4738-aead-18e2716e858f'
        definitionParameters: varPolicySetDefinitionEsMcDeployMdfcConfigParameters.defenderForContainers.parameters
      }
      {
        definitionReferenceId: 'defenderForSqlPaas'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b99b73e7-074b-4089-9395-b7236f094491'
        definitionParameters: varPolicySetDefinitionEsMcDeployMdfcConfigParameters.defenderForSqlPaas.parameters
      }
      {
        definitionReferenceId: 'defenderForVM'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e86a5b6-b9bd-49d1-8e21-4bb8a0862222'
        definitionParameters: varPolicySetDefinitionEsMcDeployMdfcConfigParameters.defenderForVM.parameters
      }
      {
        definitionReferenceId: 'securityEmailContact'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-SecurityContacts'
        definitionParameters: varPolicySetDefinitionEsMcDeployMdfcConfigParameters.securityEmailContact.parameters
      }
    ]
  }
  {
    name: 'Deploy-Private-DNS-Zones'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'Deploy-Private-DNS-Azure-File-Sync'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-File-Sync'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['Deploy-Private-DNS-Azure-File-Sync'].parameters
      }
      {
        definitionReferenceId: 'Deploy-Private-DNS-Azure-KeyVault'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-KeyVault'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['Deploy-Private-DNS-Azure-KeyVault'].parameters
      }
      {
        definitionReferenceId: 'Deploy-Private-DNS-Azure-Web'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-Web'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['Deploy-Private-DNS-Azure-Web'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ACR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e9585a95-5b8c-4d03-b193-dc7eb5ac4c32'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-ACR'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-App'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7a860e27-9ca2-4fc6-822d-c2d248c300df'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-App'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-AppServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-AppServices'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Batch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/4ec38ebc-381f-45ee-81a4-acbc4be878f8'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-Batch'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveSearch'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/fbc14a67-53e4-4932-abcc-2049c6706009'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-CognitiveSearch'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-CognitiveServices'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-CognitiveServices'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-DiskAccess'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/bc05b96c-0b36-4ca9-82f0-5c53f96ce05a'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-DiskAccess'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridDomains'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/d389df0a-e0d7-4607-833c-75a6fdac2c2d'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-EventGridDomains'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventGridTopics'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/baf19753-7502-405f-8745-370519b20483'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-EventGridTopics'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-EventHubNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ed66d4f5-8220-45dc-ab4a-20d1749c74e6'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-EventHubNamespace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoT'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/aaa64d2d-2fa3-45e5-b332-0b031b9b30e8'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-IoT'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-IoTHubs'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-IoTHubs'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-MachineLearningWorkspace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ee40564d-486e-4f68-a5ca-7a621edae0fb'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-MachineLearningWorkspace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-RedisCache'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e016b22b-e0eb-436d-8fd7-160c4eaed6e2'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-RedisCache'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-ServiceBusNamespace'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0fcf93c-c063-4071-9668-c47474bd3564'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-ServiceBusNamespace'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-SignalR'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/b0e86710-7fb7-4a6c-a064-32e9b829509e'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-SignalR'].parameters
      }
      {
        definitionReferenceId: 'DINE-Private-DNS-Azure-Site-Recovery'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/942bd215-1a66-44be-af65-6a1c0318dbe2'
        definitionParameters: varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters['DINE-Private-DNS-Azure-Site-Recovery'].parameters
      }
    ]
  }
  {
    name: 'Deploy-Sql-Security'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.json'))
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
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'ACRCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.ACRCmkDeny.parameters
      }
      {
        definitionReferenceId: 'AksCmkDeny'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/7d7be79c-23ba-4033-84dd-45e2a5ccdd67'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.AksCmkDeny.parameters
      }
      {
        definitionReferenceId: 'AzureBatchCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/99e9ccd8-3db9-4592-b0d1-14b1715a4d8a'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.AzureBatchCMKEffect.parameters
      }
      {
        definitionReferenceId: 'CognitiveServicesCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/67121cc7-ff39-4ab8-b7e3-95b84dab487d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.CognitiveServicesCMK.parameters
      }
      {
        definitionReferenceId: 'CosmosCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1f905d99-2ab7-462c-a6b0-f709acca6c8f'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.CosmosCMKEffect.parameters
      }
      {
        definitionReferenceId: 'DataBoxCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86efb160-8de7-451d-bc08-5d475b0aadae'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.DataBoxCMKEffect.parameters
      }
      {
        definitionReferenceId: 'EncryptedVMDisksEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.EncryptedVMDisksEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLCMKEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQLCMKEffect'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.MySQLCMKEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLCMKEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQLCMKEffect'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.PostgreSQLCMKEffect.parameters
      }
      {
        definitionReferenceId: 'SqlServerTDECMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0d134df8-db83-46fb-ad72-fe0c9428c8dd'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.SqlServerTDECMKEffect.parameters
      }
      {
        definitionReferenceId: 'StorageCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.StorageCMKEffect.parameters
      }
      {
        definitionReferenceId: 'StreamAnalyticsCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/87ba29ef-1ab3-4d82-b763-87fcd4f531f7'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.StreamAnalyticsCMKEffect.parameters
      }
      {
        definitionReferenceId: 'SynapseWorkspaceCMKEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f7d52b2d-e161-4dfa-a82b-55e564167385'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.SynapseWorkspaceCMKEffect.parameters
      }
      {
        definitionReferenceId: 'WorkspaceCMK'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/ba769a63-b8cc-4b2d-abf6-ac33c7204be8'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters.WorkspaceCMK.parameters
      }
    ]
  }
  {
    name: 'Enforce-EncryptTransit'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.json'))
    libSetChildDefinitions: [
      {
        definitionReferenceId: 'AKSIngressHttpsOnlyEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.AKSIngressHttpsOnlyEffect.parameters
      }
      {
        definitionReferenceId: 'APIAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.APIAppServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'APIAppServiceLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8cb6aa8b-9e41-4f4e-aa25-089a7ac2581e'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.APIAppServiceLatestTlsEffect.parameters
      }
      {
        definitionReferenceId: 'AppServiceHttpEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.AppServiceHttpEffect.parameters
      }
      {
        definitionReferenceId: 'AppServiceminTlsVersion'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.AppServiceminTlsVersion.parameters
      }
      {
        definitionReferenceId: 'FunctionLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.FunctionLatestTlsEffect.parameters
      }
      {
        definitionReferenceId: 'FunctionServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.FunctionServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.MySQLEnableSSLDeployEffect.parameters
      }
      {
        definitionReferenceId: 'MySQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.MySQLEnableSSLEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.PostgreSQLEnableSSLDeployEffect.parameters
      }
      {
        definitionReferenceId: 'PostgreSQLEnableSSLEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.PostgreSQLEnableSSLEffect.parameters
      }
      {
        definitionReferenceId: 'RedisDenyhttps'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.RedisDenyhttps.parameters
      }
      {
        definitionReferenceId: 'RedisdisableNonSslPort'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.RedisdisableNonSslPort.parameters
      }
      {
        definitionReferenceId: 'RedisTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.RedisTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.SQLManagedInstanceTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLManagedInstanceTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.SQLManagedInstanceTLSEffect.parameters
      }
      {
        definitionReferenceId: 'SQLServerTLSDeployEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.SQLServerTLSDeployEffect.parameters
      }
      {
        definitionReferenceId: 'SQLServerTLSEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.SQLServerTLSEffect.parameters
      }
      {
        definitionReferenceId: 'StorageDeployHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.StorageDeployHttpsEnabledEffect.parameters
      }
      {
        definitionReferenceId: 'StorageHttpsEnabledEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.StorageHttpsEnabledEffect.parameters
      }
      {
        definitionReferenceId: 'WebAppServiceHttpsEffect'
        definitionId: '${varTargetManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.WebAppServiceHttpsEffect.parameters
      }
      {
        definitionReferenceId: 'WebAppServiceLatestTlsEffect'
        definitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
        definitionParameters: varPolicySetDefinitionEsMcEnforceEncrypttransitParameters.WebAppServiceLatestTlsEffect.parameters
      }
    ]
  }
]

// Policy Set/Initiative Definition Parameter Variables

var varPolicySetDefinitionEsMcDenyPublicpaasendpointsParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')

var varPolicySetDefinitionEsMcDeployDiagnosticsLoganalyticsParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')

var varPolicySetDefinitionEsMcDeployMdfcConfigParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_mdfc_config.parameters.json')

var varPolicySetDefinitionEsMcDeployPrivateDnsZonesParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json')

var varPolicySetDefinitionEsMcDeploySqlSecurityParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.parameters.json')

var varPolicySetDefinitionEsMcEnforceEncryptionCmkParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')

var varPolicySetDefinitionEsMcEnforceEncrypttransitParameters = loadJsonContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')

// Customer Usage Attribution Id
var varCuaid = '2b136786-9881-412e-84ba-f4c2822e1ac9'

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
