Create View [CEN].[vw_GatewayDataSource]
As
Select  Id  
       ,GatewayId  
       ,DataSourceType  
       ,[ConnectionDetails Server]  
       ,[ConnectionDetails Database]  
       ,[ConnectionDetails Path]  
       ,[ConnectionDetails SharePointSiteUrl]  
       ,[CredentialType UseEndUserOAuth2Credentials]  
       ,DatasourceName  
       ,CAST(DateRetrieved AS DATETIME) AS DateRetrieved 
  From CEN.GatewayDataSource