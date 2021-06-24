CREATE PROCEDURE [STG].[usp_merge_Workspaces]

AS
BEGIN

	MERGE [CEN].[Workspaces] T
	USING [STG].[Workspaces] S 
	ON  T.[Workspace_Id]=S.[Workspace_Id]
	
	WHEN MATCHED THEN
	UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT ( [Workspace_Id]                    
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
			,[DateRetrieved]   )

	VALUES ( S.[Workspace_Id]                    
            ,S.[Name]                  
            ,S.[IsReadOnly]            
            ,S.[IsOnDedicatedCapacity] 
            ,S.[CapacityId]            
            ,S.[Description]           
            ,S.[Type]                  
            ,S.[State]                 
            ,S.[IsOrphaned]             
			,S.[Users]                  
			,S.[Reports]                
			,S.[Dashboards]             
			,S.[Datasets]               
			,S.[Dataflows]              
			,S.[Workbooks]              
			,S.[DateRetrieved]     );
END

--EXEC [STG].usp_merge_Workspaces
