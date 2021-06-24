Create View [CEN].[vw_ActivityLogs]
As
Select  Id  
       ,Cast(CreationTime as datetime) as CreationTime  
       ,CreationTimeUTC  
       ,RecordType  
       ,Operation  
       ,OrganizationId  
       ,UserType  
       ,UserKey  
       ,Workload  
       ,UserId  
       ,ClientIP  
       ,UserAgent  
       ,Activity  
       ,ItemName  
       ,WorkSpaceName  
       ,DashboardName  
       ,DatasetName  
       ,ReportName  
       ,WorkspaceId  
       ,ObjectId  
       ,DashboardId  
       ,DatasetId  
       ,ReportId  
       ,OrgAppPermission  
       ,CapacityId  
       ,CapacityName  
       ,AppName  
       ,IsSuccess  
       ,ReportType  
       ,RequestId  
       ,ActivityId  
       ,AppReportId  
       ,DistributionMethod  
       ,ConsumptionMethod  
       ,CAST(DateRetrieved AS DATETIME) AS DateRetrieved 
  From CEN.ActivityLogs