# Module 3 Source Files — SunnyVerse Renewable Group

These files are the frozen Stage 2 learner inputs for **Module Three — Power Query, Data Preparation & M**.

Use the healthy baseline folders first. Do **not** mix files from `Broken_Source_Variants/` into the healthy folders until the Detailed Build Guide explicitly starts a controlled failure/recovery lab.

## Inherited continuity

- SQL database: `SunnyVerseRenewableGroup` from final Module Two.
- Required inherited counts: 4 regions, 9 technologies, 12 plants, 500,000 `IntervalGeneration` rows, 50,000 `BatteryStorageInterval` rows and 500,000 `vw_ConnectivityLab` rows.
- The clean folder-ingestion baseline is the exact final Module Two July/August/September generation extract set: **1,012 business rows**.

## Healthy source folders

- `SQL/` — inherited database creation/validation scripts plus Module Three folding validation.
- `Maintenance/` — messy maintenance CSV used for cleaning/error handling.
- `Suppliers/` — canonical master, messy activity and fuzzy transformation table.
- `Targets/` — wide monthly target workbook.
- `Folder_Ingestion/Monthly_Plant_Extracts/` — three clean monthly generation CSVs.
- `Nested/` — nested JSON weather and nested XML maintenance examples.
- `Payloads/` — JSON/XML text payloads, including one controlled malformed payload.
- `API_Pages/` — deterministic four-page JSON pagination contract.

## Broken variants

The supplied failures are isolated from the healthy baseline: renamed column, added month column, reordered columns, changed numeric type/value and a nested folder-layout change. Build and validate the healthy path before using them.

Expected answers and reconciliation values are kept in `../Validation/`, not in this source folder.
