




CREATE VIEW  [CEN].[vw_WorkspaceItemsDetails] AS



select 
     W.[Workspace_ID]									   as WorkspaceID
	,DSet.[Dataset_Id]                                 as Datasets_Id                               
	,DSet.[Name]                               as Datasets_Name                             
	,DSet.[ConfiguredBy]                       as Datasets_ConfiguredBy                     
	--,DSet.[DefaultRetentionPolicy]             as Datasets_DefaultRetentionPolicy           
	,DSet.[AddRowsApiEnabled]                  as Datasets_AddRowsApiEnabled                
	--,DSet.[Tables]                             as Datasets_Tables                           
	,DSet.[WebUrl]                             as Datasets_WebUrl                           
	--,DSet.[Relationships]                      as Datasets_Relationships                    
	--,DSet.[Datasources]                        as Datasets_Datasources                      
	--,DSet.[DefaultMode]                        as Datasets_DefaultMode                      
	,DSet.[IsRefreshable]                      as Datasets_IsRefreshable                    
	,DSet.[IsEffectiveIdentityRequired]        as Datasets_IsEffectiveIdentityRequired      
	,DSet.[IsEffectiveIdentityRolesRequired]   as Datasets_IsEffectiveIdentityRolesRequired 
	,DSet.[IsOnPremGatewayRequired]            as Datasets_IsOnPremGatewayRequired          
	--,DSet.[TargetStorageMode]                  as Datasets_TargetStorageMode                
	--,DSet.[ActualStorage]                      as Datasets_ActualStorage       

	,DSet.[CreatedDate]                        as Datasets_CreatedDate                      
	,DSet.[ContentProviderType]                as Datasets_ContentProviderType     
	,DSet.[QnaEmbedURL]						   as Datasets_QnaEmbedURL    
	,DSet.[Description]                        as Datasets_Description   
--	,DSet.[WorkspaceID]                        as Datasets_WorkspaceID                      
	,DSet.[DateRetrieved]                      as Datasets_DateRetrieved  

	--,DSource.[Name]                            as DataSources_Name             
	--,DSource.[ConnectionString]                as DataSources_ConnectionString 
	--,DSource.[DatasourceType]                  as Datasource_Type   
	--,DSource.[ConnectionDetails]               as DataSources_ConnectionDetails
	--,DSource.[GatewayId]                       as DataSources_GatewayId        
	--,DSource.[DatasourceId]                    as Datasource_Id     
--	,DSource.[WorkspaceID]                     as DataSources_WorkspaceID      
--	,DSource.[DatasetId]                       as DataSources_DatasetId        
	--,DSource.[DateRetrieved]                   as DataSources_DateRetrieved   

	,R.[Name]                                  as Reports_Name         
	,R.[Description]                           as Reports_Description
--	,R.[DatasetId]                             as Reports_DatasetId     
--	,R.[WorkspaceID]                           as Reports_WorkspaceID  
	,R.[ReportType]                            as Reports_ReportType 
	,R.[DateRetrieved]                         as Reports_DateRetrieved 
	
	,D.[DisplayName]                                  as Dashboards_Name                              
--	,D.[WorkspaceID]                           as Dashboards_WorkspaceID                       
	,D.[DateRetrieved]                         as Dashboards_DateRetrieved  

from [CEN].[Workspaces] W
join [CEN].[Datasets] DSet on W.[Workspace_Id] =DSet.[Workspace_ID]
--join [CEN].[DataSources] DSource on W.[Id]= DSource.[WorkspaceID]
join [CEN].[Reports] R on  W.[Workspace_Id]=R.[Workspace_ID]
join [CEN].[Dashboards] D on W.[Workspace_Id]=D.[Workspace_ID]