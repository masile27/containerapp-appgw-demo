# Azure Application Gateway + Container Apps Demo

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmasile27%2Fcontainerapp-appgw-demo%2Fmain%2Fazuredeploy.json)

Demo showing how Azure Application Gateway routes traffic to Container Apps with Workload Profiles v2 running a containerized web application.

## What This Creates

- **Application Gateway** - Routes incoming HTTP traffic
- **Container Apps Environment** - Workload Profiles v2 with dedicated compute
- **Demo Web Application** - Simple containerized web app for testing
- **Virtual Network** - Secure networking between components
- **Container Registry** - Stores container images
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

After deployment, get your Application Gateway's public IP and test the connection:

```bash
# Get the public IP from Azure portal, then test:
curl http://YOUR-APP-GATEWAY-IP/

# Or visit in your browser:
# http://YOUR-APP-GATEWAY-IP/
```

You should see the nginx welcome page, confirming that:
- ✅ Application Gateway is routing traffic correctly
- ✅ Container App is running and responding  
- ✅ Network connectivity is working between components

## Architecture

This demo creates a complete enterprise-grade setup:
- **Application Gateway** (Standard_v2) with public IP and health probes
- **Container Apps Environment** with Workload Profiles v2 (dedicated compute)
- **Demo container** running on port 80 with auto-scaling (1-5 replicas)
- **Virtual Network** (10.0.0.0/16) with separate subnets for gateway and apps
- **Azure Container Registry** for storing custom images
- **Monitoring stack** with Log Analytics and Application Insights

## Files

- `src/app.py` - Python Flask API
- `infra/` - Bicep templates for Azure resources
- `azuredeploy.json` - ARM template for one-click deploy
- `Dockerfile` - Container image definition
- `.github/workflows/` - GitHub Actions for automated builds

## Container Images

- **Deploy to Azure Button**: Uses `nginx:alpine` for immediate, reliable functionality
- **Custom Development**: Use `azd up` to build and deploy the custom Flask API from `src/app.py`
- **GitHub Actions**: Automatically builds and pushes custom images when you modify source code

The demo works with both images - nginx proves the architecture works reliably, while the custom Flask API shows how to deploy your own applications.

## Cleanup

```bash
az group delete --name rg-containerapp-appgw-demo
```