<# 
This script needs to be executed locally on Developer Workstation.

https://learn.microsoft.com/en-us/azure/container-registry/container-registry-troubleshoot-login
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli#individual-login-with-azure-ad
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
#Create ACR and push Container Image built locally using Docker Tools
#=======================================================================================

#--------------------------------------------------------------------
#STEP 1: Create Resource Group (if needed)
#--------------------------------------------------------------------
az group create `
    --name "rg-az204-acr" `
    --location "australiaeast"

#--------------------------------------------------------------------
#STEP 2: Create an Azure Container Registry
#--------------------------------------------------------------------
$ACR_NAME='acrdemosn'  #NOTE: This needs to be globally unique inside of Azure

az acr create `
    --resource-group "rg-az204-acr" `
    --name $ACR_NAME `
    --sku "Standard"

#NOTE: SKUs include Basic, Standard and Premium (speed, replication, adv security features)

#--------------------------------------------------------------------
#STEP 3: Login to ACR to Push Containers
#--------------------------------------------------------------------
#Enable Admin access (Required for next command)
az acr update -n $ACR_NAME --admin-enabled true

#Login to ACR under current login context (Admin)
az acr login --name $ACR_NAME

# Show ACR Authentication Token
az acr login --name $ACR_NAME --expose-token

#--------------------------------------------------------------------
#STEP 4: Get ACR "loginServer" for use in Container Image Tag
#--------------------------------------------------------------------
$ACR_LOGINSERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
echo $ACR_LOGINSERVER
#Example output: acrdemosn.azurecr.io

#--------------------------------------------------------------------
#STEP 5: Create new Container Image Tag using ACR "loginServer"
#--------------------------------------------------------------------
docker tag webappimage:v1 $ACR_LOGINSERVER/webappimage:v1

#Verify latest tags
docker image ls $ACR_LOGINSERVER/webappimage:v1
docker image ls

#--------------------------------------------------------------------
#STEP 6: Push new Container Image Tag to ACR
#--------------------------------------------------------------------
docker push $ACR_LOGINSERVER/webappimage:v1

#--------------------------------------------------------------------
#STEP 7: List repositories and images/tags in ACR
#--------------------------------------------------------------------
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table

#=======================================================================================
#ALTERNATIVE: Build and push Container Image using ACR Tasks
#=======================================================================================
#NOTE: We don't have to build locally then push, we can build in ACR with Tasks.

#Navigate to folder with Dockerfile and Web App
cd "C:\Projects\Personal\AZ-204\01.Compute\02.Container"

#Use ACR build to build our image in azure and then push that into ACR
az acr build --image "webappimage:v1-acr-task" --registry $ACR_NAME .

#Both images should be there now, the one we built locally and the one build with ACR tasks
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table

#Cleanup resource group
az group delete --name "rg-az204-acr" --yes --no-wait