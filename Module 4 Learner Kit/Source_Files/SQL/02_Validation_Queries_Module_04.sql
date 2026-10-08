/* Module 4 deterministic validation queries. */
USE SunnyVerseRenewableGroup;
GO
SELECT 'Regions' ObjectName,COUNT_BIG(*) [RowCount] FROM dbo.Regions
UNION ALL SELECT 'Technologies',COUNT_BIG(*) FROM dbo.Technologies
UNION ALL SELECT 'Plants',COUNT_BIG(*) FROM dbo.Plants
UNION ALL SELECT 'IntervalGeneration',COUNT_BIG(*) FROM dbo.IntervalGeneration
UNION ALL SELECT 'BatteryStorageInterval',COUNT_BIG(*) FROM dbo.BatteryStorageInterval;
GO
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
UNION ALL SELECT 'Model_AggGenerationDayPlant',COUNT_BIG(*) FROM dbo.Model_AggGenerationDayPlant;
GO
SELECT COUNT_BIG(*) IntervalRows,SUM(ActualGenerationMWh) ActualMWh,SUM(ForecastGenerationMWh) ForecastMWh FROM dbo.Model_FactIntervalGeneration;
SELECT r.RegionID,COUNT_BIG(*) IntervalRows,SUM(f.ActualGenerationMWh) ActualMWh,SUM(f.ForecastGenerationMWh) ForecastMWh
FROM dbo.Model_FactIntervalGeneration f JOIN dbo.Model_DimPlantCurrent p ON p.PlantKey=f.PlantKey JOIN dbo.Model_DimRegion r ON r.RegionKey=p.RegionKey
GROUP BY r.RegionID ORDER BY r.RegionID;
GO
SELECT ph.PlantSK,ph.PlantID,ph.VersionNumber,COUNT_BIG(f.ReadingID) IntervalRows
FROM dbo.Model_DimPlantHistory ph LEFT JOIN dbo.Model_FactIntervalGeneration f ON f.PlantSK=ph.PlantSK
GROUP BY ph.PlantSK,ph.PlantID,ph.VersionNumber ORDER BY ph.PlantID,ph.VersionNumber;
GO
SELECT COUNT_BIG(*) SnapshotRows,MIN(DateKey) MinDateKey,MAX(DateKey) MaxDateKey FROM dbo.Model_FactBatteryDailySnapshot;
SELECT COUNT_BIG(*) WorkOrders,SUM(DurationHours) DurationHours,SUM(CostUSD) CostUSD FROM dbo.Model_FactMaintenanceWorkOrder;
SELECT Status,COUNT(*) WorkOrders FROM dbo.Model_FactMaintenanceWorkOrder GROUP BY Status ORDER BY Status;
GO
SELECT COUNT_BIG(*) AggRows,SUM(ReadingCount) DetailRows,SUM(ActualGenerationMWh) ActualMWh,SUM(ForecastGenerationMWh) ForecastMWh FROM dbo.Model_AggGenerationDayPlant;
GO
-- Referential integrity comparison: broken view has five extra rows; inner join to DimPlant eliminates them.
SELECT COUNT_BIG(*) BrokenRows FROM dbo.Model_FactIntervalGeneration_RI_Broken;
SELECT COUNT_BIG(*) RowsAfterInnerJoin FROM dbo.Model_FactIntervalGeneration_RI_Broken f INNER JOIN dbo.Model_DimPlantCurrent p ON p.PlantKey=f.PlantKey;
GO
