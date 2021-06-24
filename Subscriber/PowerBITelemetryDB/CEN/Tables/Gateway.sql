CREATE TABLE [CEN].[Gateway] (
    [Id]                                   NVARCHAR (MAX) NULL,
    [GatewayId]                            NVARCHAR (MAX) NULL,
    [Name]                                 NVARCHAR (MAX) NULL,
    [Type]                                 NVARCHAR (MAX) NULL,
    [Public Key Exponent]                  NVARCHAR (MAX) NULL,
    [Public Key Modulus]                   NVARCHAR (MAX) NULL,
    [GatewayContactInformation]            NVARCHAR (MAX) NULL,
    [GatewayVersion]                       NVARCHAR (MAX) NULL,
    [GatewayWitnessString EncryptedResult] NVARCHAR (MAX) NULL,
    [GatewayWitnessString IV]              NVARCHAR (MAX) NULL,
    [GatewayWitnessString Signature]       NVARCHAR (MAX) NULL,
    [GatewayMachine]                       NVARCHAR (MAX) NULL,
    [GatewaySalt]                          NVARCHAR (MAX) NULL,
    [GatewayWitnessStringLegacy]           NVARCHAR (MAX) NULL,
    [GatewaySaltLegacy]                    NVARCHAR (MAX) NULL,
    [DateRetrieved]                        NVARCHAR (MAX) NULL
);

