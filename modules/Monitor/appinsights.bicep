// Bicep module to deploy app insights resource
@description('Azure region in which the resource will be deployed')
param resourceLocation string

@description('App insights block')
param appInsightsValues object /*= { 
  {
    name: ''                      //string
    kind: ''                      //string
    applicationType: ''           //string
    logAnalyticsWorkspaceId: ''   //string
  }
}
*/

//create app insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' =  {
  name: appInsightsValues.name
  location: resourceLocation
  kind: appInsightsValues.kind
  properties: {
    Application_Type: appInsightsValues.applicationType
    WorkspaceResourceId: appInsightsValues.logAnalyticsWorkspaceId
  }
}

//outputs
@description('Resource Id of the application insights')
output appInsightsID string = appInsights.id

@description('Connection string of the application insight')
output appInsightsConnectionString string = appInsights.properties.ConnectionString

@description('Instrumentation key of the application insight')
output appInsightsKey string = appInsights.properties.InstrumentationKey
