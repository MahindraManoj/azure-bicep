// Bicep file to create log analytics workspace inside a resoruce group

@description('Azure region in which the resource needs to be created')
param resourceLocation string

@description('Values for the log analytics resource')
param logAnalyticsWorkspaceBlock object = {
  /*
  name: ''
  sku: '' 
  */
}

// Create log analytics workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceBlock.name
  location: resourceLocation
  properties: {
    sku: {
      name: logAnalyticsWorkspaceBlock.sku
    }
  }
}

//outputs
@description('Resource Id of the log analytics workspace that got created')
output resourceId string = logAnalyticsWorkspace.id
