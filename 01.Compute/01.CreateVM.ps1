#Login if required
az login
az account set --subscription "771d7418-66ab-4bb2-83bd-09091ebd7691" #Visual Studio Enterprise Subscription – MPN
az account show
az group list --output table

#STEP 1: Create a resource group if needed
az group create `
    --name "rg-az204-vm" `
    --location "australiaeast"