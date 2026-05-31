# Google Fiber BI Capstone Project — First Contact Resolution (FCR) Analytics

End-to-end analytics pipeline measuring repeat-caller behavior across three Google Fiber markets.

**Workflow :** BigQuery → dbt → Tableau / Power BI / Data Studio (ex-name: Looker studio)

---

## Background

Google Fiber's customer service team wants to **reduce repeat calls** and improve first-contact resolution. The business question:

> **"How often are customers repeatedly contacting customer service after their first call — and what problem types or markets drive that behavior?"**

Source: Google Business Intelligence Certificate — Case Study 2 (Google Fiber).

## Project Delivers

1. **Data transformation layer** that turns three raw call-center tables (for 3 markets) into a single, tested FCR mart
2. **Data quality tests** (12+ assertions covering nulls, ranges, accepted values, uniqueness) wired into CI
3. **Three dashboards** (Tableau, Power BI, Data Studio) connected to BigQuery by the same data pipeline
4. **Documentation** of the project including :

        - Stakeholder requirement
        - Project requirement
        - Strategy doc
        - ROCCC data quility assessment doc

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   ┌──────────────────┐         ┌──────────────────┐                 │
│   │  BigQuery (raw)  │         │   dbt staging    │                 │
│   │                  │   ──►   │                  │                 │
│   │  fiber.market_1  │         │  stg_market_1    │                 │
│   │  fiber.market_2  │         │  stg_market_2    │   (views,       │
│   │  fiber.market_3  │         │  stg_market_3    │    type-cast)   │
│   └──────────────────┘         └────────┬─────────┘                 │
│                                         │                           │
│                                         ▼                           │
│                                ┌──────────────────┐                 │
│                                │    dbt marts     │                 │
│                                │                  │                 │
│                                │  mart_fiber_fcr  │   (table,       │
│                                │   + DQ tests     │    7-day FCR    │
│                                │                  │    + decay)     │
│                                └────────┬─────────┘                 │
│                                         │                           │
│              ┌──────────────────────────┼──────────────────────────┐│
│              ▼                          ▼                          ▼│
│      ┌──────────────┐           ┌──────────────┐          ┌─────────┴──┐
│      │   Tableau    │           │   Power BI   │          │    Data    │
│      │  Dashboard   │           │  Dashboard   │          │   Studio   │
│      └──────────────┘           └──────────────┘          └────────────┘
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  ▲
                                  │
                          GitHub Actions CI
                       (dbt run + dbt test on push)
