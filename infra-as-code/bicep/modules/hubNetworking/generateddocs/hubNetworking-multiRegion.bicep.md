# ALZ Bicep - Hub Networking Module

ALZ Bicep Module used to set up Hub Networking

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into.
parSecondaryLocation | Yes      | The secondary Azure Region to deploy the resources into.
parCompanyPrefix | No       | Prefix value which will be prepended to all resource names.
parHubNetworkName | No       | Name for Hub Network.
parHubNetworkNameSecondaryLocation | No       | Name for Hub Network in the secondary location.
parGlobalResourceLock | No       | Global Resource Lock Configuration used for all resources deployed in this module.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parHubNetworkAddressPrefix | No       | The IP address range for Hub Network.
parHubNetworkAddressPrefixSecondaryLocation | No       | The IP address range for Hub Network in the secondary location.
parSubnets     | No       | The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.
parSubnetsSecondaryLocation | No       | The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks in the secondary location.
parDnsServerIps | No       | Array of DNS Server IP addresses for VNet.
parDnsServerIpsSecondaryLocation | No       | Array of DNS Server IP addresses for VNet in the secondary location.
parVirtualNetworkLock | No       | Resource Lock Configuration for Virtual Network.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPublicIpSku | No       | Public IP Address SKU.
parPublicIpSkuSecondaryLocation | No       | Public IP Address SKU in secondary location.
parPublicIpPrefix | No       | Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-
parPublicIpPrefixSecondaryLocation | No       | Optional Prefix for Public IPs in secondary location. Include a succedent dash if required . Example: prefix-
parPublicIpSuffix | No       | Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix
parAzBastionEnabled | No       | Switch to enable/disable Azure Bastion deployment.
parAzBastionEnabledSecondaryLocation | No       | Switch to enable/disable Azure Bastion deployment in secondary location.
parAzBastionName | No       | Name Associated with Bastion Service.
parAzBastionNameSecondaryLocation | No       | Name Associated with Bastion Service in secondary location.
parAzBastionSku | No       | Azure Bastion SKU.
parAzBastionSkuSecondaryLocation | No       | Azure Bastion SKU in secondary location.
parAzBastionTunneling | No       | Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client
parAzBastionTunnelingSecondaryLocation | No       | Switch to enable/disable Bastion native client support in secondary location. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client
parAzBastionNsgName | No       | Name for Azure Bastion Subnet NSG.
parAzBastionNsgNameSecondaryLocation | No       | Name for Azure Bastion Subnet NSG in secondary location.
parBastionLock | No       | Resource Lock Configuration for Bastion.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment.
parDdosEnabledSecondaryLocation | No       | Switch to enable/disable DDoS Network Protection deployment in the secondary location.
parDdosPlanName | No       | DDoS Plan Name.
parDdosPlanNameSecondaryLocation | No       | DDoS Plan Name in the secondary location.
parDdosLock    | No       | Resource Lock Configuration for DDoS Plan.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parAzFirewallEnabled | No       | Switch to enable/disable Azure Firewall deployment.
parAzFirewallEnabledSecondaryLocation | No       | Switch to enable/disable Azure Firewall deployment in the secondary location.
parAzFirewallName | No       | Azure Firewall Name.
parAzFirewallNameSecondaryLocation | No       | Azure Firewall Name in the secondary location.
parAzFirewallPoliciesEnabled | No       | Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.
parAzFirewallPoliciesEnabledSecondaryLocation | No       | Set this to true for the initial deployment as one firewall policy is required in the secondary location. Set this to false in subsequent deployments if using custom policies.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name.
parAzFirewallPoliciesNameSecondaryLocation | No       | Azure Firewall Policies Name in the secondary location.
parAzFirewallPoliciesAutoLearn | No       | The operation mode for automatically learning private ranges to not be SNAT.
parAzFirewallPoliciesAutoLearnSecondaryLocation | No       | The operation mode for automatically learning private ranges to not be SNAT in the secondary location.
parAzFirewallPoliciesPrivateRanges | No       | Private IP addresses/IP ranges to which traffic will not be SNAT.
parAzFirewallPoliciesPrivateRangesSecondaryLocation | No       | Private IP addresses/IP ranges to which traffic will not be SNAT in the secondary location.
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parAzFirewallTierSecondaryLocation | No       | Azure Firewall Tier associated with the Firewall to deploy in the secondary location.
parAzFirewallIntelMode | No       | The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.
parAzFirewallIntelModeSecondaryLocation | No       | The Azure Firewall Threat Intelligence Mode in the secondary location. If not set, the default value is Alert.
parAzFirewallCustomPublicIps | No       | Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.
parAzFirewallCustomPublicIpsSecondaryLocation | No       | Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations in the secondary location.
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parAzFirewallAvailabilityZonesSecondaryLocation | No       | Availability Zones to deploy the Azure Firewall across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty.
parAzErGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzErGatewayAvailabilityZonesSecondaryLocation | No       | Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzVpnGatewayAvailabilityZones | No       | Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzVpnGatewayAvailabilityZonesSecondaryLocation | No       | Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy.
parAzFirewallDnsProxyEnabledSecondaryLocation | No       | Switch to enable/disable Azure Firewall DNS Proxy in the secndary location.
parAzFirewallDnsServers | No       | Array of custom DNS servers used by Azure Firewall.
parAzFirewallDnsServersSecondaryLocation | No       | Array of custom DNS servers used by Azure Firewall in the secondary location.
parAzureFirewallLock | No       |  Resource Lock Configuration for Azure Firewall.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parHubRouteTableName | No       | Name of Route table to create for the default route of Hub.
parHubRouteTableNameSecondaryLocation | No       | Name of Route table to create for the default route of Hub in the secondary location.
parDisableBgpRoutePropagation | No       | Switch to enable/disable BGP Propagation on route table.
parDisableBgpRoutePropagationSecondaryLocation | No       | Switch to enable/disable BGP Propagation on route table in the secondary location.
parHubRouteTableLock | No       | Resource Lock Configuration for Hub Route Table.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parPrivateDnsZonesEnabled | No       | Switch to enable/disable Private DNS Zones deployment.
parPrivateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones.
parPrivateDnsZones | No       | Array of DNS Zones to provision and link to Hub Virtual Networks. Default: All known Azure Private DNS Zones, baked into underlying AVM module see: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones
parVirtualNetworkIdToLinkFailover | No       | Resource ID of Failover VNet for Private DNS Zone VNet Failover Links
parVirtualNetworkResourceIdsToLinkTo | No       | Array of Resource IDs of VNets to link to Private DNS Zones. Hub VNets are automatically included by module.
parPrivateDNSZonesLock | No       | Resource Lock Configuration for Private DNS Zone(s).  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parVpnGatewayEnabled | No       | Switch to enable/disable VPN virtual network gateway deployment.
parVpnGatewayEnabledSecondaryLocation | No       | Switch to enable/disable VPN virtual network gateway deployment in secondary location.
parVpnGatewayConfig | No       | Configuration for VPN virtual network gateway to be deployed.
parVpnGatewayConfigSecondaryLocation | No       | Configuration for VPN virtual network gateway to be deployed in secondary location.
parExpressRouteGatewayEnabled | No       | Switch to enable/disable ExpressRoute virtual network gateway deployment.
parExpressRouteGatewayEnabledSecondaryLocation | No       | Switch to enable/disable ExpressRoute virtual network gateway deployment in secondary location.
parExpressRouteGatewayConfig | No       | Configuration for ExpressRoute virtual network gateway to be deployed.
parExpressRouteGatewayConfigSecondaryLocation | No       | Configuration for ExpressRoute virtual network gateway to be deployed in secondary location.
parVirtualNetworkGatewayLock | No       | Resource Lock Configuration for ExpressRoute Virtual Network Gateway.  - `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None. - `notes` - Notes about this lock.  
parTags        | No       | Tags you would like to be applied to all resources in this module.
parTelemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.
parBastionOutboundSshRdpPorts | No       | Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.
parBastionOutboundSshRdpPortsSecondaryLocation | No       | Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion in secondary location.

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The secondary Azure Region to deploy the resources into.

### parCompanyPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix value which will be prepended to all resource names.

- Default value: `alz`

### parHubNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Hub Network.

- Default value: `[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parHubNetworkNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Hub Network in the secondary location.

- Default value: `[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parSecondaryLocation'))]`

### parGlobalResourceLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Global Resource Lock Configuration used for all resources deployed in this module.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parHubNetworkAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for Hub Network.

- Default value: `10.10.0.0/16`

### parHubNetworkAddressPrefixSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The IP address range for Hub Network in the secondary location.

- Default value: `10.20.0.0/16`

### parSubnets

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.

- Default value: `   `

### parSubnetsSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks in the secondary location.

- Default value: `   `

### parDnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet.

### parDnsServerIpsSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Server IP addresses for VNet in the secondary location.

### parVirtualNetworkLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Virtual Network.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parPublicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parPublicIpSkuSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU in secondary location.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parPublicIpPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-

### parPublicIpPrefixSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Prefix for Public IPs in secondary location. Include a succedent dash if required . Example: prefix-

### parPublicIpSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix

- Default value: `-PublicIP`

### parAzBastionEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Bastion deployment.

- Default value: `True`

### parAzBastionEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Bastion deployment in secondary location.

- Default value: `True`

### parAzBastionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name Associated with Bastion Service.

- Default value: `[format('{0}-bastion', parameters('parCompanyPrefix'))]`

### parAzBastionNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name Associated with Bastion Service in secondary location.

- Default value: `[format('{0}-bastion', parameters('parCompanyPrefix'))]`

### parAzBastionSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Bastion SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parAzBastionSkuSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Bastion SKU in secondary location.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parAzBastionTunneling

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client

- Default value: `False`

### parAzBastionTunnelingSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Bastion native client support in secondary location. This is only supported when the Standard SKU is used for Bastion as documented here: https://learn.microsoft.com/azure/bastion/native-client

- Default value: `False`

### parAzBastionNsgName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Azure Bastion Subnet NSG.

- Default value: `nsg-AzureBastionSubnet`

### parAzBastionNsgNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name for Azure Bastion Subnet NSG in secondary location.

- Default value: `nsg-AzureBastionSubnet`

### parBastionLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Bastion.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment.

- Default value: `True`

### parDdosEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment in the secondary location.

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name.

- Default value: `[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]`

### parDdosPlanNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name in the secondary location.

- Default value: `[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]`

### parDdosLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for DDoS Plan.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parAzFirewallEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall deployment.

- Default value: `True`

### parAzFirewallEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall deployment in the secondary location.

- Default value: `True`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name in the secondary location.

- Default value: `[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.

- Default value: `True`

### parAzFirewallPoliciesEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set this to true for the initial deployment as one firewall policy is required in the secondary location. Set this to false in subsequent deployments if using custom policies.

- Default value: `True`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name.

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name in the secondary location.

- Default value: `[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]`

### parAzFirewallPoliciesAutoLearn

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The operation mode for automatically learning private ranges to not be SNAT.

- Default value: `Disabled`

### parAzFirewallPoliciesAutoLearnSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The operation mode for automatically learning private ranges to not be SNAT in the secondary location.

- Default value: `Disabled`

- Allowed values: `Disabled`, `Enabled`

### parAzFirewallPoliciesPrivateRanges

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Private IP addresses/IP ranges to which traffic will not be SNAT.

- Allowed values: `Disabled`, `Enabled`

### parAzFirewallPoliciesPrivateRangesSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Private IP addresses/IP ranges to which traffic will not be SNAT in the secondary location.

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallTierSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy in the secondary location.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallIntelMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.

- Default value: `Alert`

- Allowed values: `Alert`, `Deny`, `Off`

### parAzFirewallIntelModeSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Firewall Threat Intelligence Mode in the secondary location. If not set, the default value is Alert.

- Default value: `Alert`

- Allowed values: `Alert`, `Deny`, `Off`

### parAzFirewallCustomPublicIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.

### parAzFirewallCustomPublicIpsSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations in the secondary location.

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzFirewallAvailabilityZonesSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzErGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzErGatewayAvailabilityZonesSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzVpnGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzVpnGatewayAvailabilityZonesSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the VPN/ER PIP across in the secondary location. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP.

- Allowed values: `1`, `2`, `3`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy.

- Default value: `True`

### parAzFirewallDnsProxyEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy in the secndary location.

- Default value: `True`

### parAzFirewallDnsServers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS servers used by Azure Firewall.

### parAzFirewallDnsServersSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS servers used by Azure Firewall in the secondary location.

### parAzureFirewallLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

 Resource Lock Configuration for Azure Firewall.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parHubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub.

- Default value: `[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]`

### parHubRouteTableNameSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Route table to create for the default route of Hub in the secondary location.

- Default value: `[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]`

### parDisableBgpRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table.

- Default value: `False`

### parDisableBgpRoutePropagationSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable BGP Propagation on route table in the secondary location.

- Default value: `False`

### parHubRouteTableLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Hub Route Table.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parPrivateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Private DNS Zones deployment.

- Default value: `True`

### parPrivateDnsZonesResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Name for Private DNS Zones.

- Default value: `[resourceGroup().name]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of DNS Zones to provision and link to Hub Virtual Networks. Default: All known Azure Private DNS Zones, baked into underlying AVM module see: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones

### parVirtualNetworkIdToLinkFailover

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of Failover VNet for Private DNS Zone VNet Failover Links

### parVirtualNetworkResourceIdsToLinkTo

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Resource IDs of VNets to link to Private DNS Zones. Hub VNets are automatically included by module.

### parPrivateDNSZonesLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for Private DNS Zone(s).

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parVpnGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN virtual network gateway deployment.

- Default value: `True`

### parVpnGatewayEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable VPN virtual network gateway deployment in secondary location.

- Default value: `True`

### parVpnGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for VPN virtual network gateway to be deployed.

- Default value: `@{name=[format('{0}-Vpn-Gateway-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]; gatewayType=Vpn; sku=VpnGw1; vpnType=RouteBased; generation=Generation1; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=; vpnClientConfiguration=; ipConfigurationName=vnetGatewayConfig; ipConfigurationActiveActiveName=vnetGatewayConfig2}`

### parVpnGatewayConfigSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for VPN virtual network gateway to be deployed in secondary location.

- Default value: `@{name=[format('{0}-Vpn-Gateway-{1}', parameters('parCompanyPrefix'), parameters('parSecondaryLocation'))]; gatewayType=Vpn; sku=VpnGw1; vpnType=RouteBased; generation=Generation1; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=; vpnClientConfiguration=; ipConfigurationName=vnetGatewayConfig; ipConfigurationActiveActiveName=vnetGatewayConfig2}`

### parExpressRouteGatewayEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable ExpressRoute virtual network gateway deployment.

- Default value: `True`

### parExpressRouteGatewayEnabledSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable ExpressRoute virtual network gateway deployment in secondary location.

- Default value: `True`

### parExpressRouteGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for ExpressRoute virtual network gateway to be deployed.

- Default value: `@{name=[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]; gatewayType=ExpressRoute; sku=ErGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=None; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=; ipConfigurationName=vnetGatewayConfig; ipConfigurationActiveActiveName=vnetGatewayConfig2}`

### parExpressRouteGatewayConfigSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Configuration for ExpressRoute virtual network gateway to be deployed in secondary location.

- Default value: `@{name=[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]; gatewayType=ExpressRoute; sku=ErGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=None; enableBgp=False; activeActive=False; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpPeeringAddress=; bgpsettings=; ipConfigurationName=vnetGatewayConfig; ipConfigurationActiveActiveName=vnetGatewayConfig2}`

### parVirtualNetworkGatewayLock

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Lock Configuration for ExpressRoute Virtual Network Gateway.

- `kind` - The lock settings of the service which can be CanNotDelete, ReadOnly, or None.
- `notes` - Notes about this lock.



- Default value: `@{kind=None; notes=This lock was created by the ALZ Bicep Hub Networking Module.}`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parTelemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

### parBastionOutboundSshRdpPorts

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.

- Default value: `22 3389`

### parBastionOutboundSshRdpPortsSecondaryLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion in secondary location.

- Default value: `22 3389`

## Outputs

Name | Type | Description
---- | ---- | -----------
outAzFirewallPrivateIp | string |
outAzFirewallPrivateIpSecondaryLocation | string |
outAzFirewallName | string |
outAzFirewallNameSecondaryLocation | string |
outPrivateDnsZones | array |
outPrivateDnsZonesNames | array |
outDdosPlanResourceId | string |
outDdosPlanResourceIdSecondaryLocation | string |
outHubVirtualNetworkName | string |
outHubVirtualNetworkNameSecondaryLocation | string |
outHubVirtualNetworkId | string |
outHubVirtualNetworkIdSecondaryLocation | string |
outHubRouteTableId | string |
outHubRouteTableIdSecondaryLocation | string |
outHubRouteTableName | string |
outHubRouteTableNameSecondaryLocation | string |
outBastionNsgId | string |
outBastionNsgIdSecondaryLocation | string |
outBastionNsgName | string |
outBastionNsgNameSecondaryLocation | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "infra-as-code/bicep/modules/hubNetworking/hubNetworking-multiRegion.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parSecondaryLocation": {
            "value": ""
        },
        "parCompanyPrefix": {
            "value": "alz"
        },
        "parHubNetworkName": {
            "value": "[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parHubNetworkNameSecondaryLocation": {
            "value": "[format('{0}-hub-{1}', parameters('parCompanyPrefix'), parameters('parSecondaryLocation'))]"
        },
        "parGlobalResourceLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parHubNetworkAddressPrefix": {
            "value": "10.10.0.0/16"
        },
        "parHubNetworkAddressPrefixSecondaryLocation": {
            "value": "10.20.0.0/16"
        },
        "parSubnets": {
            "value": [
                {
                    "name": "AzureBastionSubnet",
                    "ipAddressRange": "10.10.15.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "GatewaySubnet",
                    "ipAddressRange": "10.10.252.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallSubnet",
                    "ipAddressRange": "10.10.254.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallManagementSubnet",
                    "ipAddressRange": "10.10.253.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                }
            ]
        },
        "parSubnetsSecondaryLocation": {
            "value": [
                {
                    "name": "AzureBastionSubnet",
                    "ipAddressRange": "10.20.15.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "GatewaySubnet",
                    "ipAddressRange": "10.20.252.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallSubnet",
                    "ipAddressRange": "10.20.254.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                },
                {
                    "name": "AzureFirewallManagementSubnet",
                    "ipAddressRange": "10.20.253.0/24",
                    "networkSecurityGroupId": "",
                    "routeTableId": ""
                }
            ]
        },
        "parDnsServerIps": {
            "value": []
        },
        "parDnsServerIpsSecondaryLocation": {
            "value": []
        },
        "parVirtualNetworkLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parPublicIpSku": {
            "value": "Standard"
        },
        "parPublicIpSkuSecondaryLocation": {
            "value": "Standard"
        },
        "parPublicIpPrefix": {
            "value": ""
        },
        "parPublicIpPrefixSecondaryLocation": {
            "value": ""
        },
        "parPublicIpSuffix": {
            "value": "-PublicIP"
        },
        "parAzBastionEnabled": {
            "value": true
        },
        "parAzBastionEnabledSecondaryLocation": {
            "value": true
        },
        "parAzBastionName": {
            "value": "[format('{0}-bastion', parameters('parCompanyPrefix'))]"
        },
        "parAzBastionNameSecondaryLocation": {
            "value": "[format('{0}-bastion', parameters('parCompanyPrefix'))]"
        },
        "parAzBastionSku": {
            "value": "Standard"
        },
        "parAzBastionSkuSecondaryLocation": {
            "value": "Standard"
        },
        "parAzBastionTunneling": {
            "value": false
        },
        "parAzBastionTunnelingSecondaryLocation": {
            "value": false
        },
        "parAzBastionNsgName": {
            "value": "nsg-AzureBastionSubnet"
        },
        "parAzBastionNsgNameSecondaryLocation": {
            "value": "nsg-AzureBastionSubnet"
        },
        "parBastionLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parDdosEnabled": {
            "value": true
        },
        "parDdosEnabledSecondaryLocation": {
            "value": true
        },
        "parDdosPlanName": {
            "value": "[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]"
        },
        "parDdosPlanNameSecondaryLocation": {
            "value": "[format('{0}-ddos-plan', parameters('parCompanyPrefix'))]"
        },
        "parDdosLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parAzFirewallEnabled": {
            "value": true
        },
        "parAzFirewallEnabledSecondaryLocation": {
            "value": true
        },
        "parAzFirewallName": {
            "value": "[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallNameSecondaryLocation": {
            "value": "[format('{0}-azfw-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesEnabled": {
            "value": true
        },
        "parAzFirewallPoliciesEnabledSecondaryLocation": {
            "value": true
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesNameSecondaryLocation": {
            "value": "[format('{0}-azfwpolicy-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]"
        },
        "parAzFirewallPoliciesAutoLearn": {
            "value": "Disabled"
        },
        "parAzFirewallPoliciesAutoLearnSecondaryLocation": {
            "value": "Disabled"
        },
        "parAzFirewallPoliciesPrivateRanges": {
            "value": []
        },
        "parAzFirewallPoliciesPrivateRangesSecondaryLocation": {
            "value": []
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parAzFirewallTierSecondaryLocation": {
            "value": "Standard"
        },
        "parAzFirewallIntelMode": {
            "value": "Alert"
        },
        "parAzFirewallIntelModeSecondaryLocation": {
            "value": "Alert"
        },
        "parAzFirewallCustomPublicIps": {
            "value": []
        },
        "parAzFirewallCustomPublicIpsSecondaryLocation": {
            "value": []
        },
        "parAzFirewallAvailabilityZones": {
            "value": []
        },
        "parAzFirewallAvailabilityZonesSecondaryLocation": {
            "value": []
        },
        "parAzErGatewayAvailabilityZones": {
            "value": []
        },
        "parAzErGatewayAvailabilityZonesSecondaryLocation": {
            "value": []
        },
        "parAzVpnGatewayAvailabilityZones": {
            "value": []
        },
        "parAzVpnGatewayAvailabilityZonesSecondaryLocation": {
            "value": []
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parAzFirewallDnsProxyEnabledSecondaryLocation": {
            "value": true
        },
        "parAzFirewallDnsServers": {
            "value": []
        },
        "parAzFirewallDnsServersSecondaryLocation": {
            "value": []
        },
        "parAzureFirewallLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parHubRouteTableName": {
            "value": "[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]"
        },
        "parHubRouteTableNameSecondaryLocation": {
            "value": "[format('{0}-hub-routetable', parameters('parCompanyPrefix'))]"
        },
        "parDisableBgpRoutePropagation": {
            "value": false
        },
        "parDisableBgpRoutePropagationSecondaryLocation": {
            "value": false
        },
        "parHubRouteTableLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parPrivateDnsZonesEnabled": {
            "value": true
        },
        "parPrivateDnsZonesResourceGroup": {
            "value": "[resourceGroup().name]"
        },
        "parPrivateDnsZones": {
            "value": []
        },
        "parVirtualNetworkIdToLinkFailover": {
            "value": ""
        },
        "parVirtualNetworkResourceIdsToLinkTo": {
            "value": []
        },
        "parPrivateDNSZonesLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parVpnGatewayEnabled": {
            "value": true
        },
        "parVpnGatewayEnabledSecondaryLocation": {
            "value": true
        },
        "parVpnGatewayConfig": {
            "value": {
                "name": "[format('{0}-Vpn-Gateway-{1}', parameters('parCompanyPrefix'), parameters('parLocation'))]",
                "gatewayType": "Vpn",
                "sku": "VpnGw1",
                "vpnType": "RouteBased",
                "generation": "Generation1",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": 65515,
                    "bgpPeeringAddress": "",
                    "peerWeight": 5
                },
                "vpnClientConfiguration": {},
                "ipConfigurationName": "vnetGatewayConfig",
                "ipConfigurationActiveActiveName": "vnetGatewayConfig2"
            }
        },
        "parVpnGatewayConfigSecondaryLocation": {
            "value": {
                "name": "[format('{0}-Vpn-Gateway-{1}', parameters('parCompanyPrefix'), parameters('parSecondaryLocation'))]",
                "gatewayType": "Vpn",
                "sku": "VpnGw1",
                "vpnType": "RouteBased",
                "generation": "Generation1",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": 65515,
                    "bgpPeeringAddress": "",
                    "peerWeight": 5
                },
                "vpnClientConfiguration": {},
                "ipConfigurationName": "vnetGatewayConfig",
                "ipConfigurationActiveActiveName": "vnetGatewayConfig2"
            }
        },
        "parExpressRouteGatewayEnabled": {
            "value": true
        },
        "parExpressRouteGatewayEnabledSecondaryLocation": {
            "value": true
        },
        "parExpressRouteGatewayConfig": {
            "value": {
                "name": "[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]",
                "gatewayType": "ExpressRoute",
                "sku": "ErGw1AZ",
                "vpnType": "RouteBased",
                "vpnGatewayGeneration": "None",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": "65515",
                    "bgpPeeringAddress": "",
                    "peerWeight": "5"
                },
                "ipConfigurationName": "vnetGatewayConfig",
                "ipConfigurationActiveActiveName": "vnetGatewayConfig2"
            }
        },
        "parExpressRouteGatewayConfigSecondaryLocation": {
            "value": {
                "name": "[format('{0}-ExpressRoute-Gateway', parameters('parCompanyPrefix'))]",
                "gatewayType": "ExpressRoute",
                "sku": "ErGw1AZ",
                "vpnType": "RouteBased",
                "vpnGatewayGeneration": "None",
                "enableBgp": false,
                "activeActive": false,
                "enableBgpRouteTranslationForNat": false,
                "enableDnsForwarding": false,
                "bgpPeeringAddress": "",
                "bgpsettings": {
                    "asn": "65515",
                    "bgpPeeringAddress": "",
                    "peerWeight": "5"
                },
                "ipConfigurationName": "vnetGatewayConfig",
                "ipConfigurationActiveActiveName": "vnetGatewayConfig2"
            }
        },
        "parVirtualNetworkGatewayLock": {
            "value": {
                "kind": "None",
                "notes": "This lock was created by the ALZ Bicep Hub Networking Module."
            }
        },
        "parTags": {
            "value": {}
        },
        "parTelemetryOptOut": {
            "value": false
        },
        "parBastionOutboundSshRdpPorts": {
            "value": [
                "22",
                "3389"
            ]
        },
        "parBastionOutboundSshRdpPortsSecondaryLocation": {
            "value": [
                "22",
                "3389"
            ]
        }
    }
}
```
