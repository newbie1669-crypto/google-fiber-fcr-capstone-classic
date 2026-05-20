# Looker Studio Dashboard — Google Fiber FCR

🚧 **Status: in progress** — link will be added once published.

## Connect

1. Go to <https://lookerstudio.google.com/>
2. **Create → Data source → BigQuery connector**
3. Authenticate with the GCP project where the dbt mart lives
4. Project: `your-gcp-project-id` → Dataset: `dbt_prod` → Table: `mart_fiber_fcr`
5. **Connect** → adjust field types if needed
6. **Create Report**

## Public link

Once published with **Share → Anyone with the link can view**, paste the link below:

```
Public URL: <not yet published>
```

## Visualizations (suggested)

Match the metrics list in [`../README.md`](../README.md#common-metrics-across-all-three):

- **Scorecard** — `fcr_day1_rate` (primary KPI), `fcr_7day_rate`
- **Time series** — `repeat_rate_day1..7` over `date_created`
- **Bar chart** — repeats by `new_market`
- **Bar chart** — repeats by `new_type`
- **Filter controls** — date range, market, type

## Auto-refresh

Looker Studio caches BigQuery results for 12 hours by default. Edit the data source → **Data Freshness** to tune (1h is reasonable for most demos).
