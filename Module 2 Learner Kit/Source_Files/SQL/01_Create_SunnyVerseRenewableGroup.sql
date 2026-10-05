/*
SunnyVerse Power BI Master Series — Module 2
01_Create_SunnyVerseRenewableGroup.sql
Purpose: Create the local training database and deterministic connectivity lab data.
Target: SQL Server Developer Edition. Non-production training use only.
*/
USE master;
GO
IF DB_ID(N'SunnyVerseRenewableGroup') IS NOT NULL
BEGIN
    ALTER DATABASE SunnyVerseRenewableGroup SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SunnyVerseRenewableGroup;
END;
GO
CREATE DATABASE SunnyVerseRenewableGroup;
GO
USE SunnyVerseRenewableGroup;
GO

CREATE TABLE dbo.Regions(
    RegionID varchar(10) NOT NULL PRIMARY KEY,
    RegionName varchar(100) NOT NULL,
    TimeZoneName varchar(100) NOT NULL
);

CREATE TABLE dbo.Technologies(
    TechnologyCode varchar(10) NOT NULL PRIMARY KEY,
    TechnologyName varchar(100) NOT NULL,
    TechnologyFamily varchar(50) NOT NULL,
    AssetBehavior varchar(40) NOT NULL,
    BaseCapacityFactor decimal(6,4) NULL
);

CREATE TABLE dbo.Plants(
    PlantID varchar(20) NOT NULL PRIMARY KEY,
    PlantName varchar(120) NOT NULL,
    RegionID varchar(10) NOT NULL,
    TechnologyCode varchar(10) NOT NULL,
    GenerationCapacityMW decimal(10,2) NOT NULL,
    StoragePowerMW decimal(10,2) NOT NULL,
    StorageEnergyMWh decimal(10,2) NOT NULL,
    GenerationSequence tinyint NULL,
    CONSTRAINT FK_Plants_Regions FOREIGN KEY(RegionID) REFERENCES dbo.Regions(RegionID),
    CONSTRAINT FK_Plants_Technologies FOREIGN KEY(TechnologyCode) REFERENCES dbo.Technologies(TechnologyCode)
);

INSERT dbo.Regions(RegionID,RegionName,TimeZoneName) VALUES
('R01','Pacific Northwest','America/Los_Angeles'),
('R02','Desert Southwest','America/Phoenix'),
('R03','Great Plains','America/Chicago'),
('R04','Atlantic Coast','America/New_York');

INSERT dbo.Technologies(TechnologyCode,TechnologyName,TechnologyFamily,AssetBehavior,BaseCapacityFactor) VALUES
('T01','Solar PV','Solar','Generation',0.2400),
('T02','Wind Onshore','Wind','Generation',0.3800),
('T03','Wind Offshore','Wind','Generation',0.4400),
('T04','Hydroelectric','Hydro','Generation',0.5200),
('T05','Battery Energy Storage System','BESS','Storage',NULL),
('T06','Geothermal','Geothermal','Generation',0.9000),
('T07','Biomass/Biogas','Biomass/Biogas','Generation',0.7800),
('T08','Hybrid Solar + BESS','Hybrid','Generation + Storage',0.2600),
('T09','Hybrid Wind + BESS','Hybrid','Generation + Storage',0.4000);

INSERT dbo.Plants(PlantID,PlantName,RegionID,TechnologyCode,GenerationCapacityMW,StoragePowerMW,StorageEnergyMWh,GenerationSequence) VALUES
('SVR-001','Cascade Hydro One','R01','T04',300,0,0,1),
('SVR-002','Rainshadow Hydro Two','R01','T04',180,0,0,2),
('SVR-003','Solara Mesa Solar','R02','T01',220,0,0,3),
('SVR-004','Red Rock Solar','R02','T01',180,0,0,4),
('SVR-005','Prairie Wind One','R03','T02',250,0,0,5),
('SVR-006','Prairie Wind Two','R03','T02',200,0,0,6),
('SVR-007','Atlantic Horizon Wind','R04','T03',350,0,0,7),
('SVR-008','GeoSpring One','R02','T06',120,0,0,8),
('SVR-009','BioCycle Plains','R03','T07',80,0,0,9),
('SVR-010','Battery Hub West','R02','T05',0,100,400,NULL),
('SVR-011','SunStore Hybrid','R02','T08',150,50,200,10),
('SVR-012','WindStore Hybrid','R04','T09',160,40,160,11);
GO

CREATE TABLE dbo.IntervalGeneration(
    ReadingID bigint NOT NULL PRIMARY KEY,
    PlantID varchar(20) NOT NULL,
    IntervalStartUTC datetime2(0) NOT NULL,
    ActualGenerationMWh decimal(18,4) NOT NULL,
    ForecastGenerationMWh decimal(18,4) NOT NULL,
    SourceSystem varchar(40) NOT NULL,
    LoadTimestampUTC datetime2(0) NOT NULL,
    CONSTRAINT FK_IntervalGeneration_Plants FOREIGN KEY(PlantID) REFERENCES dbo.Plants(PlantID)
);
GO

