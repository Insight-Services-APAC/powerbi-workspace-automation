CREATE TABLE [STG].[Reports] (
    [Report_Id]          NVARCHAR (MAX) NULL,
    [Name]               NVARCHAR (MAX) NULL,
    [WebUrl]             NVARCHAR (MAX) NULL,
    [EmbedUrl]           NVARCHAR (MAX) NULL,
    [Dataset_Id]         NVARCHAR (MAX) NULL,
    [Description]        NVARCHAR (MAX) NULL,
    [CreatedBy]          NVARCHAR (MAX) NULL,
    [ModifiedBy]         NVARCHAR (MAX) NULL,
    [CreatedDateTime]    NVARCHAR (MAX) NULL,
    [ModifiedDateTime]   NVARCHAR (MAX) NULL,
    [EndorsementDetails] NVARCHAR (MAX) NULL,
    [SensitivityLabel]   NVARCHAR (MAX) NULL,
    [ReportType]         NVARCHAR (MAX) NULL,
    [Workspace_Id]       NVARCHAR (MAX) NULL,
    [DateRetrieved]      DATETIME2 (7)  DEFAULT (sysdatetime()) NOT NULL
);



