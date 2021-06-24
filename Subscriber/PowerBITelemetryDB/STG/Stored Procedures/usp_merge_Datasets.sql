CREATE PROCEDURE [STG].[usp_merge_Datasets]

AS
BEGIN

	MERGE [CEN].[Datasets] T
	USING [STG].[Datasets] S 
	ON  T.[Dataset_Id]=S.[Dataset_Id]
	
	WHEN MATCHED THEN
	UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT ( [Dataset_Id]						
            ,[Name]								
            ,[ConfiguredBy]						
            ,[AddRowsAPIEnabled]					
            ,[WebUrl]							
            ,[IsRefreshable]						
            ,[IsEffectiveIdentityRequired]		
            ,[IsEffectiveIdentityRolesRequired]	
            ,[IsOnPremGatewayRequired]			
            ,[Encryption]						
            ,[CreatedDate]						
            ,[ContentProviderType]				
            ,[CreateReportEmbedURL]				
            ,[QnaEmbedURL]						
            ,[Description]						
            ,[EndorsementDetails]				
            ,[DatasourceUsages]					
            ,[UpstreamDataflows]					                   
            ,[SensitivityLabel]					
			,[Workspace_Id]						
			,[DateRetrieved]						
			)

	VALUES ( S.[Dataset_Id]						
            ,S.[Name]								
            ,S.[ConfiguredBy]						
            ,S.[AddRowsAPIEnabled]					
            ,S.[WebUrl]							
            ,S.[IsRefreshable]						
            ,S.[IsEffectiveIdentityRequired]		
            ,S.[IsEffectiveIdentityRolesRequired]	
            ,S.[IsOnPremGatewayRequired]			
            ,S.[Encryption]						
            ,S.[CreatedDate]						
            ,S.[ContentProviderType]				
            ,S.[CreateReportEmbedURL]				
            ,S.[QnaEmbedURL]						
            ,S.[Description]						
            ,S.[EndorsementDetails]				
            ,S.[DatasourceUsages]					
            ,S.[UpstreamDataflows]					                   
            ,S.[SensitivityLabel]					
			,S.[Workspace_Id]						
			,S.[DateRetrieved]						
			);
END
