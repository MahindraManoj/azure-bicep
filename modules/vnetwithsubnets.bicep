//This module creates a vnet with 'n' number of subnets in it.

@description('Name of the virtual network to be created')
param virtualNetworkName string
@description('Address space that vnet will have')
param vnetAddressSpace string
@description('Location of the resource(s) deployed')
param resourceLocation string = resourceGroup().location
@description('Subnet(s) that the vnet will have')
param subnetBlock object

// Converts the subnetBlock dictonary object into an array of key value pairs
var subnetValues = items(subnetBlock)

//create vnet with subnets
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: resourceLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    dhcpOptions: {}
    virtualNetworkPeerings: []
    subnets: [for subnet in subnetValues: {
      name: subnet.key
      properties: {
        addressPrefix: subnet.value.addressSpace
        privateEndpointNetworkPolicies: subnet.value.privateEndpointPolicies
        privateLinkServiceNetworkPolicies: subnet.value.privateLinkServicePolicies
        delegations: (!empty(subnet.value.delegations)) ? [
          {
            name: subnet.value.delegations.name
            properties: {
              serviceName: subnet.value.delegations.servicename
            }
          }
        ] : json('null')
        serviceEndpoints: (subnet.value.serviceEndpoints) ? [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ] : json('null')
        serviceEndpointPolicies: []
        routeTable: json('null')
        networkSecurityGroup: json('null')
      }
    }]
  }
}

@description('Resource ID of the virtual Network that was deployed')
output vnetID string = virtualNetwork.id
@description('Address Space of the virtual network that was deployed')
output vnetAddress array = virtualNetwork.properties.addressSpace.addressPrefixes
@description('Resource Ids of the subnets that were deployed')
output deployedSubnets array = [for (subnet, i) in subnetValues : {
  ResourceId: virtualNetwork.properties.subnets[i].id
}]
