 
 
CREATE   proc [dbo].[sp_UpdateDimDate]
as
begin
declare
@CurrentDate date = [dbo].[fn_getWAustDateTime](getdate())
,@FiscalStartDateForCurrentYear date
,@FiscalYearStartMonth int =7

UPDATE dbo.Dim_Date SET  [CurYearOffset]	 = DATEDIFF(yy, @CurrentDate, DATE)
UPDATE dbo.Dim_Date SET  [CurQuarterOffset]  = DATEDIFF(q,  @CurrentDate, DATE)
UPDATE dbo.Dim_Date SET  [CurMonthOffset]	 = DATEDIFF(m,  @CurrentDate, DATE)
UPDATE dbo.Dim_Date SET  [CurWeekOffset]     = DATEDIFF(ww, @CurrentDate, DATE)
UPDATE dbo.Dim_Date SET  [CurDayOffset]      = DATEDIFF(dd, @CurrentDate,DATE)
UPDATE dbo.Dim_Date SET  [FutureDate] = case when datediff(day,@CurrentDate,[Date])<=0 then 'N' else 'Future' end 
UPDATE dbo.Dim_Date SET  [FutureMonth] = CASE WHEN format([Date],'yyyyMM')>format(@CurrentDate,'yyyyMM') THEN'Y' ELSE 'N' END


end
