CREATE PROCEDURE [STG].[usp_merge_GatewayDataSource]

AS
BEGIN
	
	DECLARE @json VARCHAR(MAX) = (SELECT
		*
	FROM STG.GatewayDataSource)

	MERGE [CEN].[GatewayDataSource] T
	USING (
SELECT
	Id
   ,GatewayId
   ,DataSourceType
   ,[Server] AS [ConnectionDetails Server]
   ,[database] AS [ConnectionDetails Database]
   ,[path] AS [ConnectionDetails Path]
   ,sharePointSiteUrl AS [ConnectionDetails SharePointSiteUrl]
   ,CredentialType
   ,UseEndUserOAuth2Credentials AS [CredentialType UseEndUserOAuth2Credentials]
   ,DatasourceName
   ,GETDATE() AS DateRetrieved
FROM OPENJSON(@json)
WITH (Id NVARCHAR(500) '$.id',
GatewayId NVARCHAR(500) '$.gatewayId',
DataSourceType NVARCHAR(500) '$.datasourceType',
ConnectionDetails NVARCHAR(500) '$.connectionDetails',
CredentialType NVARCHAR(500) '$.credentialType',
CredentialDetails NVARCHAR(MAX) '$.credentialDetails' AS JSON,
DatasourceName NVARCHAR(500) '$.datasourceName'
) A
CROSS APPLY OPENJSON(A.ConnectionDetails)
WITH ([server] VARCHAR(MAX), [database] VARCHAR(MAX), [path] VARCHAR(MAX), sharePointSiteUrl VARCHAR(MAX)) B
CROSS APPLY OPENJSON(A.CredentialDetails)
WITH (useEndUserOAuth2Credentials VARCHAR(MAX)) C
) S 
	ON  T.[Id]=S.[Id]
	
	WHEN MATCHED THEN
	UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT (Id
,GatewayId
,DataSourceType
,[ConnectionDetails Server]
,[ConnectionDetails Database]
,[ConnectionDetails Path]
,[ConnectionDetails SharePointSiteUrl]
,[CredentialType UseEndUserOAuth2Credentials]
,DatasourceName
,DateRetrieved
)

	VALUES (Id
,S.GatewayId
,S.DataSourceType
,S.[ConnectionDetails Server]
,S.[ConnectionDetails Database]
,S.[ConnectionDetails Path]
,S.[ConnectionDetails SharePointSiteUrl]
,S.[CredentialType UseEndUserOAuth2Credentials]
,S.DatasourceName
,S.DateRetrieved
);
END

--EXEC [STG].usp_merge_GatewayDataSource
