USE [ArijitDB-DataWareHouse]
GO

/****** Object:  Table [myapp].[Users]    Script Date: 25-03-2021 12:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [myapp].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[Sport] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](100) NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO


