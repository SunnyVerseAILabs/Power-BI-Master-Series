# SQL Scripts

Use only on a local non-production SQL Server Developer environment.

1. `01_Create_SunnyVerseRenewableGroup.sql` — recreates the local training database and deterministic data. The final object-count query uses `[RowCount]` as the escaped alias.
2. `02_Validation_Queries.sql` — proves row counts, UTC boundaries, totals, region totals and technology totals. Row-count aliases use `[RowCount]`.
3. `03_DirectQuery_Workload_Observer.sql` — observes active DirectQuery requests and recent Query Store activity.
4. `04_Optional_SQL_Authentication_Lab.sql` — optional; only when Mixed Mode already exists in your environment.
5. `05_Recover_SQL_Authentication_Lab.sql` — re-enables the optional training login after the disabled-login scenario.

The standard course path uses Windows Authentication and does not require Mixed Mode.
