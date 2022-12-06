Use MobilePhone;

go
Create procedure GET_GOODS_BY_ID
@search_id int
as begin
SELECT * from good where id_good = @search_id;
end;

declare @param int;
set @param = 1;
EXEC GET_GOODS_BY_ID @param;
--drop procedure GET_GOODS_BY_ID;


-- get all workers
go
Create procedure GET_WORKERS
as begin
SELECT * from worker where role = 0;
end;

EXEC GET_WORKERS;
--drop procedure GET_WORKERS;


-- get worker by name
go
Create procedure GET_WORKERS_BY_NAME
@search_text nvarchar(40)
as begin
SELECT * from worker where  (upper(secondName) like upper(@search_text) + '%')  or (upper(firstName)  like upper(@search_text) + '%');
end;

declare @param nvarchar(40);
set @param = 'Smith';
EXEC GET_WORKERS_BY_NAME @param;
--drop procedure GET_WORKERS_BY_NAME;


go
Create procedure GET_WORKER_BY_EMAIL
@search_text nvarchar(40)
as begin
SELECT * from worker where  email = @search_text;
end;

declare @param nvarchar(40);
set @param = 'tomsmith@gmail.com';
EXEC GET_WORKER_BY_EMAIL @param;
--drop procedure GET_WORKER_BY_EMAIL;

--get id worker by email

go
Create procedure GET_ID_WORKER_BY_EMAIL
@search_email nvarchar(40)
as begin
SELECT id_worker from worker where  email = @search_email;
end;

declare @param nvarchar(40);
set @param = 'tomsmith@gmail.com';
EXEC GET_ID_WORKER_BY_EMAIL @param;
--drop procedure GET_ID_WORKER_BY_EMAIL;


-- get role worker
go
Create procedure GET_ROLE_WORKER
@search_id int
as begin
SELECT role from worker where id_worker = @search_id;
end;

declare @param int;
set @param = 3; --если поставить id=5, то роль будет = 1(Admin)
EXEC GET_ROLE_WORKER @param;
--drop procedure GET_ROLE_WORKER;


-- delete client by id
go
Create procedure DELETE_CLIENT_BY_ID
@idClient int
as begin
delete from client where id_client = @idClient;
end;

declare @ic int;
--set @ic = 3;      
EXEC DELETE_CLIENT_BY_ID @ic;
--drop procedure DELETE_CLIENT_BY_ID;


-- get all clients
go
Create procedure GET_CLIENTS
as begin
SELECT * from client;
end;

EXEC GET_CLIENTS;
--drop procedure GET_CLIENTS;


-- get client by name
go
Create procedure GET_CLIENT_BY_NAME
@search_text nvarchar(40)
as begin
SELECT * from client where  (upper(secondName) like upper(@search_text) + '%')  or (upper(firstName)  like upper(@search_text) + '%');
end;

declare @param nvarchar(40);
set @param = 'Егор';
EXEC GET_CLIENT_BY_NAME @param;
--drop procedure GET_CLIENT_BY_NAME;

-- get client by email
go
Create procedure GET_CLIENT_BY_EMAIL
@search_text nvarchar(40)
as begin
SELECT * from client where  email = @search_text;
end;

declare @param nvarchar(40);
set @param = 'Egor@mail.ru';
EXEC GET_CLIENT_BY_EMAIL @param;
--drop procedure GET_CLIENT_BY_EMAIL;


-- get info client
go
Create procedure GET_INFO_CLIENT_BY_ID
@search_id int
as begin
SELECT * from client where  id_client = @search_id;
end;

declare @param int;
set @param = 1;
EXEC GET_INFO_CLIENT_BY_ID @param;
--drop procedure GET_INFO_CLIENT_BY_ID;

go
Create procedure GET_ID_CLIENT_BY_EMAIL
@search_email nvarchar(40)
as begin
SELECT id_client from client where  email = @search_email;
end;

