Create View [CEN].[vw_Workspaces]
As
Select  Id  
       ,Name  
       ,IsReadOnly  
       ,IsOnDedicatedCapacity  
       ,CapacityId  
       ,Description  
       ,Type  
       ,State  
       ,IsOrphaned  
       ,Users  
       ,Reports  
       ,Dashboards  
       ,Datasets  
       ,Dataflows  
       ,Workbooks  
       ,CAST(DateRetrieved AS DATETIME) AS DateRetrieved 
  From CEN.Workspaces