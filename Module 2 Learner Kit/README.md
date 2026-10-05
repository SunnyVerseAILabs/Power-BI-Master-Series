# Module 2 Learner Kit

# Power BI Ecosystem, Architecture & Data Connectivity

This learner kit teaches how trustworthy information enters Power BI and how to prove what happened when a connection works or fails. You will connect to file, Web and SQL Server sources; inspect Navigator objects; manage credentials and privacy; parameterize SQL endpoints; compare Import and DirectQuery; observe refresh and source workload; diagnose controlled failures; and create/reopen a Power BI template.

## Required software
- Power BI Desktop
- SQL Server 2025 Standard Developer Edition for the standard local course path, or a compatible local SQL Server Developer environment
- SQL Server Management Studio (SSMS) 22 or compatible current SSMS
- Microsoft Excel or a compatible spreadsheet application

## Not required
- Power BI Service account
- Microsoft Fabric trial
- Paid Power BI/Fabric capacity
- Python
- External tools

## Recommended learning order
1. Copy this learner kit to a writable local working folder. Keep the downloaded kit unchanged as your clean reference copy.
2. Open `Practice/03_Module_02_Practice_Workbook.xlsx`.
3. Follow `01_Module_02_Detailed_Build_Guide.docx` from Part 00 through final validation.
4. Use the clean `Source_Files/` plus working copies created when the guide asks you to simulate a failure.
5. Reconcile evidence with `Validation/` after your own attempt.
6. Complete `02_Module_02_Knowledge_Check.docx` before reading its answer section.
7. Compare your practice workbook with `Reference/03_Module_02_Practice_Workbook_COMPLETED.xlsx`.
8. Only after building your own Power BI files, compare them with `Reference/PowerBI_Reference_Artifacts/`.
9. Use the three companion podcasts for architecture, build/troubleshooting and enterprise cross-platform depth.

## Power BI artifacts you build
- `Module_02_File_Connectivity_Lab.pbix`
- `Module_02_SQL_Connectivity_Lab.pbix`
- `Module_02_Import_Lab.pbix`
- `Module_02_DirectQuery_Lab.pbix`
- `Module_02_Parameterized_Connectivity_Template.pbit`

Completed examples of these artifacts are included in `Reference/PowerBI_Reference_Artifacts/` for post-attempt comparison.

## Authoritative SQL validation baseline
- Regions: **4**
- Technologies: **9**
- Plants: **12**
- `dbo.IntervalGeneration`: **500,000 rows**
- `dbo.BatteryStorageInterval`: **50,000 rows**
- `dbo.vw_ConnectivityLab`: **500,000 rows**
- Minimum UTC interval: **2025-07-01 00:00:00**
- Maximum UTC interval: **2026-10-17 11:30:00**
- Total ActualGenerationMWh: **10,727,271.3600 MWh**
- Total ForecastGenerationMWh: **10,727,272.9111 MWh**

## Scope boundary
This kit focuses on connectivity, source-object selection, execution modes, credentials/privacy, refresh behavior, evidence-based validation and failure-layer diagnosis. Deep transformation, dimensional modeling, DAX, report design, Service administration and source-control/deployment workflows are intentionally outside this hands-on connectivity scope.

## Cloud rule
No Fabric trial is required. Direct Lake, live connections, cloud connectors and gateways are covered at architecture-awareness level where a live cloud environment is unnecessary.

## Folder roles
- `Source_Files/` — clean inputs, SQL scripts and controlled broken variants.
- `Practice/` — your evidence workbook.
- `Validation/` — independent expected values and reconciliation material.
- `Reference/` — completed workbook and completed Power BI artifacts for comparison after your attempt.
- `Guide_Images/` — individual copies of the screenshots embedded in the Detailed Build Guide.
