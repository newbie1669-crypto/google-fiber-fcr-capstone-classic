# Power BI Dashboard — Google Fiber FCR

## How I connect Power BI to GCP 

1. Open Power BI Desktop.
2. **Get Data → Google BigQuery**.
3. Authenticate to the GCP project.
4. Navigate: `your-gcp-project-id` → `dbt_prod` → `mart_fiber_fcr`.
5. Choose **DirectQuery** (recommended for production) or **Import** (smaller datasets, embedded with data for sharing).
6. Build visuals and dashboard