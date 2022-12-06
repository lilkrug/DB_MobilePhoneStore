Use MobilePhone;

--------------------------------------------------------------------------------------

--Export to xml
go
create procedure GoodToXml
as
begin
	select name, category, price, country, description
	from good
		for xml path('good'), root('goods');

	exec master.dbo.sp_configure 'show advanced options', 1
		reconfigure with override
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		reconfigure with override;

	declare @cmd nvarchar(255);
	select @cmd = '
    bcp "use MobilePhone; select name, category, price, country, description from good for xml path(''good''), root(''goods'')" ' +
    'queryout "D:\Education\3 курс 1 сем\Kursach\Export.xml" -S .\SQLEXPRESS -T -w -r -t';
exec xp_cmdshell @cmd;
end; 

exec GoodToXml;

--drop procedure GoodToXml;

--import from xml to server 
go
create procedure XmlToGood
as begin
DECLARE @xml XML;

SELECT @xml = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK 'D:\Education\3 курс 1 сем\Kursach\Export.xml', SINGLE_BLOB) AS x

INSERT INTO  good(name, category, price, country, description)
SELECT 
	t.x.query('name').value('.', 'nvarchar(30)'),
	t.x.query('category').value('.', 'nvarchar(30)'),
	t.x.query('price').value('.', 'nvarchar(30)') ,
	t.x.query('country').value('.', 'nvarchar(30)') ,
	t.x.query('description').value('.', 'nvarchar(2000)')
FROM @xml.nodes('//goods/good') t(x)
end

select * from good;
exec XmlToGood;
-----
--drop procedure XmlToGood;
------
go
Create Procedure DeleteXmlData @number int, @numberend int AS
Begin

While @number <= @numberend
	BEGIN
		delete from good where id_good = @number;

		set @number = @number + 1;
	END;
End;

declare @param int, @param2 int;
set @param = 2;
set @param2 = 3;
exec DeleteXmlData @param, @param2;

--drop procedure DeleteXmlData