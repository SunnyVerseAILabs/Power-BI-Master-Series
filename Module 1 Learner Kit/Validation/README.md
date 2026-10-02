# Validation

Use this folder only when the Detailed Build Guide reaches the final reconciliation stage.

The guide already includes stage validations after major checkpoints so you can confirm your reasoning progressively without opening the final answer pack too early. This folder is the final independent reconciliation layer.

- `Expected_Validation_Values.xlsx` — final portfolio totals and expected planted-quality findings
- `Expected_Portfolio_Values.csv` — machine-readable portfolio baseline
- `Expected_Region_Values.csv` — machine-readable regional baseline
- `Final_Reference_Data/` — clean authoritative datasets used for final reconciliation

The files in `Final_Reference_Data/` are not normal source inputs. They represent the corrected authoritative state after the data-quality issues and source-authority decisions have been understood.

Completed artifacts are kept separately under `../Reference/` so you can distinguish validation evidence from finished examples.
