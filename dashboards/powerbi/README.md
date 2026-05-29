# Power BI Dashboard — Google Fiber FCR

**Status: Done** 

## Plan

1. Open Power BI Desktop.
2. **Get Data → Google BigQuery**.
3. Authenticate to your GCP project.
4. Navigate: `your-gcp-project-id` → `dbt_prod` → `mart_fiber_fcr`.
5. Choose **DirectQuery** (recommended) or **Import** (smaller datasets only).
6. Build visuals using the columns listed in [`../README.md`](../README.md#common-metrics-across-all-three).

## Why DirectQuery?

The pipeline rebuilds the mart on every push (via GitHub Actions). With DirectQuery, the dashboard always reflects the latest tested data — no manual refresh needed.

## File to add

Once built, save as `google_fiber_fcr.pbix` in this folder.

> ⚠️ Power BI `.pbix` files are binary and not diff-friendly. Treat them like assets, not source code — each commit is effectively a full overwrite.
