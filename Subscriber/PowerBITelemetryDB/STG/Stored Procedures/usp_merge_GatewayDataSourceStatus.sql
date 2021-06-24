CREATE PROCEDURE [STG].[usp_merge_GatewayDataSourceStatus]

AS
BEGIN

	DECLARE @json VARCHAR(MAX) = (SELECT
			*
		FROM STG.GatewayDataSourceStatus)

	MERGE [CEN].[GatewayDataSourceStatus] T USING (SELECT
			StatusCode
		   ,Content
		   ,GatewayId
		   ,DatasourceId
		   ,GETDATE() AS DateRetrieved
		FROM OPENJSON(@json)
		WITH (StatusCode NVARCHAR(500) '$.StatusCode', Content NVARCHAR(500) '$.Content',
		GatewayId NVARCHAR(500) '$.GatewayId', DatasourceId NVARCHAR(500) '$.DatasourceId'
		) A) S
	ON T.[DatasourceId] = S.[DatasourceId]

	WHEN MATCHED
		THEN UPDATE
			SET [DateRetrieved] = S.[DateRetrieved]

	WHEN NOT MATCHED BY TARGET
		THEN INSERT (StatusCode, Content, GatewayId, DatasourceId, DateRetrieved)

				VALUES (StatusCode, Content, GatewayId, DatasourceId, S.DateRetrieved);
END

--EXEC [STG].usp_merge_GatewayDataSourceStatus
