@description('The environment name. Used for naming resources.')
param environmentName string

@description('Location for all resources.')
param location string

@description('Resource token for unique naming.')
param resourceToken string

@description('Tags to apply to resources.')
param tags object

@description('Subnet ID for Application Gateway')
param subnetId string

@description('Container App FQDN for backend pool')
param containerAppFqdn string

// Public IP for Application Gateway
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-appgw-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'appgw-${environmentName}-${resourceToken}'
    }
  }
}

// Application Gateway
resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: 'appgw-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 1
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'containerAppBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: containerAppFqdn
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'containerAppHttpSettings'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 30
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', 'appgw-${environmentName}-${resourceToken}', 'containerAppHealthProbe')
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'containerAppListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'appgw-${environmentName}-${resourceToken}', 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'appgw-${environmentName}-${resourceToken}', 'port_80')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'containerAppRoutingRule'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', 'appgw-${environmentName}-${resourceToken}', 'containerAppListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'appgw-${environmentName}-${resourceToken}', 'containerAppBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'appgw-${environmentName}-${resourceToken}', 'containerAppHttpSettings')
          }
        }
      }
    ]
    probes: [
      {
        name: 'containerAppHealthProbe'
        properties: {
          protocol: 'Https'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
  }
}

// Outputs
output applicationGatewayName string = applicationGateway.name
output publicIpAddress string = publicIp.properties.ipAddress
output publicFqdn string = publicIp.properties.dnsSettings.fqdn
