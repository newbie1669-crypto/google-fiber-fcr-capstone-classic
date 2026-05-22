# ROCCC Data Credibility Assessment

> **Source:** `04_roccc_data_assessment.docx` (original)
> **Project:** Google Fiber — Customer Service Repeat Contact Analysis
> **Context:** Google Business Intelligence Certificate — Capstone Project, 2025–2026

---

## 1. Project Overview

This project is part of the **Google Business Intelligence Certificate Capstone — Case Study 2 (Google Fiber)**. Its objective is to analyze repeat-contact behavior of customers after their initial contact with Customer Service.

**Primary business question:** How often must customers contact Customer Service again after their first contact, and what patterns indicate unresolved problems?

## 2. About the Dataset

| Attribute            | Value                                                                                          |
|----------------------|------------------------------------------------------------------------------------------------|
| **Source**           | Google Business Intelligence Certificate — Capstone Case Study 2                               |
| **Platform**         | Google BigQuery                                                                                |
| **Project / Dataset**| `gbi-test.fiber`                                                                               |
| **Tables**           | `market_1`, `market_2`, `market_3`                                                             |
| **Columns**          | 11 columns (`date_created`, `contacts_n` … `contacts_n_7`, `new_type`, `new_market`)          |
| **Nature**           | First-party data from Google Fiber's CRM / Customer Service system                             |
| **Purpose**          | Repeat Contact analysis                                                                        |

---

## 3. ROCCC Evaluation

ROCCC is a 5-pillar framework for data credibility: **Reliable, Original, Comprehensive, Current, Cited.**

### R — Reliable ✓

- Collected directly by Google Fiber from its Customer Contact Tracking System (a system in real operational use), giving it strong first-party credibility.
- All three markets share a single, consistent schema, allowing clean UNION operations.
- Should be cross-verified with record-level Data Quality Check (see `sql/02_data_quality_check.sql` and `dbt test`).
- *Caveat:* Educational dataset — may include adjustments for learning purposes.

### O — Original ✓

- This is **original first-party data** collected directly from customer interactions, not aggregated or transformed by a third party.
- Captured by Google Fiber's internal CRM / ticketing system.
- Not purchased from a data broker or external source.
- Each row represents a real customer event (contact date, type, market).
- Market-level partitioning makes it traceable back to source.

### C — Comprehensive ✓

The dataset covers the key dimensions required for repeat-contact analysis:
- **Time** — `date_created`
- **Behavior** — `contacts_n` through `contacts_n_7` (8 day-lag columns)
- **Type** — `new_type` (5 problem categories)
- **Geography** — `new_market` (3 markets)

*Limitations:* no customer ID (can't track individuals), no channel (phone / email / chat unknown).

### C — Current ✓

- Prepared by Google/Coursera for the Capstone project; the true date range is verified via CHECK 4 in `sql/02_data_quality_check.sql`.
- For a Capstone, currency is less critical than for a live business project.
- *Limitation:* the dataset is static and not refreshed in real time.

### C — Cited ✓

- Source clearly traceable to Google Business Intelligence Certificate — Case Study 2 (Google Fiber).
- Platform: Google BigQuery, project `gbi-test`, dataset `fiber`.
- Publisher: Google / Coursera (for educational use).
- As first-party data, no external citation is needed.
- *Recommendation:* record an **access date** for auditability.

---

## 4. ROCCC Summary

| Criterion                          | Assessment                                                | Status |
|------------------------------------|-----------------------------------------------------------|--------|
| **R**eliable — credibility         | First-party data, direct from Google Fiber                | ✓ Pass |
| **O**riginal — provenance          | Collected by internal CRM, not third-party                | ✓ Pass |
| **C**omprehensive — coverage       | Covers 3 markets, 8 contact day-lag columns               | ✓ Pass |
| **C**urrent — recency              | Latest available for the Capstone                         | ✓ Pass |
| **C**ited — sourcing               | Clearly attributed (BigQuery / Coursera)                  | ✓ Pass |

**Verdict:** The dataset passes all five ROCCC criteria and has sufficient quality for Repeat-Contact analysis in the Google Fiber Capstone. That said, a record-level Data Quality Check (see `sql/02_data_quality_check.sql` or `dbt test`) should still be run before downstream analysis.

---

## 5. Limitations

Even with ROCCC passing, these limitations should be acknowledged in any analysis:

- **No Customer ID** — cannot track individual customers' behavior.
- **No Channel data** — unknown whether contact was phone / email / chat.
- **Static dataset** — not refreshed in real time; suitable only for retrospective analysis.
- **Fictional data** — for educational use; results may not generalize to live operations.
- **No Resolution data** — unknown whether the customer's issue was actually resolved.

---

## 6. Next Steps

After ROCCC assessment, the next steps in this Capstone are:

1. Run `sql/02_data_quality_check.sql` (or `make test`) to verify quality at the record level.
2. Resolve any DQ issues surfaced (NULLs, duplicates, etc.).
3. Build the combined view (`mart_fiber_fcr`) for downstream analysis.
4. Analyze repeat-contact rate by market, type, and period.
5. Build dashboards (Tableau / Power BI / Looker Studio) to present findings.
