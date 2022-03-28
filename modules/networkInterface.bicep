//This module crates a vNIC that can be associated to a vm in Azure

@description('Name prefix of the vNIC')
param vNicName string
@description('Location of the resource being deployed')
param resourceLocation string = resourceGroup().location
@description('Virtual Network that will be used by the vNIC')
param vNicVnetName string
@description('Resource Group where the vnet was deployed')
param vnetRG string
@description('Subnet where the primary vNic will be deployed')
param vNicPrimarySubnet string
@description('Subnet where the secondary vNIC will be deployed')
param vNicSecondarySubnet string
@description('Size of the virtual machine to which the vNIC will be attached')
param vmSize string

// Resource Id of the subnet that the vNIC will use
resource pVnicSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vNicVnetName}/${vNicPrimarySubnet}'
  scope: resourceGroup(vnetRG)
}

resource sVnicSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = if(!empty(vNicSecondarySubnet)) {
  name: '${vNicVnetName}/${vNicSecondarySubnet}'
}

// Crate network interface
resource vNic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: vNicName
  location: resourceLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: empty(vNicSecondarySubnet) ? pVnicSubnet.id : sVnicSubnet.id
          }
        }
      }
    ]
    enableAcceleratedNetworking: (empty(vNicSecondarySubnet) && ((vmSize != 'Standard_B2ms') || (vmSize != 'Standard_B4ms') || (vmSize != 'Standard_B8ms'))) ? true : false
  }
}
//outputs from this module
output vNicResourceId string = vNic.id
