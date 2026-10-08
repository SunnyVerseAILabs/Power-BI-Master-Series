/*
SunnyVerse Power BI Master Series — Module 4
01_Extend_SunnyVerseRenewableGroup_Module_04.sql
Purpose: Extend the already validated SunnyVerseRenewableGroup database with deterministic semantic-modeling sources.
Prerequisite: Module 2/3 base database exists and retains 4 Regions, 9 Technologies, 12 Plants, 500,000 IntervalGeneration rows and 50,000 BatteryStorageInterval rows.
This script does NOT recreate the database and does NOT alter inherited source truth.
*/
USE SunnyVerseRenewableGroup;
GO
IF (SELECT COUNT_BIG(*) FROM dbo.Regions) <> 4 OR (SELECT COUNT_BIG(*) FROM dbo.Technologies) <> 9 OR (SELECT COUNT_BIG(*) FROM dbo.Plants) <> 12 OR (SELECT COUNT_BIG(*) FROM dbo.IntervalGeneration) <> 500000 OR (SELECT COUNT_BIG(*) FROM dbo.BatteryStorageInterval) <> 50000
    THROW 51000, 'Inherited SunnyVerse baseline does not match the frozen Module 3 prerequisite.', 1;
GO

-- Remove only Module Four extension objects so rerunning the extension is deterministic.
DROP VIEW IF EXISTS dbo.Model_FactIntervalGeneration_RI_Broken;
DROP VIEW IF EXISTS dbo.Model_FactIntervalGeneration;
DROP TABLE IF EXISTS dbo.Model_AggGenerationDayPlant;
DROP TABLE IF EXISTS dbo.Model_FactHydroOperatingContext;
DROP TABLE IF EXISTS dbo.Model_FactRegionalTargetMonthly;
DROP TABLE IF EXISTS dbo.Model_FactGenerationForecast;
DROP TABLE IF EXISTS dbo.Model_FactInspectionSchedule;
DROP TABLE IF EXISTS dbo.Model_FactMaintenanceTask;
DROP TABLE IF EXISTS dbo.Model_FactMaintenanceWorkOrder;
DROP TABLE IF EXISTS dbo.Model_FactBatteryDailySnapshot;
DROP TABLE IF EXISTS dbo.Model_BridgeEquipmentSupplier;
DROP TABLE IF EXISTS dbo.Model_BridgePlantContract;
DROP TABLE IF EXISTS dbo.Model_DimMaintenanceFlags;
DROP TABLE IF EXISTS dbo.Model_DimContract;
DROP TABLE IF EXISTS dbo.Model_DimEquipment;
DROP TABLE IF EXISTS dbo.Model_DimSupplier;
DROP TABLE IF EXISTS dbo.Model_DimPlantHistory;
DROP TABLE IF EXISTS dbo.Model_DimPlantCurrent;
DROP TABLE IF EXISTS dbo.Model_DimTechnology;
DROP TABLE IF EXISTS dbo.Model_DimRegion;
DROP TABLE IF EXISTS dbo.Model_DimTime_Source;
DROP TABLE IF EXISTS dbo.Model_DimDate_Source;
GO


CREATE TABLE dbo.Model_DimRegion(
 RegionKey int NOT NULL PRIMARY KEY, RegionID varchar(10) NOT NULL UNIQUE, RegionName varchar(100) NOT NULL,
 TimeZoneName varchar(100) NOT NULL, CountryCode char(2) NOT NULL, Latitude decimal(9,4) NULL, Longitude decimal(9,4) NULL,
 RegionWebsiteURL varchar(250) NULL, RegionImageURL varchar(250) NULL
);
CREATE TABLE dbo.Model_DimTechnology(
 TechnologyKey int NOT NULL PRIMARY KEY, TechnologyCode varchar(10) NOT NULL UNIQUE, TechnologyName varchar(100) NOT NULL,
 TechnologyFamily varchar(50) NOT NULL, AssetBehavior varchar(40) NOT NULL, BaseCapacityFactor decimal(6,4) NULL
);
CREATE TABLE dbo.Model_DimPlantCurrent(
 PlantKey int NOT NULL PRIMARY KEY, PlantID varchar(20) NOT NULL UNIQUE, PlantName varchar(120) NOT NULL, SiteName varchar(120) NOT NULL,
 RegionKey int NOT NULL, TechnologyKey int NOT NULL, GenerationCapacityMW decimal(10,2) NOT NULL, StoragePowerMW decimal(10,2) NOT NULL,
 StorageEnergyMWh decimal(10,2) NOT NULL, CommissioningDate date NOT NULL, CommissioningDateKey int NOT NULL, OperatingStatus varchar(30) NOT NULL
);
CREATE TABLE dbo.Model_DimPlantHistory(
 PlantSK int NOT NULL PRIMARY KEY, PlantKey int NOT NULL, PlantID varchar(20) NOT NULL, VersionNumber tinyint NOT NULL,
 PlantName varchar(120) NOT NULL, SiteName varchar(120) NOT NULL, RegionKey int NOT NULL, TechnologyKey int NOT NULL,
 GenerationCapacityMW decimal(10,2) NOT NULL, StoragePowerMW decimal(10,2) NOT NULL, StorageEnergyMWh decimal(10,2) NOT NULL,
 CommissioningDate date NOT NULL, CommissioningDateKey int NOT NULL, OperatingStatus varchar(30) NOT NULL,
 EffectiveStartDate date NOT NULL, EffectiveEndDate date NOT NULL, IsCurrent bit NOT NULL, ChangeReason varchar(200) NOT NULL,
 CONSTRAINT UQ_Model_DimPlantHistory_BusinessVersion UNIQUE(PlantID,VersionNumber)
);
CREATE TABLE dbo.Model_DimDate_Source(
 DateKey int NOT NULL PRIMARY KEY, [Date] date NOT NULL UNIQUE, [Year] smallint NOT NULL, [Quarter] char(2) NOT NULL,
 MonthNumber tinyint NOT NULL, MonthName varchar(15) NOT NULL, YearMonth char(7) NOT NULL, [Day] tinyint NOT NULL,
 DayName varchar(15) NOT NULL, DayOfWeek tinyint NOT NULL, IsWeekend bit NOT NULL, FiscalYear varchar(8) NOT NULL,
 FiscalQuarter varchar(4) NOT NULL, FiscalMonthNumber tinyint NOT NULL
);
CREATE TABLE dbo.Model_DimTime_Source(
 TimeKey smallint NOT NULL PRIMARY KEY, [Time] time(0) NOT NULL UNIQUE, [Hour] tinyint NOT NULL, [Minute] tinyint NOT NULL,
 QuarterHourIndex tinyint NOT NULL, QuarterHourLabel char(5) NOT NULL, DayPart varchar(12) NOT NULL
);
CREATE TABLE dbo.Model_DimSupplier(
 SupplierKey int NOT NULL PRIMARY KEY, SupplierID varchar(20) NOT NULL UNIQUE, SupplierName varchar(160) NOT NULL,
 SupplierCategory varchar(80) NOT NULL, CountryCode char(2) NOT NULL, PreferredFlag bit NOT NULL, RiskTier varchar(20) NOT NULL
);
CREATE TABLE dbo.Model_DimEquipment(
 EquipmentKey int NOT NULL PRIMARY KEY, EquipmentID varchar(30) NOT NULL UNIQUE, PlantKey int NOT NULL, TechnologyKey int NOT NULL,
 ParentEquipmentKey int NULL, EquipmentName varchar(160) NOT NULL, EquipmentType varchar(50) NOT NULL, HierarchyLevel tinyint NOT NULL,
 Level1Name varchar(160) NULL, Level2Name varchar(160) NULL, Level3Name varchar(160) NULL
);
CREATE TABLE dbo.Model_DimContract(
 ContractKey int NOT NULL PRIMARY KEY, ContractID varchar(20) NOT NULL UNIQUE, ContractName varchar(160) NOT NULL,
 ContractType varchar(50) NOT NULL, StartDate date NOT NULL, EndDate date NOT NULL, Currency char(3) NOT NULL
);
CREATE TABLE dbo.Model_DimMaintenanceFlags(
 MaintenanceFlagsKey tinyint NOT NULL PRIMARY KEY, SafetyCritical bit NOT NULL, PlannedFlag bit NOT NULL, RequiresShutdown bit NOT NULL, FlagLabel varchar(100) NOT NULL
);
CREATE TABLE dbo.Model_BridgePlantContract(PlantKey int NOT NULL, ContractKey int NOT NULL, AssociationType varchar(20) NOT NULL, PRIMARY KEY(PlantKey,ContractKey));
CREATE TABLE dbo.Model_BridgeEquipmentSupplier(EquipmentKey int NOT NULL, SupplierKey int NOT NULL, AssociationType varchar(20) NOT NULL, PRIMARY KEY(EquipmentKey,SupplierKey));
CREATE TABLE dbo.Model_FactMaintenanceWorkOrder(
 WorkOrderKey int NOT NULL PRIMARY KEY, MaintenanceEventID varchar(20) NOT NULL, WorkOrderID varchar(20) NOT NULL UNIQUE, PlantKey int NOT NULL,
 RaisedDateKey int NOT NULL, StartDateKey int NOT NULL, ClosedDateKey int NULL, MaintenanceType varchar(30) NOT NULL, Status varchar(30) NOT NULL,
 MaintenanceFlagsKey tinyint NOT NULL, DurationHours decimal(10,2) NULL, CostUSD decimal(18,2) NULL
);
CREATE TABLE dbo.Model_FactMaintenanceTask(
 TaskKey int NOT NULL PRIMARY KEY, WorkOrderID varchar(20) NOT NULL, TaskSequence tinyint NOT NULL, PlantKey int NOT NULL,
 TaskDateKey int NOT NULL, TaskType varchar(50) NOT NULL, TaskDurationHours decimal(10,2) NULL, TaskCostUSD decimal(18,2) NULL
);
CREATE TABLE dbo.Model_FactInspectionSchedule(
 InspectionKey int NOT NULL PRIMARY KEY, PlantKey int NOT NULL, EquipmentKey int NOT NULL, ScheduledDateKey int NOT NULL,
 InspectionType varchar(30) NOT NULL, RequiredFlag bit NOT NULL
);
CREATE TABLE dbo.Model_FactGenerationForecast(
 ForecastKey int NOT NULL PRIMARY KEY, PlantKey int NOT NULL, IssueDateKey int NOT NULL, TargetDateKey int NOT NULL,
 ForecastVersion tinyint NOT NULL, ForecastGenerationMWh decimal(18,2) NOT NULL
);
CREATE TABLE dbo.Model_FactRegionalTargetMonthly(
 TargetKey int NOT NULL PRIMARY KEY, RegionKey int NOT NULL, TargetMonthKey int NOT NULL, TargetMonth char(7) NOT NULL,
 GenerationTargetMWh decimal(18,2) NOT NULL
);
CREATE TABLE dbo.Model_FactHydroOperatingContext(
 HydroContextKey int NOT NULL PRIMARY KEY, PlantKey int NOT NULL, DateKey int NOT NULL,
 ReservoirLevelPct decimal(7,2) NOT NULL, InflowM3s decimal(10,2) NOT NULL, SpillFlag bit NOT NULL
);
GO

