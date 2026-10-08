# Module Three Validation — Stage Two Frozen Truth

This folder contains independent expected values for source fingerprinting and later learner checkpoints. Do not use it as a substitute for the transformation work.

Key frozen truths:

- Healthy monthly generation folder: 1,012 rows.
- Maintenance raw: 26 physical data rows including one blank row and one exact duplicate; 24 unique business events; 23 final prepared events after one invalid-start-date row is quarantined.
- Supplier activity: 36 rows = 12 exact + 8 transformation-table + 10 fuzzy + 6 unmatched. All 36 remain visible in the prepared/audit architecture.
- Wide targets: 23 rows; Jul-Sep unpivot = 69 rows. Added-month variant = 92 rows.
- Weather: 20 region-day observations and 6 nested alerts.
- Payloads: 12 rows, 11 successful parses and 1 controlled parse error.
- API: 4 pages x 7 rows = 28 operations.
- SQL Q3 RangeStart/RangeEnd window: 97,152 interval rows.
- Date helper: 92 rows. Time helper: 96 quarter-hour rows.

`Source_File_SHA256.csv` is generated after all Stage Two files, including the two Excel workbooks, are finalized.
