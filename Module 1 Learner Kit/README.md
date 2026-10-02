# Module 1 — Analytics, Business Intelligence & Decision Systems

Welcome to the SunnyVerse Power BI Master Series. In this module, you build the analytical foundation that every later Power BI decision depends on. You will work inside the fictional **SunnyVerse Renewable Group** enterprise and use supplied data for solar PV, onshore wind, offshore wind, hydroelectric, BESS, geothermal, biomass/biogas, and hybrid renewable assets.

## What you will do

You will turn stakeholder requests into analytical questions, define grain and business meaning, distinguish facts and dimensions conceptually, define measures/metrics/KPIs before implementation, classify fields and units, evaluate data quality and freshness, resolve source-authority conflicts, work through weighting and Simpson's paradox, validate expected results, and explain why an analytical product should or should not be trusted.

## Start here

1. Open `01_Module_01_Detailed_Build_Guide.docx` and follow Parts 1–12 in order.
2. Use `Practice/03_Module_01_Practice_Workbook.xlsx` as your working file while you complete the guide.
3. Open files inside `Source_Files/` only when the guide tells you to use them.
4. Use the stage-validation answers inside the Detailed Build Guide after each major checkpoint.
5. Do not use `Validation/` for final reconciliation until the guide reaches the final validation stage.
6. Inspect `Reference/Module_01_Reference_Report.pbix` only when Part 10 directs you to inspect the completed analytical product.
7. Compare your practice workbook with `Reference/03_Module_01_Practice_Workbook_COMPLETED.xlsx` only after completing your own work.
8. Complete `02_Module_01_Knowledge_Check.docx`. A detailed answer key is included in the same document and the complete question-and-answer set is also explained in the Detailed Build Guide.

## Folder structure

```text
Module 1 Learner Kit/
├── README.md
├── 01_Module_01_Detailed_Build_Guide.docx
├── 02_Module_01_Knowledge_Check.docx
├── Guide_Images/
│   └── README.md
├── Practice/
│   ├── README.md
│   └── 03_Module_01_Practice_Workbook.xlsx
├── Source_Files/
│   ├── README.md
│   ├── Business_Context/
│   │   └── Stakeholder_Request.md
│   └── ... supplied data files
├── Validation/
│   ├── README.md
│   ├── Expected_Validation_Values.xlsx
│   ├── Expected_Portfolio_Values.csv
│   ├── Expected_Region_Values.csv
│   └── Final_Reference_Data/
│       └── README.md
└── Reference/
    ├── README.md
    ├── Module_01_Reference_Report.pbix
    └── 03_Module_01_Practice_Workbook_COMPLETED.xlsx
```

## Why the folders are separated

- **Source_Files** contains the evidence you inspect and work from. Some files intentionally contain defects because identifying those defects is part of the exercise.
- **Practice** contains your working workbook. It is not source data and should not be treated as authoritative evidence.
- **Guide_Images** is reserved for screenshots that materially prevent interface ambiguity.
- **Validation** contains final reconciliation material. Use it only when the Detailed Build Guide tells you to perform final validation.
- **Reference** contains completed artifacts used after your own attempt: the finished Power BI report for analytical-product inspection and the completed practice workbook for comparison.

## Required software

- Power BI Desktop — free
- Microsoft Excel or a compatible spreadsheet application that can open `.xlsx` files

You do **not** need SQL Server, Power BI Service, a Microsoft Fabric trial, a paid Power BI licence, or a commercial dataset for Module 1.

## Authoritative metric definitions

- **Generation Variance** = Actual Generation − Forecast Generation
- **Generation Variance Percentage** = (Actual Generation − Forecast Generation) ÷ Forecast Generation
- **Target Attainment** = Actual Generation ÷ Target Generation

Do not combine standalone BESS power with generation capacity. Storage power is measured in MW; storage energy is measured in MWh; neither is the same thing as generated MWh.

## Podcast companions

- **Algoryn & Vector — SunnyVerse Power BI Architecture Lab**
- **Twinkle & Celestyn — SunnyVerse Power BI Build & Troubleshooting Lab**
- **SunnyVerse Power BI Enterprise Innovation Lab — with Arka & Vehdah**

The Detailed Build Guide remains the authoritative execution artifact. The podcasts provide conceptual depth, practical reasoning, troubleshooting, and cross-platform professional context.
