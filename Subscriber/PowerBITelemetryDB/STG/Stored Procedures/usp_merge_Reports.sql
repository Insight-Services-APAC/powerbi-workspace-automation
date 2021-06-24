CREATE PROCEDURE [STG].[usp_merge_Reports]

AS
BEGIN

	MERGE [CEN].[Reports] T
	USING [STG].[Reports] S 
	ON  T.[Report_Id]=S.[Report_Id]
	
	WHEN MATCHED THEN
	UPDATE SET T.[DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT ( [Report_Id]
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
		    ) 
	VALUES ( S.[Report_Id]
	        ,S.[Name]				
			,S.[WebUrl]			
			,S.[EmbedUrl]			
			,S.[Dataset_Id]		
			,S.[Description]		
			,S.[CreatedBy]			
			,S.[ModifiedBy]		
			,S.[CreatedDateTime]	
			,S.[ModifiedDateTime]	
			,S.[EndorsementDetails]
			,S.[SensitivityLabel]	
			,S.[ReportType]		
			,S.[Workspace_Id]		
		    ,S.[DateRetrieved]
		   );
END
