use MobilePhone;

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