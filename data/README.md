# Data

This folder holds reference data — **not the production source**. The real raw tables live in my BigQuery.

```
data/
├── raw/                # intentionally empty — see below
└── samples/            # small sanitized CSV for local previews
```

## `raw/`

**Empty by design.** Raw data lives in BigQuery (`gbi-test.fiber.market_{1,2,3}`) and should never be committed to the repo. This follows the *"data is immutable"* principle from Cookiecutter Data Science.

## `samples/`

Contains a small CSV exported from the mart for use in previews.
