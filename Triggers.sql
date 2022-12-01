Use MobileTelephone;
/*
--история заказов
create trigger triggerOrderHistory
on orderList
after update
as 
	begin
		DECLARE @oldStatus smallint
		SELECT @oldStatus  = (SELECT status FROM deleted)
		DECLARE @newStatus smallint
		SELECT @newStatus  = (SELECT status FROM inserted)
		DECLARE @completedStatus smallint
		SET @completedStatus = 1
		DECLARE @id_order int
		select @id_order = (select id_order from inserted)
		DECLARE @idClient int, @idWorker int, @idService int, @idFreeTime int
		SELECT @idClient  = (SELECT idClient FROM inserted)
		SELECT @idWorker  = (SELECT idWorker FROM inserted)
		SELECT @idService  = (SELECT idService FROM inserted)
		SELECT @idFreeTime  = (SELECT idFreeTime FROM inserted)
		
		IF @newStatus = @completedStatus
		begin
			IF @oldStatus != @newStatus 
			begin
			 INSERT INTO orderHistory(id_order, idClient, idWorker, idService,idFreeTime, status ) 
			 VALUES( @id_order,@idClient, @idWorker, @idService,@idFreeTime, @newStatus)
			 delete from orderList where id_order = @id_order
			end
		end
	end
*/

--удаление свободного времени
go
create trigger triggerDeleteFreeTime
on orderList
after insert
as 
	begin
		declare @idFreeTime int
		set @idFreeTime = (select idFreeTime from inserted)

		update timetableWorkers set status = 1 where id_freeDateTime = @idFreeTime

	end

--проверка изменения времени
go
create trigger triggerChekUpdateTime
on orderList
after update
as 
	begin
		declare @newIdFreeTime int
		set @newIdFreeTime = (select idFreeTime from inserted)
		declare @oldIdFreeTime int
		set @oldIdFreeTime = (select idFreeTime from deleted)
		if @oldIdFreeTime != @newIdFreeTime
			begin
				update timetableWorkers set status = 0 where id_freeDateTime = @oldIdFreeTime
				update timetableWorkers set status = 1 where id_freeDateTime = @newIdFreeTime
			end
	end