# Broken Source Variants

These files exist only for controlled troubleshooting.

- `Technology_Status_MALFORMED.json` — invalid JSON.
- `Generation_7Day_CHANGED_COLUMN.csv` — `ActualGenerationMWh` changed to `ActualMWh`.
- `2026_10_Generation_SCHEMA_CHANGED.csv` — adds a new column to demonstrate a changed source contract.

Do not use these as normal inputs. Follow the Detailed Build Guide, observe the failure, diagnose it, restore the healthy source and revalidate.
