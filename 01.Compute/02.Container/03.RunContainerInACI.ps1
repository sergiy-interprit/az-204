<# 
This script can be executed locally on Developer Workstation or Azure Cloud Shell.
#>

#=======================================================================================
#Deploy Container from ACR (Private Registry) with Authentication
#=======================================================================================

#--------------------------------------------------------------------
#STEP 1: Create Resource Group (if needed)
#--------------------------------------------------------------------
az group create `
    --name "rg-az204-aci" `
    --location "australiaeast"

#--------------------------------------------------------------------
#STEP 2: Obtain ACR ID and LoginServer for Service Principal
#--------------------------------------------------------------------
$ACR_NAME='acrdemosn'
$ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
$ACR_LOGINSERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)

#Verify
echo "ACR ID: $ACR_REGISTRY_ID"
echo "ACR Login Server: $ACR_LOGINSERVER"

#--------------------------------------------------------------------
#STEP 3: Create Service Principal to Pull Images from ACR
#--------------------------------------------------------------------
$SP_PASSWD=$(az ad sp create-for-rbac `
    --name http://$ACR_NAME-pull `
    --scopes $ACR_REGISTRY_ID `
    --role acrpull `
    --query password `
    --output tsv)

$SP_APPID=$(az ad sp list `
    --display-name http://$ACR_NAME-pull `
    --query '[].appId' `
    --output tsv)

#NOTE: Key Vault Secrets can be used instead of environment variables for secure access and reuse

#Verify
echo "Service principal ID: $SP_APPID"
echo "Service principal password: $SP_PASSWD"

#--------------------------------------------------------------------
#STEP 4: Create Container in ACI via Service Principal
#--------------------------------------------------------------------
az container create `
    --resource-group "rg-az204-aci" `
    --name cntr-webapp-sn `
    --dns-name-label cntr-webapp-sn `
    --ports 80 `
    --image $ACR_LOGINSERVER/webappimage:v1 `
    --registry-login-server $ACR_LOGINSERVER `
    --registry-username $SP_APPID `
    --registry-password $SP_PASSWD 

#NOTE: Last three parameters can be omitted if ACR has no Auth enabled

#Confirm container is running (i.e. See instanceView.state)
az container show --resource-group rg-az204-aci --name cntr-webapp-sn

#--------------------------------------------------------------------
#STEP 5: Test Web App running in Container
#--------------------------------------------------------------------
#Get Container FQDN
$WebAppBaseUrl=$(az container show --resource-group rg-az204-aci --name cntr-webapp-sn --query ipAddress.fqdn --output tsv) 
echo $WebAppBaseUrl

#Test Web App
curl $WebAppBaseUrl/test

#Pull logs from running Container
az container logs --resource-group rg-az204-aci --name cntr-webapp-sn

#--------------------------------------------------------------------
#STEP 6: Delete running Container
#--------------------------------------------------------------------
az container delete `
    --resource-group rg-az204-aci `
    --name cntr-webapp-sn `
    --yes

#=======================================================================================
#Deploy Container from Public Registry
#=======================================================================================

#--------------------------------------------------------------------
#STEP 1: Create Container with unique DNS Name Label
#--------------------------------------------------------------------
az container create `
    --resource-group rg-az204-aci `
    --name cntr-hello-world-sn `
    --dns-name-label cntr-hello-world-sn `
    --image mcr.microsoft.com/azuredocs/aci-helloworld `
    --ports 80

#Confirm container is running (i.e. See instanceView.state)
az container show --resource-group 'rg-az204-aci' --name 'cntr-hello-world-sn' 

#--------------------------------------------------------------------
#STEP 2: Test Web App running in Container
#--------------------------------------------------------------------
#Get Container FQDN
$URL=$(az container show --resource-group 'rg-az204-aci' --name 'cntr-hello-world-sn' --query ipAddress.fqdn --output tsv) 
echo "http://$URL"

#Test Web App (curl and Web Browser)
curl $URL

#--------------------------------------------------------------------
#STEP 3: Delete running Container
#--------------------------------------------------------------------
az container delete `
    --resource-group rg-az204-aci `
    --name cntr-hello-world-sn `
    --yes

#Cleanup resource groups
az group delete --name "rg-az204-acr" --yes --no-wait
az group delete --name "rg-az204-aci" --yes --no-wait

#Delete local container images
docker image rm psdemoacr.azurecr.io/webappimage:v1
docker image rm webappimage:v1

<# 
#=======================================================================================
ADDITIONAL INFO
#=======================================================================================

--------------------------------------------------------------------
Container Restart Policy
--------------------------------------------------------------------
- Always (default): If App inside container stops for any reason
- On Failure: If App inside container fails. If the App exits gracefully then container will be stopped and not restarted
- Never: If container stops (gracefully or error) then container will not be restarted

--------------------------------------------------------------------
Deploying Containers in ACI from Container Registries
--------------------------------------------------------------------
- Azure Container Registry (ACR)
- Docker Hub or other container registries
- Public or private container registries
- Public: No Authentication required
- Private: Not attached to Internet
- ACR requires Authentication by default
- Login server and Username/password with appropriate RBAC required to "pull" image from ACR
#>