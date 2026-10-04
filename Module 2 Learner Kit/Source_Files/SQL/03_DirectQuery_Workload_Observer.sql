/*
03_DirectQuery_Workload_Observer.sql
Run this in a separate SSMS window while interacting with the DirectQuery report.
Because fast queries can start and finish between samples, Query Store is also enabled by the database build script.
*/
USE SunnyVerseRenewableGroup;
GO

SELECT
    r.session_id,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time,
    r.reads,
    r.logical_reads,
    DB_NAME(r.database_id) AS DatabaseName,
    SUBSTRING(t.text,
              (r.statement_start_offset/2)+1,
              ((CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(t.text)
                     ELSE r.statement_end_offset END-r.statement_start_offset)/2)+1) AS RunningStatement
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.database_id = DB_ID(N'SunnyVerseRenewableGroup')
  AND r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;
GO

SELECT TOP (25)
    qt.query_sql_text,
    rs.count_executions,
    rs.avg_duration,
    rs.avg_cpu_time,
    rs.avg_logical_io_reads,
    rs.last_execution_time
FROM sys.query_store_query_text qt
JOIN sys.query_store_query q ON q.query_text_id=qt.query_text_id
JOIN sys.query_store_plan p ON p.query_id=q.query_id
JOIN sys.query_store_runtime_stats rs ON rs.plan_id=p.plan_id
WHERE qt.query_sql_text LIKE '%vw_ConnectivityLab%'
   OR qt.query_sql_text LIKE '%IntervalGeneration%'
ORDER BY rs.last_execution_time DESC;
GO
