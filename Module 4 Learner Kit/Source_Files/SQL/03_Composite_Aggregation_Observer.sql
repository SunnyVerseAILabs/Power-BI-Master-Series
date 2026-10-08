/* Module 4 DirectQuery / aggregation observer. Run in SSMS while interacting with the composite-model lab. */
USE SunnyVerseRenewableGroup;
GO
SELECT r.session_id,r.status,r.command,r.cpu_time,r.total_elapsed_time,r.reads,r.logical_reads,LEFT(t.text,4000) AS SqlText
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.session_id <> @@SPID AND (t.text LIKE '%Model_FactIntervalGeneration%' OR t.text LIKE '%Model_AggGenerationDayPlant%')
ORDER BY r.total_elapsed_time DESC;
GO
SELECT TOP (50) qt.query_sql_text,rs.count_executions,rs.avg_duration,rs.last_execution_time
FROM sys.query_store_query_text qt
JOIN sys.query_store_query q ON q.query_text_id=qt.query_text_id
JOIN sys.query_store_plan p ON p.query_id=q.query_id
JOIN sys.query_store_runtime_stats rs ON rs.plan_id=p.plan_id
WHERE qt.query_sql_text LIKE '%Model_FactIntervalGeneration%' OR qt.query_sql_text LIKE '%Model_AggGenerationDayPlant%'
ORDER BY rs.last_execution_time DESC;
GO
