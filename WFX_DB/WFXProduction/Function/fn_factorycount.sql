USE [WFX]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_factorycount]    Script Date: 6/25/2021 3:03:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[fn_factorycount]
(
	@ClusterID int 
)
RETURNS int	
AS
BEGIN
	DECLARE @clustercount int 
	
	SET @clustercount = 0 

	SELECT @clustercount = isnull(count(*),0) 
	FROM tbl_Factory 
	WHERE ClusterID = @ClusterID 
	 
RETURN @clustercount 
END