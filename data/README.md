# Data

This folder holds reference data — **not** the production source of truth. The real raw tables live in BigQuery.

```
data/
├── raw/                # intentionally empty — see below
└── samples/            # small sanitized CSV for local previews
```

## `raw/`

**Empty by design.** Raw data lives in BigQuery (`gbi-test.fiber.market_{1,2,3}`) and should never be committed to the repo. This follows the *"data is immutable"* principle from Cookiecutter Data Science.

To access the raw data:

```bash
gcloud auth application-default login
bq head -n 10 gbi-test:fiber.market_1
```

## `samples/`

Contains a small CSV exported from the mart for use in:

- BI-tool offline previews (when you can't connect to BigQuery)
- Tableau Public dashboards that need an embedded extract
- Anyone exploring the project without a GCP account

| File                                         | Rows  | Description                                      |
|----------------------------------------------|-------|--------------------------------------------------|
| `google_fiber_case_dashboard_data.csv`       | ~1.5k | Aggregated extract used to back the Tableau twb  |

The CSV is **not** the canonical source. Always prefer `mart_fiber_fcr` in BigQuery for fresh, tested data.
