/*
04_Optional_SQL_Authentication_Lab.sql
OPTIONAL. Run only if the SQL Server instance has Mixed Mode authentication enabled.
This is a local training login. Never reuse training credentials in production.
Change the password below before execution.
*/
USE SunnyVerseRenewableGroup;
GO
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N'SunnyVerseModule2Reader')
    DROP USER SunnyVerseModule2Reader;
GO

USE master;
GO
IF EXISTS (SELECT 1 FROM sys.sql_logins WHERE name=N'SunnyVerseModule2Reader')
    DROP LOGIN SunnyVerseModule2Reader;
GO

CREATE LOGIN SunnyVerseModule2Reader
WITH PASSWORD = 'CHANGE_THIS_LOCAL_TRAINING_PASSWORD!',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = OFF;
GO

USE SunnyVerseRenewableGroup;
GO
CREATE USER SunnyVerseModule2Reader FOR LOGIN SunnyVerseModule2Reader;
ALTER ROLE db_datareader ADD MEMBER SunnyVerseModule2Reader;
GO

-- Controlled failure: run this from master to disable the login.
-- ALTER LOGIN SunnyVerseModule2Reader DISABLE;
-- Recovery:
-- ALTER LOGIN SunnyVerseModule2Reader ENABLE;
