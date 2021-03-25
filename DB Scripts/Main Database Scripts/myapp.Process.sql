USE [ArijitDB-01]
GO

/****** Object:  Table [myapp].[Process]    Script Date: 25-03-2021 12:43:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [myapp].[Process](
	[ProcessId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessName] [nvarchar](100) NOT NULL,
	[ProcessDesc] [nvarchar](2000) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](100) NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Uk_Process_ProcessName] UNIQUE NONCLUSTERED 
(
	[ProcessName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


