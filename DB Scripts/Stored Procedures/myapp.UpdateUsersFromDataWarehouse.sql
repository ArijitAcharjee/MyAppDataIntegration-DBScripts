USE [ArijitDB-01]
GO

/****** Object:  StoredProcedure [myapp].[PopulateUsersFromDataWareHouse]    Script Date: 25-03-2021 12:46:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ===========================
-- Author : Arijit Acharjee
-- ===========================

create procedure [myapp].[PopulateUsersFromDataWareHouse]
as
begin

declare @ProcessHistoryLog Table (
									Description Nvarchar(MAX),
									Status      Nvarchar(100),
									CreatedBy	Nvarchar(100),
									CreatedDate	Datetime
								)


				-- // =================================================
				-- // Insert Record into Process History
				-- // =================================================

				declare @ProcessName		varchar(500);
				declare @ProcessId			int;
				declare @ProcessHistoryId	int;
				declare @CreatedBy			varchar(50);
				declare @CreatedDate		varchar(50);
				declare @DuplicateRecordCount	int;

				set @ProcessName = 'PopulateUsersFromDataWareHouse';
				set @CreatedBy = 'System'
				set @CreatedDate = GETDATE()

				select 
					@ProcessId = PR.ProcessId
				From myapp.Process PR
				where PR.ProcessName = @ProcessName;

				EXEC @ProcessHistoryId = myapp.InsertProcessHistory @ProcessId = @ProcessId;

			begin try
				begin transaction

					declare @SourceUsers table (
													[UserId] [int] identity(1,1) not null,
													[UserName] [nvarchar] (100) null,
													[Sport] [nvarchar] (100) null,
													[MyAppDWSourceId] int null,
													[IsActive] [bit] null,
													[CreatedBy] [nvarchar] (100) null,
													[CreatedDate] [datetime] null,
													[UpdatedBy] [nvarchar] (100) null,
													[UpdatedDate] [datetime] null
												);
					
					--// Insert all the user details into table variable

					insert into @SourceUsers (
					
												UserName,
												Sport,
												MyAppDWSourceId,
												IsActive,
												CreatedBy,
												CreatedDate,
												UpdatedBy,
												UpdatedDate
											  )
											  select SU.UserName,
													 SU.Sport,
													 SU.MyAppDWSourceId,
													 SU.IsActive,
													 SU.CreatedBy,
													 SU.CreatedDate,
													 SU.UpdatedBy,
													 SU.UpdatedDate
											  from myapp.StgUsers SU


						--// Insert into Log Table Variable

						insert into @ProcessHistoryLog(
								Description,
								Status,
								CreatedBy,
								CreatedDate
								)
								values
								(
									'STEP-1 : Data has been Loaded into Table Variable(@SourceUsers).',
									'PASS',
									@CreatedBy,
									@CreatedDate
								);


							--// Insert into Log Table Variable
							Insert Into @ProcessHistoryLog(
															Description,
															Status,
															CreatedBy,
															CreatedDate
														)
														Values
														(
															'STEP-2 : Starting Merge process into Main table(myapp.Users)',
															'PASS',
															'AUTO_LOAD',
															GETDATE()
														);


								--// Merge the data with main table.



	merge myapp.Users U
		using @SourceUsers SU
		on(U.MyAppDWSourceId = SU.MyAppDWSourceId)
		when MATCHED
		AND (
				ISNULL(U.UserName, 'UNKNOWN') <> ISNULL(SU.UserName, 'UNKNOWN')
			OR  ISNULL(U.Sport, 'UNKNOWN') <> ISNULL(SU.Sport, 'UNKNOWN')
			OR	U.IsActive = SU.IsActive
			)



		then update set
				
				U.UserName = SU.UserName,
				U.Sport = SU.Sport,
				U.IsActive = SU.IsActive,
				U.UpdatedBy = 'System',
				U.UpdatedDate = GETDATE()

				when NOT MATCHED BY TARGET

				THEN INSERT(
								UserName,
								Sport,
								IsActive
							)
						Values (SU.UserName,
								SU.Sport,
								SU.IsActive
								)
				WHEN NOT MATCHED BY SOURCE and U.IsActive = 1
				THEN
				UPDATE SET

						U.IsActive = 0,
						U.UpdatedBy = 'SYSTEM',
						U.UpdatedDate = GETDATE();


			--// Insert Into Log Table Variable

				Insert Into @ProcessHistoryLog(
													Description,
													Status,
													CreatedBy,
													CreatedDate
												)
												Values
													(

														'STEP-3 : End Merge process into Main Table(myapp.Users)',
														'PASS',
														'AUTO_LOAD',
														GETDATE()
													);

					--// Update Process history to Complete

					EXEC myapp.UpdateProcessHistory @ProcessHistoryId = @ProcessHistoryId, @Status = 'COMPLETE';

					--// Insert Record into main Log Table

					Insert into myapp.ProcessHistoryLog(
															ProcessHistoryId,
															Description,
															Status,
															CreatedBy,
															CreatedDate
															)

													select
														@ProcessHistoryId,
														Description,
														Status,
														CreatedBy,
														CreatedDate
													From @ProcessHistoryLog;



COMMIT TRANSACTION;

END TRY
		BEGIN CATCH
			
				ROLLBACK TRANSACTION;

				BEGIN TRANSACTION

				Declare @ErrorMessage nvarchar(4000);
				declare @ErrorSeverity int;
				declare @ErrorState int;
				declare @ErrorNumber int;
				declare @ErrorLine int;
				declare @ErrorProcedure nvarchar(200);
				declare @CatchLog nvarchar(4000);

				select @ErrorLine = ERROR_LINE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorNumber = ERROR_NUMBER(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProcedure = ISNULL(ERROR_PROCEDURE(),'-');

				SET @CatchLog = CONCAT('Severity = ', @ErrorSeverity, '|', 'ErrorNumber =', @ErrorNumber, '|', 
				'ErrorLine =', @ErrorLine, '|', 'ErrorState =', @ErrorState, '|', 'ErrorProcedure =', @ErrorProcedure, '|',
				'ErrorMessage =', @ErrorMessage);
				

				--Insert Process History Table

				EXEC @ProcessHistoryId = myapp.InsertProcessHistory @ProcessId = @ProcessId

				INSERT INTO @ProcessHistoryLog(
												Description,
												Status,
												CreatedBy,
												CreatedDate
												)
												VALUES
												(
													'FAILED : ' +@CatchLog,
													'FAIL',
													'AUTO_LOAD',
													GETDATE()
													);

					--//Insert Record into Main Log table

					Insert into myapp.ProcessHistoryLog(
															ProcessHistoryId,
															Description,
															Status,
															CreatedBy,
															CreatedDate
														)
														SELECT
															@ProcessHistoryId,
															Description,
															Status,
															CreatedBy,
															CreatedDate
														FROM @ProcessHistoryLog;

						--// Update process History to complete

						EXEC myapp.UpdateProcessHistory @ProcessHistoryId = @ProcessHistoryId, @Status = 'FAILED';

						COMMIT TRANSACTION;

						THROW;

				END CATCH
END
GO


