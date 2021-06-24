 
 
CREATE FUNCTION [dbo].[fn_getWAustDateTime](@d as datetime)
returns DATETIME
as
begin
     DECLARE @DT AS datetimeoffset
 
     SET @DT = CONVERT(datetimeoffset, @d) AT TIME ZONE 'W. Australia Standard Time'
 
     RETURN CONVERT(datetime, @DT);
 
end