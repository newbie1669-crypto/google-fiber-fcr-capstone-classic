# Architecture & Repository Layout

This document explains **what was built**, **how it flows**, and **why each folder exists**. Every structural decision is anchored in a published industry standard so the design can be defended in code review or interview.

---

## 1. Pipeline Architecture

```
                ┌──────────────────────────────────────┐
                │   Google BigQuery — RAW              │
                │                                      │
                │   gbi-test.fiber.market_1            │
                │   gbi-test.fiber.market_2            │
                │   gbi-test.fiber.market_3            │
                └────────────────┬─────────────────────┘
                                 │  declared as `sources` in dbt
                                 │  (models/staging/_sources.yml)
                                 ▼
                ┌──────────────────────────────────────┐
                │   dbt STAGING (views)                │
                │                                      │
                │   stg_market_1  ─┐                   │
                │   stg_market_2  ─┼─ type-cast +      │
                │   stg_market_3  ─┘  trim + uppercase │
                │                                      │
                │   Tests: not_null, expression >= 0   │
                └────────────────┬─────────────────────┘
                                 │  UNION ALL
                                 ▼
                ┌──────────────────────────────────────┐
                │   dbt MARTS (table)                  │
                │                                      │
                │   mart_fiber_fcr                     │
                │   - Combined across markets          │
                │   - fcr_day1_rate                    │
                │   - fcr_7day_rate                    │
                │   - repeat_rate_day1 .. day7         │
                │                                      │
                │   Tests: 12+ including unique combo, │
                │          accepted values, ranges     │
                └────────────────┬─────────────────────┘
                                 │  same shared mart
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                  ▼
       ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
       │   Tableau    │  │   Power BI   │  │ Looker Studio│
       │              │  │              │  │              │
       └──────────────┘  └──────────────┘  └──────────────┘

                    GitHub Actions (CI on push to main):
                    dbt deps → dbt run --target prod → dbt test --target prod
```

The whole pipeline is **idempotent**: rerunning `make build` from any state produces the same result. Models are materialized in BigQuery, so dashboards never query raw tables directly — they hit the tested mart.

---

## 2. Repository Layout

```
google-fiber-fcr-capstone/
├── .github/workflows/         CI: GitHub Actions auto-runs dbt on push
│   └── dbt_ci.yml
├── docs/                      [Capture phase] requirements + assessments
├── data/                      Reference samples (sanitized)
│   └── samples/
├── sql/                       [Analyze phase] legacy raw SQL (pre-dbt)
├── dbt/                       [Analyze phase] production transformations
│   ├── models/staging/             3 views, one per market
│   ├── models/marts/               mart_fiber_fcr
│   ├── macros/                     generate_dq_summary
│   └── analyses/                   dq_summary_report
├── dashboards/                [Monitor phase] BI deliverables
│   ├── tableau/
│   ├── powerbi/
│   ├── looker_studio/
│   └── mockups/
├── Makefile                   One-command operations
├── .gitignore                 Blocks secrets + build artifacts
├── LICENSE                    MIT
└── README.md                  Portfolio landing page
```

---

## 3. Design Decisions & Rationale

Every choice maps to a published, reviewable standard.

### 3.1 `dbt/` is a subfolder, not the repo root

**Decision:** dbt project lives at `dbt/`, not at the repo root.

**Reference:** [dbt Labs — How we structure our dbt projects](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview). dbt projects should live in a subfolder whenever the repo also contains non-dbt artifacts (dashboards, docs, scripts), so that each concern is independently navigable.

### 3.2 `staging` + `marts` only, no `intermediate`

**Decision:** Two layers — `models/staging/` (views) and `models/marts/` (tables) — no intermediate layer.

