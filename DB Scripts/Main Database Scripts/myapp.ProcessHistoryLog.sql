USE [ArijitDB-01]
GO

/****** Object:  Table [myapp].[ProcessHistoryLog]    Script Date: 25-03-2021 12:44:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [myapp].[ProcessHistoryLog](
	[ProcessHistoryLogId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessHistoryId] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProcessHistoryLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [myapp].[ProcessHistoryLog]  WITH CHECK ADD  CONSTRAINT [FK_ProcessHistoryLog_ProcessHostoryId] FOREIGN KEY([ProcessHistoryId])
REFERENCES [myapp].[ProcessHistory] ([ProcessHistoryId])
GO

ALTER TABLE [myapp].[ProcessHistoryLog] CHECK CONSTRAINT [FK_ProcessHistoryLog_ProcessHostoryId]
GO


