# GBI Phase ↔ Engineering Folder Mapping

This project follows the **Capture → Analyze → Monitor** lifecycle taught in the Google Business Intelligence Certificate. The engineering layout uses standard data-engineering folder names (so it reads naturally to data engineers and reviewers), but every GBI phase is preserved and traceable.

---

## Side-by-side mapping

| GBI Phase  | Engineering folder(s)                                | What lives there                                                                                          |
|------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| **1. Capture** | `docs/`                                          | Stakeholder requirements, project requirements, ROCCC data assessment, data dictionary, architecture doc  |
| **2. Analyze** | `sql/` + `dbt/` + `data/samples/`                | Legacy exploratory SQL → production dbt models (staging + marts) + 12 DQ tests + sample CSV               |
| **3. Monitor** | `dashboards/`                                    | Three BI dashboards (Tableau, Power BI, Data Studio) + lo-fi mockups + GitHub Actions CI                |

## What was done in each phase

### Phase 1 — Capture (`docs/`)

The goal of Capture is to understand the business problem and the data we have access to **before** writing any SQL. Deliverables:

- `01_stakeholder_requirements.md` — verbatim from the hiring manager
- `02_project_requirements.md` — refined, prioritized (R / D / N), with SMART success criteria
- `03_strategy_document.md` — dashboard specification: the four charts to build
- `04_roccc_data_assessment.md` — 5-pillar credibility assessment of the source data

These produce the artifacts that justify every later technical decision.

### Phase 2 — Analyze (`sql/` + `dbt/`)

The Analyze phase translates the business question into queries and a tested data model:

- **`sql/`** — the original raw SQL (UNION + DQ checks) written during exploration. Preserved as a "before-dbt" reference so the progression is visible.
- **`dbt/`** — the production version. Three staging views (one per market) → one mart with FCR metrics → 12+ DQ tests covering nulls, ranges, accepted values, uniqueness.
- **`data/samples/`** — a small CSV slice for local dashboarding or BI tool previews without a BigQuery connection.

### Phase 3 — Monitor (`dashboards/`)

Monitor is about putting the answers in front of stakeholders and keeping them fresh:

- **`dashboards/tableau/`** — the primary deliverable as requested by stakeholders (`.twb`)
- **`dashboards/powerbi/`** — second BI version
- **`dashboards/Data_studio/`** — third BI version (browser-shareable)
- **`dashboards/mockups/`** — lo-fi mockups from the design phase, kept for context
- **`.github/workflows/`** — CI that re-runs `dbt run + dbt test` on every push, so dashboards never read stale or broken data

## Why we didn't keep the original `1 Capture/` / `2 Analyze/` / `3 Monitor/` folder names

Three reasons:

1. **POSIX-friendliness** — folder names with spaces require shell escaping and break some CI/build tools.
2. **Discoverability for reviewers** — data engineers and BI hiring managers expect names like `dbt/`, `dashboards/`, `docs/`; numbered phase names look unfamiliar.
3. **Information goes in docs, not in path names** — phase information is metadata about *how* the work was done; the folder is *where the artifact lives*. Two different things.

The GBI phase metadata is fully preserved in this document and in the root `README.md`.
