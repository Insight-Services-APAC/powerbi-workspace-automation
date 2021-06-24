
CREATE VIEW  [CEN].[WorkspaceItemsDetails] AS



select 
	 DSet.[Dataset_Id]                         as Datasets_Id                               
	,DSet.[Name]                               as Datasets_Name                             
	,DSet.[ConfiguredBy]                       as Datasets_ConfiguredBy                     
--	,DSet.[DefaultRetentionPolicy]             as Datasets_DefaultRetentionPolicy           
	,DSet.[AddRowsApiEnabled]                  as Datasets_AddRowsApiEnabled                
	--,DSet.[Tables]                             as Datasets_Tables                           
	,DSet.[WebUrl]                             as Datasets_WebUrl                           
	--,DSet.[Relationships]                      as Datasets_Relationships                    
	--,DSet.[Datasources]                        as Datasets_Datasources                      
	--,DSet.[DefaultMode]                        as Datasets_DefaultMode                      
	,DSet.[IsRefreshable]                      as Datasets_IsRefreshable                    
--	,DSet.[IsEffectiveIdentityRequired]        as Datasets_IsEffectiveIdentityRequired      
--	,DSet.[IsEffectiveIdentityRolesRequired]   as Datasets_IsEffectiveIdentityRolesRequired 
--	,DSet.[IsOnPremGatewayRequired]            as Datasets_IsOnPremGatewayRequired          
--	,DSet.[TargetStorageMode]                  as Datasets_TargetStorageMode                
--	,DSet.[ActualStorage]                      as Datasets_ActualStorage                    
	,DSet.[CreatedDate]                        as Datasets_CreatedDate                      
	,DSet.[ContentProviderType]                as Datasets_ContentProviderType              
	,DSet.[Workspace_Id]                       as Datasets_WorkspaceID                      
	,DSet.[DateRetrieved]                      as Datasets_DateRetrieved  

	,DSource.[Name]                            as DataSources_Name             
	,DSource.[ConnectionString]                as DataSources_ConnectionString 
	,DSource.[DatasourceType]                  as DataSources_DatasourceType   
	,DSource.[ConnectionDetails]               as DataSources_ConnectionDetails
	,DSource.[GatewayId]                       as DataSources_GatewayId        
	,DSource.[DatasourceId]                    as DataSources_DatasourceId     
	,DSource.[WorkspaceID]                     as DataSources_WorkspaceID      
	,DSource.[DatasetId]                       as DataSources_DatasetId        
	,DSource.[DateRetrieved]                   as DataSources_DateRetrieved   

	,R.[Name]                                  as Reports_Name          
	,R.[Dataset_Id]                            as Reports_DatasetId     
	,R.[Workspace_ID]                          as Reports_WorkspaceID 
	,R.[ReportType]                            as Reports_Type
	,R.[DateRetrieved]                         as Reports_DateRetrieved 
	
	,D.[DisplayName]                           as Dashboards_Name                              
	,D.[Workspace_ID]                          as Dashboards_WorkspaceID                       
	,D.[DateRetrieved]                         as Dashboards_DateRetrieved  

from [CEN].[Workspaces] W
left join [CEN].[Datasets] DSet on W.[Id] =DSet.[Workspace_ID]
left join [CEN].[DataSources] DSource on W.[Id]= DSource.[WorkspaceID]
left join [CEN].[Reports] R on  W.[Id]=R.[Workspace_ID]
left join [CEN].[Dashboards] D on W.[Id]=D.[Workspace_ID]