# Module 2 Learner Kit

# Power BI Ecosystem, Architecture & Data Connectivity

Module 2 teaches how trustworthy information enters Power BI. You will connect to multiple file formats and SQL Server, inspect Navigator object types, manage authentication/credentials/privacy, parameterize SQL endpoints, compare Import and DirectQuery with source evidence, diagnose controlled connectivity failures, and export/reopen a Power BI template.

## Required software
- Power BI Desktop
- SQL Server Developer Edition
- SQL Server Management Studio (SSMS)
- Microsoft Excel or a compatible spreadsheet application

## Not required
- Power BI Service account
- Microsoft Fabric trial
- Paid Power BI/Fabric capacity
- Python
- External tools

## Recommended learning order
1. Open `Practice/03_Module_02_Practice_Workbook.xlsx`.
2. Follow `01_Module_02_Detailed_Build_Guide.docx` from Part 00 through final validation.
3. Use only the supplied `Source_Files/` and working copies created when the guide asks you to simulate a failure.
4. Use `Validation/` to reconcile expected values after attempting the relevant activity.
5. Complete `02_Module_02_Knowledge_Check.docx` before reading its answer explanations.
6. Compare your workbook with `Reference/03_Module_02_Practice_Workbook_COMPLETED.xlsx` only after your own attempt.
7. Use the three companion podcasts for architecture depth, practical troubleshooting, and enterprise cross-platform reasoning.

## Power BI artifacts you build
Create these in your own working folder; they are not prebuilt reference files:
- `Module_02_File_Connectivity_Lab.pbix`
- `Module_02_SQL_Connectivity_Lab.pbix`
- `Module_02_Import_Lab.pbix`
- `Module_02_DirectQuery_Lab.pbix`
- `Module_02_Parameterized_Connectivity_Template.pbit`

## Authoritative SQL validation baseline
- `dbo.IntervalGeneration`: **500,000 rows**
- `dbo.BatteryStorageInterval`: **50,000 rows**
- `dbo.vw_ConnectivityLab`: **500,000 rows**
- Minimum UTC interval: **2025-07-01 00:00:00**
- Maximum UTC interval: **2026-10-17 11:30:00**
- Total ActualGenerationMWh: **10,727,271.3600 MWh**
- Total ForecastGenerationMWh: **10,727,272.9111 MWh**

## Important boundaries
This module teaches connectivity, execution modes, credentials/privacy, refresh behavior and failure-layer diagnosis. It does **not** become a Power Query transformation masterclass, semantic-modeling lesson, DAX lesson, report-design lesson, Service/gateway-administration lesson or PBIP/Git lifecycle lesson. Those capabilities are developed later in the series.

## Cloud trial rule
Do **not** start a Fabric trial for Module 2. Direct Lake, live connections, cloud connectors and gateways are recognized through architecture and expected behavior so the course can preserve trial access for later modules.

## Reference discipline
`Source_Files/` contains the inputs and controlled failure variants. `Practice/` is where you record your evidence. `Validation/` contains independent expected values. `Reference/` contains the completed practice workbook for comparison after your attempt.
