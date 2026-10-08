# Date and Time Model Specification

- `DimDate` covers 2024-01-01 through 2026-12-31 inclusive (1,096 rows).
- Fiscal year begins July 1. `FY2027` therefore begins 2026-07-01.
- `DimTime` has 96 quarter-hour members, TimeKey 1 through 96.
- Auto date/time is disabled for the final clean model.
- `DimDate` is marked as the model's date table using the Date column.
- Role-playing requirements include maintenance raised/start/closed dates, forecast issue/target dates, and plant commissioning date.
- DAX date-table creation is comparison-only; the primary supplied date source remains the model authority for this module.
