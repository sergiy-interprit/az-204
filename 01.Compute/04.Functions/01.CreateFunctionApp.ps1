<# 
=======================================================================================
ADDITIONAL INFO
=======================================================================================

--------------------------------------------------------------------
Create Function App in Azure Portal
--------------------------------------------------------------------
- Create a resource > search for "Function App" > Create:
	> Subscription
	> Resource Group
	> Function App name = [unique].azurewebsites.net
	> Publish = Code, Docker Container
	> Runtime stack = .NET Core, Node.js (JavaScript)
	> Region = North Europe
	> Storage account = (New) storageaccountaz2048535
	> Operating System = Linux, Windows
	> Plan = Consumption (Serverless), App service plan, Premium
	> Enable App Insights = No, Yes
	> App Insights = (New) az204-pluralsight (North Europe)

--------------------------------------------------------------------
Adding new Functions in Azure Portal
--------------------------------------------------------------------
[HTTP Trigger]
- Function App > Functions > Add > enter below > Create
	> Templates = HTTP Trigger
	> New Function = HttpTrigger1
	> Authroization level = Function

[Timer Trigger]
- Function App > Functions > Add > enter below > Create
	> New Function = TimerTrigger1
	> Schedule = 0 */5 * * * * (every 5 min)
	> CRON expression format = {second} {minute} {hour} {day} {month} {day of week}
	> Overview tab - Disable function from running

[Blob Trigger]
- Function App > Functions > Add > enter below > Create
	> Template: Azure Blob Storage Trigger
		New Function = BlobTrigger1
		Path = samples-workitems/{name}
			{name} is a binding expression. Allows function access name of the file that triggered the function.
		Storage account connection = AzureWebJobsStorage

--------------------------------------------------------------------
Testing new Function in Azure Portal
--------------------------------------------------------------------
[HTTP Trigger]
- Open Function > Code + Test:
	> Edit source code (e.g. index.js)
	> Get function Url
	> Test/Run option
		HTTP Method = POST
		Key = master (Host key)
		Query - Add query params
		Headers - Add headers
		Body - Specify JSON request payload. e.g. { "name": "Azure" }
		Click Run
		Check Logs

[Blob Trigger]
- Open Storage account > Storage Explorer > Blob containers > samples-workitems:
	> Click Upload > select text.txt > click Upload
	> Check Function > Monitor tab > note all Invocation Traces (may be delayed by 5 min)
	> Navigate to each invocation to see detailed message logs

--------------------------------------------------------------------
View and Modify Function Files in Azure Portal
--------------------------------------------------------------------
[Code]
- Function App > Functions BlobTrigger1 > Code + Test > "select index.js" code file
	> Mainly used for Testing purposes only
	> Production functions are typically build/tested locally (e.g. using Visual Studio 2022) and deployed as a compiled package (i.e. Can't edit code in Azure Portal)

[Bindings]
- Code + Test > HttpTrigger1 > select "function.json" bindings file
	> Defines the trigger:
		authLevel = function
		type = httpTrigger
		direction = In
		name = req
		methods = get, post
	> Define response:
		type = http
		direction = out
		name = res
- Every function has a bindings file (i.e. Trigger and additional bindings)
- Tooling may create a bindings file
- Sometimes may need to modify the bindings file manually
#>