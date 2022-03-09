targetScope = 'tenant'

@description('Prefix for the management group hierarchy.  This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@description('Display name for top level management group.  This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

@description('Management group hierarchy to be deployed.')
param parManagementGroupHierarchy array = [
  {
    name: parTopLevelManagementGroupPrefix
    displayName: parTopLevelManagementGroupDisplayName
    children: [
      {
        name: 'decommissioned'
        displayName: 'Decommissioned'
        children: []
      }
      {
        name: 'landingzones'
        displayName: 'Landing Zones'
        children: [
          {
            name: 'corp'
            displayName: 'Corp'
            children: []
          }
          {
            name: 'online'
            displayName: 'Online'
            children: []
          }
        ]
      }
      {
        name: 'platform'
        displayName: 'Platform'
        children: [
          {
            name: 'connectivity'
            displayName: 'Connectivity'
            children: []
          }
          {
            name: 'identity'
            displayName: 'Identity'
            children: []
          }
          {
            name: 'management'
            displayName: 'Management'
            children: []
          }
        ]
      }
      {
        name: 'sandbox'
        displayName: 'Sandbox'
        children: []
      }
    ]
  }
]

@description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '9b7965a0-d77c-41d6-85ef-ec3dfea4845b'

module modManagementGroup 'managementGroup.bicep' = [for (mg, i) in parManagementGroupHierarchy: {
  name: mg.name
  params: {
    parManagementGroupName: mg.name
    parManagementGroupDisplayName: mg.displayName
    parChildrenManagementGroups: mg.children
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
