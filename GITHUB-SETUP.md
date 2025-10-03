# GitHub Repository Setup Instructions

## 📋 Steps to Create Your Public GitHub Repository

### 1. Create Repository on GitHub
1. Go to [GitHub](https://github.com) and sign in
2. Click **"New repository"** or go to [https://github.com/new](https://github.com/new)
3. Configure your repository:
   - **Repository name**: `containerapp-appgw-demo`
   - **Description**: `Azure Application Gateway with Container Apps - Workload Profiles v2 Demo`
   - **Visibility**: ✅ **Public** (required for Deploy to Azure button)
   - **Initialize**: ❌ Don't check any boxes (we'll push existing code)

### 2. Push Your Code to GitHub

```bash
# Navigate to your project directory
cd "C:\Users\marcelosiles\OneDrive - Microsoft\Documents\PTA - marcelosiles\Labs\ContainerAppWithAppGW"

# Initialize git repository
git init

# Add all files
git add .

# Commit your code
git commit -m "Initial commit: Azure Application Gateway + Container Apps demo"

# Add your GitHub repository as remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/containerapp-appgw-demo.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 3. Update README with Your GitHub Username

After creating the repository, update the Deploy to Azure button URL in your README files:

**Replace in README-GITHUB.md and README-ENHANCED.md:**
```
[YOUR-GITHUB-USERNAME] → YourActualGitHubUsername
```

The Deploy to Azure button URL should become:
```
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FYourActualGitHubUsername%2Fcontainerapp-appgw-demo%2Fmain%2Fazuredeploy.json
```

### 4. Choose Your Preferred README

You have three README options:

1. **README.md** (current) - Basic documentation
2. **README-GITHUB.md** - GitHub-optimized with Deploy button
3. **README-ENHANCED.md** - Enhanced with badges, diagrams, and detailed docs

**Recommendation**: Use README-ENHANCED.md for maximum impact:

```bash
# Replace the basic README with the enhanced version
mv README.md README-original.md
mv README-ENHANCED.md README.md
git add README.md
git commit -m "Update to enhanced README with Deploy to Azure button"
git push
```

### 5. Repository Features to Enable

After creating the repository:

1. **Go to Settings → General**:
   - ✅ Enable Issues
   - ✅ Enable Projects  
   - ✅ Enable Wiki

2. **Go to Settings → Pages** (optional):
   - Enable GitHub Pages from main branch for documentation

3. **Add Topics** (in main repository page):
   - Click ⚙️ next to "About"
   - Add topics: `azure`, `container-apps`, `application-gateway`, `python`, `flask`, `bicep`, `infrastructure-as-code`

### 6. Test the Deploy to Azure Button

1. Go to your repository on GitHub
2. Click the "Deploy to Azure" button in the README
3. Verify it redirects to Azure Portal with your template loaded
4. Test the deployment process

### 7. Optional: Set up GitHub Actions (Advanced)

If you want automated deployments, set up the GitHub Actions workflow:

1. **Go to Settings → Secrets and variables → Actions**
2. **Add repository secret** `AZURE_CREDENTIALS` with your Azure service principal:

```json
{
  "clientId": "your-client-id",
  "clientSecret": "your-client-secret", 
  "subscriptionId": "your-subscription-id",
  "tenantId": "your-tenant-id"
}
```

3. The workflow in `.github/workflows/deploy.yml` will automatically deploy on pushes to main

## 🎯 Final Repository Structure

Your public repository will contain:
```
containerapp-appgw-demo/
├── 📄 README.md                      # Main documentation with Deploy button
├── 📄 azuredeploy.json               # ARM template for Azure deployment  
├── 📄 azuredeploy.parameters.json    # Default parameters
├── 📄 azure.yaml                     # Azure Developer CLI config
├── 📄 Dockerfile                     # Container configuration
├── 📄 LICENSE                        # MIT License
├── 📁 src/                           # Python Flask API source
├── 📁 infra/                         # Infrastructure as Code (Bicep)
├── 📁 .github/workflows/             # GitHub Actions (optional)
└── 📄 .gitignore                     # Git ignore rules
```

## ✅ Verification Checklist

- [ ] Repository is public
- [ ] Deploy to Azure button works and loads your template
- [ ] README displays correctly with badges and documentation  
- [ ] All source code and infrastructure files are present
- [ ] License file is included
- [ ] Repository has appropriate topics/tags
- [ ] Button URL contains your correct GitHub username

## 🎉 Ready to Share!

Once completed, your repository will be ready for:
- ⭐ Starring and sharing with the community
- 🚀 One-click deployments via Deploy to Azure button  
- 🔄 Community contributions and improvements
- 📖 Documentation and learning resource
- 💼 Portfolio showcase of Azure architecture skills

Your public repository will demonstrate enterprise-grade Azure architecture with modern DevOps practices!