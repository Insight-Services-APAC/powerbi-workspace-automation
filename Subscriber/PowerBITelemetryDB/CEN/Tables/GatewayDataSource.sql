CREATE TABLE [CEN].[GatewayDataSource] (
    [Id]                                         NVARCHAR (MAX) NULL,
    [GatewayId]                                  NVARCHAR (MAX) NULL,
    [DataSourceType]                             NVARCHAR (MAX) NULL,
    [ConnectionDetails Server]                   NVARCHAR (MAX) NULL,
    [ConnectionDetails Database]                 NVARCHAR (MAX) NULL,
    [ConnectionDetails Path]                     NVARCHAR (MAX) NULL,
    [ConnectionDetails SharePointSiteUrl]        NVARCHAR (MAX) NULL,
    [CredentialType UseEndUserOAuth2Credentials] NVARCHAR (MAX) NULL,
    [DatasourceName]                             NVARCHAR (MAX) NULL,
    [DateRetrieved]                              NVARCHAR (MAX) NULL
);