INSERT dbo.Model_DimRegion (RegionKey,RegionID,RegionName,TimeZoneName,CountryCode,Latitude,Longitude,RegionWebsiteURL,RegionImageURL) VALUES
(1,N'R01',N'Pacific Northwest',N'America/Los_Angeles',N'US',45.5152,-122.6784,N'https://sunnyverse.example/regions/r01',N'https://sunnyverse.example/images/r01.png'),
(2,N'R02',N'Desert Southwest',N'America/Phoenix',N'US',33.4484,-112.074,N'https://sunnyverse.example/regions/r02',N'https://sunnyverse.example/images/r02.png'),
(3,N'R03',N'Great Plains',N'America/Chicago',N'US',41.2565,-95.9345,N'https://sunnyverse.example/regions/r03',N'https://sunnyverse.example/images/r03.png'),
(4,N'R04',N'Atlantic Coast',N'America/New_York',N'US',36.8508,-76.2859,N'https://sunnyverse.example/regions/r04',N'https://sunnyverse.example/images/r04.png');
GO

INSERT dbo.Model_DimTechnology (TechnologyKey,TechnologyCode,TechnologyName,TechnologyFamily,AssetBehavior,BaseCapacityFactor) VALUES
(1,N'T01',N'Solar PV',N'Solar',N'Generation',0.2400),
(2,N'T02',N'Wind Onshore',N'Wind',N'Generation',0.3800),
(3,N'T03',N'Wind Offshore',N'Wind',N'Generation',0.4400),
(4,N'T04',N'Hydroelectric',N'Hydro',N'Generation',0.5200),
(5,N'T05',N'Battery Energy Storage System',N'BESS',N'Storage',NULL),
(6,N'T06',N'Geothermal',N'Geothermal',N'Generation',0.9000),
(7,N'T07',N'Biomass/Biogas',N'Biomass/Biogas',N'Generation',0.7800),
(8,N'T08',N'Hybrid Solar + BESS',N'Hybrid',N'Generation + Storage',0.2600),
(9,N'T09',N'Hybrid Wind + BESS',N'Hybrid',N'Generation + Storage',0.4000);
GO

INSERT dbo.Model_DimPlantCurrent (PlantKey,PlantID,PlantName,SiteName,RegionKey,TechnologyKey,GenerationCapacityMW,StoragePowerMW,StorageEnergyMWh,CommissioningDate,CommissioningDateKey,OperatingStatus) VALUES
(1,N'SVR-001',N'Cascade Hydro One',N'Cascade Hydro Site',1,4,300.00,0.00,0.00,N'2024-01-15',20240115,N'Active'),
(2,N'SVR-002',N'Rainshadow Hydro Two',N'Rainshadow Hydro Site',1,4,180.00,0.00,0.00,N'2024-03-01',20240301,N'Active'),
(3,N'SVR-003',N'Solara Mesa Solar',N'Solara Mesa Solar',2,1,220.00,0.00,0.00,N'2024-05-20',20240520,N'Active'),
(4,N'SVR-004',N'Red Rock Solar',N'Red Rock Solar',2,1,180.00,0.00,0.00,N'2024-07-10',20240710,N'Active'),
(5,N'SVR-005',N'Prairie Wind One',N'Prairie Wind Site',3,2,250.00,0.00,0.00,N'2024-09-15',20240915,N'Active'),
(6,N'SVR-006',N'Prairie Wind Two',N'Prairie Wind Site',3,2,200.00,0.00,0.00,N'2024-11-01',20241101,N'Active'),
(7,N'SVR-007',N'Atlantic Horizon Wind',N'Atlantic Horizon Wind',4,3,350.00,0.00,0.00,N'2025-01-20',20250120,N'Active'),
(8,N'SVR-008',N'GeoSpring One',N'GeoSpring Site',2,6,120.00,0.00,0.00,N'2025-02-15',20250215,N'Active'),
(9,N'SVR-009',N'BioCycle Plains',N'BioCycle Plains',3,7,80.00,0.00,0.00,N'2025-03-10',20250310,N'Active'),
(10,N'SVR-010',N'Battery Hub West',N'Battery Hub West',2,5,0.00,100.00,400.00,N'2025-04-05',20250405,N'Active'),
(11,N'SVR-011',N'SunStore Hybrid',N'SunStore Hybrid',2,8,150.00,50.00,200.00,N'2025-05-12',20250512,N'Active'),
(12,N'SVR-012',N'WindStore Hybrid',N'WindStore Hybrid',4,9,160.00,40.00,160.00,N'2025-06-18',20250618,N'Active');
GO

