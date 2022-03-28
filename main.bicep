// Bicep config file to set up things in Azure
targetScope = 'subscription'

param resourceLocation string = deployment().location

param resourceGroupBlock object

param virtualNetworkName string 

param virtualNetworkAddressPrefix string

param subnetBlock object

param vmAvailabilitySetName string

param vmSize string = 'Standard_B2ms'

param vmValues object

param vmAdminUsername string = 'vmlocadmin'

@secure()
param vmAdminPassword string


module rg 'modules/resourcegroup.bicep' = {
  scope: subscription('Pay-As-You-Go')
  name: 'resourceGroup'
  params: {
    resourceGroupBlock: resourceGroupBlock
  }
}

module vnetSnet 'modules/vnetwithsubnets.bicep' = {
  scope: resourceGroup(resourceGroupBlock.name)
  name: 'virtualNetwork'
  params: {
    resourceLocation: resourceLocation
    virtualNetworkName: virtualNetworkName
    vnetAddressSpace:  virtualNetworkAddressPrefix
    subnetBlock: subnetBlock
  }
}

module vm 'modules/virtualmachine.bicep' = {
  name: 'vm'
  scope: 
  params: {
    vmAdminPassword: vmAdminPassword  
    vmAdminUsername: vmAdminUsername
    vmSize: vmSize
    vmValues: vmValues
    resourceLocation: resourceLocation
    availabilitySetName: vmAvailabilitySetName
  }
}
