CREATE PROCEDURE [STG].[usp_merge_Capacities]

AS
BEGIN
	
	DECLARE @json VARCHAR(MAX) = (SELECT
		*
	FROM stg.capacities)

	MERGE [CEN].[Capacities] T
	USING (
SELECT
	ID, DisplayName, value AS Admin, Sku, State, CapacityUserAccessRight, Region, GETDATE() as DateRetrieved
FROM OPENJSON(@json)
WITH (Id NVARCHAR(500) '$.id',
displayName NVARCHAR(500) '$.displayName',
admins NVARCHAR(MAX) '$.admins' AS JSON,
sku NVARCHAR(500) '$.sku',
State NVARCHAR(500) '$.state',
capacityUserAccessRight NVARCHAR(500) '$.capacityUserAccessRight',
Region NVARCHAR(500) '$.region'
)CROSS APPLY OPENJSON(admins)) S
	ON  T.[DisplayName] = S.[DisplayName]
	AND T.[Admin] = S.[Admin]
	
	WHEN MATCHED THEN
	UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT (ID,DisplayName,Admin,Sku,State,CapacityUserAccessRight,Region, DateRetrieved)

	VALUES (S.ID,S.DisplayName,S.Admin,S.Sku,S.State,S.CapacityUserAccessRight,S.Region, S.DateRetrieved);
END

--EXEC [STG].usp_merge_Capacities
