CREATE PROCEDURE [STG].[usp_merge_Dashboards]

AS
BEGIN

	MERGE [CEN].[Dashboards] T
	USING [STG].[Dashboards] S 
	ON T.[Dashboard_Id]=S.[Dashboard_Id]
	
	WHEN MATCHED THEN
	UPDATE SET T.[DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT ([Dashboard_Id]		
		   ,[DisplayName]		
		   ,[IsReadOnly]		
		   ,[EmbedUrl]			
		   ,[Tiles]				
		   ,[DataClassification]
		   ,[SensitivityLabel]	
		   ,[Workspace_ID]		
		   ,[DateRetrieved]		
		   )
	VALUES (S.[Dashboard_Id]		
		   ,S.[DisplayName]		
		   ,S.[IsReadOnly]		
		   ,S.[EmbedUrl]			
		   ,S.[Tiles]				
		   ,S.[DataClassification]
		   ,S.[SensitivityLabel]	
		   ,S.[Workspace_ID]		
		   ,S.[DateRetrieved]		
		   );
END

--EXEC [STG].usp_merge_Dashboards
