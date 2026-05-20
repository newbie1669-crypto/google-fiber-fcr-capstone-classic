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

## Columns used

| Column              | Visualization              |
|---------------------|----------------------------|
| `fcr_day1_rate`     | KPI card — primary metric  |
| `fcr_7day_rate`     | KPI card — secondary       |
| `repeat_rate_day1..7` | Line chart (decay curve) |
| `new_market`        | Filter / color encoding    |
| `new_type`          | Filter / breakdown         |
| `date_created`      | Time axis                  |

## Publishing to Tableau Public

```
File → Save to Tableau Public As...
```

> ⚠️ Tableau Public requires the workbook to use a published or extracted data source — direct BigQuery live connections aren't supported. For Public, export an extract first:
> `File → Export Packaged Workbook (.twbx)` → publish that.

## Versioning

`.twb` is XML — diff-friendly. The file is committed directly (not `.twbx`) so PRs can show meaningful changes.
