<# 
This script can be executed locally on Developer Workstation or Azure Cloud Shell.

Web References:
https://learn.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest
#>

#Login to Azure
az login

#Set correct Azure Subscription
az account set --subscription "771d7418-66ab-4bb2-83bd-09091ebd7691" #Visual Studio Enterprise Subscription – MPN

#Show current Azure Subscription
az account show

#Show current Resource Groups
az group list --output table

#=======================================================================================
#Create a Web App with Azure CLI
#=======================================================================================

#--------------------------------------------------------------------
#STEP 1: Create Resource Group (if needed)
#--------------------------------------------------------------------
az group create `
    --name "rg-az204-appsvc" `
    --location "australiaeast"

#--------------------------------------------------------------------
#STEP 2: Create App Service Plan (Linux)
#--------------------------------------------------------------------
az appservice plan create `
    --name asp-webapp-sn `
    --resource-group rg-az204-appsvc `
    --sku s1 `
    --is-linux

#NOTE: Different App Service command parameters are available to create ASE!

#--------------------------------------------------------------------
#STEP 3: Create App Service
#--------------------------------------------------------------------
az webapp create `
    -g rg-az204-appsvc `
    -p asp-webapp-sn `
    -n appsvc-webapp-sn `
    --runtime "NODE:18-lts"

#NOTE: Run the following commands to get a list of supported Linux runtimes (JavaScript code on server-side)
az webapp list-runtimes --os-type linux

#Cleanup resource group
az group delete --name "rg-az204-appsvc" --yes --no-wait

<# 
=======================================================================================
ADDITIONAL INFO
=======================================================================================

--------------------------------------------------------------------
Create Web App with PowerShell
--------------------------------------------------------------------
- Open Azure Cloud Shell (PowerShell) in Azure Portal (already authenticated) and run these commands:
    cd $home
    clear
    $webappname = "mywebapp$(Get-Random)"
    $rgname = 'webapps3-dev-rg'
    $location = 'westus2'
    New-AzResourceGroup -Name $rgname -Location $location
    New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName $rgname -Tier S1
    New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname -ResourceGroupName $rgname

--------------------------------------------------------------------
Create Web App with ARM Template
--------------------------------------------------------------------
- Native Azure solution
- Templates Library > Deploy a basic Linux web app > click "Deploy to Azure"
- Alternatively deploy template from Azure Cloud Shell command line:
    PowerShell:
        New-AzResourceGroup -Name [RgName] -Location [RgLoc]
        New-AzResourceGroupDeployment -ResourceGroupName [RgName] -TemplateUri [TemplateUri]
    Bash:
        az group create
            --name [RgName]
            --location [RgLoc]
        az group deployment create
            --resource-group [RgName]
            --template-uri [TemplateUri]

#--------------------------------------------------------------------
Web App Deployment Automation Options
#--------------------------------------------------------------------
- Best way for web app deployment is via Infrastructure as Code (IaC) automation
- Typically automated via CI/CD pipeline using:
    > GitHub Actions
    > Azure DevOps Pipelines
#>