```

See [`docs/architecture.md`](docs/architecture.md) for the full diagram and rationale.

---

## Repository Layout

```
google-fiber-fcr-capstone/
├── .github/workflows/      CI: auto-run dbt on push to main
├── docs/                   Requirements, ROCCC, architecture, data dictionary
├── data/samples/           Reference CSV (sanitized)
├── sql/                    Legacy raw SQL (pre-dbt, kept for reference)
├── dbt/                    Production transformation layer
│   ├── models/staging/         3 staging views (one per market)
│   ├── models/marts/           mart_fiber_fcr (final table)
│   ├── macros/                 generate_dq_summary
│   └── analyses/               ad-hoc DQ summary
├── dashboards/             3 BI versions on the same mart
│   ├── tableau/
│   ├── powerbi/
│   ├── data_studio/
│   └── mockups/                lo-fi mockups from design phase
├── Makefile                One-command operations (`make help`)
└── README.md               You are here
```

Every choice maps to an established standard (dbt Labs structure guide, Twelve-Factor App, Cookiecutter Data Science).

---

## Key Metrics Built by the Pipeline

The `mart_fiber_fcr` table exposes these columns for any BI tool:

| Column                      | Type   | Meaning                                                                       |
|-----------------------------|--------|-------------------------------------------------------------------------------|
| `date_created`              | DATE   | First-contact date                                                            |
| `new_market`                | STRING | `MARKET_1` / `MARKET_2` / `MARKET_3`                                          |
| `new_type`                  | STRING | Problem type (technician, internet/wifi, phone, cable, charges)               |
| `contacts_n`                | INT    | First contacts on `date_created`                                              |
| `contacts_n_1` … `_n_7`     | INT    | Repeat contacts 1–7 days later                                                |
| **`fcr_day1_rate`**         | FLOAT  | **% of customers not calling back the next day** (primary KPI)                |
| **`fcr_7day_rate`**         | FLOAT  | **% of customers not calling back within 7 days** (secondary KPI)             |
| `repeat_rate_day1` … `_7`   | FLOAT  | Repeat rate at each day-lag (for decay curves)(*optional I didn't use it either)                      |

Full schema: [`docs/data_dictionary.md`](docs/data_dictionary.md).

---

## Data Quality Testing

Twelve+ tests run on every push via GitHub Actions. They map to the seven CHECKs of the original analysis:

| NO. | Coverage                                | dbt test                                   |
|-------|-----------------------------------------|--------------------------------------------|
| 1     | Row counts by market                    | `dbt run` + BigQuery review                |
| 2     | NULL checks on key columns              | `not_null`                                 |
| 3     | Composite uniqueness `(date, type, mkt)`| `dbt_utils.unique_combination_of_columns`  |
| 4     | Date range sanity                       | `dbt_expectations.expect_column_values_to_be_between` |
| 5     | No negative contact counts              | `dbt_utils.expression_is_true: ">= 0"`     |
| 6     | Categorical values match enum           | `accepted_values`                          |
| 7     | Aggregate DQ summary                    | `analyses/dq_summary_report.sql`           |

---

## Dashboards

Three independent dashboards backed by the same `mart_fiber_fcr` table — pick the BI tool of your choice.

| BI Tool             | Status                | Folder                                    |
|---------------------|-----------------------|-------------------------------------------|
| **Tableau**         | ✅ Built (.twbx)      | [`dashboards/tableau/`](dashboards/tableau/)             |
| **Power BI**        | ✅ Built (.pbix)      | [`dashboards/powerbi/`](dashboards/powerbi/)             |
| **Looker Studio**   | ✅ Built (Data Studio)      | [`dashboards/data_studio/`](dashboards/data_studio/) |

Lo-fidelity mockups from the design phase: [`dashboards/mockups/`](dashboards/mockups/).

---

## Project Phases

This project follows the three phases BI project lifecycle from the Google Business Intelligence Certificate :

| Phase    | What was done                                                   | Folder                         |
|--------------|-----------------------------------------------------------------|----------------------------------------|
| **01 Capture**  | Stakeholder requirements, project requirements, strategy doc, ROCCC data quality assessment doc | `docs/`                              |
| **02 Analyze**  | SQL exploration → dbt models → DQ tests                     | `sql/` + `dbt/` |
| **03 Monitor**  | Dashboards + lo-fi mockups                                | `dashboards/`                          |

For full detail : [`docs/phase_mapping.md`](docs/phase_mapping.md).

---

## Tools Used in The Project

| Layer        | Tool                                              | Description                                       |
|--------------|---------------------------------------------------|-------------------------------------------|
| Warehouse    | Google BigQuery                                   | Serverless, SQL-first, integrates with GCP|
| Transform    | dbt-bigquery 1.8.x                                  | SQL-native, version-controlled, testable  |
| DQ Tests     | dbt-utils, dbt-expectations                       | Great-Expectations-style assertions in dbt|
| CI/CD        | GitHub Actions                                    | Auto-test on every PR / push to main      |
| BI           | Tableau / Power BI / Data Studio                  | Same mart, three dashboards               |
| Docs         | Markdown + .docx originals                        | GitHub-rendered + Word for delivery to stakeholder |

---

### Deliverables documentation (for stakeholder)

- [`docs/01_stakeholder_requirements.md`](docs/01_stakeholder_requirements.md) — what the business asked for
- [`docs/02_project_requirements.md`](docs/02_project_requirements.md) — scoped & prioritized requirements
- [`docs/03_strategy_document.md`](docs/03_strategy_document.md) — dashboard spec: the four charts to build
- [`docs/04_roccc_data_assessment.md`](docs/04_roccc_data_assessment.md) — data quality evaluation

### Reference documentation (for detail)

- [`docs/data_dictionary.md`](docs/data_dictionary.md) — every column explained
- [`docs/architecture.md`](docs/architecture.md) — pipeline & structure rationale
- [`docs/phase_mapping.md`](docs/phase_mapping.md) — GBI phase ↔ folder mapping
- [`dbt/README.md`](dbt/README.md) — dbt project usage guide

---

## Author

**Pluemprach Dangdee** — Google Business Intelligence Capstone, 2025–2026