USE [WFX]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_clustercount]    Script Date: 6/25/2021 3:03:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_clustercount]
(
	@OrganisationID int 
)
RETURNS int	
AS
BEGIN
	DECLARE @orgcount int 
	
	SET @orgcount = 0 

	SELECT @orgcount = isnull(count(*),0) 
	FROM tbl_Clusters 
	WHERE OrganisationID = @OrganisationID
	 
RETURN @orgcount 
END
