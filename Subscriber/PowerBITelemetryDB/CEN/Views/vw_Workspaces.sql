


CREATE View [CEN].[vw_Workspaces]
AS

WITH DashboardApps AS
(
	SELECT Distinct Workspace_ID 
	FROM CEN.Dashboards
	WHERE SUBSTRING(TRIM([DisplayName]),1,5) = '[App]'
)
,ReportApps as
(
	SELECT Distinct Workspace_ID 
	FROM CEN.Reports
	WHERE SUBSTRING(TRIM([Name]),1,5) = '[App]'
)
,Apps as
(
	SELECT DISTINCT Workspace_ID 
	FROM
	(
		SELECT Workspace_ID FROM DashboardApps
		UNION ALL
		SELECT Workspace_ID FROM ReportApps
	) as a
)

Select  W.[Workspace_Id]  
       ,[Name]  
       ,[IsReadOnly]  
       ,[IsOnDedicatedCapacity]  
       ,[CapacityId]  
       ,[Description]  
       ,[Type]  
       ,[State]
       ,[IsOrphaned]  
       ,[Users]  
       ,[Reports]  
       ,[Dashboards]  
       ,[Datasets]  
       ,[Dataflows]  
       ,[Workbooks]  
	   ,CASE WHEN A.Workspace_ID is NULL THEN 0
	         ELSE 1
		END as HasApp
       ,CAST([DateRetrieved] AS DATETIME2) AS DateRetrieved 
  From CEN.Workspaces as W
  LEFT JOIN Apps as A
  on W.Workspace_Id = A.Workspace_ID