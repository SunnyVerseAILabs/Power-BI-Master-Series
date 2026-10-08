# Module 4 — Semantic Modeling & Relationship Architecture

Welcome to Module 4 of the **SunnyVerse Power BI Master Series — PL-300**. This module turns the prepared data layer into a governed semantic model.

## Start here
1. Follow `01_Module_04_Detailed_Build_Guide.docx` from Part 00 through Part 13.
2. Record your evidence in `Practice/03_Module_04_Practice_Workbook.xlsx`.
3. Use the frozen `Source_Files/` and run the SQL scripts in the order specified by the guide.
4. Complete all ten Stage Validation gates before moving on.
5. Use `Validation/` only when the guide reaches the corresponding reconciliation step.
6. Complete `02_Module_04_Knowledge_Check.docx` after the build and analytical challenge.
7. Use `Reference/` only after your own attempt.

## Native reference files
The final learner reference package now includes the two real Power BI Desktop files:
- `Reference/PowerBI_Reference_Artifacts/Module_04_Semantic_Model_Lab.pbix`
- `Reference/PowerBI_Reference_Artifacts/Module_04_Composite_Aggregation_Lab.pbix`

Their final SHA-256 values are recorded in `Reference/PowerBI_Reference_Artifacts/Module_04_Native_PBIX_SHA256.csv`.

## Frozen modeling truth
Key checkpoints include:
- 4 regions; 9 technologies; 12 current plants; 17 Type 2 plant-history rows.
- 1,096 date rows covering 2024-01-01 through 2026-12-31 and 96 quarter-hour time members.
- 500,000 interval-generation rows.
- Full interval Actual = **10,727,271.3600 MWh**, Forecast = **10,727,272.9111 MWh**, Variance = **-1.5511 MWh**.
- Q3 2026 = **97,152 rows**, Actual = **2,084,353.3725 MWh**, Forecast = **2,084,352.9967 MWh**, Variance = **+0.3758 MWh**.
- 12 regional target rows totaling **2,097,913.95 MWh**.
- 18 Plant-Contract associations.
- 42 Equipment-Supplier associations across 36 equipment items and **11 associated suppliers**. `DimSupplier` still contains 12 suppliers; SupplierKey 11 has no equipment association.
- 522 battery daily snapshots; 23 maintenance work orders; 46 maintenance tasks; 36 inspection schedule rows; 66 generation forecast rows; 184 hydro context rows.
- 5,214 rows in the aggregation source, representing all 500,000 detail rows.

## Modeling rule
Do not connect tables until a visual appears to work. Validate **grain → key uniqueness → cardinality → filter direction → active path → referential integrity → business meaning → expected result**.

Use the troubleshooting rhythm: **Build → Observe → Inspect → Validate → Break → Diagnose → Repair → Revalidate**.

## Required software
- Power BI Desktop
- SQL Server Developer Edition
- SQL Server Management Studio

No Power BI account or trial is required for the mandatory Module 4 path.

## Module boundary
Module 4 owns semantic-model structure and relationship architecture. DAX is used only minimally to validate model behavior. Foundational DAX begins in Module 5; PATH-family hierarchy calculations and advanced performance engineering belong to Module 6.
