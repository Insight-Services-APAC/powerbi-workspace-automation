Create View [CEN].[vw_Gateway]
As
Select  Id
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
	     ,CAST(DateRetrieved AS DATETIME) AS DateRetrieved 
  From CEN.Gateway