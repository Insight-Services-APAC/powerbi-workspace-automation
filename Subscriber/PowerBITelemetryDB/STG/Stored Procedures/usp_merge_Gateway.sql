CREATE PROCEDURE [STG].[usp_merge_Gateway]

AS
BEGIN
	
	DECLARE @json VARCHAR(MAX) = (SELECT
		*
	FROM stg.Gateway)

	MERGE [CEN].[Gateway] T
	USING (

SELECT
	Id
   ,GatewayId
   ,Name
   ,A.Type
   ,Exponent AS [Public Key Exponent]
   ,Modulus AS [Public Key Modulus]
   ,D.value AS GatewayContactInformation
   ,GatewayVersion
   ,EncryptedResult AS [GatewayWitnessString EncryptedResult]
   ,IV AS [GatewayWitnessString IV]
   ,[Signature] AS [GatewayWitnessString Signature]
   ,GatewayMachine
   ,GatewaySalt
   ,GatewayWitnessStringLegacy
   ,GatewaySaltLegacy
   ,GETDATE() AS DateRetrieved
FROM OPENJSON(@json)
WITH (Id NVARCHAR(500) '$.id',
gatewayId NVARCHAR(500) '$.gatewayId',
name NVARCHAR(500) '$.name',
type NVARCHAR(500) '$.type',
publicKey NVARCHAR(MAX) '$.publicKey' AS JSON,
gatewayAnnotation NVARCHAR(MAX) '$.gatewayAnnotation'
) A
CROSS APPLY OPENJSON(A.publicKey)
WITH (exponent NVARCHAR(100),
modulus NVARCHAR(MAX)) B
CROSS APPLY OPENJSON(A.gatewayAnnotation)
WITH (gatewayContactInformation NVARCHAR(MAX) AS JSON,
gatewayVersion NVARCHAR(MAX),
gatewayWitnessString NVARCHAR(MAX),
gatewayMachine NVARCHAR(MAX),
gatewaySalt NVARCHAR(MAX),
gatewayWitnessStringLegacy NVARCHAR(MAX),
gatewaySaltLegacy NVARCHAR(MAX)) C
CROSS APPLY OPENJSON(C.gatewayContactInformation) D
CROSS APPLY OPENJSON(C.gatewayWitnessString)
WITH (EncryptedResult NVARCHAR(MAX), IV NVARCHAR(MAX), [signature] NVARCHAR(MAX)) F

) S
	ON  T.[Id] = S.[Id]
	
	WHEN MATCHED THEN
	UPDATE SET [DateRetrieved]=S.[DateRetrieved]
	
	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT (Id
,GatewayId
,Name
,Type
,[Public Key Exponent]
,[Public Key Modulus]
,GatewayContactInformation
,GatewayVersion
,[GatewayWitnessString EncryptedResult]
,[GatewayWitnessString IV]
,[GatewayWitnessString Signature]
,GatewayMachine
,GatewaySalt
,GatewayWitnessStringLegacy
,GatewaySaltLegacy
,DateRetrieved
)

	VALUES (Id
,S.GatewayId
,S.Name
,S.Type
,S.[Public Key Exponent]
,S.[Public Key Modulus]
,S.GatewayContactInformation
,S.GatewayVersion
,S.[GatewayWitnessString EncryptedResult]
,S.[GatewayWitnessString IV]
,S.[GatewayWitnessString Signature]
,S.GatewayMachine
,S.GatewaySalt
,S.GatewayWitnessStringLegacy
,S.GatewaySaltLegacy
,S.DateRetrieved
);
END

--EXEC [STG].usp_merge_Gateway
