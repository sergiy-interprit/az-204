<# 
This script can be executed locally on Developer Workstation or Azure Cloud Shell.

Microsoft Documentation References:
https://learn.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest
https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions
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
#Create and configure Virtual Machine in Azure
#=======================================================================================

#--------------------------------------------------------------------
#STEP 1: Create Resource Group (if needed)
#--------------------------------------------------------------------
az group create `
    --name "rg-az204-vm" `
    --location "australiaeast"

#--------------------------------------------------------------------
#STEP 2: Create Virtual Machine
#--------------------------------------------------------------------
az vm create `
    --resource-group "rg-az204-vm" `
    --name "vm-win-demo-sn" `
    --image "win2022datacenter" `
    --admin-username "vmadmin" `
    --admin-password "Complex_P4ss2023#!"

<# NOTE:
Default VM Size: Standard DS1 v2 (1 vcpu, 3.5 GiB memory)
Default Open RDP Port: 3389
#>

#--------------------------------------------------------------------
#STEP 3: Open Port for RDP (if needed)
#--------------------------------------------------------------------
az vm open-port `
    --resource-group "rg-az204-vm" `
    --name "vm-win-demo-sn" `
    --port "3389"

#--------------------------------------------------------------------
#STEP 4: Show Public IP Address
#--------------------------------------------------------------------
az vm list-ip-addresses `
    --resource-group "rg-az204-vm" `
    --name "vm-win-demo-sn"

#Cleanup resource group
az group delete --name "rg-az204-vm" --yes --no-wait