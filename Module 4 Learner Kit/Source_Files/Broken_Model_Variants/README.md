# Broken Model Variants

These files are controlled teaching defects. Keep them isolated from the healthy final model.

- `Duplicate_DimPlant.csv`: 13 rows; PlantKey 3 / SVR-003 is duplicated so one-side uniqueness fails.
- `Orphan_Fact_Sample.csv`: 20 rows; exactly one row uses PlantKey 999.
- `Missing_Date_Coverage.csv`: 6 rows; exactly one row uses DateKey 20270105 outside the governed date table.
- `ManyToMany_Left.csv` and `ManyToMany_Right.csv`: repeated PlantID values on both sides create an accidental many-to-many risk.
- `Assume_RI_Bad_Rows.csv`: 5 orphan DirectQuery-style rows used to demonstrate why Assume referential integrity is unsafe when the contract is false.
