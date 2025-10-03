@description('The environment name. Used for naming resources.')
param environmentName string

@description('Location for all resources.')
param location string

@description('Resource token for unique naming.')
param resourceToken string

@description('Tags to apply to resources.')
param tags object

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-appgateway'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: applicationGatewayNsg.id
          }
        }
      }
      {
        name: 'snet-containerapp'
        properties: {
          addressPrefix: '10.0.2.0/23'
          delegations: [
            {
              name: 'Microsoft.App.environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
          networkSecurityGroup: {
            id: containerAppNsg.id
          }
        }
      }
    ]
  }
}

// Network Security Group for Application Gateway
resource applicationGatewayNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-appgateway-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          description: 'Allow Azure infrastructure communication'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTPInbound'
        properties: {
          description: 'Allow HTTP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTPSInbound'
        properties: {
          description: 'Allow HTTPS traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Network Security Group for Container App
resource containerAppNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-containerapp-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowApplicationGatewayInbound'
        properties: {
          description: 'Allow traffic from Application Gateway subnet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Outputs
output virtualNetworkId string = virtualNetwork.id
output applicationGatewaySubnetId string = virtualNetwork.properties.subnets[0].id
output containerAppSubnetId string = virtualNetwork.properties.subnets[1].id