INSERT dbo.Model_DimPlantHistory (PlantSK,PlantKey,PlantID,VersionNumber,PlantName,SiteName,RegionKey,TechnologyKey,GenerationCapacityMW,StoragePowerMW,StorageEnergyMWh,CommissioningDate,CommissioningDateKey,OperatingStatus,EffectiveStartDate,EffectiveEndDate,IsCurrent,ChangeReason) VALUES
(101,1,N'SVR-001',1,N'Cascade Hydro One',N'Cascade Hydro Site',1,4,300.00,0.00,0.00,N'2024-01-15',20240115,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(201,2,N'SVR-002',1,N'Rainshadow Hydro Two',N'Rainshadow Hydro Site',1,4,180.00,0.00,0.00,N'2024-03-01',20240301,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(301,3,N'SVR-003',1,N'Solara Mesa Solar',N'Solara Mesa Solar',2,1,200.00,0.00,0.00,N'2024-05-20',20240520,N'Active',N'2024-01-01',N'2025-12-31',0,N'Capacity uprate effective 2026-01-01'),
(302,3,N'SVR-003',2,N'Solara Mesa Solar',N'Solara Mesa Solar',2,1,220.00,0.00,0.00,N'2024-05-20',20240520,N'Active',N'2026-01-01',N'9999-12-31',1,N'Current post-uprate version'),
(401,4,N'SVR-004',1,N'Red Rock Solar',N'Red Rock Solar',2,1,180.00,0.00,0.00,N'2024-07-10',20240710,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(501,5,N'SVR-005',1,N'Prairie Wind One',N'Prairie Wind Site',3,2,230.00,0.00,0.00,N'2024-09-15',20240915,N'Active',N'2024-01-01',N'2025-12-31',0,N'Capacity uprate effective 2026-01-01'),
(502,5,N'SVR-005',2,N'Prairie Wind One',N'Prairie Wind Site',3,2,250.00,0.00,0.00,N'2024-09-15',20240915,N'Active',N'2026-01-01',N'9999-12-31',1,N'Current post-uprate version'),
(601,6,N'SVR-006',1,N'Prairie Wind Two',N'Prairie Wind Site',3,2,200.00,0.00,0.00,N'2024-11-01',20241101,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(701,7,N'SVR-007',1,N'Atlantic Horizon Wind',N'Atlantic Horizon Wind',4,3,320.00,0.00,0.00,N'2025-01-20',20250120,N'Active',N'2024-01-01',N'2025-12-31',0,N'Capacity uprate effective 2026-01-01'),
(702,7,N'SVR-007',2,N'Atlantic Horizon Wind',N'Atlantic Horizon Wind',4,3,350.00,0.00,0.00,N'2025-01-20',20250120,N'Active',N'2026-01-01',N'9999-12-31',1,N'Current post-uprate version'),
(801,8,N'SVR-008',1,N'GeoSpring One',N'GeoSpring Site',2,6,120.00,0.00,0.00,N'2025-02-15',20250215,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(901,9,N'SVR-009',1,N'BioCycle Plains',N'BioCycle Plains',3,7,80.00,0.00,0.00,N'2025-03-10',20250310,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(1001,10,N'SVR-010',1,N'Battery Hub West',N'Battery Hub West',2,5,0.00,100.00,400.00,N'2025-04-05',20250405,N'Active',N'2024-01-01',N'9999-12-31',1,N'Initial/current version'),
(1101,11,N'SVR-011',1,N'SunStore Hybrid',N'SunStore Hybrid',2,8,140.00,50.00,200.00,N'2025-05-12',20250512,N'Active',N'2024-01-01',N'2025-12-31',0,N'Capacity uprate effective 2026-01-01'),
(1102,11,N'SVR-011',2,N'SunStore Hybrid',N'SunStore Hybrid',2,8,150.00,50.00,200.00,N'2025-05-12',20250512,N'Active',N'2026-01-01',N'9999-12-31',1,N'Current post-uprate version'),
(1201,12,N'SVR-012',1,N'WindStore Hybrid',N'WindStore Hybrid',4,9,150.00,40.00,160.00,N'2025-06-18',20250618,N'Active',N'2024-01-01',N'2025-12-31',0,N'Capacity uprate effective 2026-01-01'),
(1202,12,N'SVR-012',2,N'WindStore Hybrid',N'WindStore Hybrid',4,9,160.00,40.00,160.00,N'2025-06-18',20250618,N'Active',N'2026-01-01',N'9999-12-31',1,N'Current post-uprate version');
GO


;WITH d AS (
    SELECT CAST('2024-01-01' AS date) AS [Date]
    UNION ALL SELECT DATEADD(day,1,[Date]) FROM d WHERE [Date] < '2026-12-31'
)
INSERT dbo.Model_DimDate_Source(DateKey,[Date],[Year],[Quarter],MonthNumber,MonthName,YearMonth,[Day],DayName,DayOfWeek,IsWeekend,FiscalYear,FiscalQuarter,FiscalMonthNumber)
SELECT CONVERT(int,CONVERT(char(8),[Date],112)), [Date], YEAR([Date]), CONCAT('Q',DATEPART(quarter,[Date])), MONTH([Date]), DATENAME(month,[Date]),
       CONVERT(char(7),[Date],126), DAY([Date]), DATENAME(weekday,[Date]),
       ((DATEDIFF(day,'19000101',[Date]) % 7) + 1), CASE WHEN ((DATEDIFF(day,'19000101',[Date]) % 7)+1) IN (6,7) THEN 1 ELSE 0 END,
       CONCAT('FY', CASE WHEN MONTH([Date]) >= 7 THEN YEAR([Date])+1 ELSE YEAR([Date]) END),
       CONCAT('FQ', (( ( (MONTH([Date])-7+12)%12 ) / 3) + 1)),
       (((MONTH([Date])-7+12)%12)+1)
FROM d OPTION (MAXRECURSION 0);
GO
;WITH n AS (SELECT 0 n UNION ALL SELECT n+1 FROM n WHERE n<95)
INSERT dbo.Model_DimTime_Source(TimeKey,[Time],[Hour],[Minute],QuarterHourIndex,QuarterHourLabel,DayPart)
SELECT n+1, CAST(DATEADD(minute,n*15,CAST('00:00:00' AS datetime2)) AS time(0)), (n*15)/60, (n*15)%60, n+1,
       LEFT(CONVERT(char(8),CAST(DATEADD(minute,n*15,CAST('00:00:00' AS datetime2)) AS time(0)),108),5),
       CASE WHEN (n*15)/60 < 6 THEN 'Night' WHEN (n*15)/60 < 12 THEN 'Morning' WHEN (n*15)/60 < 18 THEN 'Afternoon' ELSE 'Evening' END
FROM n OPTION (MAXRECURSION 100);
GO

INSERT dbo.Model_DimSupplier (SupplierKey,SupplierID,SupplierName,SupplierCategory,CountryCode,PreferredFlag,RiskTier) VALUES
(1,N'SUP-001',N'NorthStar Turbine Services',N'Mechanical',N'US',1,N'Medium'),
(2,N'SUP-002',N'HelioGrid Solar Components',N'Solar Components',N'US',1,N'Low'),
(3,N'SUP-003',N'Cascade Hydro Works',N'Hydro Services',N'US',1,N'Low'),
(4,N'SUP-004',N'GeoCore Drilling Systems',N'Geothermal Services',N'US',0,N'Medium'),
(5,N'SUP-005',N'BioCycle Feedstock Partners',N'Biomass Supply',N'US',1,N'Medium'),
(6,N'SUP-006',N'Storage Dynamics LLC',N'Battery Systems',N'US',1,N'Low'),
(7,N'SUP-007',N'Atlantic Marine Wind Services',N'Offshore Services',N'US',1,N'High'),
(8,N'SUP-008',N'Prairie Electrical & Controls',N'Electrical',N'US',1,N'Low'),
(9,N'SUP-009',N'GridSense Analytics',N'Analytics',N'US',0,N'Low'),
(10,N'SUP-010',N'RenewOps Safety Solutions',N'Safety',N'US',1,N'Low'),
(11,N'SUP-011',N'GreenLink Logistics',N'Logistics',N'CA',0,N'Medium'),
(12,N'SUP-012',N'Apex Industrial Calibration',N'Calibration',N'US',1,N'Low');
GO

INSERT dbo.Model_DimEquipment (EquipmentKey,EquipmentID,PlantKey,TechnologyKey,ParentEquipmentKey,EquipmentName,EquipmentType,HierarchyLevel,Level1Name,Level2Name,Level3Name) VALUES
(101,N'EQ-01-01',1,4,NULL,N'Cascade Hydro One Hydro System',N'System',1,N'Cascade Hydro One Hydro System',NULL,NULL),
(102,N'EQ-01-02',1,4,101,N'Turbine-Generator',N'Primary Asset',2,N'Cascade Hydro One Hydro System',N'Turbine-Generator',NULL),
(103,N'EQ-01-03',1,4,102,N'Governor Controls',N'Control Subsystem',3,N'Cascade Hydro One Hydro System',N'Turbine-Generator',N'Governor Controls'),
(201,N'EQ-02-01',2,4,NULL,N'Rainshadow Hydro Two Hydro System',N'System',1,N'Rainshadow Hydro Two Hydro System',NULL,NULL),
(202,N'EQ-02-02',2,4,201,N'Turbine-Generator',N'Primary Asset',2,N'Rainshadow Hydro Two Hydro System',N'Turbine-Generator',NULL),
(203,N'EQ-02-03',2,4,201,N'Governor Controls',N'Peer Subsystem',2,N'Rainshadow Hydro Two Hydro System',N'Governor Controls',NULL),
(301,N'EQ-03-01',3,1,NULL,N'Solara Mesa Solar Solar System',N'System',1,N'Solara Mesa Solar Solar System',NULL,NULL),
(302,N'EQ-03-02',3,1,301,N'Inverter Block',N'Primary Asset',2,N'Solara Mesa Solar Solar System',N'Inverter Block',NULL),
(303,N'EQ-03-03',3,1,302,N'Tracker Controls',N'Control Subsystem',3,N'Solara Mesa Solar Solar System',N'Inverter Block',N'Tracker Controls'),
(401,N'EQ-04-01',4,1,NULL,N'Red Rock Solar Solar System',N'System',1,N'Red Rock Solar Solar System',NULL,NULL),
(402,N'EQ-04-02',4,1,401,N'Inverter Block',N'Primary Asset',2,N'Red Rock Solar Solar System',N'Inverter Block',NULL),
(403,N'EQ-04-03',4,1,401,N'Tracker Controls',N'Peer Subsystem',2,N'Red Rock Solar Solar System',N'Tracker Controls',NULL),
(501,N'EQ-05-01',5,2,NULL,N'Prairie Wind One Wind System',N'System',1,N'Prairie Wind One Wind System',NULL,NULL),
(502,N'EQ-05-02',5,2,501,N'Turbine Train',N'Primary Asset',2,N'Prairie Wind One Wind System',N'Turbine Train',NULL),
(503,N'EQ-05-03',5,2,502,N'Pitch & Yaw Controls',N'Control Subsystem',3,N'Prairie Wind One Wind System',N'Turbine Train',N'Pitch & Yaw Controls'),
(601,N'EQ-06-01',6,2,NULL,N'Prairie Wind Two Wind System',N'System',1,N'Prairie Wind Two Wind System',NULL,NULL),
(602,N'EQ-06-02',6,2,601,N'Turbine Train',N'Primary Asset',2,N'Prairie Wind Two Wind System',N'Turbine Train',NULL),
(603,N'EQ-06-03',6,2,601,N'Pitch & Yaw Controls',N'Peer Subsystem',2,N'Prairie Wind Two Wind System',N'Pitch & Yaw Controls',NULL),
(701,N'EQ-07-01',7,3,NULL,N'Atlantic Horizon Wind Wind System',N'System',1,N'Atlantic Horizon Wind Wind System',NULL,NULL),
(702,N'EQ-07-02',7,3,701,N'Turbine Train',N'Primary Asset',2,N'Atlantic Horizon Wind Wind System',N'Turbine Train',NULL),
(703,N'EQ-07-03',7,3,702,N'Pitch & Yaw Controls',N'Control Subsystem',3,N'Atlantic Horizon Wind Wind System',N'Turbine Train',N'Pitch & Yaw Controls'),
(801,N'EQ-08-01',8,6,NULL,N'GeoSpring One Geothermal System',N'System',1,N'GeoSpring One Geothermal System',NULL,NULL),
(802,N'EQ-08-02',8,6,801,N'Steam Turbine',N'Primary Asset',2,N'GeoSpring One Geothermal System',N'Steam Turbine',NULL),
(803,N'EQ-08-03',8,6,801,N'Brine Pump Controls',N'Peer Subsystem',2,N'GeoSpring One Geothermal System',N'Brine Pump Controls',NULL),
(901,N'EQ-09-01',9,7,NULL,N'BioCycle Plains Biomass/Biogas System',N'System',1,N'BioCycle Plains Biomass/Biogas System',NULL,NULL),
(902,N'EQ-09-02',9,7,901,N'Feed System',N'Primary Asset',2,N'BioCycle Plains Biomass/Biogas System',N'Feed System',NULL),
(903,N'EQ-09-03',9,7,902,N'Generator Controls',N'Control Subsystem',3,N'BioCycle Plains Biomass/Biogas System',N'Feed System',N'Generator Controls'),
(1001,N'EQ-10-01',10,5,NULL,N'Battery Hub West BESS System',N'System',1,N'Battery Hub West BESS System',NULL,NULL),
(1002,N'EQ-10-02',10,5,1001,N'Battery Block',N'Primary Asset',2,N'Battery Hub West BESS System',N'Battery Block',NULL),
(1003,N'EQ-10-03',10,5,1001,N'Power Conversion System',N'Peer Subsystem',2,N'Battery Hub West BESS System',N'Power Conversion System',NULL),
(1101,N'EQ-11-01',11,8,NULL,N'SunStore Hybrid Hybrid System',N'System',1,N'SunStore Hybrid Hybrid System',NULL,NULL),
(1102,N'EQ-11-02',11,8,1101,N'Generation-Storage Block',N'Primary Asset',2,N'SunStore Hybrid Hybrid System',N'Generation-Storage Block',NULL),
(1103,N'EQ-11-03',11,8,1102,N'Hybrid Controls',N'Control Subsystem',3,N'SunStore Hybrid Hybrid System',N'Generation-Storage Block',N'Hybrid Controls'),
(1201,N'EQ-12-01',12,9,NULL,N'WindStore Hybrid Hybrid System',N'System',1,N'WindStore Hybrid Hybrid System',NULL,NULL),
(1202,N'EQ-12-02',12,9,1201,N'Generation-Storage Block',N'Primary Asset',2,N'WindStore Hybrid Hybrid System',N'Generation-Storage Block',NULL),
(1203,N'EQ-12-03',12,9,1201,N'Hybrid Controls',N'Peer Subsystem',2,N'WindStore Hybrid Hybrid System',N'Hybrid Controls',NULL);
GO

INSERT dbo.Model_DimContract (ContractKey,ContractID,ContractName,ContractType,StartDate,EndDate,Currency) VALUES
(1,N'CON-001',N'Pacific Hydro Reliability',N'Operations',N'2025-01-01',N'2027-12-31',N'USD'),
(2,N'CON-002',N'Desert Solar PPA',N'Power Purchase',N'2025-04-01',N'2030-03-31',N'USD'),
(3,N'CON-003',N'Great Plains Wind Service',N'Service',N'2025-01-01',N'2028-12-31',N'USD'),
(4,N'CON-004',N'Atlantic Offshore Service',N'Service',N'2025-02-01',N'2029-01-31',N'USD'),
(5,N'CON-005',N'Storage Capacity Agreement',N'Capacity',N'2025-05-01',N'2028-04-30',N'USD'),
(6,N'CON-006',N'Renewable Portfolio Hedge',N'Commercial',N'2025-07-01',N'2027-06-30',N'USD'),
(7,N'CON-007',N'Safety & Compliance Framework',N'Compliance',N'2025-01-01',N'2027-12-31',N'USD'),
(8,N'CON-008',N'Calibration Services Master',N'Service',N'2025-01-01',N'2027-12-31',N'USD');
GO

INSERT dbo.Model_DimMaintenanceFlags (MaintenanceFlagsKey,SafetyCritical,PlannedFlag,RequiresShutdown,FlagLabel) VALUES
(1,0,0,0,N'Safety=N | Planned=N | Shutdown=N'),
(2,0,0,1,N'Safety=N | Planned=N | Shutdown=Y'),
(3,0,1,0,N'Safety=N | Planned=Y | Shutdown=N'),
(4,0,1,1,N'Safety=N | Planned=Y | Shutdown=Y'),
(5,1,0,0,N'Safety=Y | Planned=N | Shutdown=N'),
(6,1,0,1,N'Safety=Y | Planned=N | Shutdown=Y'),
(7,1,1,0,N'Safety=Y | Planned=Y | Shutdown=N'),
(8,1,1,1,N'Safety=Y | Planned=Y | Shutdown=Y');
GO

INSERT dbo.Model_BridgePlantContract (PlantKey,ContractKey,AssociationType) VALUES
(1,1,N'Primary'),
(2,1,N'Primary'),
(3,2,N'Primary'),
(4,2,N'Primary'),
(5,3,N'Primary'),
(6,3,N'Primary'),
(7,4,N'Primary'),
(8,6,N'Primary'),
(9,6,N'Primary'),
(10,5,N'Primary'),
(11,2,N'Primary'),
(11,5,N'Primary'),
(12,4,N'Secondary'),
(12,5,N'Secondary'),
(1,7,N'Secondary'),
(5,7,N'Secondary'),
(8,8,N'Secondary'),
(11,8,N'Secondary');
GO

INSERT dbo.Model_BridgeEquipmentSupplier (EquipmentKey,SupplierKey,AssociationType) VALUES
(101,3,N'Primary'),
(102,3,N'Primary'),
(103,3,N'Primary'),
(201,3,N'Primary'),
(202,3,N'Primary'),
(203,3,N'Primary'),
(301,2,N'Primary'),
(302,2,N'Primary'),
(303,2,N'Primary'),
(401,2,N'Primary'),
(402,2,N'Primary'),
(403,2,N'Primary'),
(501,1,N'Primary'),
(502,1,N'Primary'),
(503,1,N'Primary'),
(601,1,N'Primary'),
(602,1,N'Primary'),
(603,1,N'Primary'),
(701,7,N'Primary'),
(702,7,N'Primary'),
(703,7,N'Primary'),
(801,4,N'Primary'),
(802,4,N'Primary'),
(803,4,N'Primary'),
(901,5,N'Primary'),
(902,5,N'Primary'),
(903,5,N'Primary'),
(1001,6,N'Primary'),
(1002,6,N'Primary'),
(1003,6,N'Primary'),
(1101,6,N'Primary'),
(1102,6,N'Primary'),
(1103,6,N'Primary'),
(1201,1,N'Primary'),
(1202,1,N'Primary'),
(1203,1,N'Primary'),
(103,12,N'Secondary'),
(203,10,N'Secondary'),
(503,8,N'Secondary'),
(703,10,N'Secondary'),
(1003,9,N'Secondary'),
(1103,12,N'Secondary');
GO

INSERT dbo.Model_FactMaintenanceWorkOrder (WorkOrderKey,MaintenanceEventID,WorkOrderID,PlantKey,RaisedDateKey,StartDateKey,ClosedDateKey,MaintenanceType,Status,MaintenanceFlagsKey,DurationHours,CostUSD) VALUES
(1,N'MNT-001',N'WO-260701',1,20260630,20260702,20260702,N'Preventive',N'Completed',3,4.00,1250.00),
(2,N'MNT-002',N'WO-260702',2,20260702,20260705,20260705,N'Inspection',N'Completed',3,1.50,450.00),
(3,N'MNT-003',N'WO-260703',3,20260705,20260706,20260706,N'Corrective',N'Completed',6,6.50,2875.50),
(4,N'MNT-004',N'WO-260704',4,20260709,20260711,20260711,N'Calibration',N'Completed',3,2.00,600.00),
(5,N'MNT-005',N'WO-260705',5,20260715,20260718,NULL,N'Preventive',N'Scheduled',3,4.00,980.00),
(6,N'MNT-006',N'WO-260706',6,20260721,20260722,20260722,N'Inspection',N'Completed',3,2.50,725.25),
(7,N'MNT-007',N'WO-260707',7,20260721,20260723,20260723,N'Emergency',N'Completed',6,6.00,12500.00),
(8,N'MNT-008',N'WO-260708',8,20260725,20260728,20260728,N'Preventive',N'Completed',3,8.00,3250.00),
(9,N'MNT-009',N'WO-260709',9,20260802,20260803,20260803,N'Corrective',N'Completed',2,5.00,1800.00),
(10,N'MNT-010',N'WO-260710',10,20260805,20260807,20260807,N'Inspection',N'Completed',3,2.00,525.00),
(11,N'MNT-011',N'WO-260711',11,20260807,20260810,20260810,N'Calibration',N'Completed',3,3.00,975.00),
(12,N'MNT-012',N'WO-260712',12,20260813,20260814,20260814,N'Preventive',N'Completed',3,5.00,1420.00),
(13,N'MNT-013',N'WO-260713',1,20260816,20260818,20260818,N'Inspection',N'Completed',3,1.50,310.00),
(14,N'MNT-014',N'WO-260714',3,20260818,20260821,20260821,N'Corrective',N'Completed',6,5.50,2260.75),
(15,N'MNT-015',N'WO-260715',5,20260824,20260825,20260825,N'Preventive',N'Completed',3,4.00,1150.00),
(16,N'MNT-016',N'WO-260716',7,20260827,20260829,20260829,N'Inspection',N'Completed',7,4.00,4600.00),
(17,N'MNT-017',N'WO-260717',8,20260831,20260903,20260903,N'Calibration',N'Completed',3,4.00,1340.00),
(18,N'MNT-019',N'WO-260719',11,20260908,20260909,20260909,N'Preventive',N'Completed',3,4.50,1725.00),
(19,N'MNT-020',N'WO-260720',12,20260910,20260912,20260912,N'Inspection',N'Completed',3,3.00,860.00),
(20,N'MNT-021',N'WO-260721',2,20260912,20260915,20260915,N'Corrective',N'Completed',6,5.00,2450.00),
(21,N'MNT-022',N'WO-260722',4,20260918,20260919,20260919,N'Inspection',N'Completed',3,2.00,NULL),
(22,N'MNT-023',N'WO-260723',6,20260922,20260924,NULL,N'Preventive',N'Scheduled',3,3.00,990.00),
(23,N'MNT-024',N'WO-260724',10,20260925,20260928,NULL,N'Emergency',N'In Progress',6,NULL,7500.00);
GO

INSERT dbo.Model_FactMaintenanceTask (TaskKey,WorkOrderID,TaskSequence,PlantKey,TaskDateKey,TaskType,TaskDurationHours,TaskCostUSD) VALUES
(1,N'WO-260701',1,1,20260702,N'Inspect/Diagnose',2.00,625.00),
(2,N'WO-260701',2,1,20260702,N'Repair/Verify',2.00,625.00),
(3,N'WO-260702',1,2,20260705,N'Inspect/Diagnose',0.75,225.00),
(4,N'WO-260702',2,2,20260705,N'Repair/Verify',0.75,225.00),
(5,N'WO-260703',1,3,20260706,N'Inspect/Diagnose',3.25,1437.75),
(6,N'WO-260703',2,3,20260706,N'Repair/Verify',3.25,1437.75),
(7,N'WO-260704',1,4,20260711,N'Inspect/Diagnose',1.00,300.00),
(8,N'WO-260704',2,4,20260711,N'Repair/Verify',1.00,300.00),
(9,N'WO-260705',1,5,20260718,N'Inspect/Diagnose',2.00,490.00),
(10,N'WO-260705',2,5,20260718,N'Repair/Verify',2.00,490.00),
(11,N'WO-260706',1,6,20260722,N'Inspect/Diagnose',1.25,362.62),
(12,N'WO-260706',2,6,20260722,N'Repair/Verify',1.25,362.62),
(13,N'WO-260707',1,7,20260723,N'Inspect/Diagnose',3.00,6250.00),
(14,N'WO-260707',2,7,20260723,N'Repair/Verify',3.00,6250.00),
(15,N'WO-260708',1,8,20260728,N'Inspect/Diagnose',4.00,1625.00),
(16,N'WO-260708',2,8,20260728,N'Repair/Verify',4.00,1625.00),
(17,N'WO-260709',1,9,20260803,N'Inspect/Diagnose',2.50,900.00),
(18,N'WO-260709',2,9,20260803,N'Repair/Verify',2.50,900.00),
(19,N'WO-260710',1,10,20260807,N'Inspect/Diagnose',1.00,262.50),
(20,N'WO-260710',2,10,20260807,N'Repair/Verify',1.00,262.50),
(21,N'WO-260711',1,11,20260810,N'Inspect/Diagnose',1.50,487.50),
(22,N'WO-260711',2,11,20260810,N'Repair/Verify',1.50,487.50),
(23,N'WO-260712',1,12,20260814,N'Inspect/Diagnose',2.50,710.00),
(24,N'WO-260712',2,12,20260814,N'Repair/Verify',2.50,710.00),
(25,N'WO-260713',1,1,20260818,N'Inspect/Diagnose',0.75,155.00),
(26,N'WO-260713',2,1,20260818,N'Repair/Verify',0.75,155.00),
(27,N'WO-260714',1,3,20260821,N'Inspect/Diagnose',2.75,1130.38),
(28,N'WO-260714',2,3,20260821,N'Repair/Verify',2.75,1130.38),
(29,N'WO-260715',1,5,20260825,N'Inspect/Diagnose',2.00,575.00),
(30,N'WO-260715',2,5,20260825,N'Repair/Verify',2.00,575.00),
(31,N'WO-260716',1,7,20260829,N'Inspect/Diagnose',2.00,2300.00),
(32,N'WO-260716',2,7,20260829,N'Repair/Verify',2.00,2300.00),
(33,N'WO-260717',1,8,20260903,N'Inspect/Diagnose',2.00,670.00),
(34,N'WO-260717',2,8,20260903,N'Repair/Verify',2.00,670.00),
(35,N'WO-260719',1,11,20260909,N'Inspect/Diagnose',2.25,862.50),
(36,N'WO-260719',2,11,20260909,N'Repair/Verify',2.25,862.50),
(37,N'WO-260720',1,12,20260912,N'Inspect/Diagnose',1.50,430.00),
(38,N'WO-260720',2,12,20260912,N'Repair/Verify',1.50,430.00),
(39,N'WO-260721',1,2,20260915,N'Inspect/Diagnose',2.50,1225.00),
(40,N'WO-260721',2,2,20260915,N'Repair/Verify',2.50,1225.00),
(41,N'WO-260722',1,4,20260919,N'Inspect/Diagnose',1.00,NULL),
(42,N'WO-260722',2,4,20260919,N'Repair/Verify',1.00,NULL),
(43,N'WO-260723',1,6,20260924,N'Inspect/Diagnose',1.50,495.00),
(44,N'WO-260723',2,6,20260924,N'Repair/Verify',1.50,495.00),
(45,N'WO-260724',1,10,20260928,N'Inspect/Diagnose',NULL,3750.00),
(46,N'WO-260724',2,10,20260928,N'Repair/Verify',NULL,3750.00);
GO

INSERT dbo.Model_FactInspectionSchedule (InspectionKey,PlantKey,EquipmentKey,ScheduledDateKey,InspectionType,RequiredFlag) VALUES
(1,1,101,20261018,N'Safety',1),
(2,1,102,20261119,N'Reliability',1),
(3,1,103,20261220,N'Compliance',1),
(4,2,201,20261020,N'Safety',1),
(5,2,202,20261121,N'Reliability',1),
(6,2,203,20261222,N'Compliance',1),
(7,3,301,20261022,N'Safety',1),
(8,3,302,20261123,N'Reliability',1),
(9,3,303,20261215,N'Compliance',1),
(10,4,401,20261015,N'Safety',1),
(11,4,402,20261116,N'Reliability',1),
(12,4,403,20261217,N'Compliance',1),
(13,5,501,20261017,N'Safety',1),
(14,5,502,20261118,N'Reliability',1),
(15,5,503,20261219,N'Compliance',1),
(16,6,601,20261019,N'Safety',1),
(17,6,602,20261120,N'Reliability',1),
(18,6,603,20261221,N'Compliance',1),
(19,7,701,20261021,N'Safety',1),
(20,7,702,20261122,N'Reliability',1),
(21,7,703,20261223,N'Compliance',1),
(22,8,801,20261023,N'Safety',1),
(23,8,802,20261115,N'Reliability',1),
(24,8,803,20261216,N'Compliance',1),
(25,9,901,20261016,N'Safety',1),
(26,9,902,20261117,N'Reliability',1),
(27,9,903,20261218,N'Compliance',1),
(28,10,1001,20261018,N'Safety',1),
(29,10,1002,20261119,N'Reliability',1),
(30,10,1003,20261220,N'Compliance',1),
(31,11,1101,20261020,N'Safety',1),
(32,11,1102,20261121,N'Reliability',1),
(33,11,1103,20261222,N'Compliance',1),
(34,12,1201,20261022,N'Safety',1),
(35,12,1202,20261123,N'Reliability',1),
(36,12,1203,20261215,N'Compliance',1);
GO

INSERT dbo.Model_FactGenerationForecast (ForecastKey,PlantKey,IssueDateKey,TargetDateKey,ForecastVersion,ForecastGenerationMWh) VALUES
(1,1,20260616,20260731,1,114613.34),
(2,1,20260716,20260731,2,116940.51),
(3,1,20260717,20260831,1,114613.34),
(4,1,20260816,20260831,2,116940.51),
(5,1,20260816,20260930,1,111044.76),
(6,1,20260915,20260930,2,113299.48),
(7,2,20260616,20260731,1,69410.03),
(8,2,20260716,20260731,2,70819.38),
(9,2,20260717,20260831,1,69410.03),
(10,2,20260816,20260831,2,70819.38),
(11,2,20260816,20260930,1,67113.70),
(12,2,20260915,20260930,2,68476.42),
(13,3,20260616,20260731,1,38775.73),
(14,3,20260716,20260731,2,39563.05),
(15,3,20260717,20260831,1,38775.73),
(16,3,20260816,20260831,2,39563.05),
(17,3,20260816,20260930,1,37604.47),
(18,3,20260915,20260930,2,38368.02),
(19,4,20260616,20260731,1,31765.03),
(20,4,20260716,20260731,2,32410.00),
(21,4,20260717,20260831,1,31765.03),
(22,4,20260816,20260831,2,32410.00),
(23,4,20260816,20260930,1,30734.72),
(24,4,20260915,20260930,2,31358.77),
(25,5,20260616,20260731,1,70134.04),
(26,5,20260716,20260731,2,71558.08),
(27,5,20260717,20260831,1,70134.04),
(28,5,20260816,20260831,2,71558.08),
(29,5,20260816,20260930,1,67661.64),
(30,5,20260915,20260930,2,69035.48),
(31,6,20260616,20260731,1,56781.13),
(32,6,20260716,20260731,2,57934.05),
(33,6,20260717,20260831,1,56781.13),
(34,6,20260816,20260831,2,57934.05),
(35,6,20260816,20260930,1,55020.60),
(36,6,20260915,20260930,2,56137.77),
(37,7,20260616,20260731,1,114015.77),
(38,7,20260716,20260731,2,116330.81),
(39,7,20260717,20260831,1,114015.77),
(40,7,20260816,20260831,2,116330.81),
(41,7,20260816,20260930,1,110114.28),
(42,7,20260915,20260930,2,112350.11),
(43,8,20260616,20260731,1,79296.48),
(44,8,20260716,20260731,2,80906.56),
(45,8,20260717,20260831,1,79296.48),
(46,8,20260816,20260831,2,80906.56),
(47,8,20260816,20260930,1,76868.81),
(48,8,20260915,20260930,2,78429.60),
(49,9,20260616,20260731,1,45527.51),
(50,9,20260716,20260731,2,46451.92),
(51,9,20260717,20260831,1,45527.51),
(52,9,20260816,20260831,2,46451.92),
(53,9,20260816,20260930,1,43989.85),
(54,9,20260915,20260930,2,44883.05),
(55,11,20260616,20260731,1,28662.39),
(56,11,20260716,20260731,2,29244.36),
(57,11,20260717,20260831,1,28662.39),
(58,11,20260816,20260831,2,29244.36),
(59,11,20260816,20260930,1,27812.56),
(60,11,20260915,20260930,2,28377.28),
(61,12,20260616,20260731,1,47349.88),
(62,12,20260716,20260731,2,48311.29),
(63,12,20260717,20260831,1,47349.88),
(64,12,20260816,20260831,2,48311.29),
(65,12,20260816,20260930,1,45817.20),
(66,12,20260915,20260930,2,46747.49);
GO

INSERT dbo.Model_FactRegionalTargetMonthly (TargetKey,RegionKey,TargetMonthKey,TargetMonth,GenerationTargetMWh) VALUES
(1,1,20260701,N'2026-07',186825.76),
(2,2,20260701,N'2026-07',181217.89),
(3,3,20260701,N'2026-07',175068.71),
(4,4,20260701,N'2026-07',163822.99),
(5,1,20260801,N'2026-08',186825.76),
(6,2,20260801,N'2026-08',181217.89),
(7,3,20260801,N'2026-08',175068.71),
(8,4,20260801,N'2026-08',163822.99),
(9,1,20260901,N'2026-09',180871.54),
(10,2,20260901,N'2026-09',175655.39),
(11,3,20260901,N'2026-09',169210.25),
(12,4,20260901,N'2026-09',158306.07);
GO

INSERT dbo.Model_FactHydroOperatingContext (HydroContextKey,PlantKey,DateKey,ReservoirLevelPct,InflowM3s,SpillFlag) VALUES
(1,1,20260701,65.50,193.00,0),
(2,2,20260701,69.00,206.00,0),
(3,1,20260702,67.00,204.00,0),
(4,2,20260702,70.50,217.00,0),
(5,1,20260703,68.50,215.00,0),
(6,2,20260703,72.00,228.00,0),
(7,1,20260704,70.00,226.00,0),
(8,2,20260704,73.50,239.00,0),
(9,1,20260705,71.50,237.00,0),
(10,2,20260705,62.50,250.00,0),
(11,1,20260706,73.00,248.00,0),
(12,2,20260706,64.00,261.00,0),
(13,1,20260707,62.00,259.00,0),
(14,2,20260707,65.50,182.00,0),
(15,1,20260708,63.50,180.00,0),
(16,2,20260708,67.00,193.00,0),
(17,1,20260709,65.00,191.00,0),
(18,2,20260709,68.50,204.00,0),
(19,1,20260710,66.50,202.00,0),
(20,2,20260710,70.00,215.00,0),
(21,1,20260711,68.00,213.00,0),
(22,2,20260711,71.50,226.00,0),
(23,1,20260712,69.50,224.00,0),
(24,2,20260712,73.00,237.00,0),
(25,1,20260713,71.00,235.00,0),
(26,2,20260713,62.00,248.00,0),
(27,1,20260714,72.50,246.00,0),
(28,2,20260714,63.50,259.00,0),
(29,1,20260715,74.00,257.00,0),
(30,2,20260715,65.00,180.00,0),
(31,1,20260716,63.00,268.00,0),
(32,2,20260716,66.50,191.00,0),
(33,1,20260717,64.50,189.00,0),
(34,2,20260717,68.00,202.00,0),
(35,1,20260718,66.00,200.00,0),
(36,2,20260718,69.50,213.00,0),
(37,1,20260719,67.50,211.00,0),
(38,2,20260719,71.00,224.00,0),
(39,1,20260720,69.00,222.00,0),
(40,2,20260720,72.50,235.00,0),
(41,1,20260721,70.50,233.00,0),
(42,2,20260721,74.00,246.00,0),
(43,1,20260722,72.00,244.00,0),
(44,2,20260722,63.00,257.00,1),
(45,1,20260723,73.50,255.00,1),
(46,2,20260723,64.50,268.00,0),
(47,1,20260724,62.50,266.00,0),
(48,2,20260724,66.00,189.00,0),
(49,1,20260725,64.00,187.00,0),
(50,2,20260725,67.50,200.00,0),
(51,1,20260726,65.50,198.00,0),
(52,2,20260726,69.00,211.00,0),
(53,1,20260727,67.00,209.00,0),
(54,2,20260727,70.50,222.00,0),
(55,1,20260728,68.50,220.00,0),
(56,2,20260728,72.00,233.00,0),
(57,1,20260729,70.00,231.00,0),
(58,2,20260729,73.50,244.00,0),
(59,1,20260730,71.50,242.00,0),
(60,2,20260730,62.50,255.00,0),
(61,1,20260731,73.00,253.00,0),
(62,2,20260731,64.00,266.00,0),
(63,1,20260801,62.00,264.00,0),
(64,2,20260801,65.50,187.00,0),
(65,1,20260802,63.50,185.00,0),
(66,2,20260802,67.00,198.00,0),
(67,1,20260803,65.00,196.00,0),
(68,2,20260803,68.50,209.00,0),
(69,1,20260804,66.50,207.00,0),
(70,2,20260804,70.00,220.00,0),
(71,1,20260805,68.00,218.00,0),
(72,2,20260805,71.50,231.00,0),
(73,1,20260806,69.50,229.00,0),
(74,2,20260806,73.00,242.00,0),
(75,1,20260807,71.00,240.00,0),
(76,2,20260807,62.00,253.00,0),
(77,1,20260808,72.50,251.00,0),
(78,2,20260808,63.50,264.00,0),
(79,1,20260809,74.00,262.00,0),
(80,2,20260809,65.00,185.00,0),
(81,1,20260810,63.00,183.00,0),
(82,2,20260810,66.50,196.00,0),
(83,1,20260811,64.50,194.00,0),
(84,2,20260811,68.00,207.00,0),
(85,1,20260812,66.00,205.00,0),
(86,2,20260812,69.50,218.00,0),
(87,1,20260813,67.50,216.00,0),
(88,2,20260813,71.00,229.00,0),
(89,1,20260814,69.00,227.00,0),
(90,2,20260814,72.50,240.00,1),
(91,1,20260815,70.50,238.00,1),
(92,2,20260815,74.00,251.00,0),
(93,1,20260816,72.00,249.00,0),
(94,2,20260816,63.00,262.00,0),
(95,1,20260817,73.50,260.00,0),
(96,2,20260817,64.50,183.00,0),
(97,1,20260818,62.50,181.00,0),
(98,2,20260818,66.00,194.00,0),
(99,1,20260819,64.00,192.00,0),
(100,2,20260819,67.50,205.00,0),
(101,1,20260820,65.50,203.00,0),
(102,2,20260820,69.00,216.00,0),
(103,1,20260821,67.00,214.00,0),
(104,2,20260821,70.50,227.00,0),
(105,1,20260822,68.50,225.00,0),
(106,2,20260822,72.00,238.00,0),
(107,1,20260823,70.00,236.00,0),
(108,2,20260823,73.50,249.00,0),
(109,1,20260824,71.50,247.00,0),
(110,2,20260824,62.50,260.00,0),
(111,1,20260825,73.00,258.00,0),
(112,2,20260825,64.00,181.00,0),
(113,1,20260826,62.00,269.00,0),
(114,2,20260826,65.50,192.00,0),
(115,1,20260827,63.50,190.00,0),
(116,2,20260827,67.00,203.00,0),
(117,1,20260828,65.00,201.00,0),
(118,2,20260828,68.50,214.00,0),
(119,1,20260829,66.50,212.00,0),
(120,2,20260829,70.00,225.00,0),
(121,1,20260830,68.00,223.00,0),
(122,2,20260830,71.50,236.00,0),
(123,1,20260831,69.50,234.00,0),
(124,2,20260831,73.00,247.00,0),
(125,1,20260901,71.00,245.00,0),
(126,2,20260901,62.00,258.00,0),
(127,1,20260902,72.50,256.00,0),
(128,2,20260902,63.50,269.00,0),
(129,1,20260903,74.00,267.00,0),
(130,2,20260903,65.00,190.00,0),
(131,1,20260904,63.00,188.00,0),
(132,2,20260904,66.50,201.00,0),
(133,1,20260905,64.50,199.00,0),
(134,2,20260905,68.00,212.00,0),
(135,1,20260906,66.00,210.00,0),
(136,2,20260906,69.50,223.00,1),
(137,1,20260907,67.50,221.00,1),
(138,2,20260907,71.00,234.00,0),
(139,1,20260908,69.00,232.00,0),
(140,2,20260908,72.50,245.00,0),
(141,1,20260909,70.50,243.00,0),
(142,2,20260909,74.00,256.00,0),
(143,1,20260910,72.00,254.00,0),
(144,2,20260910,63.00,267.00,0),
(145,1,20260911,73.50,265.00,0),
(146,2,20260911,64.50,188.00,0),
(147,1,20260912,62.50,186.00,0),
(148,2,20260912,66.00,199.00,0),
(149,1,20260913,64.00,197.00,0),
(150,2,20260913,67.50,210.00,0),
(151,1,20260914,65.50,208.00,0),
(152,2,20260914,69.00,221.00,0),
(153,1,20260915,67.00,219.00,0),
(154,2,20260915,70.50,232.00,0),
(155,1,20260916,68.50,230.00,0),
(156,2,20260916,72.00,243.00,0),
(157,1,20260917,70.00,241.00,0),
(158,2,20260917,73.50,254.00,0),
(159,1,20260918,71.50,252.00,0),
(160,2,20260918,62.50,265.00,0),
(161,1,20260919,73.00,263.00,0),
(162,2,20260919,64.00,186.00,0),
(163,1,20260920,62.00,184.00,0),
(164,2,20260920,65.50,197.00,0),
(165,1,20260921,63.50,195.00,0),
(166,2,20260921,67.00,208.00,0),
(167,1,20260922,65.00,206.00,0),
(168,2,20260922,68.50,219.00,0),
(169,1,20260923,66.50,217.00,0),
(170,2,20260923,70.00,230.00,0),
(171,1,20260924,68.00,228.00,0),
(172,2,20260924,71.50,241.00,0),
(173,1,20260925,69.50,239.00,0),
(174,2,20260925,73.00,252.00,0),
(175,1,20260926,71.00,250.00,0),
(176,2,20260926,62.00,263.00,0),
(177,1,20260927,72.50,261.00,0),
(178,2,20260927,63.50,184.00,0),
(179,1,20260928,74.00,182.00,0),
(180,2,20260928,65.00,195.00,0),
(181,1,20260929,63.00,193.00,0),
(182,2,20260929,66.50,206.00,1),
(183,1,20260930,64.50,204.00,1),
(184,2,20260930,68.00,217.00,0);
GO


CREATE TABLE dbo.Model_FactBatteryDailySnapshot(
 SnapshotKey int IDENTITY(1,1) NOT NULL PRIMARY KEY, PlantKey int NOT NULL, DateKey int NOT NULL,
 SnapshotTimeUTC datetime2(0) NOT NULL, StateOfChargePct decimal(7,4) NOT NULL, ChargeMWh decimal(18,4) NOT NULL, DischargeMWh decimal(18,4) NOT NULL,
 CONSTRAINT UQ_Model_BatterySnapshot UNIQUE(PlantKey,DateKey)
);
;WITH x AS (
 SELECT CASE PlantID WHEN 'SVR-010' THEN 10 WHEN 'SVR-011' THEN 11 WHEN 'SVR-012' THEN 12 END AS PlantKey,
        CONVERT(int,CONVERT(char(8),CAST(IntervalStartUTC AS date),112)) AS DateKey,
        IntervalStartUTC, StateOfChargePct, ChargeMWh, DischargeMWh,
        ROW_NUMBER() OVER(PARTITION BY PlantID,CAST(IntervalStartUTC AS date) ORDER BY IntervalStartUTC DESC,StorageReadingID DESC) AS rn
 FROM dbo.BatteryStorageInterval
)
INSERT dbo.Model_FactBatteryDailySnapshot(PlantKey,DateKey,SnapshotTimeUTC,StateOfChargePct,ChargeMWh,DischargeMWh)
SELECT PlantKey,DateKey,IntervalStartUTC,StateOfChargePct,ChargeMWh,DischargeMWh FROM x WHERE rn=1;
GO


CREATE OR ALTER VIEW dbo.Model_FactIntervalGeneration AS
SELECT g.ReadingID,
       pc.PlantKey,
       ph.PlantSK,
       CONVERT(int,CONVERT(char(8),CAST(g.IntervalStartUTC AS date),112)) AS DateKey,
       DATEPART(hour,g.IntervalStartUTC)*4 + DATEPART(minute,g.IntervalStartUTC)/15 + 1 AS TimeKey,
       g.IntervalStartUTC,
       g.ActualGenerationMWh,
       g.ForecastGenerationMWh,
       g.SourceSystem,
       g.LoadTimestampUTC
FROM dbo.IntervalGeneration g
JOIN dbo.Model_DimPlantCurrent pc ON pc.PlantID=g.PlantID
JOIN dbo.Model_DimPlantHistory ph ON ph.PlantID=g.PlantID
 AND CAST(g.IntervalStartUTC AS date) BETWEEN ph.EffectiveStartDate AND ph.EffectiveEndDate;
GO


CREATE TABLE dbo.Model_AggGenerationDayPlant(
 DateKey int NOT NULL, PlantKey int NOT NULL, ReadingCount int NOT NULL,
 ActualGenerationMWh decimal(19,4) NOT NULL, ForecastGenerationMWh decimal(19,4) NOT NULL,
 PRIMARY KEY(DateKey,PlantKey)
);
INSERT dbo.Model_AggGenerationDayPlant(DateKey,PlantKey,ReadingCount,ActualGenerationMWh,ForecastGenerationMWh)
SELECT CONVERT(int,CONVERT(char(8),CAST(g.IntervalStartUTC AS date),112)), pc.PlantKey, COUNT_BIG(*),
       SUM(g.ActualGenerationMWh), SUM(g.ForecastGenerationMWh)
FROM dbo.IntervalGeneration g JOIN dbo.Model_DimPlantCurrent pc ON pc.PlantID=g.PlantID
GROUP BY CAST(g.IntervalStartUTC AS date),pc.PlantKey;
GO


CREATE OR ALTER VIEW dbo.Model_FactIntervalGeneration_RI_Broken AS
SELECT ReadingID,PlantKey,PlantSK,DateKey,TimeKey,IntervalStartUTC,ActualGenerationMWh,ForecastGenerationMWh FROM dbo.Model_FactIntervalGeneration
UNION ALL
SELECT CAST(900000001 AS bigint),999,99901,20260930,94,CAST('2026-09-30T23:15:00' AS datetime2(0)),CAST(10.5000 AS decimal(18,4)),CAST(10.3000 AS decimal(18,4))
UNION ALL SELECT 900000002,999,99901,20260930,95,CAST('2026-09-30T23:30:00' AS datetime2(0)),11.5000,11.3000
UNION ALL SELECT 900000003,999,99901,20260930,96,CAST('2026-09-30T23:45:00' AS datetime2(0)),12.5000,12.3000
UNION ALL SELECT 900000004,999,99901,20261001,1,CAST('2026-10-01T00:00:00' AS datetime2(0)),13.5000,13.3000
UNION ALL SELECT 900000005,999,99901,20261001,2,CAST('2026-10-01T00:15:00' AS datetime2(0)),14.5000,14.3000;
GO


-- Final extension counts. If these differ, do not begin the model build.
SELECT 'Model_DimRegion' ObjectName,COUNT_BIG(*) [RowCount] FROM dbo.Model_DimRegion
UNION ALL SELECT 'Model_DimTechnology',COUNT_BIG(*) FROM dbo.Model_DimTechnology
UNION ALL SELECT 'Model_DimPlantCurrent',COUNT_BIG(*) FROM dbo.Model_DimPlantCurrent
UNION ALL SELECT 'Model_DimPlantHistory',COUNT_BIG(*) FROM dbo.Model_DimPlantHistory
UNION ALL SELECT 'Model_DimDate_Source',COUNT_BIG(*) FROM dbo.Model_DimDate_Source
UNION ALL SELECT 'Model_DimTime_Source',COUNT_BIG(*) FROM dbo.Model_DimTime_Source
UNION ALL SELECT 'Model_DimEquipment',COUNT_BIG(*) FROM dbo.Model_DimEquipment
UNION ALL SELECT 'Model_DimSupplier',COUNT_BIG(*) FROM dbo.Model_DimSupplier
UNION ALL SELECT 'Model_DimContract',COUNT_BIG(*) FROM dbo.Model_DimContract
UNION ALL SELECT 'Model_DimMaintenanceFlags',COUNT_BIG(*) FROM dbo.Model_DimMaintenanceFlags
UNION ALL SELECT 'Model_BridgePlantContract',COUNT_BIG(*) FROM dbo.Model_BridgePlantContract
UNION ALL SELECT 'Model_BridgeEquipmentSupplier',COUNT_BIG(*) FROM dbo.Model_BridgeEquipmentSupplier
UNION ALL SELECT 'Model_FactIntervalGeneration',COUNT_BIG(*) FROM dbo.Model_FactIntervalGeneration
UNION ALL SELECT 'Model_FactBatteryDailySnapshot',COUNT_BIG(*) FROM dbo.Model_FactBatteryDailySnapshot
UNION ALL SELECT 'Model_FactMaintenanceWorkOrder',COUNT_BIG(*) FROM dbo.Model_FactMaintenanceWorkOrder
UNION ALL SELECT 'Model_FactMaintenanceTask',COUNT_BIG(*) FROM dbo.Model_FactMaintenanceTask
UNION ALL SELECT 'Model_FactInspectionSchedule',COUNT_BIG(*) FROM dbo.Model_FactInspectionSchedule
UNION ALL SELECT 'Model_FactGenerationForecast',COUNT_BIG(*) FROM dbo.Model_FactGenerationForecast
UNION ALL SELECT 'Model_FactRegionalTargetMonthly',COUNT_BIG(*) FROM dbo.Model_FactRegionalTargetMonthly
UNION ALL SELECT 'Model_FactHydroOperatingContext',COUNT_BIG(*) FROM dbo.Model_FactHydroOperatingContext
UNION ALL SELECT 'Model_AggGenerationDayPlant',COUNT_BIG(*) FROM dbo.Model_AggGenerationDayPlant
UNION ALL SELECT 'Model_FactIntervalGeneration_RI_Broken',COUNT_BIG(*) FROM dbo.Model_FactIntervalGeneration_RI_Broken;
GO
