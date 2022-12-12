Use MobilePhone;
--Хранимые процедуры позволяют объединить последовательность запросов и сохранить их на сервере
-- поиск товара
go
Create procedure GET_GOODS_BY_NAME
@search_text nvarchar(40)
as begin
SELECT * from good where (upper(name) like upper(@search_text) + '%');
end;

declare @param nvarchar(40);
set @param = 'APPLE';
EXEC GET_GOODS_BY_NAME @param;
--drop procedure GET_GOODS_BY_NAME;



--рестрация клиента
go
Create procedure RegClient
	@firstName nvarchar(35),
	@secondName nvarchar(35),
	@phoneNumber nvarchar(20),
	@email nvarchar(50),
	@password nvarchar(60)
AS
Begin
	insert into client(secondName,firstName, phoneNumber, email, password)
	values (@secondName, @firstName, @phoneNumber, @email, @password);
	
End;

declare @first nvarchar(35),@second nvarchar(35),@phone nvarchar(20), @em nvarchar(50),@p nvarchar(60);
set @first = 'тест';
set @second = 'тест';
set @phone = 'тест';
set @em = 'тест';
set @p = 'тест';
EXEC RegClient @first,@second, @phone, @em, @p;
--drop procedure RegClient;
select * from client;


--авторизация клиента
go
Create procedure Login
	@log nvarchar(13),
	@pass nvarchar(30)
AS
Begin
	Declare @passwordClient nvarchar(30);
	Declare @passwordWorker nvarchar(30);
	set @passwordClient = (select password from client where email= @log);
	set @passwordWorker = (select password from worker where email= @log);
	
	if @passwordClient = @pass or @passwordWorker = @pass
		select 1 as login;
	else 
		select 0 as login;
End;


declare @em nvarchar(50),@p nvarchar(60);
set @em = 'тест';
set @p = 'тест';
EXEC Login  @em, @p;
select * from client;



--добавление товара в корзину

go 
Create procedure ADD_GOOD
	@Name nvarchar(35),
	@Category nvarchar(35),
	@Price nvarchar(20),
	@Country nvarchar(50),
	@Description TEXT
as begin 
	insert into good(name, category, price, country, description)
	values (@Name, @Category, @Price, @Country, @Description);
end;

declare @nam nvarchar(35),@cat nvarchar(35),@pri nvarchar(20), @cou nvarchar(50),@des nvarchar(60);
set @nam = 'тест1';
set @cat = 'тест1';
set @pri = 'тест1';
set @cou = 'тест1';
set @des = 'тест1';
EXEC ADD_GOOD @nam,@cat, @pri, @cou, @des;
--drop procedure INSERT_GOOD
select * from good;

--удаление товара из корзины
go 
Create Procedure DELETE_GOOD
	@idGood int
as begin 
	delete from good where id_good = @idGood;
end;

declare @ic int;
set @ic = 6;      
EXEC DELETE_GOOD @ic;



--оформление заказа
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
set @paramIdClient = 4;
set @paramOrderDate = '26-12-2020';
set @paramOrderTime = '17:00';
set @paramNameGood = 'Apple';
set @paramFirstNameWorker = 'Tina';
set @paramSecondNameWorker = 'Cooper';
EXEC AddOrder @paramIdClient, @paramOrderDate,
								@paramOrderTime,@paramNameGood,
								@paramFirstNameWorker,
								@paramSecondNameWorker;
--drop procedure AddOrder;
select * from order_list



--редактирование товаров
go
Create Procedure EDIT_GOODS
	@Price nvarchar(30),
	@idGood int
as begin
	update good set price = @Price where id_good = @idGood;
end;

declare @paramprice nvarchar(30), @paramid int ;
set @paramprice = '800$';
set @paramid = 1;
EXEC EDIT_GOODS @paramprice, @paramid;

select * from good;
--drop procedure EDIT_GOODS;



--просмотр товаров
go
Create procedure GET_GOODS
as begin
SELECT * from good;
end;

EXEC GET_GOODS;
--drop procedure GET_GOODS;



--просмотр заказов
go
Create procedure GET_ORDER_LIST
as begin
SELECT * from order_list;
end;

EXEC GET_ORDER_LIST;
--drop procedure GET_ORDER_LIST

