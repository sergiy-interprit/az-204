<# 
=======================================================================================
ADDITIONAL INFO
=======================================================================================

--------------------------------------------------------------------
Designing Auto-scaling Rules
--------------------------------------------------------------------
- Leaning on Azure Monitor capabilities
- Autoscale Profile:
	> Capacity Settings - Min, Max, and default values for number of instances
	> Rules - Dictates what happens based on scale conditions
	> Notifications - Ability to receive notifications when scaling out
- Autoscale rule options:
	> Metrics = resource/custom
		Existing metrics from Azure Monitor
		Custom metrics for App Service
	> Time (schedule)
	> When rule fires > execute Actions
		Add/Remove VMs
		Send Email
		Ping Webhook (e.g. Kick off an automated process)

--------------------------------------------------------------------
Configuring Custom Auto-Scale Rules
--------------------------------------------------------------------
- Azure Portal > App Service > Settings > Scale out (App Service plan) > "Custom autoscale":
	> Add auto scale condition:
		Scale mode = Scale based on a metric
		Instance limits = Min (2), Max (4), Default (2)
		
		Add a rule (#1 Scale-out):
			Time aggregation = Average
			Metric namespace = App Service plans standard metrics
			Metric name = CPU Percentage
			Greater than or equal to = 75%
			Duration = 10min (requires tuning to avoid anomalies; not too low or high)
			Increase count by = 2
			Cool down = 5min
		
		Add a rule (#2 Scale-in):
			Less than or equal to = 30%
			Duration = 10min
			Decrease count by = 2
			Cool down = 5min
#>