CREATE PROCEDURE [STG].[usp_merge_DataSources]

AS
BEGIN
Select 1

	--MERGE [CEN].[DataSources] T
	--USING [STG].[DataSources] S 
	--ON  T.[DatasourceId]=S.[DatasourceId]
	--AND T.[DatasetId]=S.[DatasetId]
	
	--WHEN MATCHED THEN
	--UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	--WHEN NOT MATCHED BY TARGET 
	--THEN 
	--INSERT ( [Name]             
 --           ,[ConnectionString] 
 --           ,[DatasourceType]   
 --           ,[ConnectionDetails]
 --           ,[GatewayId]        
 --           ,[DatasourceId]     
 --           ,[WorkspaceID]      
 --           ,[DatasetId]        
 --           ,[DateRetrieved]       )

	--VALUES ( S.[Name]             
 --           ,S.[ConnectionString] 
 --           ,S.[DatasourceType]   
 --           ,S.[ConnectionDetails]
 --           ,S.[GatewayId]        
 --           ,S.[DatasourceId]     
 --           ,S.[WorkspaceID]      
 --           ,S.[DatasetId]        
 --           ,S.[DateRetrieved]  );
END

--EXEC [STG].usp_merge_DataSources
