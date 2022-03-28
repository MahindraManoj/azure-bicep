param appServicePlanBlock object = {
  /*name: ''
  location: resourceGroup().location
  sku: {
    name: ''
    tier: ''
  }
  properties: {
    maximumElasticWorkerCount: ''
  }*/
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanBlock.name
  location: appServicePlanBlock.location
  sku: {
    name: appServicePlanBlock.sku.name
    tier: appServicePlanBlock.sku.tier
  }
  properties: appServicePlanBlock.properties
}
