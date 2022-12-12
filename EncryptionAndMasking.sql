Use MobilePhone;

--Masking
select * from worker;
go
CREATE USER Test WITHOUT LOGIN;  

go 
CREATE USER TestAdmin WITHOUT LOGIN;  


ALTER ROLE db_datareader ADD MEMBER Test; 
ALTER ROLE db_datareader ADD MEMBER TestAdmin;

GRANT UNMASK TO TestAdmin;   
GRANT SELECT ON worker TO Test;
 
EXECUTE AS USER = 'TestAdmin';  
SELECT * FROM worker;  
REVERT;	 

EXECUTE AS USER = 'Test';  
SELECT * FROM worker;  
REVERT;


SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl   
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1;



--Encryption
--encrypt
--шифрование SQL Server на уровне столбцов с использованием симметричных ключей
--Создайте главный ключ базы данных для шифрования SQL Server на уровне столбцов
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'KruglikAlex';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- Создание сертификата для шифрования на уровне столбцов
GO
CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

--Настройка симметричного ключа для шифрования
CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_test;

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;




go
create procedure MaskWorker
AS BEGIN
	EXECUTE AS USER = 'Test';  
	SELECT * FROM worker;  
	REVERT;
END;

EXEC MaskWorker;

go
create procedure MaskAdminWorker
AS BEGIN
	EXECUTE AS USER = 'TestAdmin';  
	SELECT * FROM worker;  
	REVERT;
END;

EXEC MaskAdminWorker;

go
create procedure MaskClient
AS BEGIN
	EXECUTE AS USER = 'Test';  
	SELECT * FROM client;  
	REVERT;
END;

EXEC MaskClient;

go
create procedure MaskAdminClient
AS BEGIN
	EXECUTE AS USER = 'TestAdmin';  
	SELECT * FROM client;  
	REVERT;
END;

EXEC MaskAdminClient;



ALTER TABLE dbo.good
ADD price_encrypt varbinary(MAX) ----------ОБЯЗАТЕЛЬНО ДОБАВИТЬ ЭТУ СТРОКУ ПЕРЕД ТЕСТИРОВКОЙ МЕТОДА ШИФРОВАНИЯ

go
create procedure Encrypt
AS BEGIN
	OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

UPDATE dbo.good
        SET price_encrypt = EncryptByKey (Key_GUID('SymKey_test'), price)
        FROM dbo.good;
        
CLOSE SYMMETRIC KEY SymKey_test;

END;

EXEC Encrypt;
select * from good;
--drop procedure Encrypt;

go
create procedure Decoding

AS BEGIN
	OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

SELECT name, category, country, price_encrypt AS 'Encrypted data',
            CONVERT(nvarchar, DecryptByKey(price_encrypt)) AS 'Decrypted Bank account number'
            FROM dbo.good;

END;

EXEC Decoding;
--drop procedure Decoding;