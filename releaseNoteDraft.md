ALZ Bicep Release Notes:

The local private DNS zones modules (`privateDnsZones.bicep`) has been replaced in the networking related modules in this repo with the AVM Pattern module of [`avm/ptn/network/private-link-private-dns-zones`](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones) to resolve bug #695.

This has meant some breaking changes to each of the networking modules that are detailed below.

#### `hubNetworking.bicep` & `hubNetworking-multiRegion.bicep`

- `parPrivateDnsZones` default value changed to an empty array (`[]`)
    - Only enter values in here if you want to override the defaults in the underlying AVM pattern module. See: https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/network/private-link-private-dns-zones#parameter-privatelinkprivatednszones
- `parPrivateDnsZoneAutoMergeAzureBackupZone` removed from module
- `parVirtualNetworkResourceIdsToLinkTo` added to module
- The value returned in `outPrivateDnsZones` has changed

**From:**

```
[
  {
    "name": "privatelink.api.azureml.ms",
    "id": "/subscriptions/<subID>/resourceGroups/<rgID>/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
  },
  {
    "name": "privatelink.notebooks.azure.net",
    "id": "subscriptions/<subID>/resourceGroups/<rgID>/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
  },
  …
]
```

**To:**
```
[
  {
    "pdnsZoneName": "privatelink.api.azureml.ms",
    "virtualNetworkResourceIdsToLinkTo": [
      "/subscriptions/<subID>/resourceGroups/<rgID>/providers/Microsoft.Network/virtualNetworks/alz-hub-uksouth"
    ]
  },
  {
    "pdnsZoneName": "privatelink.notebooks.azure.net",
    "virtualNetworkResourceIdsToLinkTo": [
      "/subscriptions/<subID>/resourceGroups/<rgID>/providers/Microsoft.Network/virtualNetworks/alz-hub-uksouth"
    ]
  },
  …
]
```
