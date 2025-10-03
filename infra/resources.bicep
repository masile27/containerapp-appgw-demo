@description('The environment name. Used for naming resources.')
param environmentName string

@description('Location for all resources.')
param location string = resourceGroup().location



// Variables
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
}

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'ai-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'cr${replace(environmentName, '-', '')}${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

// User Assigned Managed Identity
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${environmentName}-${resourceToken}'
  location: location
  tags: tags
}

// ACR Pull Role Assignment
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, userAssignedIdentity.id, '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Network Module
module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    environmentName: environmentName
    location: location
    resourceToken: resourceToken
    tags: tags
  }
}

// Container App Environment and App
module containerApp 'modules/containerapp.bicep' = {
  name: 'containerapp'
  params: {
    environmentName: environmentName
    location: location
    resourceToken: resourceToken
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.id
    applicationInsightsConnectionString: applicationInsights.properties.ConnectionString
    containerRegistryName: containerRegistry.name
    userAssignedIdentityId: userAssignedIdentity.id
    subnetId: network.outputs.containerAppSubnetId
  }
  dependsOn: [
    acrPullRoleAssignment
  ]
}

// Application Gateway
module applicationGateway 'modules/appgateway.bicep' = {
  name: 'appgateway'
  params: {
    environmentName: environmentName
    location: location
    resourceToken: resourceToken
    tags: tags
    subnetId: network.outputs.applicationGatewaySubnetId
    containerAppFqdn: containerApp.outputs.containerAppFqdn
  }
}

// Outputs
output AZURE_LOCATION string = location
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.properties.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.name
output SERVICE_API_IDENTITY_PRINCIPAL_ID string = userAssignedIdentity.properties.principalId
output SERVICE_API_NAME string = containerApp.outputs.containerAppName
output SERVICE_API_URI string = 'https://${containerApp.outputs.containerAppFqdn}'
output APPLICATION_GATEWAY_PUBLIC_IP string = applicationGateway.outputs.publicIpAddress
output RESOURCE_GROUP_ID string = resourceGroup().id
