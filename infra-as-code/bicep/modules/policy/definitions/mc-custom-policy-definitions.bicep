targetScope = 'managementGroup'

@description('The management group scope to which the policy definitions are to be created at. DEFAULT VALUE = "alz"')
param parTargetManagementGroupID string = 'alz'

var varTargetManagementGroupResourceID = tenantResourceId('Microsoft.Management/managementGroups', parTargetManagementGroupID)

// This variable contains a number of objects that load in the custom Azure Policy Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_definitions\_policyDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable. 
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

// This variable contains a number of objects that load in the custom Azure Policy Set/Initiative Defintions that are provided as part of the ESLZ/ALZ reference implementation - this is automatically created in the file 'infra-as-code\bicep\modules\policy\lib\policy_set_definitions\_policySetDefinitionsBicepInput.txt' via a GitHub action, that runs on a daily schedule, and is then manually copied into this variable.
var varCustomPolicySetDefinitionsArray = [
  {
    name: 'Deny-PublicPaaSEndpoints'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'ACRDenyPaasPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0fdf0491-d080-4575-b627-ad0e843cba0f'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).ACRDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'AFSDenyPaasPublicIP'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AFSPaasPublicIP'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).AFSDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'AKSDenyPaasPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/040732e8-d947-40b8-95d6-854c95024bf8'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).AKSDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'BatchDenyPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/74c5a0ae-5e48-4738-b093-65e23a060488'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).BatchDenyPublicIP.parameters
        }
        {
          definitionReferenceID: 'CosmosDenyPaasPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/797b37f7-06b8-444c-b1ad-fc62867f335a'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).CosmosDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'KeyVaultDenyPaasPublicIP'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-KeyVaultPaasPublicIP'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).KeyVaultDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'SqlServerDenyPaasPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).SqlServerDenyPaasPublicIP.parameters
        }
        {
          definitionReferenceID: 'StorageDenyPaasPublicIP'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deny_publicpaasendpoints.parameters.json')).StorageDenyPaasPublicIP.parameters
        }
      ]
  }
  {
    name: 'Deploy-ASCDF-Config'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_ascdf_config.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'ascExport'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_ascdf_config.parameters.json')).ascExport.parameters
        }
        {
          definitionReferenceID: 'defenderForSqlPaas'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b99b73e7-074b-4089-9395-b7236f094491'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_ascdf_config.parameters.json')).defenderForSqlPaas.parameters
        }
        {
          definitionReferenceID: 'defenderForVM'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/8e86a5b6-b9bd-49d1-8e21-4bb8a0862222'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_ascdf_config.parameters.json')).defenderForVM.parameters
        }
        {
          definitionReferenceID: 'securityEmailContact'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-ASC-SecurityContacts'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_ascdf_config.parameters.json')).securityEmailContact.parameters
        }
      ]
  }
  {
    name: 'Deploy-Diagnostics-LogAnalytics'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'ACIDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACI'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).ACIDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'ACRDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ACR'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).ACRDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'AKSDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).AKSDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'AnalysisServiceDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AnalysisService'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).AnalysisServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'APIforFHIRDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApiForFHIR'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).APIforFHIRDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'APIMgmtDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-APIMgmt'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).APIMgmtDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ApplicationGateway'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).ApplicationGatewayDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'AppServiceDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WebServerFarm'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).AppServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'AppServiceWebappDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Website'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).AppServiceWebappDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'AutomationDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).AutomationDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'BatchDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c84e5349-db6d-4769-805e-e14037dab9b5'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).BatchDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'CDNEndpointsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CDNEndpoints'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).CDNEndpointsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'CognitiveServicesDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CognitiveServices'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).CognitiveServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'CosmosDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-CosmosDB'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).CosmosDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'DatabricksDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Databricks'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).DatabricksDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataExplorerCluster'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).DataExplorerClusterDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'DataFactoryDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DataFactory'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).DataFactoryDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-DLAnalytics'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).DataLakeAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'DataLakeStoreDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/d56a5a7c-72d7-42bc-8ceb-3baf4c0eae03'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).DataLakeStoreDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'EventGridSubDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSub'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).EventGridSubDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'EventGridTopicDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridTopic'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).EventGridTopicDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'EventHubDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1f6e93e8-6b31-41b1-83f6-36e449a42579'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).EventHubDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'EventSystemTopicDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-EventGridSystemTopic'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).EventSystemTopicDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'ExpressRouteDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-ExpressRoute'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).ExpressRouteDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'FirewallDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).FirewallDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'FrontDoorDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-FrontDoor'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).FrontDoorDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'FunctionAppDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Function'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).FunctionAppDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'HDInsightDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-HDInsight'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).HDInsightDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'IotHubDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-iotHub'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).IotHubDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'KeyVaultDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).KeyVaultDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'LoadBalancerDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LoadBalancer'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).LoadBalancerDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'LogicAppsISEDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-LogicAppsISE'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).LogicAppsISEDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'LogicAppsWFDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b889a06c-ec72-4b03-910a-cb169ee18721'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).LogicAppsWFDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'MariaDBDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MariaDB'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).MariaDBDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'MediaServiceDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MediaService'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).MediaServiceDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'MlWorkspaceDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MlWorkspace'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).MlWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'MySQLDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-MySQL'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).MySQLDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'NetworkNICDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NIC'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).NetworkNICDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).NetworkPublicIPNicDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-NetworkSecurityGroups'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).NetworkSecurityGroupsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'PostgreSQLDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PostgreSQL'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).PostgreSQLDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-PowerBIEmbedded'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).PowerBIEmbeddedDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'RecoveryVaultDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).RecoveryVaultDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'RedisCacheDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-RedisCache'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).RedisCacheDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'RelayDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Relay'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).RelayDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'SearchServicesDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/08ba64b8-738f-4918-9686-730d2ed79c7d'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).SearchServicesDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'ServiceBusDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/04d53d87-841c-4f23-8a5b-21564380b55e'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).ServiceBusDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'SignalRDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SignalR'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).SignalRDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'SQLDatabaseDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b79fa14e-238a-4c2d-b376-442ce508fc84'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).SQLDatabaseDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLElasticPools'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).SQLElasticPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'SQLMDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-SQLMI'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).SQLMDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'StorageAccountDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6f8f98a4-f108-47cb-8e98-91a0d85cd474'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).StorageAccountDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/237e0f7e-b0e8-4ec4-ad46-8c12cb66d673'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).StreamAnalyticsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TimeSeriesInsights'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).TimeSeriesInsightsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'TrafficManagerDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-TrafficManager'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).TrafficManagerDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'VirtualMachinesDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VM'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).VirtualMachinesDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'VirtualNetworkDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VirtualNetwork'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).VirtualNetworkDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'VMSSDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VMSS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).VMSSDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'VNetGWDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-VNetGW'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).VNetGWDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'WVDAppGroupDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDAppGroup'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).WVDAppGroupDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDHostPools'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).WVDHostPoolsDeployDiagnosticLogDeployLogAnalytics.parameters
        }
        {
          definitionReferenceID: 'WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-WVDWorkspace'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_diagnostics_loganalytics.parameters.json')).WVDWorkspaceDeployDiagnosticLogDeployLogAnalytics.parameters
        }
      ]
  }
  {
    name: 'Deploy-Private-DNS-Zones'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'Deploy-Private-DNS-Azure-File-Sync'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-File-Sync'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['Deploy-Private-DNS-Azure-File-Sync'].parameters
        }
        {
          definitionReferenceID: 'Deploy-Private-DNS-Azure-KeyVault'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-KeyVault'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['Deploy-Private-DNS-Azure-KeyVault'].parameters
        }
        {
          definitionReferenceID: 'Deploy-Private-DNS-Azure-Web'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Private-DNS-Azure-Web'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['Deploy-Private-DNS-Azure-Web'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-ACR'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e9585a95-5b8c-4d03-b193-dc7eb5ac4c32'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-ACR'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-App'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/7a860e27-9ca2-4fc6-822d-c2d248c300df'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-App'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-AppServices'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-AppServices'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-Batch'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/4ec38ebc-381f-45ee-81a4-acbc4be878f8'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-Batch'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-CognitiveSearch'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/fbc14a67-53e4-4932-abcc-2049c6706009'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-CognitiveSearch'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-CognitiveServices'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c4bc6f10-cb41-49eb-b000-d5ab82e2a091'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-CognitiveServices'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-DiskAccess'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/bc05b96c-0b36-4ca9-82f0-5c53f96ce05a'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-DiskAccess'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-EventGridDomains'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/d389df0a-e0d7-4607-833c-75a6fdac2c2d'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-EventGridDomains'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-EventGridTopics'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/baf19753-7502-405f-8745-370519b20483'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-EventGridTopics'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-EventHubNamespace'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ed66d4f5-8220-45dc-ab4a-20d1749c74e6'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-EventHubNamespace'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-IoT'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/aaa64d2d-2fa3-45e5-b332-0b031b9b30e8'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-IoT'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-IoTHubs'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-IoTHubs'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-MachineLearningWorkspace'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ee40564d-486e-4f68-a5ca-7a621edae0fb'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-MachineLearningWorkspace'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-RedisCache'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/e016b22b-e0eb-436d-8fd7-160c4eaed6e2'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-RedisCache'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-ServiceBusNamespace'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f0fcf93c-c063-4071-9668-c47474bd3564'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-ServiceBusNamespace'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-SignalR'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/b0e86710-7fb7-4a6c-a064-32e9b829509e'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-SignalR'].parameters
        }
        {
          definitionReferenceID: 'DINE-Private-DNS-Azure-Site-Recovery'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/942bd215-1a66-44be-af65-6a1c0318dbe2'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_private_dns_zones.parameters.json'))['DINE-Private-DNS-Azure-Site-Recovery'].parameters
        }
      ]
  }
  {
    name: 'Deploy-Sql-Security'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'SqlDbAuditingSettingsDeploySqlSecurity'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-AuditingSettings'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.parameters.json')).SqlDbAuditingSettingsDeploySqlSecurity.parameters
        }
        {
          definitionReferenceID: 'SqlDbSecurityAlertPoliciesDeploySqlSecurity'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-SecurityAlertPolicies'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.parameters.json')).SqlDbSecurityAlertPoliciesDeploySqlSecurity.parameters
        }
        {
          definitionReferenceID: 'SqlDbTdeDeploySqlSecurity'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-Tde'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.parameters.json')).SqlDbTdeDeploySqlSecurity.parameters
        }
        {
          definitionReferenceID: 'SqlDbVulnerabilityAssessmentsDeploySqlSecurity'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Sql-vulnerabilityAssessments'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_deploy_sql_security.parameters.json')).SqlDbVulnerabilityAssessmentsDeploySqlSecurity.parameters
        }
      ]
  }
  {
    name: 'Enforce-Encryption-CMK'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'ACRCmkDeny'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).ACRCmkDeny.parameters
        }
        {
          definitionReferenceID: 'AksCmkDeny'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/7d7be79c-23ba-4033-84dd-45e2a5ccdd67'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).AksCmkDeny.parameters
        }
        {
          definitionReferenceID: 'AzureBatchCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/99e9ccd8-3db9-4592-b0d1-14b1715a4d8a'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).AzureBatchCMKEffect.parameters
        }
        {
          definitionReferenceID: 'CognitiveServicesCMK'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/67121cc7-ff39-4ab8-b7e3-95b84dab487d'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).CognitiveServicesCMK.parameters
        }
        {
          definitionReferenceID: 'CosmosCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1f905d99-2ab7-462c-a6b0-f709acca6c8f'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).CosmosCMKEffect.parameters
        }
        {
          definitionReferenceID: 'DataBoxCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/86efb160-8de7-451d-bc08-5d475b0aadae'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).DataBoxCMKEffect.parameters
        }
        {
          definitionReferenceID: 'EncryptedVMDisksEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).EncryptedVMDisksEffect.parameters
        }
        {
          definitionReferenceID: 'MySQLCMKEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQLCMKEffect'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).MySQLCMKEffect.parameters
        }
        {
          definitionReferenceID: 'PostgreSQLCMKEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQLCMKEffect'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).PostgreSQLCMKEffect.parameters
        }
        {
          definitionReferenceID: 'SqlServerTDECMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/0d134df8-db83-46fb-ad72-fe0c9428c8dd'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).SqlServerTDECMKEffect.parameters
        }
        {
          definitionReferenceID: 'StorageCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).StorageCMKEffect.parameters
        }
        {
          definitionReferenceID: 'StreamAnalyticsCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/87ba29ef-1ab3-4d82-b763-87fcd4f531f7'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).StreamAnalyticsCMKEffect.parameters
        }
        {
          definitionReferenceID: 'SynapseWorkspaceCMKEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f7d52b2d-e161-4dfa-a82b-55e564167385'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).SynapseWorkspaceCMKEffect.parameters
        }
        {
          definitionReferenceID: 'WorkspaceCMK'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/ba769a63-b8cc-4b2d-abf6-ac33c7204be8'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encryption_cmk.parameters.json')).WorkspaceCMK.parameters
        }
      ]
  }
  {
    name: 'Enforce-EncryptTransit'
    libSetDefinition: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.json'))
    libSetChildDefinitions: [
        {
          definitionReferenceID: 'AKSIngressHttpsOnlyEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).AKSIngressHttpsOnlyEffect.parameters
        }
        {
          definitionReferenceID: 'APIAppServiceHttpsEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceApiApp-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).APIAppServiceHttpsEffect.parameters
        }
        {
          definitionReferenceID: 'APIAppServiceLatestTlsEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/8cb6aa8b-9e41-4f4e-aa25-089a7ac2581e'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).APIAppServiceLatestTlsEffect.parameters
        }
        {
          definitionReferenceID: 'AppServiceHttpEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-httpsonly'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).AppServiceHttpEffect.parameters
        }
        {
          definitionReferenceID: 'AppServiceminTlsVersion'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Append-AppService-latestTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).AppServiceminTlsVersion.parameters
        }
        {
          definitionReferenceID: 'FunctionLatestTlsEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).FunctionLatestTlsEffect.parameters
        }
        {
          definitionReferenceID: 'FunctionServiceHttpsEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceFunctionApp-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).FunctionServiceHttpsEffect.parameters
        }
        {
          definitionReferenceID: 'MySQLEnableSSLDeployEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-MySQL-sslEnforcement'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).MySQLEnableSSLDeployEffect.parameters
        }
        {
          definitionReferenceID: 'MySQLEnableSSLEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-MySql-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).MySQLEnableSSLEffect.parameters
        }
        {
          definitionReferenceID: 'PostgreSQLEnableSSLDeployEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-PostgreSQL-sslEnforcement'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).PostgreSQLEnableSSLDeployEffect.parameters
        }
        {
          definitionReferenceID: 'PostgreSQLEnableSSLEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-PostgreSql-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).PostgreSQLEnableSSLEffect.parameters
        }
        {
          definitionReferenceID: 'RedisDenyhttps'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Redis-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).RedisDenyhttps.parameters
        }
        {
          definitionReferenceID: 'RedisdisableNonSslPort'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-disableNonSslPort'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).RedisdisableNonSslPort.parameters
        }
        {
          definitionReferenceID: 'RedisTLSDeployEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Append-Redis-sslEnforcement'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).RedisTLSDeployEffect.parameters
        }
        {
          definitionReferenceID: 'SQLManagedInstanceTLSDeployEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SqlMi-minTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).SQLManagedInstanceTLSDeployEffect.parameters
        }
        {
          definitionReferenceID: 'SQLManagedInstanceTLSEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-SqlMi-minTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).SQLManagedInstanceTLSEffect.parameters
        }
        {
          definitionReferenceID: 'SQLServerTLSDeployEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-SQL-minTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).SQLServerTLSDeployEffect.parameters
        }
        {
          definitionReferenceID: 'SQLServerTLSEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Sql-minTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).SQLServerTLSEffect.parameters
        }
        {
          definitionReferenceID: 'StorageDeployHttpsEnabledEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Storage-sslEnforcement'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).StorageDeployHttpsEnabledEffect.parameters
        }
        {
          definitionReferenceID: 'StorageHttpsEnabledEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-Storage-minTLS'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).StorageHttpsEnabledEffect.parameters
        }
        {
          definitionReferenceID: 'WebAppServiceHttpsEffect'
          definitionID: '${varTargetManagementGroupResourceID}/providers/Microsoft.Authorization/policyDefinitions/Deny-AppServiceWebApp-http'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).WebAppServiceHttpsEffect.parameters
        }
        {
          definitionReferenceID: 'WebAppServiceLatestTlsEffect'
          definitionID: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
          definitionParameters: json(loadTextContent('lib/china/policy_set_definitions/policy_set_definition_es_mc_enforce_encrypttransit.parameters.json')).WebAppServiceLatestTlsEffect.parameters
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
  name: policySet.libSetDefinition.name
  properties: {
    description: policySet.libSetDefinition.properties.description
    displayName: policySet.libSetDefinition.properties.displayName
    metadata: policySet.libSetDefinition.properties.metadata
    parameters: policySet.libSetDefinition.properties.parameters
    policyType: policySet.libSetDefinition.properties.policyType
    policyDefinitions: [for policySetDef in policySet.libSetChildDefinitions: {
      policyDefinitionReferenceId: policySetDef.definitionReferenceID
      policyDefinitionId: policySetDef.definitionID
      parameters: policySetDef.definitionParameters
    }]
    policyDefinitionGroups: policySet.libSetDefinition.properties.policyDefinitionGroups
  }
}]
