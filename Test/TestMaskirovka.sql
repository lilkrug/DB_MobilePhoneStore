--Use master;
create database TestKursach;
Use TestKursach;

CREATE TABLE Membership  
(
   MemberID int IDENTITY PRIMARY KEY,  
   FirstName varchar(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL,  
   LastName varchar(100) NOT NULL,  
   Phone varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,  
   Email varchar(100) MASKED WITH (FUNCTION = 'email()') NULL
); 

--alter table dbo.membership alter column LastName varchar(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL;
--alter table dbo.membership alter column Email Drop MASKED;
--alter table dbo.membership alter column LastName Drop MASKED;


INSERT Membership (FirstName, LastName, Phone, Email) VALUES   
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com'),  
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co'),  
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net'); 

--SELECT * FROM Membership;
--GRANT CREATE TABLE,INSERT, UPDATE ON Membership TO DDMUser;

go
CREATE USER Test1 WITHOUT LOGIN;  

go 
CREATE USER TestAdmin WITHOUT LOGIN;  

ALTER ROLE db_datareader ADD MEMBER Test1; 
ALTER ROLE db_datareader ADD MEMBER TestAdmin;

GRANT UNMASK TO TestAdmin;  
GRANT SELECT ON Membership TO Test1;
 
EXECUTE AS USER = 'TestAdmin';  
SELECT * FROM Membership;  
REVERT;	 

EXECUTE AS USER = 'Test1';  
SELECT * FROM Membership;  
REVERT;


SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl   
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1;




--Encryption
CREATE TABLE CustomerInfo
            (CustID        INT PRIMARY KEY, 
             CustName     VARCHAR(30) NOT NULL, 
             BankACCNumber VARCHAR(10) NOT NULL
            );
            GO
			Insert into CustomerInfo (CustID,CustName,BankACCNumber)
            Select 1,'Rajendra',11111111 UNION ALL
            Select 2, 'Manoj',22222222 UNION ALL
            Select 3, 'Shyam',33333333 UNION ALL
            Select 4,'Akshita',44444444 UNION ALL
            Select 5, 'Kashish',55555555

select * from CustomerInfo;
--drop table CustomerInfo;

--Зашифровать
--CREATE MASTER KEY для создания главного ключа базы данных

GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQLShack@1';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- Создание сертификата для шифрования
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

--
ALTER TABLE dbo.CustomerInfo
ADD BankACCNumber_encrypt varbinary(MAX)

OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

UPDATE dbo.CustomerInfo
        SET BankACCNumber_encrypt = EncryptByKey (Key_GUID('SymKey_test'), BankACCNumber)
        FROM dbo.CustomerInfo;
        
CLOSE SYMMETRIC KEY SymKey_test;

ALTER TABLE dbo.CustomerInfo DROP COLUMN BankACCNumber;
Alter table dbo.CustomerInfo Add BankACCNumber varchar(10);
--ALTER TABLE dbo.CustomerInfo DROP COLUMN BankACCNumber_encrypt;
 


--Расшифровать
--открываем симметричный ключ и расшифруем с помощью сертификата.
OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

SELECT CustID, CustName,BankACCNumber_encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(BankACCNumber_encrypt)) AS 'Decrypted Bank account number'
            FROM dbo.CustomerInfo;

--Для разрешения пользователям
GRANT VIEW DEFINITION ON SYMMETRIC KEY::SymKey_test TO SQLShack; 
GO
GRANT VIEW DEFINITION ON Certificate::[Certificate_test] TO SQLShack;
GO
GRANT CONTROL ON Certificate::[Certificate_test] TO SQLShack;


go
create procedure Mask
AS BEGIN
	EXECUTE AS USER = 'Test1';  
	SELECT * FROM Membership;  
	REVERT;
END;

EXEC Mask;

go
create procedure MaskAdmin
AS BEGIN
	EXECUTE AS USER = 'TestAdmin';  
	SELECT * FROM Membership;  
	REVERT;
END;

EXEC MaskAdmin;

go
create procedure Encrypt
AS BEGIN
	OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

UPDATE dbo.CustomerInfo
        SET BankACCNumber_encrypt = EncryptByKey (Key_GUID('SymKey_test'), BankACCNumber)
        FROM dbo.CustomerInfo;
        
CLOSE SYMMETRIC KEY SymKey_test;

ALTER TABLE dbo.CustomerInfo DROP COLUMN BankACCNumber;

END;

EXEC Encrypt;
select * from CustomerInfo;
--drop procedure Encrypt;

go
create procedure Decoding

AS BEGIN
	OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

SELECT CustID, CustName,BankACCNumber_encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(BankACCNumber_encrypt)) AS 'Decrypted Bank account number'
            FROM dbo.CustomerInfo;

END;

EXEC Decoding;
--drop procedure Decoding;







			


