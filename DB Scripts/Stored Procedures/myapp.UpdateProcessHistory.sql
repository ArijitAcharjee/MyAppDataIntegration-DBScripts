USE [ArijitDB-01]
GO

/****** Object:  StoredProcedure [myapp].[UpdateProcessHistory]    Script Date: 25-03-2021 12:46:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ================================
-- Author : Arijit Acharjee
-- ================================

create procedure [myapp].[UpdateProcessHistory]
	@ProcessHistoryId int,
	@Status varchar(20)

	as
		begin
			
			update myapp.ProcessHistory

			set ProcessEndDate = SYSDATETIME(),
				status = @Status,
				UpdatedBy = CURRENT_USER,
				UpdatedDate = SYSDATETIME()
			where ProcessHistoryId = @ProcessHistoryId;

end

GO


