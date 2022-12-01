use MobilePhone;

--добавить заказ
GO
CREATE PROCEDURE AddOrder 
    @idClient int,
    @orderDate date,
    @orderTime time, 
	@name nvarchar(30),
	@firstNameWorker nvarchar(35),
	@secondNameWorker nvarchar(35)
AS begin
	declare @idWorker int, @idGood int, @idFreeTime int;
	set @idGood = (select id_good from good where name = @name);
	set @idWorker = (select id_worker from worker where firstName = @firstNameWorker and 
														secondName = @secondNameWorker);
	set @idFreeTime = (select id_freeDateTime from timetable_worker where 
														freeDate = @orderDate and
														freeTime = @orderTime);
	INSERT INTO order_list(idClient, idWorker, idGood, idFreeTime, status) 
	VALUES(@idClient, @idWorker, @idGood, @idFreeTime, 0);
end

declare @paramIdClient int, @paramOrderDate date, @paramOrderTime time, 
		@paramNameGood nvarchar(30), @paramFirstNameWorker nvarchar(35),
		@paramSecondNameWorker nvarchar(35);
set @paramIdClient = 1;
set @paramOrderDate = '30-11-2022';
set @paramOrderTime = '15:50';
set @paramNameGood = 'Apple Iphone14';
set @paramFirstNameWorker = 'Владислав';
set @paramSecondNameWorker = 'Третьяк';
EXEC AddOrder @paramIdClient, @paramOrderDate,
								@paramOrderTime,@paramNameGood,
								@paramFirstNameWorker,
								@paramSecondNameWorker;
--drop procedure AddOrder;


--удалить заказ у клиента
GO
CREATE PROCEDURE DeleteOrder 
    @idOrder int
AS begin
	declare  @idFreeTime int;
	set @idFreeTime = (select idFreeTime from order_list where id_order = @idOrder);
	delete from order_list where id_order = @idOrder;
	update timetable_worker set status = 0 where id_freeDateTime = @idFreeTime;
end

declare @param int;
set @param = 4;
exec DeleteOrder @param;
--drop procedure DeleteOrder

--обновить заказ у клиента
GO
CREATE PROCEDURE UpdateOrderByClient 
    @idOrder int, 
    @orderDate date,
    @orderTime time
AS begin
	declare  @idFreeTime int, @idWorker int;

	set @idWorker = (select idWorker from order_list where id_order = @idOrder);
	set @idFreeTime = (select id_freeDateTime from timetable_worker where idWorker = @idWorker and freeDate = @orderDate and freeTime = @orderTime);

	update order_list set idFreeTime = @idFreeTime where id_order = @idOrder;
	
end

select * from order_list;
select * from timetable_worker;
declare @paramIdOrder int, @paramOrderDate date, @paramOrderTime time;
set @paramIdOrder = 10;
set @paramOrderDate = '30-12-2022';
set @paramOrderTime = '16:50';
exec UpdateOrderByClient @paramIdOrder, @paramOrderDate, @paramOrderTime;
--drop procedure DeleteOrder