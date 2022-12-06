use MobilePhone;

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
--drop procedure UpdateOrderByClient 