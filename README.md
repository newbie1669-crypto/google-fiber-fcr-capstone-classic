# **Google Fiber - First Call Resolution (FCR)**

> **Capstone project for the [Google Business Intelligence Professional Certificate](https://www.coursera.org/professional-certificates/google-business-intelligence)**
>
> Analyzes Google Fiber's repeat caller data to build a dashboard on customer issue-reporting calls, enabling the customer service team to monitor operations and analyze problems on their own.

---

## **Note: Before going into this project**

This project is the original capstone, built as intended by the certificates (I consider it legacy for myself).

- You can view the modernized version at — [`This Link`]('') — the differences include:
  
  - A real `data pipeline` (the original capstone project has no exact pipeline at all) built with **`dbt` (data build tool)**, connecting everything from the source on `BigQuery` all the way to the dashboard on the BI tool
  - Systematic, automated testing — no more manually running queries to check things like this
  - A docs site and clear lineage visualization
  - CI/CD via GitHub Actions, allow team collaboration and pretty scalable
- The [`dbt version`]('') is far better than this one, but it requires some background knowledge to understand

---

## **Background**

![ling](docs/images/phone.png)

**Google Fiber** operates a fiber optic internet service business. In this type of business, customers periodically report issues through phone calls, either to report problems or ask for guidance.

**Google Fiber's customer service team** wants to reduce repeat calls and improve first-contact resolution. To achieve this, they first need to understand the repeat call rate and identify the most common issues customers call about — so they can address problems proactively, prepare for on-the-spot troubleshooting, and improve Google Fiber's overall service quality.

### **Business question:**

> **"How often are customers repeatedly contacting customer service after their first call — and what problem types or markets drive that behavior?"**

### **Stakeholders:**

| Name | Role |
| --- | --- |
| Emma Santiago | `Hiring Manager` |
| Keith Portone | `Project Manager` |
| Minna Rah | `Lead BI Analyst` |

### **Key Metric:**

> **FCR (First Call Resolution)** -  a customer service metric that measures the **percentage of customer issues resolved during the first contact, without needing a follow-up or repeat call**.

---

## **How I Did It (Simplified)**

- Wrote BI documents to communicate and define project scope and key metics with stakeholders (`stakeholder_requirements`, `project_requirements`, `strategy_document`)
- Drafted a low-fidelity dashboard — see `Mock-up`
- Loaded CSV files market_1–3 → uploaded to BigQuery
- SQL query (UNION ALL & DQ check) → wrote `ROCCC docs` → loaded the results locally as a CSV
- Imported the CSV into a dashboard tool (Tableau / Power BI / Data Studio) → calculated the project's metric (FCR) → built the dashboard

---

## **Results**

- Stakeholder documents include:

    | File | Detail |
    | --- | --- |
    | `01_stakeholder_requirements.docx` | Stakeholder requirements |
    | `02_project_requirements.docx` | Project-level requirements |
    | `03_strategy_document.docx` | Analysis and presentation strategy |
    | `04_roccc_data_assessment.docx` | Data quality assessment based on ROCCC criteria |

    `.md` versions are provided for easy viewing on GitHub, but the original files are `.docx` - See [`Project Documents`](docs/) for details

- Produced dashboards on 3 platforms
- Summary deck for stakeholder with a few recommendations — [`Coming soon`]('')

---

## **Dashboards**

All 3 dashboards use **the same dataset** - See [dashboards/](dashboards/) - if you don't want to open dashboard, I have screenshots of every dashboard as well.

| BI Tool | Format | Note |
| --- | --- | --- |
| **Tableau** | `.twbx` | The original requirements, opens with Tableau |
| **Power BI** | `.pbix` | Opens with Power BI |
| **Data Studio** | URL (public link) | Opens directly in a browser — see the README in `data_studio_version/` |

**Mockups** in [dashboards/mockups/](dashboards/mockups/) are low-fidelity mockups made during the planning phase to align with stakeholders before building the actual dashboard. The final shape may differ.

### **Questions the Dashboard Can Answer**

- Which market has the highest rate of repeat callers ?
- Which problem type (new_type) causes the most repeat calls from customers ?
- What is the FCR rate for each market and each problem type ?

---

## **Data**

### Schema of Raw Files and Mart Table ( literally the same)

| Column | Description |
| --- | --- |
| `date_created` | Date the first call was received |
| `contacts_n` | Number of initial contacts on that day |
| `contacts_n_1` … `contacts_n_7` | Number of repeat contacts occurring 1–7 days after the first call |
| `new_type` | Problem type (type_1 – type_5) |
| `new_market` | Market/service area (market_1 – market_3) |

**Data time period:** Q1 2022 (January – March 2022)

### **Data Pipeline (not really but it shows how data flow)**

```plain text
Raw CSVs (market_1–3)
    └── 01_data_union.sql (BigQuery UNION ALL + COALESCE null to 0)
            └── google_fiber_case.csv (Mart Table)
                    └── Dashboard (Tableau / Power BI / Data Studio)
```

Note: SQL is written in **BigQuery** dialect — if using a different SQL engine, adjust syntax such as `SAFE_CAST`, which is native to BigQuery.

See [**`sql/`**](sql) for SQL code.

---

## **Data Quality Checks (`02_data_quality_check.sql`)**

This file is divided into 7 sessions as follows:

| Session | What's Checked | Expected Result |
| --- | --- | --- |
| 1 | Row count by market | Every market has data (> 0 rows) |
| 2 | NULLs across all columns | No NULLs |
| 3 | Duplicate rows | No duplicates |
| 4 | Date range | Falls within Jan–Mar 2022 |
| 5 | Negative contacts | No negative values |
| 6 | Distinct values of new_type / new_market | Matches business rules |
| 7 | Summary report | Full overview in a single query |

---

## **Quick Start**

- **Open the dashboard** → load the file into whichever BI tool you prefer. No need to load the data separately, as it's already embedded in the file. For the Data Studio version, just open the link directly.
- **Build the mart from raw data yourself** → load the raw data, then run `sql/01_data_union.sql` on BigQuery (or whichever SQL engine you're using), and export the result as a `.csv`.
- **Check data quality** → run `sql/02_data_quality_check.sql` session by session. Comment out any sessions you don't want to run — each session ends wherever the `;` closes it (some SQL engines may be able to run everything at once).

---

## **Author and License**

**Author**: Pluemprach Dangdee - 2026

**License**: [`LICENSE`](https://app.notion.com/p/LICENSE)
