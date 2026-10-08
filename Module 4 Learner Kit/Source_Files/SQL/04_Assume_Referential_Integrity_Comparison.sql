/* Assume referential integrity comparison. */
USE SunnyVerseRenewableGroup;
GO
SELECT COUNT_BIG(*) HealthyDetailRows FROM dbo.Model_FactIntervalGeneration;
SELECT COUNT_BIG(*) BrokenDetailRows FROM dbo.Model_FactIntervalGeneration_RI_Broken;
SELECT COUNT_BIG(*) InnerJoinRows
FROM dbo.Model_FactIntervalGeneration_RI_Broken f
INNER JOIN dbo.Model_DimPlantCurrent p ON p.PlantKey=f.PlantKey;
SELECT f.PlantKey,COUNT_BIG(*) OrphanRows
FROM dbo.Model_FactIntervalGeneration_RI_Broken f
LEFT JOIN dbo.Model_DimPlantCurrent p ON p.PlantKey=f.PlantKey
WHERE p.PlantKey IS NULL GROUP BY f.PlantKey;
GO
