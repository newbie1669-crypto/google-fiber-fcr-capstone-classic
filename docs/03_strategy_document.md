# Strategy Document - Google Fiber

> **Source:** `03_strategy_document.docx` (original)

> **Phase:** Capture (final step — the dashboard specification)

This document is the bridge between requirements and the built dashboard. It specifies exactly which charts the dashboard must contain, their types, dimensions, and metrics - the blueprint the BI layer is built against.

---

## Sign-off Matrix

| Field             | Value                                                    |
|-------------------|----------------------------------------------------------|
| **Proposer**      | Emma Santiago, Hiring Manager                            |
| **Status**        | Draft -> Under review -> Implemented / Not implemented     |
| **Primary dataset** | `market_1`, `market_2`, `market_3`                     |
| **Secondary dataset** | - |

| Name           | Team / Role     | Date              |
|----------------|-----------------|-------------------|
| Emma Santiago  | Hiring Manager  | December 15, 2026 |

## User Profiles

| Name           | Role             |
|----------------|------------------|
| Emma Santiago  | Hiring Manager   |
| Keith Portone  | Project Manager  |
| Minna Rah      | Lead BI Analyst  |
| Ian Ortega     | BI Analyst       |
| Sylvie Essa    | BI Analyst       |

---

## Dashboard Functionality

| Feature                       | Specification                                                                                                                                  |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| **Reference dashboard**        | Build a new dashboard to explore the number of repeat callers and their problem types across three different market cities.                    |
| **Access**                     | Read-only access, granted to the user profiles listed above.                                                                                   |
| **Scope**                      | Fields included: `date`, `market`, `problem_type`, `contact_n`, and `contact_n_#`.                                                              |
| **Date filters & granularity** | Date filters for Week / Month / Quarter. Any chart with detailed metrics should be clickable to drill into specific information (granularity).   |

---

## Metrics and Charts

The dashboard must contain the following four charts.

### Chart 1 - Repeat calls by first date

| Attribute     | Specification                              |
|---------------|--------------------------------------------|
| Chart type    | Table                                      |
| Dimension(s)  | Day of initial call, subsequent repeat calls |
| Metric(s)     | Contact                                    |

### Chart 2 - Market and Problem Type of First Repeat Calls

| Attribute     | Specification                          |
|---------------|----------------------------------------|
| Chart type    | Bar                                    |
| Dimension(s)  | Call type, market, `contact_n_1`       |
| Metric(s)     | Contact                                |

### Chart 3 - Calls by Market and Type

| Attribute     | Specification                |
|---------------|------------------------------|
| Chart type    | Table                        |
| Dimension(s)  | Market, call type, day       |
| Metric(s)     | Contact                      |

### Chart 4 - Repeats by Week, Month, and Quarter

| Attribute     | Specification          |
|---------------|------------------------|
| Chart type    | Bar                    |
| Dimension(s)  | Date, contact          |
| Metric(s)     | Contact                |

---

## How this maps to the build

Each chart specified here is delivered by the dashboards in [`../dashboards/`](../dashboards/), all backed by the `mart_fiber_fcr` table. The mart columns that satisfy these charts are documented in [`data_dictionary.md`](data_dictionary.md).
