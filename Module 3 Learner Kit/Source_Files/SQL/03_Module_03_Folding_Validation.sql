/*
SunnyVerse Power BI Master Series — Module 3
03_Module_03_Folding_Validation.sql
Purpose: Independently validate the inherited SQL source used for folding, diagnostics and RangeStart/RangeEnd labs.
*/
USE SunnyVerseRenewableGroup;
GO

-- Inherited object counts.
SELECT 'Regions' AS ObjectName, COUNT_BIG(*) AS RowCount FROM dbo.Regions
UNION ALL SELECT 'Technologies', COUNT_BIG(*) FROM dbo.Technologies
UNION ALL SELECT 'Plants', COUNT_BIG(*) FROM dbo.Plants
UNION ALL SELECT 'IntervalGeneration', COUNT_BIG(*) FROM dbo.IntervalGeneration
UNION ALL SELECT 'BatteryStorageInterval', COUNT_BIG(*) FROM dbo.BatteryStorageInterval
UNION ALL SELECT 'vw_ConnectivityLab', COUNT_BIG(*) FROM dbo.vw_ConnectivityLab;
GO

-- Module 3 RangeStart/RangeEnd validation window.
DECLARE @RangeStart datetime2(0)='2026-07-01T00:00:00';
DECLARE @RangeEnd   datetime2(0)='2026-10-01T00:00:00';
SELECT
    COUNT_BIG(*) AS ExpectedRows,
    SUM(ActualGenerationMWh) AS ActualGenerationMWh,
    SUM(ForecastGenerationMWh) AS ForecastGenerationMWh,
    SUM(ActualGenerationMWh-ForecastGenerationMWh) AS VarianceMWh
FROM dbo.IntervalGeneration
WHERE IntervalStartUTC >= @RangeStart
  AND IntervalStartUTC <  @RangeEnd;
GO

-- A fold-friendly projection/filter baseline for learner comparison.
SELECT PlantID, IntervalStartUTC, ActualGenerationMWh, ForecastGenerationMWh
FROM dbo.IntervalGeneration
WHERE IntervalStartUTC >= '2026-07-01T00:00:00'
  AND IntervalStartUTC <  '2026-10-01T00:00:00'
  AND PlantID IN ('SVR-001','SVR-003','SVR-005')
ORDER BY IntervalStartUTC, PlantID;
GO
