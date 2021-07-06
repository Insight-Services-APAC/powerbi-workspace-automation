
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [CEN].[vw_Dashboards]
 AS
  SELECT [Dashboard_Id]
        ,[DisplayName]
        ,[IsReadOnly]
        ,[EmbedUrl]
        ,[Tiles]
        ,[DataClassification]
        ,[SensitivityLabel]
        ,[Workspace_ID]
        ,[DateRetrieved]
  FROM [CEN].[Dashboards]
  WHERE SUBSTRING(TRIM([DisplayName]),1,5) <> '[App]'