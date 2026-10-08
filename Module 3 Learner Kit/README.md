# Module 3 — Power Query, Data Preparation & M

Welcome to Module 3 of the **SunnyVerse Power BI Master Series — PL-300**. You continue inside **SunnyVerse Renewable Group** and move from the connectivity layer established in Module 2 into the complete Power Query data-preparation layer.

You will inspect, profile, type, clean, reshape, combine, parameterize, reuse, diagnose and validate data in Power Query. You will also work directly with M, query folding, native queries, buffering, Query Diagnostics, privacy behaviour, Formula.Firewall, schema drift and the `RangeStart`/`RangeEnd` preparation pattern used before incremental refresh.

## Start here

1. Open `01_Module_03_Detailed_Build_Guide.docx` and follow Parts 00–13 in order.
2. Use `Practice/03_Module_03_Practice_Workbook.xlsx` as your evidence workbook.
3. Use `Source_Files/` only when the guide instructs you to inspect, transform or deliberately break a source.
4. Complete each of the ten Stage Validation gates before advancing.
5. Use `Validation/` at the matching reconciliation steps rather than as a substitute for doing the work.
6. Complete `02_Module_03_Knowledge_Check.docx` after the practical build and analytical challenge.
7. Open `Reference/` only after your own attempt. It contains a completed evidence workbook, canonical M scripts and the two completed native Power BI reference artifacts.

## What you will build

- `Module_03_Data_Preparation_Lab.pbix` — your clean integrated Power Query preparation file.
- `Module_03_Folding_Performance_Lab.pbix` — your focused 500,000-row SQL folding, buffering and diagnostics file.
- `Practice/03_Module_03_Practice_Workbook.xlsx` — your evidence, reasoning, troubleshooting and validation record.

Completed native PBIX references are available under `Reference/PowerBI_Reference_Artifacts/` for **post-attempt comparison**. Build your own files first.

## Folder structure

```text
Module 3 Learner Kit/
├── README.md
├── 01_Module_03_Detailed_Build_Guide.docx
├── 02_Module_03_Knowledge_Check.docx
├── Guide_Images/
│   └── Embedded_Guide_Images/        # 25 extracted guide images
├── Practice/
│   └── 03_Module_03_Practice_Workbook.xlsx
├── Source_Files/
├── Validation/
└── Reference/
    ├── 03_Module_03_Practice_Workbook_COMPLETED.xlsx
    ├── M_Reference_Scripts/
    └── PowerBI_Reference_Artifacts/
        ├── Module_03_Data_Preparation_Lab.pbix
        ├── Module_03_Folding_Performance_Lab.pbix
        └── Module_03_Native_PBIX_SHA256.csv
```

## Required software

- Power BI Desktop
- SQL Server Developer Edition, using the Module 2 `SunnyVerseRenewableGroup` database
- SQL Server Management Studio

Python is optional and is not required for the learner workflow. No Power BI account is required for the mandatory Module 3 path. Power Query Online/Dataflows exercises remain optional when an eligible trial/environment is available.

## Frozen validation baseline

Module 3 intentionally uses two different generation workloads:

- **Folder-ingestion preparation:** 1,012 rows across July, August and September; Actual Generation = **2,088,673.20 MWh**; Forecast Generation = **2,077,142.54 MWh**; Variance = **+11,530.66 MWh**.
- **SQL folding/performance window:** 500,000-row source table, filtered by `RangeStart = 2026-07-01 00:00:00` and `RangeEnd = 2026-10-01 00:00:00`, returning **97,152 rows**; Actual Generation = **2,084,353.3725 MWh**; Forecast Generation = **2,084,352.9967 MWh**; Variance = **+0.3758 MWh**.

These are intentionally different source workloads. Do not reconcile one as though it were the other.

Additional prepared-state checkpoints include 23 maintenance rows with 3 audited errors, 69 target rows, 36 supplier-activity rows with 30 matched and 6 unmatched, 20 weather rows, 28 API operations, 92 date rows and 96 quarter-hour time rows.

## Learning rules

A refresh completing successfully is not proof that the preparation is correct. Record evidence, validate row counts and totals, and explain the business meaning of transformations.

Use the troubleshooting rhythm:

**Build → Observe → Inspect → Validate → Break → Diagnose → Repair → Revalidate**

When schema changes, prefer evidence-based repair over random setting changes. Do not replace unknown business values with zero merely to remove an error.

## Reference material

`Reference/` is post-attempt material. The completed workbook, canonical M scripts and completed native PBIX references are supplied so you can compare your reasoning and implementation after attempting the build yourself. The SHA-256 manifest under the PBIX reference folder lets you verify the final binaries.

## Module boundary

Module 3 prepares clean, typed, explicit and reusable structures. It may produce tables that resemble future facts or dimensions, including M-built date and time structures, but **relationship architecture, cardinality, filter propagation and full dimensional modeling belong to Module 4**. Incremental-refresh policy and Service behaviour remain Module 8 ownership.
