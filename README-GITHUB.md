# Deploy to Azure - Application Gateway with Container Apps

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2F[YOUR-GITHUB-USERNAME]%2Fcontainerapp-appgw-demo%2Fmain%2Fazuredeploy.json)

This repository demonstrates how an Azure Application Gateway can serve incoming requests to a backend Container App with Workload Profiles (v2) running a Python microservice.

## 🏗️ Architecture

- **Azure Application Gateway**: Frontend load balancer with public IP endpoint
- **Azure Container App**: Workload Profiles v2 (dedicated compute) hosting Python Flask API
- **Virtual Network**: Proper subnet segmentation with security groups
- **Supporting Services**: Container Registry, Log Analytics, Application Insights

## 🚀 Quick Deploy

### Option 1: Deploy to Azure Button
Click the "Deploy to Azure" button above to deploy directly from the Azure Portal.

### Option 2: Azure Developer CLI (azd)
```bash
# Clone the repository
git clone https://github.com/[YOUR-GITHUB-USERNAME]/containerapp-appgw-demo.git
cd containerapp-appgw-demo

# Login and deploy
azd auth login
azd up
```

### Option 3: Azure CLI
```bash
# Clone the repository
git clone https://github.com/[YOUR-GITHUB-USERNAME]/containerapp-appgw-demo.git
cd containerapp-appgw-demo

# Deploy using Azure CLI
az group create --name rg-containerapp-appgw-demo --location eastus
az deployment group create \
  --resource-group rg-containerapp-appgw-demo \
  --template-file azuredeploy.json \
  --parameters environmentName=demo location=eastus
```

## 🧪 Testing the Deployment

After deployment, you'll receive:
- **Application Gateway Public IP**: Use this to access your application
- **Application Gateway FQDN**: Alternative public endpoint

### Test Commands:
```bash
# Replace <PUBLIC-IP> with your Application Gateway IP
curl http://<PUBLIC-IP>/
curl http://<PUBLIC-IP>/health
curl http://<PUBLIC-IP>/api/info
curl http://<PUBLIC-IP>/api/data
```

### API Endpoints:
- `GET /` - Home page with service information
- `GET /health` - Health check endpoint (used by Application Gateway probe)
- `GET /api/info` - API information and available endpoints  
- `GET /api/data` - Sample data endpoint

## 📁 Repository Structure

```
├── azuredeploy.json           # ARM template for "Deploy to Azure" button
├── azuredeploy.parameters.json # Default parameters for ARM template
├── azure.yaml                 # Azure Developer CLI configuration
├── Dockerfile                 # Container image definition
├── src/
│   ├── app.py                 # Python Flask microservice
│   └── requirements.txt       # Python dependencies
├── infra/                     # Infrastructure as Code (Bicep)
│   ├── main.bicep             # Main deployment template
│   ├── main.parameters.json   # Deployment parameters
│   ├── resources.bicep        # Azure resources definition
│   └── modules/
│       ├── network.bicep      # Virtual network and security groups
│       ├── containerapp.bicep # Container App Environment and App
│       └── appgateway.bicep   # Application Gateway configuration
└── README.md                  # This file
```

## 🔧 Key Features

### Container App Configuration
- **Workload Profiles v2**: Uses dedicated compute (GeneralPurpose D4)
- **Auto-scaling**: 1-5 replicas based on HTTP request load
- **Health Probes**: Liveness and readiness probes on `/health` endpoint
- **Managed Identity**: Secure access to Container Registry

### Application Gateway Configuration  
- **Public Endpoint**: Internet-facing load balancer
- **Health Monitoring**: Continuous health checks on backend Container App
- **Load Balancing**: Distributes traffic to Container App instances
- **Network Integration**: Secure communication within VNet

### Security Features
- **Managed Identity**: No hardcoded credentials
- **Network Segmentation**: Separate subnets for App Gateway and Container Apps
- **Security Groups**: Controlled network access between components
- **HTTPS Backend**: Encrypted communication to Container App

## 📊 Monitoring and Logging

- **Application Insights**: Application performance monitoring and telemetry
- **Log Analytics**: Centralized logging for all components  
- **Health Probes**: Application Gateway monitors backend health

## 🛠️ Customization

### Environment Variables
Configure these parameters during deployment:

- `environmentName`: Environment name (default: demo)
- `location`: Azure region (default: eastus)

### Scaling Configuration
Modify auto-scaling rules in `infra/modules/containerapp.bicep`:

```bicep
scale: {
  minReplicas: 1
  maxReplicas: 5
  rules: [
    {
      name: 'http-scaler'
      http: {
        metadata: {
          concurrentRequests: '50'
        }
      }
    }
  ]
}
```

## 🔍 Troubleshooting

### Check deployment status:
```bash
az deployment group show --resource-group <resource-group-name> --name <deployment-name>
```

### View Container App logs:
```bash
az containerapp logs show --name <container-app-name> --resource-group <resource-group-name>
```

### Check Application Gateway backend health:
```bash
az network application-gateway show-backend-health --name <app-gateway-name> --resource-group <resource-group-name>
```

## 🧹 Clean Up

### Using Azure Developer CLI:
```bash
azd down
```

### Using Azure CLI:
```bash
az group delete --name rg-containerapp-appgw-demo --yes --no-wait
```

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Tags

`azure` `container-apps` `application-gateway` `python` `flask` `bicep` `infrastructure-as-code` `workload-profiles` `microservices` `load-balancer`