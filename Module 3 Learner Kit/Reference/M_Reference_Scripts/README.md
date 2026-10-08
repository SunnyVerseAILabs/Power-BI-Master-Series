# Module 3 M Reference Scripts

Use these scripts only after attempting the learner build. They are canonical comparison examples for the frozen Stage 4 package. They demonstrate the intended architecture and business-preserving patterns; source paths and credentials remain environment-specific.

Key rules:
- Treat parameters as configuration, not secrets.
- Keep raw/staging access separate from prepared outputs.
- Preserve error/audit evidence instead of making failures disappear.
- Prefer schema-resilient contracts such as Unpivot Other Columns and explicit required-column selection.
- Validate row counts/totals after every material recovery.
- Preserve folding for RangeStart/RangeEnd where the source/connector supports it.
- Measure buffering and diagnostics rather than assuming faster performance.

The scripts are text references; the validated learner process remains the Detailed Build Guide.