;WITH N AS (
    SELECT TOP (500000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT dbo.IntervalGeneration
    (ReadingID,PlantID,IntervalStartUTC,ActualGenerationMWh,ForecastGenerationMWh,SourceSystem,LoadTimestampUTC)
SELECT
    n.n + 1,
    p.PlantID,
    DATEADD(MINUTE, 15 * (n.n / 11), CAST('2025-07-01T00:00:00' AS datetime2(0))),
    CAST(ROUND(calc.ActualMWh,4) AS decimal(18,4)),
    CAST(ROUND(calc.ActualMWh * (0.985 + ((n.n * 19) % 31) / 1000.0),4) AS decimal(18,4)),
    'SunnyVerse Operations Historian',
    CAST('2026-10-01T06:00:00' AS datetime2(0))
FROM N n
JOIN dbo.Plants p
  ON p.GenerationSequence = (n.n % 11) + 1
JOIN dbo.Technologies t
  ON t.TechnologyCode = p.TechnologyCode
CROSS APPLY (
    SELECT p.GenerationCapacityMW * 0.25 * t.BaseCapacityFactor
           * (0.90 + ((n.n * 37) % 21) / 100.0) AS ActualMWh
) calc;
GO

CREATE INDEX IX_IntervalGeneration_IntervalStartUTC
ON dbo.IntervalGeneration(IntervalStartUTC)
INCLUDE (PlantID,ActualGenerationMWh,ForecastGenerationMWh);
GO

CREATE INDEX IX_IntervalGeneration_PlantID_IntervalStartUTC
ON dbo.IntervalGeneration(PlantID,IntervalStartUTC)
INCLUDE (ActualGenerationMWh,ForecastGenerationMWh);
GO

CREATE TABLE dbo.BatteryStorageInterval(
    StorageReadingID bigint NOT NULL PRIMARY KEY,
    PlantID varchar(20) NOT NULL,
    IntervalStartUTC datetime2(0) NOT NULL,
    StateOfChargePct decimal(7,4) NOT NULL,
    ChargeMWh decimal(18,4) NOT NULL,
    DischargeMWh decimal(18,4) NOT NULL,
    CONSTRAINT FK_BatteryStorageInterval_Plants FOREIGN KEY(PlantID) REFERENCES dbo.Plants(PlantID)
);
GO

;WITH N AS (
    SELECT TOP (50000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),
StoragePlants AS (
    SELECT * FROM (VALUES
        (1,'SVR-010'),
        (2,'SVR-011'),
        (3,'SVR-012')
    ) s(StorageSequence,PlantID)
)
INSERT dbo.BatteryStorageInterval
    (StorageReadingID,PlantID,IntervalStartUTC,StateOfChargePct,ChargeMWh,DischargeMWh)
SELECT
    n.n + 1,
    s.PlantID,
    DATEADD(MINUTE,15*(n.n/3),CAST('2026-04-01T00:00:00' AS datetime2(0))),
    CAST((20 + ((n.n * 7) % 75)) / 100.0 AS decimal(7,4)),
    CAST(CASE WHEN n.n % 4 IN (0,1) THEN 1.25 + ((n.n * 11) % 40)/20.0 ELSE 0 END AS decimal(18,4)),
    CAST(CASE WHEN n.n % 4 IN (2,3) THEN 1.10 + ((n.n * 13) % 36)/20.0 ELSE 0 END AS decimal(18,4))
FROM N n
JOIN StoragePlants s ON s.StorageSequence=(n.n%3)+1;
GO

CREATE OR ALTER VIEW dbo.vw_ConnectivityLab
AS
SELECT
    g.ReadingID,
    g.IntervalStartUTC,
    CAST(g.IntervalStartUTC AS date) AS ReadingDate,
    p.PlantID,
    p.PlantName,
    r.RegionID,
    r.RegionName,
    t.TechnologyCode,
    t.TechnologyFamily,
    p.GenerationCapacityMW,
    g.ActualGenerationMWh,
    g.ForecastGenerationMWh
FROM dbo.IntervalGeneration g
JOIN dbo.Plants p ON p.PlantID=g.PlantID
JOIN dbo.Regions r ON r.RegionID=p.RegionID
JOIN dbo.Technologies t ON t.TechnologyCode=p.TechnologyCode;
GO

ALTER DATABASE SunnyVerseRenewableGroup SET QUERY_STORE = ON;
GO

SELECT 'Regions' AS ObjectName, COUNT_BIG(*) AS [RowCount] FROM dbo.Regions
UNION ALL SELECT 'Technologies', COUNT_BIG(*) FROM dbo.Technologies
UNION ALL SELECT 'Plants', COUNT_BIG(*) FROM dbo.Plants
UNION ALL SELECT 'IntervalGeneration', COUNT_BIG(*) FROM dbo.IntervalGeneration
UNION ALL SELECT 'BatteryStorageInterval', COUNT_BIG(*) FROM dbo.BatteryStorageInterval
UNION ALL SELECT 'vw_ConnectivityLab', COUNT_BIG(*) FROM dbo.vw_ConnectivityLab;
GO
