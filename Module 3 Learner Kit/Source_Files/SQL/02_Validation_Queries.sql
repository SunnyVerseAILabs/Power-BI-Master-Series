/*
02_Validation_Queries.sql
Use these queries to prove source row counts, date boundaries, and totals before comparing Power BI.
*/
USE SunnyVerseRenewableGroup;
GO

SELECT COUNT_BIG(*) AS IntervalGenerationRows FROM dbo.IntervalGeneration;
SELECT MIN(IntervalStartUTC) AS MinIntervalStartUTC,
       MAX(IntervalStartUTC) AS MaxIntervalStartUTC
FROM dbo.IntervalGeneration;

SELECT
    CAST(SUM(ActualGenerationMWh) AS decimal(24,4)) AS TotalActualMWh,
    CAST(SUM(ForecastGenerationMWh) AS decimal(24,4)) AS TotalForecastMWh
FROM dbo.IntervalGeneration;

SELECT r.RegionName,
       COUNT_BIG(*) AS [RowCount],
       CAST(SUM(g.ActualGenerationMWh) AS decimal(24,4)) AS TotalActualMWh
FROM dbo.IntervalGeneration g
JOIN dbo.Plants p ON p.PlantID=g.PlantID
JOIN dbo.Regions r ON r.RegionID=p.RegionID
GROUP BY r.RegionName
ORDER BY r.RegionName;

SELECT t.TechnologyFamily,
       COUNT_BIG(*) AS [RowCount],
       CAST(SUM(g.ActualGenerationMWh) AS decimal(24,4)) AS TotalActualMWh
FROM dbo.IntervalGeneration g
JOIN dbo.Plants p ON p.PlantID=g.PlantID
JOIN dbo.Technologies t ON t.TechnologyCode=p.TechnologyCode
GROUP BY t.TechnologyFamily
ORDER BY t.TechnologyFamily;

SELECT COUNT_BIG(*) AS BatteryStorageRows FROM dbo.BatteryStorageInterval;
GO
