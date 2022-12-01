--Use master;
create database MobilePhone;
Use MobilePhone;

Create Table client
(
	id_client int identity(1,1) primary key,
	secondName nvarchar(50) not null,
	firstName nvarchar(50) not null,
	phoneNumber nvarchar(20) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL,
	email nvarchar(50) MASKED WITH (FUNCTION = 'email()') NULL,
	password nvarchar(60) MASKED WITH (FUNCTION = 'default()') NULL
);

insert into client(secondName, firstName, phoneNumber, email, password)
	values('Драчан', 'Егор', '+375298879566', 'Egor@mail.ru', '12345678'),
		  ('Мишук', 'Саша', '+3752934215564', 'Sasha@mail.ru', '22222222'),
		  ('Коржик', 'Иван', '+3752925467290', 'Korzh@mail.ru', '12532623')

select * from client;
delete from client where email = 'Egor@mail.ru';
--drop table clients;


Create Table good
(
	id_good int identity(1,1) primary key,
	name nvarchar(50) not null,
	category nvarchar(50) not null,
	price nvarchar(50) not null,
	country nvarchar(50) not null,
	description TEXT not null,
)

insert into good(name, category, price, country, description) 
	values('Apple', 'Iphone', '650$', 'USA', 'Most popular mobilephone in the world');

delete from good where id_good = 5;	
select * from good;
--drop table good;

Create Table worker(
	id_worker int identity(1,1) primary key,
	secondName nvarchar(50),
	firstName nvarchar(50),
	phoneNumber nvarchar(20) MASKED WITH (FUNCTION = 'partial(5,"XXXXXXX",0)') NULL,
	email nvarchar(50) MASKED WITH (FUNCTION = 'email()') NULL,
	password nvarchar(60) MASKED WITH (FUNCTION = 'default()') NULL,
	role smallint, --0 - worker, 1 -admin
	salary nvarchar(20)
);

--drop table worker;

select * from worker;
insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Smith', 'Tom', '+375331245856', 'tomsmith@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1360$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Ford', 'Reyna', '+375254589632', 'freyna@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1420$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Chapman', 'Morgan', '+375338950127', 'liloooo@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1390$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Kelly', 'Piper', '+375299875823', 'piperka@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1610$');

insert into worker(secondName,firstName, phoneNumber, email, password, role) --admin
		     values('Admin', 'Admin', '+375448695364', 'admin@mail.ru','21232f297a57a5a743894a0e4a801fc3', 1);

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Miller', 'Victoria', '+375444789507', 'vik@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1250$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Cooper', 'Tina', '+375444748507', 'coop@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1310$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Jones', 'Lila', '+375338950127', 'liloooo@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1220$');

insert into worker(secondName,firstName, phoneNumber, email, password, role, salary)
		     values('Wood', 'Lolita', '+375298289507', 'woooooood@gmail.com','21232f297a57a5a743894a0e4a801fc3', 0, '1550$');
--delete from worker where id_worker = 18;

Create Table order_list
(
	id_order int identity(1,1) primary key,
	idClient int foreign key (idClient) references client(id_client) not null,
	idWorker int foreign key (idWorker) references worker(id_worker) not null, 
	idGood int foreign key (idGood) references good(id_good) not null,
	idFreeTime int foreign key (idFreeTime) references timetable_worker(id_freeDateTime) not null,
	status smallint -- 0 - completed, 1 -not done
)

select * from order_list;
insert into order_list(idClient,  idWorker, idGood, idFreeTime , status)
			values(1, 1, 1, 3, 0);

update order_list set status = 1 where id_order = 2;
select * from order_list where id_order = 1;
delete from order_list where status = 0;
--drop table order_list;

create table timetable_worker(
	id_freeDateTime int identity(1,1) primary key not null,
	idWorker int foreign key (idWorker) references worker(id_worker) not null, 
	freeDate date not null,
	freeTime time not null,
	status smallint -- 0 -free
);

insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(1, '30-12-2020', '13:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(1, '28-12-2020', '15:30', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(2, '29-12-2020', '9:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(2, '30-12-2020', '20:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(3, '25-12-2020', '13:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(3, '26-12-2020', '11:00', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(4, '30-12-2020', '13:00', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(4, '30-12-2020', '14:30', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(6, '30-12-2020', '13:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(7, '30-12-2020', '10:45', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(7, '26-12-2020', '17:00', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(8, '18-12-2020', '17:50', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(8, '29-12-2020', '9:00', 0);
insert into timetable_worker(idWorker,freeDate, freetime, status)
			values(9, '30-12-2020', '13:50', 0);
select * from timetable_worker;
--drop table timetable_worker;


Create Table comment
(
	id_comment int identity(1,1) primary key,
	idClient int foreign key (idClient) references client(id_client) not null, 
	idGood int foreign key (idGood) references good(id_good) not null,
	commentDate date not null,
	commentTime time not null,
	message TEXT not null
)

select * from comment;
delete from comment;

insert into comment(idClient, idGood, commentDate, commentTime, message)
			values(1, 1, '28-10-2020', '13:20',  'I really liked this service.I advise everyone');

--drop table comment;



