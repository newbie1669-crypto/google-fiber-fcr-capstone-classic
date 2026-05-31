# Google Fiber FCR — dbt Project (the hardest part ?)

Pipeline: **BigQuery (raw data)** → **dbt staging** → **dbt mart** → **Tableau / Power BI / Data Studio**

> CI workflow (`dbt_ci.yml`) lives at the **repo root** under `.github/workflows/`, not inside this folder — GitHub Actions only discovers workflows at the root.

---

## Project layout

```
dbt/
├── dbt_project.yml              # Project config
├── profiles.yml.example         # Template — copy to ~/.dbt/profiles.yml
├── packages.yml                 # dbt dependencies (dbt-utils, dbt-expectations)
├── models/
│   ├── staging/
│   │   ├── _sources.yml         # Declares raw tables in BigQuery
│   │   ├── _schema.yml          # DQ tests for staging
│   │   ├── stg_market_1.sql     # Clean + cast types
│   │   ├── stg_market_2.sql
│   │   └── stg_market_3.sql
│   └── marts/
│       ├── _schema.yml          # DQ tests covering CHECK 1-7
│       └── mart_fiber_fcr.sql   # UNION 3 markets + FCR metrics
├── macros/
│   └── generate_dq_summary.sql  # Macro for DQ summary report
└── analyses/
    └── dq_summary_report.sql    # Ad-hoc DQ summary (compile-only)
```

---

## 1. First Setup (One-time)

### Install dbt

```bash
pip install dbt-bigquery
```

### Copy profiles.yml.example to ~/.dbt/profiles.yml

```bash
mkdir -p ~/.dbt
cp dbt/profiles.yml.example ~/.dbt/profiles.yml
```

> ⚠️ The real `profiles.yml` is **gitignored** — it lives only at `~/.dbt/profiles.yml`, never in the repo. Only the `.example` template is versioned.

### Edit ~/.dbt/profiles.yml

Replace the placeholders:

```yaml
project: your-gcp-project-id   # ← your real GCP Project ID (e.g. gbi-test)
```

For the `prod` target, also point `keyfile` to your service-account JSON.

### Login GCP (for dev)

```bash
gcloud auth application-default login
```

### Install dbt packages

```bash
cd dbt
dbt deps
```

### Check connection

```bash
dbt debug
```

Expected result : `All checks passed!`

---

## 2. Daily Run

### Run all models (staging + marts)

```bash
dbt run
```

### Run all DQ tests

```bash
dbt test
```

If the test pass :
```
Completed successfully
Done. PASS=12 WARN=0 ERROR=0 SKIP=0 TOTAL=12
```

If the test fail:
```
Failure in test not_null_mart_fiber_fcr_date_created (...)
  Got 5 results, configured to fail if != 0
```

### Run + test in one command

```bash
dbt build   # = both dbt run + dbt test
```

---

## 3. Frequently used command

| command | description |
|--------|-----------|
| `dbt run` | Run all models |
| `dbt test` | Run all DQ tests  |
| `dbt build` | Run + test |
| `dbt run -s stg_market_1` | Run specific mode |
| `dbt test -s mart_fiber_fcr` | Test only mart |
| `dbt run --target prod` | Run on production dataset |
| `dbt docs generate` | Create documentation site |
| `dbt docs serve` | Open docs at localhost:8080 |
| `dbt compile --select dq_summary_report` | compile DQ summary SQL |

---

## 4. See DQ Summary Report (ad-hoc)

```bash
dbt compile --select dq_summary_report
```

then copy SQL from `target/compiled/.../dq_summary_report.sql` run on BigQuery Console

---

## 5. Connect a BI tool

Per-tool setup guides live in `dashboards/tableau/`, `dashboards/powerbi/`, and `dashboards/looker_studio/`. All three connect to the same table:

1. Connect → **Google BigQuery**
2. Project: `your-gcp-project-id`
3. Dataset: `dbt_prod` (or `dbt_dev` for development)
4. Table: `mart_fiber_fcr`

Columns ready to use in any BI tool:

| Column | purpose |
|--------|-------|
| `fcr_day1_rate` | KPI card FCR |
| `fcr_7day_rate` | KPI card 7-day FCR |
| `repeat_rate_day1..7` | Line chart to show decay curve |
| `new_market` | Filter / breakdown |
| `new_type` | Filter / breakdown |
| `date_created` | Time series axis |

---

## 6. GitHub Actions (CI/CD)

On every push or PR to `main`, GitHub Actions runs `.github/workflows/dbt_ci.yml` (located at the **repo root**, not inside this folder):

1. Installs `dbt-bigquery`
2. Authenticates to GCP using the `GCP_SA_KEY` secret
3. Runs `dbt run --target prod`
4. Runs `dbt test --target prod` — any failure blocks the merge

### Set the GCP secret

1. GitHub repo → **Settings → Secrets and variables → Actions**
2. **New repository secret** → name it `GCP_SA_KEY`
3. Paste the **entire content** of your service-account JSON key

---

## 7. DQ Tests

| CHECK | dbt test used |
|-----------|----------------|
| CHECK 1: rows by market | `dbt run` + see in BigQuery |
| CHECK 2: NULL checks | `not_null` all column |
| CHECK 3: duplicates | `unique_combination_of_columns` |
| CHECK 4: date range | `dbt_expectations.expect_column_values_to_be_between` |
| CHECK 5: negatives | `expression_is_true: ">= 0"` |
| CHECK 6: accepted values | `accepted_values` |
| CHECK 7: summary | `analyses/dq_summary_report.sql` |
