/*
05_Recover_SQL_Authentication_Lab.sql
Use after the controlled disabled-login scenario.
*/
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.sql_logins WHERE name=N'SunnyVerseModule2Reader')
    ALTER LOGIN SunnyVerseModule2Reader ENABLE;
GO
