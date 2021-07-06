
/****** Script for SelectTopNRows command from SSMS  ******/
 
CREATE VIEW [CEN].[vw_ReportAppItems]
 AS
 SELECT [Report_Id]
      ,[Name]
      ,[WebUrl]
      ,[EmbedUrl]
      ,[Dataset_Id]
      ,[Description]
      ,[CreatedBy]
      ,[ModifiedBy]
      ,[CreatedDateTime]
      ,[ModifiedDateTime]
      ,[EndorsementDetails]
      ,[SensitivityLabel]
      ,[ReportType]
      ,[Workspace_Id]
      ,[DateRetrieved]
  FROM [CEN].[Reports]
  WHERE SUBSTRING(TRIM([Name]),1,5) = '[App]'