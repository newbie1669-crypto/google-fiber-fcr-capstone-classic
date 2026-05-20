# Data Dictionary

Schema of all tables in the pipeline.

---

## Raw Source — `gbi-test.fiber.market_{1,2,3}`

Three sibling tables, identical schema, one per market.

| Column         | Type   | Nullable | Description                                                              |
|----------------|--------|----------|--------------------------------------------------------------------------|
| `date_created` | DATE   | No       | First-contact date for the (type, market) bucket                         |
| `contacts_n`   | INT64  | No       | First contacts on `date_created`                                         |
| `contacts_n_1` | INT64  | No       | Repeat contacts 1 day after first contact                                |
| `contacts_n_2` | INT64  | No       | Repeat contacts 2 days after                                             |
| `contacts_n_3` | INT64  | No       | Repeat contacts 3 days after                                             |
| `contacts_n_4` | INT64  | No       | Repeat contacts 4 days after                                             |
| `contacts_n_5` | INT64  | No       | Repeat contacts 5 days after                                             |
| `contacts_n_6` | INT64  | No       | Repeat contacts 6 days after                                             |
| `contacts_n_7` | INT64  | No       | Repeat contacts 7 days after                                             |
| `new_type`     | STRING | No       | Problem type label (`type_1` … `type_5`)                                 |
| `new_market`   | STRING | No       | Market label (`market_1` / `market_2` / `market_3`)                      |

**Problem type mapping (from project requirements):**

| Code     | Meaning                       |
|----------|-------------------------------|
| `type_1` | Account management            |
| `type_2` | Technician troubleshooting    |
| `type_3` | Scheduling                    |
| `type_4` | Construction                  |
| `type_5` | Internet and WiFi             |

> ⚠️ The dbt `accepted_values` test uses the **English labels** (e.g. `TECHNICIAN`, `INTERNET AND WIFI`). If the raw data uses codes (`type_1` …), update either the source or the test to keep them aligned. See `dbt/models/marts/_schema.yml`.

---

## Staging Layer — `dbt_dev.stg_market_{1,2,3}`

Materialized as **views** for cheap rebuilds.

Same columns as the source, but:

- `date_created` is `CAST` to `DATE`
- All `contacts_n*` are `CAST` to `INT64`
- `new_type`, `new_market` are `TRIM(UPPER(...))` (normalized casing & whitespace)

---

## Mart Layer — `dbt_prod.mart_fiber_fcr`

Materialized as a **table** — this is what BI tools connect to.

### Dimensions

| Column         | Type   | Description                                |
|----------------|--------|--------------------------------------------|
| `date_created` | DATE   | First-contact date                         |
| `new_market`   | STRING | `MARKET_1` / `MARKET_2` / `MARKET_3`       |
| `new_type`     | STRING | Problem type (normalized uppercase)        |

### Raw measures

| Column                  | Type | Description                                      |
|-------------------------|------|--------------------------------------------------|
| `contacts_n`            | INT  | First contacts on `date_created`                 |
| `contacts_n_1` … `_n_7` | INT  | Repeat contacts at each day-lag (1–7 days)       |
| `total_repeat_contacts` | INT  | Sum of `contacts_n_1` through `contacts_n_7`     |

### Calculated metrics

| Column                        | Type  | Formula                                                                       |
|-------------------------------|-------|-------------------------------------------------------------------------------|
| **`fcr_day1_rate`**           | FLOAT | `SAFE_DIVIDE(contacts_n - contacts_n_1, contacts_n)`                          |
| **`fcr_7day_rate`**           | FLOAT | `SAFE_DIVIDE(contacts_n - total_repeat_contacts, contacts_n)`                 |
| `repeat_rate_day1` … `day7`   | FLOAT | `SAFE_DIVIDE(contacts_n_<N>, contacts_n)` for N = 1…7                         |

### Metadata

| Column           | Type        | Description                                       |
|------------------|-------------|---------------------------------------------------|
| `dbt_updated_at` | TIMESTAMP   | When dbt last rebuilt this row (`CURRENT_TIMESTAMP()`) |

---

## Granularity & Uniqueness

The grain of `mart_fiber_fcr` is **one row per `(date_created, new_type, new_market)`** — enforced by the dbt test `dbt_utils.unique_combination_of_columns`.

## KPI Interpretation Guide

- **`fcr_day1_rate`** — share of first contacts that did **not** trigger a call-back the next day. *Primary KPI* — higher is better.
- **`fcr_7day_rate`** — share of first contacts with **zero repeats over 7 days**. *Secondary KPI* — stricter measure.
- **`repeat_rate_day{N}`** — used to plot the **decay curve** of repeat calls over time. Useful for finding "lingering issue" patterns.
