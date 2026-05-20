# Dashboards

Three dashboards built on the **same** `mart_fiber_fcr` table — one per BI tool. They answer the same business question with the same metrics; the differences are purely interface and platform.

```
dashboards/
├── tableau/            primary deliverable (Tableau Public)
├── powerbi/            secondary version (Power BI Desktop)
├── looker_studio/      browser-shareable version (GDS)
└── mockups/            lo-fi designs from the planning phase
```

## Why three versions?

A portfolio benefits from showing range — the same data engineering work supports any BI front-end. Reviewers can open the version that matches their team's stack.

| BI Tool          | Best for                                        | Output format        |
|------------------|-------------------------------------------------|----------------------|
| **Tableau**      | Interactive, polished, public sharing           | `.twb` / Tableau Public link |
| **Power BI**     | Microsoft-heavy stacks, Office integration      | `.pbix` / Power BI Service |
| **Looker Studio**| Free, browser-shareable, GCP-native             | URL                  |

All three connect to **the same `mart_fiber_fcr` table** in BigQuery — meaning DQ tests, schema changes, and metric definitions are managed in **one** place (dbt), and the three dashboards stay in sync automatically.

## Common metrics across all three

| Metric              | Visualization      | Source column          |
|---------------------|--------------------|------------------------|
| FCR Day-1 Rate      | KPI card           | `fcr_day1_rate`        |
| 7-Day FCR Rate      | KPI card           | `fcr_7day_rate`        |
| Repeat decay curve  | Line chart         | `repeat_rate_day1..7`  |
| Repeat by market    | Bar / heatmap      | `new_market`           |
| Repeat by type      | Bar / treemap      | `new_type`             |
| Trend over time     | Time series        | `date_created`         |

See [`docs/04_data_dictionary.md`](../docs/04_data_dictionary.md) for the full schema.

## Mockups

Lo-fi mockups (`mockups/`) were produced in the planning phase before any chart was built. They served as alignment artifacts with stakeholders.
