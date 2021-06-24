CREATE TABLE [STG].[Dashboards] (
    [Dashboard_Id]       NVARCHAR (MAX) NULL,
    [DisplayName]        NVARCHAR (MAX) NULL,
    [IsReadOnly]         NVARCHAR (MAX) NULL,
    [EmbedUrl]           NVARCHAR (MAX) NULL,
    [Tiles]              NVARCHAR (MAX) NULL,
    [DataClassification] NVARCHAR (MAX) NULL,
    [SensitivityLabel]   NVARCHAR (MAX) NULL,
    [Workspace_Id]       NVARCHAR (MAX) NULL,
    [DateRetrieved]      DATETIME2 (7)  DEFAULT (sysdatetime()) NOT NULL
);



