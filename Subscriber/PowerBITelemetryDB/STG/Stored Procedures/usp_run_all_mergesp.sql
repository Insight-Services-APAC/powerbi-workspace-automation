CREATE PROCEDURE [STG].[usp_run_all_mergesp]

AS

BEGIN
	EXEC [STG].[usp_merge_ActivityLogs]
	EXEC [STG].[usp_merge_Dashboards]
	EXEC [STG].[usp_merge_Datasets]
	--EXEC [STG].[usp_merge_DataSources]
	EXEC [STG].[usp_merge_Reports]
	EXEC [STG].[usp_merge_Workspaces]
	EXEC [STG].[usp_merge_Capacities]
	EXEC [STG].[usp_merge_Gateway]
	EXEC [STG].[usp_merge_GatewayDataSource]
	EXEC [STG].[usp_merge_CapacityWorkloads]
	EXEC [STG].usp_merge_GatewayDataSourceStatus
END
