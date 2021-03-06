USE [WFX]
GO
/****** Object:  Table [dbo].[tbl_Calendar]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Calendar](
	[CalendarID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[Calendar] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Calendar] PRIMARY KEY CLUSTERED 
(
	[CalendarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Clusters]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Clusters](
	[ClusterID] [int] NOT NULL,
	[OrganisationID] [int] NOT NULL,
	[ClusterName] [nvarchar](255) NOT NULL,
	[ClusterHead] [nvarchar](255) NOT NULL,
	[ClusterEmail] [nvarchar](255) NOT NULL,
	[ClusterRegion] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Clusters] PRIMARY KEY CLUSTERED 
(
	[ClusterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Clusters_ClusterName] UNIQUE NONCLUSTERED 
(
	[ClusterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Customer]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Customer](
	[CustomerID] [bigint] NOT NULL,
	[FactoryID] [int] NOT NULL,
	[CustomerName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Defects]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Defects](
	[DefectID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[DefectCode] [nvarchar](255) NOT NULL,
	[DefectName] [nvarchar](255) NOT NULL,
	[DefectType] [nvarchar](255) NOT NULL,
	[DefectLevel] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Defects] PRIMARY KEY CLUSTERED 
(
	[DefectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Defects_DefectCode] UNIQUE NONCLUSTERED 
(
	[DefectCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Departmnents]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Departmnents](
	[DepartmentID] [int] NOT NULL,
	[FactoryID] [int] NOT NULL,
	[DepartmentName] [nvarchar](255) NOT NULL,
	[DepartmentHead] [nvarchar](255) NOT NULL,
	[DepartmentEmail] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Departmnents] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Factory]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Factory](
	[FactoryID] [int] NOT NULL,
	[ClusterID] [int] NOT NULL,
	[FactoryName] [nvarchar](255) NOT NULL,
	[FactoryAddress] [nvarchar](255) NOT NULL,
	[FactoryType] [nvarchar](255) NOT NULL,
	[FactoryHead] [nvarchar](255) NOT NULL,
	[FactoryEmail] [nvarchar](255) NOT NULL,
	[FactoryContactNumber] [int] NOT NULL,
	[FactoryCountry] [nvarchar](255) NOT NULL,
	[FactoryTimeZone] [nvarchar](255) NOT NULL,
	[NoOfShifts] [int] NOT NULL,
	[DecimalValue] [int] NOT NULL,
	[PTMPrice] [float] NOT NULL,
	[NoOfUsers] [int] NOT NULL,
	[FactoryOffOn] [nvarchar](255) NOT NULL,
	[MeasuringUnit] [nvarchar](255) NOT NULL,
	[DataScale] [int] NOT NULL,
 CONSTRAINT [PK_Factory] PRIMARY KEY CLUSTERED 
(
	[FactoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Lines]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Lines](
	[LineID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[LineName] [nvarchar](255) NOT NULL,
	[InternalLineName] [nvarchar](255) NOT NULL,
	[NoOfMachine] [int] NOT NULL,
	[LineCapacity] [int] NOT NULL,
	[LineloadingPoint] [nvarchar](255) NOT NULL,
	[TabletID] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED 
(
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Lines_LineName] UNIQUE NONCLUSTERED 
(
	[LineName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Lines_TabletID] UNIQUE NONCLUSTERED 
(
	[TabletID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Modules]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Modules](
	[ModuleID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[ModuleName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Modules] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Organisations]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Organisations](
	[OrganisationID] [int] NOT NULL,
	[OrganisationName] [nvarchar](255) NOT NULL,
	[OrganisationAddress] [nvarchar](255) NOT NULL,
	[OrganisationLogoPath] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Organisations] PRIMARY KEY CLUSTERED 
(
	[OrganisationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Organisations_OrgnisationName] UNIQUE NONCLUSTERED 
(
	[OrganisationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ProductFit]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ProductFit](
	[ProductFitID] [int] NOT NULL,
	[FactoryID] [int] NOT NULL,
	[FitType] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ProductFit] PRIMARY KEY CLUSTERED 
(
	[ProductFitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Products]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Products](
	[ProductID] [bigint] NOT NULL,
	[FactoryID] [int] NOT NULL,
	[ProductName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Shift]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Shift](
	[ShiftID] [int] NOT NULL,
	[ModuleID] [int] NOT NULL,
	[ShiftName] [nvarchar](255) NOT NULL,
	[ShiftStartTime] [time](7) NOT NULL,
	[ShiftEndTime] [time](7) NOT NULL,
 CONSTRAINT [PK_Shift] PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Shift_ShiftName] UNIQUE NONCLUSTERED 
(
	[ShiftName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_UserRole]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserRole](
	[UserRoleID] [int] NOT NULL,
	[UserRole] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Users]    Script Date: 17-03-2021 10:48:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Users](
	[UserID] [int] NOT NULL,
	[FactoryID] [int] NOT NULL,
	[UserFirstName] [nvarchar](255) NOT NULL,
	[UserLastName] [nvarchar](255) NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[UserRoleID] [int] NOT NULL,
	[Members] [int] NOT NULL,
	[UserType] [nvarchar](255) NOT NULL,
	[UserEmail] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Users_UserName] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Calendar]  WITH CHECK ADD  CONSTRAINT [FK_Calendar_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tbl_Modules] ([ModuleID])
GO
ALTER TABLE [dbo].[tbl_Calendar] CHECK CONSTRAINT [FK_Calendar_ModuleID]
GO
ALTER TABLE [dbo].[tbl_Clusters]  WITH CHECK ADD  CONSTRAINT [FK_Clusters_OrganisationID] FOREIGN KEY([OrganisationID])
REFERENCES [dbo].[tbl_Organisations] ([OrganisationID])
GO
ALTER TABLE [dbo].[tbl_Clusters] CHECK CONSTRAINT [FK_Clusters_OrganisationID]
GO
ALTER TABLE [dbo].[tbl_Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_FactoryID] FOREIGN KEY([FactoryID])
REFERENCES [dbo].[tbl_Factory] ([FactoryID])
GO
ALTER TABLE [dbo].[tbl_Customer] CHECK CONSTRAINT [FK_Customer_FactoryID]
GO
ALTER TABLE [dbo].[tbl_Defects]  WITH CHECK ADD  CONSTRAINT [FK_Defects_DepartmnentID] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[tbl_Departmnents] ([DepartmentID])
GO
ALTER TABLE [dbo].[tbl_Defects] CHECK CONSTRAINT [FK_Defects_DepartmnentID]
GO
ALTER TABLE [dbo].[tbl_Departmnents]  WITH CHECK ADD  CONSTRAINT [FK_Departmnents_FactoryID] FOREIGN KEY([FactoryID])
REFERENCES [dbo].[tbl_Factory] ([FactoryID])
GO
ALTER TABLE [dbo].[tbl_Departmnents] CHECK CONSTRAINT [FK_Departmnents_FactoryID]
GO
ALTER TABLE [dbo].[tbl_Factory]  WITH CHECK ADD  CONSTRAINT [FK_Factory_ClustersID] FOREIGN KEY([ClusterID])
REFERENCES [dbo].[tbl_Clusters] ([ClusterID])
GO
ALTER TABLE [dbo].[tbl_Factory] CHECK CONSTRAINT [FK_Factory_ClustersID]
GO
ALTER TABLE [dbo].[tbl_Lines]  WITH CHECK ADD  CONSTRAINT [FK_Lines_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tbl_Modules] ([ModuleID])
GO
ALTER TABLE [dbo].[tbl_Lines] CHECK CONSTRAINT [FK_Lines_ModuleID]
GO
ALTER TABLE [dbo].[tbl_Modules]  WITH CHECK ADD  CONSTRAINT [FK_Modules_DepartmnentID] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[tbl_Departmnents] ([DepartmentID])
GO
ALTER TABLE [dbo].[tbl_Modules] CHECK CONSTRAINT [FK_Modules_DepartmnentID]
GO
ALTER TABLE [dbo].[tbl_ProductFit]  WITH CHECK ADD  CONSTRAINT [FK_ProductFit_FactoryID] FOREIGN KEY([FactoryID])
REFERENCES [dbo].[tbl_Factory] ([FactoryID])
GO
ALTER TABLE [dbo].[tbl_ProductFit] CHECK CONSTRAINT [FK_ProductFit_FactoryID]
GO
ALTER TABLE [dbo].[tbl_Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_FactoryID] FOREIGN KEY([FactoryID])
REFERENCES [dbo].[tbl_Factory] ([FactoryID])
GO
ALTER TABLE [dbo].[tbl_Products] CHECK CONSTRAINT [FK_Products_FactoryID]
GO
ALTER TABLE [dbo].[tbl_Shift]  WITH CHECK ADD  CONSTRAINT [FK_Shift_ModuleID] FOREIGN KEY([ModuleID])
REFERENCES [dbo].[tbl_Modules] ([ModuleID])
GO
ALTER TABLE [dbo].[tbl_Shift] CHECK CONSTRAINT [FK_Shift_ModuleID]
GO
ALTER TABLE [dbo].[tbl_Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_FactoryID] FOREIGN KEY([FactoryID])
REFERENCES [dbo].[tbl_Factory] ([FactoryID])
GO
ALTER TABLE [dbo].[tbl_Users] CHECK CONSTRAINT [FK_Users_FactoryID]
GO
ALTER TABLE [dbo].[tbl_Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserRoleID] FOREIGN KEY([UserRoleID])
REFERENCES [dbo].[tbl_UserRole] ([UserRoleID])
GO
ALTER TABLE [dbo].[tbl_Users] CHECK CONSTRAINT [FK_Users_UserRoleID]
GO
