USE [ArijitDB-01]
GO

/****** Object:  StoredProcedure [myapp].[InsertProcessHistory]    Script Date: 25-03-2021 12:45:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================
-- Author : Arijit
-- =============================

Create Procedure [myapp].[InsertProcessHistory]
	@ProcessID int

	as
	begin
		begin transaction;
			declare @ProcessHistoryId int

			insert into myapp.processhistory
			(
				ProcessId,
				ProcessStartDate,
				ProcessEndDate,
				Status,
				CreatedBy,
				CreatedDate,
				UpdatedBy,
				UpdatedDate
			
			)
			values
			(
				@ProcessID,
				GETDATE(),
				Null,
				'INPROGRESS',
				CURRENT_USER,
				GETDATE(),
				CURRENT_USER,
				GETDATE()
			);

			set @ProcessHistoryId = SCOPE_IDENTITY();

		commit transaction;
		return @ProcessHistoryId

end

GO


