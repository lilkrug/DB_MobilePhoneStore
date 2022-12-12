Use MobilePhone;

--заполнение 100000 строк
go
create procedure procedure_ADD_100_000_ROW
AS
BEGIN
DECLARE @secondName NVARCHAR(50);
DECLARE @firstName NVARCHAR(50);
DECLARE @phoneNumber NVARCHAR(50);
DECLARE @email NVARCHAR(50);
DECLARE @password NVARCHAR(50);
DECLARE @countJ INT;
SET @countJ=1;
while @countJ<100000
BEGIN
SET @secondName='secondName_'+cast(@countJ as varchar);
SET @firstName='firstName_'+cast(@countJ as varchar);
SET @phoneNumber='phoneNumber_'+cast(@countJ as varchar);
SET @email='email_'+cast(@countJ as varchar);
SET @password='password_'+cast(@countJ as varchar);

exec RegClient @secondName,@firstName,@phoneNumber, @email,@password
SET @countJ=@countJ+1;
END
END

Exec procedure_ADD_100_000_ROW;
--drop procedure procedure_ADD_100_000_ROW;


--удаление клиентов
go
Create Procedure DeleteClient @number int, @numberend int AS
Begin

While @number <= @numberend
	BEGIN
		delete from client where id_client = @number;

		set @number = @number + 1;
	END;
End;

declare @param int, @param2 int;
set @param = 2;
set @param2 = 140000;
exec DeleteClient @param, @param2;

select * from client;