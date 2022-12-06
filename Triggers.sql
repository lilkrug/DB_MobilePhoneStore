Use MobilePhone;

--проверка изменения времени
go
create trigger triggerChekUpdateTime
on order_list
after update
as 
	begin
		declare @newIdFreeTime int
		set @newIdFreeTime = (select idFreeTime from inserted)
		declare @oldIdFreeTime int
		set @oldIdFreeTime = (select idFreeTime from deleted)
		if @oldIdFreeTime != @newIdFreeTime
			begin
				update timetable_worker set status = 0 where id_freeDateTime = @oldIdFreeTime
				update timetable_worker set status = 1 where id_freeDateTime = @newIdFreeTime
			end
	end