# Tableau Dashboard — Google Fiber FCR

Primary deliverable, as requested by the original stakeholder spec.

```
tableau/
├── Google_Fiber_FCR_Dashboard.twb     workbook (uncompressed)
├── screenshots/                       previews for the root README
└── README.md                          you are here
```

## Connect to the dbt mart

1. Open the `.twb` in Tableau Desktop or Tableau Public.
2. If prompted for a data source: **Connect → Google BigQuery**.
3. Authenticate to your GCP project (OAuth).
4. Project: `your-gcp-project-id`
5. Dataset: `dbt_prod` (or `dbt_dev` if developing)
6. Table: `mart_fiber_fcr`
7. Refresh the workbook.
