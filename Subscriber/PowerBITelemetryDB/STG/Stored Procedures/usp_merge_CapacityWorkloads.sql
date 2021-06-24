CREATE PROCEDURE [STG].[usp_merge_CapacityWorkloads]

AS
BEGIN

	DECLARE @json VARCHAR(MAX) = (SELECT
			*
		FROM STG.CapacityWorkloads)

	MERGE [CEN].[CapacityWorkloads] T USING (SELECT
			[Name]
		   ,MaxMemoryPercentageSetByUser
		   ,[State]
		   ,CapacityName
		   ,CapacityId
		   ,GETDATE() AS DateRetrieved
		FROM OPENJSON(@json)
		WITH (Name NVARCHAR(500) '$.name',
		MaxMemoryPercentageSetByUser NVARCHAR(500) '$.maxMemoryPercentageSetByUser',
		State NVARCHAR(500) '$.state',
		CapacityName NVARCHAR(500) '$.CapacityName',
		CapacityId NVARCHAR(500) '$.CapacityId'
		) A) S
	ON T.[Name] = S.[Name]

	WHEN MATCHED
		THEN UPDATE
			SET [DateRetrieved] = S.[DateRetrieved]

	WHEN NOT MATCHED BY TARGET
		THEN INSERT ([Name],
			MaxMemoryPercentageSetByUser,
			[State]
			,CapacityName
			,CapacityId
			,DateRetrieved)

				VALUES ([Name], MaxMemoryPercentageSetByUser, [State], CapacityName, CapacityId, DateRetrieved);
END

--EXEC [STG].usp_merge_CapacityWorkloads
