CREATE TABLE [STG].[Workspaces] (
    [Workspace_Id]          NVARCHAR (MAX) NULL,
    [Name]                  NVARCHAR (MAX) NULL,
    [IsReadOnly]            NVARCHAR (MAX) NULL,
    [IsOnDedicatedCapacity] NVARCHAR (MAX) NULL,
    [CapacityId]            NVARCHAR (MAX) NULL,
    [Description]           NVARCHAR (MAX) NULL,
    [Type]                  NVARCHAR (MAX) NULL,
    [State]                 NVARCHAR (MAX) NULL,
    [IsOrphaned]            NVARCHAR (MAX) NULL,
    [Users]                 NVARCHAR (MAX) NULL,
    [Reports]               NVARCHAR (MAX) NULL,
    [Dashboards]            NVARCHAR (MAX) NULL,
    [Datasets]              NVARCHAR (MAX) NULL,
    [Dataflows]             NVARCHAR (MAX) NULL,
    [Workbooks]             NVARCHAR (MAX) NULL,
    [DateRetrieved]         NVARCHAR (MAX) DEFAULT (sysdatetime()) NULL
);





