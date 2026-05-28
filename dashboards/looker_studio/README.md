# Data Studio Dashboard — Google Fiber FCR

**Status: Done**

## Connect

1. Go to <https://datastudio.google.com/>
2. **Create → Data source → BigQuery connector**
3. Authenticate with the GCP project where the dbt mart lives
4. Project: `your-gcp-project-id` → Dataset: `dbt_prod` → Table: `mart_fiber_fcr`
5. **Connect** → adjust field types if needed
6. **Create Report**

## Public link

Once published with **Share → Anyone with the link can view**, paste the link below:

Public URL: [`Google Fiber Capstone Dashboard`](https://datastudio.google.com/reporting/fd6d408a-0a4b-45eb-bf1a-7ca99d69dd03)

## Auto-refresh

Looker Studio caches BigQuery results for 12 hours by default. Edit the data source → **Data Freshness** to tune (1h is reasonable for most demos).
