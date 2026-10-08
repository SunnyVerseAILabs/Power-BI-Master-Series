# Power BI Reference Artifacts — Final Native References

Use these files **after completing your own Module 3 build**. They are reference artifacts, not substitutes for the Detailed Build Guide or your Practice workbook.

## Included

- `Module_03_Data_Preparation_Lab.pbix` — final integrated Power Query preparation reference.
- `Module_03_Folding_Performance_Lab.pbix` — focused SQL folding, native-query, buffering and diagnostics reference.
- `Module_03_Native_PBIX_SHA256.csv` — file-integrity fingerprints for the two native references.

## Final integrity fingerprints

| File | Bytes | SHA-256 |
|---|---:|---|
| `Module_03_Data_Preparation_Lab.pbix` | 256,305 | `8ac8723c7e835e5d3c3e893d8db350142220e0c5a6ccc8c9504e13908dac9be3` |
| `Module_03_Folding_Performance_Lab.pbix` | 3,589,951 | `65dce3457fae8a4e33e85a1ec2100277f87bb0c0ae2c4a0ddce435bdded14c65` |

Both files are structurally valid PBIX containers and were supplied as the completed Power BI Desktop reference builds. Their loaded model-table layouts match the Module 3 reference contract: eleven prepared outputs in the Data Preparation file and four performance branches in the Folding & Performance file.

The reference files intentionally do **not** establish Module 4 semantic relationship architecture. The PBIX metadata contains no auto-created relationships; relationship/cardinality/filter-propagation design remains Module 4 ownership.

If your environment uses a different local source path or SQL instance, rebind the source/parameters as instructed in the Detailed Build Guide rather than changing the frozen validation truth.
