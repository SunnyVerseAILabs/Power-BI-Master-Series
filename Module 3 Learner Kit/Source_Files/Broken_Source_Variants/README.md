# Broken Source Variants

These files are controlled failures. They are not the starting sources. Use them only after the healthy transformation has been built, observed and validated.

- `Renamed_Column/` — `PlantID` becomes `PlantIdentifier`.
- `Added_Column/` — the target workbook receives an October 2026 month column.
- `Reordered_Columns/` — same monthly generation fields, different physical order.
- `Changed_Type/` — one September generation value becomes `not_available`.
- `New_Folder_Layout/` — September moves below `2026/Q3` while July and August remain at the root.
