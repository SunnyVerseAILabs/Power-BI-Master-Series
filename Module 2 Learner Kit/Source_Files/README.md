# Source Files

Use these as the clean Module 2 inputs. Perform rename/move/schema-failure exercises on writable copies so the clean kit remains recoverable.

## File connectors
- `SunnyVerse_Source_Objects.xlsx`
- `Regions.csv`
- `Generation_7Day_Sample.txt`
- `Technology_Status.json`
- `Maintenance_Events.xml`
- `Portfolio_Snapshot.parquet`

## Folder connector
`Monthly_Extracts/` contains **4 physical files**: 3 generation CSVs for July, August and September 2026 plus `README.md`. The 3 generation CSVs contain **1,012 business rows** in total. `README.md` is documentation and must not be counted as business data.

## GitHub Web connector
`GitHub_Web/Regions_Public.csv` is the required remote-HTTP example. On GitHub choose **Raw** and connect to the `raw.githubusercontent.com` URL with Anonymous authentication.

## SQL Server
`SQL/` contains the database build, validation, DirectQuery workload observer and optional SQL-authentication scripts. The current `01_Create_SunnyVerseRenewableGroup.sql` and `02_Validation_Queries.sql` use `[RowCount]` as the safe SQL alias.

## Broken variants
`Broken_Source_Variants/` contains controlled malformed/schema-change files. Use them only for the troubleshooting exercises in the guide.
