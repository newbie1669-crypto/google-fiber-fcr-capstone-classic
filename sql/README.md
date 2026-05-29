# Legacy SQL — pre-dbt reference

These are the **original SQL files** written during exploratory analysis, before the project was migrated to dbt. They are kept for **reference and storytelling**, not for production purpose.

```
sql/
├── 01_preparation_and_union.sql       Union of three market tables
└── 02_data_quality_check.sql          Manual DQ checks (CHECK 1–7)
```

## Why keep this?

For a portfolio reviewer, the progression `raw SQL → dbt project` shows:

1. The ability to write working SQL against BigQuery directly.
2. The judgment to recognize when raw SQL stops scaling and adopt a transformation framework.
3. A real example of refactoring analytics code into a tested, version-controlled, modular form.

## Mapping to the dbt version

| Legacy file                          | Replaced by                                                              |
|--------------------------------------|---------------------------------------------------------------------------|
| `01_preparation_and_union.sql`       | `dbt/models/staging/stg_market_{1,2,3}.sql` + `dbt/models/marts/mart_fiber_fcr.sql` (the UNION lives in the mart) |
| `02_data_quality_check.sql` — CHECK 1 (row counts) | `dbt run` + BigQuery row counts                                      |
| `02_data_quality_check.sql` — CHECK 2 (NULLs)      | `not_null` tests in `_schema.yml`                                    |
| `02_data_quality_check.sql` — CHECK 3 (dupes)      | `dbt_utils.unique_combination_of_columns`                            |
| `02_data_quality_check.sql` — CHECK 4 (date range) | `dbt_expectations.expect_column_values_to_be_between`                |
| `02_data_quality_check.sql` — CHECK 5 (negatives)  | `dbt_utils.expression_is_true: ">= 0"`                               |
| `02_data_quality_check.sql` — CHECK 6 (categories) | `accepted_values`                                                    |
| `02_data_quality_check.sql` — CHECK 7 (summary)    | `dbt/analyses/dq_summary_report.sql` + `macros/generate_dq_summary.sql` |

## When to update these files

**Don't.** They're a frozen reference. New work goes in `dbt/`. If you change source schemas, update the dbt project; the legacy SQL is historical.