declare @param nvarchar(40);
set @param = 'Egor@mail.ru';
EXEC GET_ID_CLIENT_BY_EMAIL @param;
--drop procedure GET_ID_CLIENT_BY_EMAIL;


--get client email
go
Create procedure GET_EMAIL_CLIENT_BY_ID
@search_id nvarchar(40)
as begin
SELECT email from client where  id_client = @search_id;
end;

declare @param int;
set @param = 1;
EXEC GET_EMAIL_CLIENT_BY_ID @param;
--drop procedure GET_EMAIL_CLIENT_BY_ID;


--get count client's orders

go
Create procedure GET_CLIENT_ORDERS_BY_ID
@search_id int
as begin
SELECT * from order_list where idClient = @search_id;
end;

declare @param nvarchar(40);
set @param = 1;
EXEC GET_CLIENT_ORDERS_BY_ID @param;
--drop procedure GET_CLIENT_ORDERS_BY_ID;

--get good comments
go
Create procedure GET_GOOD_COMMENTS_BY_ID
@search_id int
as begin
SELECT idClient, message from comment where  idGood = @search_id;
end;

declare @param nvarchar(40);
set @param = 1;
EXEC GET_GOOD_COMMENTS_BY_ID @param;
--drop procedure GET_GOOD_COMMENTS_BY_ID;

--get count good comments

go
Create procedure GET_COUNT_GOOD_COMMENTS_BY_ID
@search_id int
as begin
SELECT count(*) from comment where idGood = @search_id;
end;

declare @param nvarchar(40);
set @param = 1;
EXEC GET_COUNT_GOOD_COMMENTS_BY_ID @param;
--drop procedure GET_COUNT_GOOD_COMMENTS_BY_ID;


-- get datetime order
go
Create procedure GET_DATETIME_ORDER_BY_ID
@search_id int
as begin
SELECT * from timetable_worker where  id_freeDateTime = @search_id;
end;

declare @param int;
set @param = 1;
EXEC GET_DATETIME_ORDER_BY_ID @param;
--drop procedure GET_DATETIME_ORDER_BY_ID;


--get free datetime worker

go
Create procedure GET_FREEDATETIME_WORKER
@search_worker_firstname nvarchar(40),
@search_worker_secondname nvarchar(40)
as begin
declare @id_worker int;
set @id_worker = (SELECT id_worker from worker where  firstName = @search_worker_firstname and
													   secondName = @search_worker_secondname);

select freeDate, freeTime from timetable_worker where idWorker = @id_worker and 
													  status = 0; 
end;

declare @param1 nvarchar(40),  @param2 nvarchar(40);
set @param1 = 'Tom';
set @param2 = 'Smith';
EXEC GET_FREEDATETIME_WORKER @param1, @param2;
--drop procedure GET_FREEDATETIME_WORKER;


--get comment by id good

go
Create procedure GET_COMMENT_BY_ID_GOOD
@search_id int
as begin

select * from comment where idGood = @search_id; 
end;

declare @param int;
set @param = 1;
EXEC GET_COMMENT_BY_ID_GOOD @param;
--drop procedure GET_COMMENT_BY_ID_GOOD;

--add comment
go 
create procedure ADD_COMMENT 
@idClient int,
@idService int,
@inputMessage text

as begin

declare @time time, @date date;
set @date = CONVERT (date, GETDATE());
set @time = CONVERT (time, GETDATE());

insert into comment(idClient, idGood, commentDate, commentTime, message)
	   values(@idClient, @idService, @date, @time, @inputMessage);

end;

declare @idC int, @idS int, @message nvarchar(40);
set @idC = 3;
set @idS = 1;
set @message = 'NICE!!!';
EXEC ADD_COMMENT @idC,  @idS, @message;
--drop procedure ADD_COMMENT;

--delete comment
go 
create procedure DELETE_COMMENT 
@idComment int
as begin
delete from comment where id_comment = @idComment;
end;

declare @param nvarchar(40);
set @param = 1;
EXEC DELETE_COMMENT @param;
--drop procedure DELETE_COMMENT;