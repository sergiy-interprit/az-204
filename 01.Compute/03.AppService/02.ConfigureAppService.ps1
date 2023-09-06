<# 
=======================================================================================
ADDITIONAL INFO
=======================================================================================

--------------------------------------------------------------------
Configuring a Custom Domain in Azure Portal
--------------------------------------------------------------------
- Azure Portal > Resource Group > Create a resource > search for "App Service Domain" (e.g. theazurelab.org)
	> This will also create public "DNS zone" resource (e.g. theazurelab.org)
	> This is critical to map a Domain Name record to our App Service
- Creating above using "Create a resource" is not necessary but is helpful to visualize resources involved
- Navigate to App Service > Settings > Custom domains > note:
	> IP address
	> Custom Domain Verification ID
- Click "Add custom domain" > enter "www.theazurelab.org" > click Validate
	> Azure uses public DNS to prove that you own the specified domain
	> Copy CNAME (e.g. pluralsight110820.azurewebsites.net)
	> Copy Custom Domain Verification ID (e.g. 288ABC)
- Navigate to created "DNS zone" resource > click "Add record set"
	> Enter Name as "www" (i.e. URL extension should show ".theazurelab.org")
	> Select Type as "CNAME"
	> Set Alias to "pluralsight110820.azurewebsites.net" from CNAME copied earlier
	> Click OK
- Click "Add record set" again
	> Enter Name as "asuid.www"
	> Select Type as "TXT"
	> Set Value as "288ABC" from Custom Domain Verification ID copied earlier
	> Click OK
	> This record will be queried by App Service to prove that you own the domain
- Go back to App Service > Custom domains > Add a custom domain pane > click "Add custom domain" at the bottom
- Refresh the page and note any warnings to "Add binding" to secure your custom domains
- Scroll down to "Status Filder" > click "Add binding"

--------------------------------------------------------------------
Configure a TLS/SSL Binding in Azure Portal
--------------------------------------------------------------------
- Navigate to App Service > Settings > TLS/SSL settings > Bindings tab
- Under Protocol Settings
	> Set HTTP Only = On
	> Set Minimum TLS Version = 1.2
- Note "Private Key Certificates (.pfx)" tab > Private Key Certificate section:
	> Import App Service Certificate - Select "App Service Certificate" resource created similarly to "App Service Domain" resource
	> Upload Certificate - Your own .PFX
	> Import Key Vault Certificate - Select .PFX from Key Vault
	> Create App Service Managed Certificate - Newest option. Gives you free SSL certificate for your App Service
- Click Create Managed App Service Certificate:
	> Ensure your custom domain (e.g. www.theazurelab.org) is selected
	> Click Create
- Go back to "Bindings" tab > TLS/SSL bindings section > click "Add TLS/SSL Binding":
	> Custom domain = www.theazurelab.org
	> Private Certificate Thumbprint = [Choose certificate]
	> TLS/SSL Type = SNI SSL
		IP Based SSL
		SNI SSL = Server Name Indication - Run multiple SSL certificates per multiple domains on same IP Address
	> Click Add Binding
- Go to App Service Overview > URL > ensure it is updated to "https://www.theazurelab.org" > click and verify the link > click on Lock icon to example the SSL certificate

--------------------------------------------------------------------
Configuring a Database Connection String in Azure Portal
--------------------------------------------------------------------
- Create SQL Database
	> Subscription
	> Resource Group
	> Database name = sales
	> Server = Create new:
		Server name = ps1108 (extension will be ".database.windows.net")
		Server admin login = dbadmin
		Password = abc123!
		Location = (US) West US 2 (same as Web App)
		Click OK
	> Want to use SQL elastic pool? = No
	> Compute + storage = Basic (5 DTUs, 2 GB)
	> Review + create
	> Navigate to SQL database > Overview > Connection strings > click "Show database connection strings" > copy the value

- Configure App Service
	> A common task for Web Apps to prevent hard-coding environment specific configuration
	> [App Service Web App] > Connection String: SQLServerDB > [Azure SQL Database]
	> Navigate to App Service > Configuration tab > Connection strings section
		Click "New connection string"
		Enter Name as "SqlServerConnect"
		Enter Value = Paste value copied earlier and specify password
		Select Type as "SQLAzure"
		Click OK
		Click Save
		This approach will securely store the connection string
		Alternatively, a connection sting can be mapped to Azure Vault secret (advanced scenario)
	> This setting will be available as Environment Variable in memory, which can be queried by app code, resolving to actual SQL Connection String value

NOTE:
Developer working locally can set "SQLServerDB" environment variable to point to local Dev Database

--------------------------------------------------------------------
Enable Diagnostic Logging in Azure Portal
--------------------------------------------------------------------
- Open App Service > Monitoring > App Service Logs
	> Application Logging (Filesystem, Blob) = Off or On
	> Web Server logging (Storage, File System) = Off or On
		If File System:
			Quota = 35 MB
			Retention Period (Days) = 30
		If Storage:
	> Storage account
		Retention Period (Days) = 30
	> Detailed error messages = Off or On
	> Failed request tracing = Off or On
	> Download logs (FTP, FTPS)
		From "File System"

--------------------------------------------------------------------
Setup CI / CD for App Service in Azure Portal
--------------------------------------------------------------------
- App Service > Deployment > Deployment Center
- 3 Steps:
	> Source Control - Where to get the code
	> Build Provider - Which service will compile the code
	> Configure - Other CI/CD settings
- Continuous Deployment (CI / CD) options:
	> Azure Repos
	> GitHub (this demo)
	> Bitbucket
	> Local Git
- Manual Deployment (push / sync) options:
	> OneDrive
	> Dropbox
	> External
	> FTP

- Login to GitHub Repo: https://github.com/mikepfeiffer/aspnetcore3.1
	> This is a standard template from .NET Core
- Back on App Service > Deployment > CI /CD > GitHub > click Authorize > This should pick-up existing Auth Token
- Click Continue > select Build Service (3 options below)
	> App Service build service (Kudu engine) - Selected
	> GitFlow Actions
	> Azure Pipelines
- Click Configure > set below > Continue > Finish
	> Organization = mikepfeiffer
	> Repository = aspnetcore3.1
	> Branch = main
- Check Status of last deployment (Commit, Time, etc.)
- Updating a repo file in GitHub should automatically kick off a new deployment
#>