Create View [CEN].[vw_Capacities]
As
Select  ID  
       ,DisplayName  
       ,Admin  
       ,Sku  
       ,State  
       ,CapacityUserAccessRight  
       ,Region  
       ,CAST(DateRetrieved AS DATETIME) AS DateRetrieved 
  From CEN.Capacities