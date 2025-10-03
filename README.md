# Azure Application Gateway + Container Apps Demo

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmasile27%2Fcontainerapp-appgw-demo%2Fmain%2Fazuredeploy.json)

Demo showing how Azure Application Gateway routes traffic to Container Apps with Workload Profiles v2 running a Python Flask API.

## What This Creates

- **Application Gateway** - Routes incoming HTTP traffic
- **Container Apps Environment** - Workload Profiles v2 with dedicated compute
- **Python Flask API** - Simple REST API with health endpoints
- **Virtual Network** - Secure networking between components
- **Container Registry** - Stores the container image
- **Monitoring** - Log Analytics and Application Insights

## Quick Deploy

Click the "Deploy to Azure" button above, or use the Azure Developer CLI:

```bash
git clone https://github.com/masile27/containerapp-appgw-demo.git
cd containerapp-appgw-demo
azd auth login
azd up
```


## Testing the Deployment

After deployment, get your Application Gateway's public IP and test the endpoints:

```bash
# Get the public IP from Azure portal, then test:
curl http://YOUR-APP-GATEWAY-IP/
curl http://YOUR-APP-GATEWAY-IP/health
curl http://YOUR-APP-GATEWAY-IP/api/info
```

## What Gets Created

- Application Gateway with public IP
- Container Apps Environment (Workload Profiles v2)
- Python Flask API container
- Virtual Network with secure subnets
- Container Registry for images
- Log Analytics and monitoring

## Files

- `src/app.py` - Python Flask API
- `infra/` - Bicep templates for Azure resources
- `azuredeploy.json` - ARM template for one-click deploy
- `Dockerfile` - Container image definition
- `.github/workflows/` - GitHub Actions for automated builds

## Container Image

- **Deploy to Azure**: Uses `mcr.microsoft.com/azuredocs/aci-helloworld` for immediate functionality
- **Custom Development**: Use `azd up` to build and deploy your custom Flask API
- **GitHub Actions**: Automatically builds custom image when you push changes

## Cleanup

```bash
az group delete --name rg-containerapp-appgw-demo
```