**Reference:** [dbt Labs — The marts layer](https://docs.getdbt.com/best-practices/how-we-structure/4-marts). Intermediate models exist to avoid duplication when multiple marts share complex logic. This pipeline has **one** mart — adding an intermediate layer would be premature abstraction.

### 3.3 `profiles.yml` lives at `~/.dbt/`, not in the repo

**Decision:** Only `dbt/profiles.yml.example` is in version control. The real `profiles.yml` is at `~/.dbt/profiles.yml` (gitignored).

**Reference:** [Twelve-Factor App III — Config](https://12factor.net/config) and [dbt Labs — About profiles](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml). Environment-specific config (credentials, project IDs, datasets) **must** be separated from code so the same code can run unchanged across dev, prod, and CI.

### 3.4 `.github/workflows/` lives at the repo root

**Decision:** CI workflows live at `.github/workflows/dbt_ci.yml`, not at `dbt/.github/workflows/`.

**Reference:** [GitHub Actions — About workflows](https://docs.github.com/en/actions/using-workflows/about-workflows). GitHub Actions discovers workflows **only** under the repo-root `.github/workflows/` directory. The previous location (inside `fiber_dbt/`) would have caused CI to silently never run — this was a real bug in the original layout.

### 3.5 Engineering folder names (lower-case, no spaces)

**Decision:** `docs/`, `sql/`, `dbt/`, `dashboards/` instead of `1 Capture/`, `2 Analyze/`, `3 Monitor/`.

**Reference:** [POSIX portable filename character set](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_278) plus [Cookiecutter Data Science conventions](https://drivendata.github.io/cookiecutter-data-science/). Spaces and capitalization in folder names create friction with the shell, with import paths, and with cross-platform tooling. Phase metadata is preserved in [`06_phase_mapping.md`](06_phase_mapping.md), not encoded in folder names.

### 3.6 `sql/` (legacy) kept alongside `dbt/` (production)

**Decision:** Legacy raw SQL (pre-dbt) is preserved as reference, not deleted.

**Reference:** [README-Driven Development — Tom Preston-Werner](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html). For a portfolio project, showing the progression "raw SQL → dbt project with tests" is a stronger signal than showing only the final state. The `sql/README.md` explains the relationship explicitly.

### 3.7 `data/samples/` separate from `data/raw/`

**Decision:** A small, sanitized sample lives in `data/samples/`; `data/raw/` is intentionally empty with a README pointing to BigQuery.

**Reference:** [Cookiecutter Data Science — Data is immutable](https://drivendata.github.io/cookiecutter-data-science/#data-is-immutable). Raw data should never be committed; only a small representative sample, for local exploration or onboarding.

### 3.8 `dashboards/` split by BI tool

**Decision:** Each BI tool gets its own subfolder (`tableau/`, `powerbi/`, `looker_studio/`).

**Reference:** Convention used by analytics portfolios on GitHub (e.g. [Tableau Public best practices](https://www.tableau.com/learn/articles/best-practices)). Reviewers can navigate to the BI tool they know without sifting through unrelated artifacts.

### 3.9 `Makefile` for one-command operations

**Decision:** A `Makefile` with `setup`, `run`, `test`, `build`, `debug`, etc.

**Reference:** [Sandi Metz — "Make a Makefile"](https://thoughtbot.com/blog/how-to-make-a-makefile) plus dbt Labs example projects. Reviewers cloning the repo can go from zero to a working environment with a single command, which is a strong signal of engineering maturity.

### 3.10 `.gitignore` blocks secrets & build artifacts

**Decision:** `.gitignore` actively blocks `profiles.yml`, `*.json` keys, `target/`, `dbt_packages/`, and OS noise.

**Reference:** [GitHub — gitignore best practices](https://github.com/github/gitignore) plus [OWASP — Secret Management](https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password). Defense-in-depth — even if someone accidentally `git add`s a secret, `.gitignore` blocks it.

---

## 4. References — Summary

| Principle                          | Source                                                  |
|------------------------------------|---------------------------------------------------------|
| dbt project structure              | dbt Labs *"How we structure our dbt projects"*          |
| dbt layered modeling               | dbt Labs *"The marts layer"*                            |
| Config-from-code separation        | Twelve-Factor App III — Config                          |
| CI workflows location              | GitHub Actions official docs                            |
| Data-project folder layout         | Cookiecutter Data Science                               |
| Immutable raw data                 | Cookiecutter Data Science                               |
| README-as-front-door               | README-Driven Development (Tom Preston-Werner)          |
| Filename conventions               | POSIX portable filename character set                   |
| Secret hygiene                     | OWASP Secret Management                                 |
| One-command developer ergonomics   | GNU Make conventions                                    |
