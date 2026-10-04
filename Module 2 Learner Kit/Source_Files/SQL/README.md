# SQL Scripts

Run scripts in this order:

1. `01_Create_SunnyVerseRenewableGroup.sql` — recreates the local training database and deterministic data.
2. `02_Validation_Queries.sql` — proves row counts, date boundaries and authoritative totals.
3. `03_DirectQuery_Workload_Observer.sql` — helps observe DirectQuery workload through active requests and Query Store.
4. `04_Optional_SQL_Authentication_Lab.sql` — optional; requires Mixed Mode and a learner-selected temporary password.
5. `05_Recover_SQL_Authentication_Lab.sql` — re-enables the optional training login after the disabled-login failure.

Use only on a local non-production SQL Server Developer instance.
