USE [ArijitDB-01]
GO

/****** Object:  Table [myapp].[ProcessHistory]    Script Date: 25-03-2021 12:44:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [myapp].[ProcessHistory](
	[ProcessHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessId] [int] NULL,
	[ProcessStartDate] [datetime] NULL,
	[ProcessEndDate] [datetime] NULL,
	[Status] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProcessHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [myapp].[ProcessHistory]  WITH CHECK ADD  CONSTRAINT [FK_ProcessHistory_ProcessId] FOREIGN KEY([ProcessId])
REFERENCES [myapp].[Process] ([ProcessId])
GO

ALTER TABLE [myapp].[ProcessHistory] CHECK CONSTRAINT [FK_ProcessHistory_ProcessId]
GO


