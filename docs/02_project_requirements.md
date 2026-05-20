# Project Requirements Document — Google Fiber

> **Source:** `02_project_requirements.docx` (original)
> **Phase:** Capture
> **BI Analyst:** Pluemprach Dangdee
> **Client/Sponsor:** Emma Santiago, Hiring Manager

---

## Purpose

As part of the interview process, the Fiber customer service team has asked for a dashboard using fictional call-center data based on the data they use regularly on the job, to gain insights about repeat callers. The team's ultimate goal is to **communicate with customers to reduce call volume, increase customer satisfaction, and improve operational optimization**. The dashboard must demonstrate an understanding of this goal and provide stakeholders with insights about repeat caller volumes in different markets and the types of problems they represent.

## Key Dependencies

The datasets are fictionalized versions of the actual data this team works with. Because of this, the data is already anonymized and approved. However, stakeholders must have data access to all datasets so they can explore the steps taken. The primary contacts are Emma Santiago and Keith Portone.

---

## Stakeholder Requirements (Prioritized)

Priority key — **R** = Required, **D** = Desired, **N** = Nice to have.

In order to continuously improve customer satisfaction, the dashboard must help Google Fiber decision-makers understand how often customers are having to repeatedly call and what problem types or other factors might be influencing those calls.

| # | Requirement                                                                   | Priority |
|---|-------------------------------------------------------------------------------|----------|
| 1 | A chart or table measuring repeat calls by their first-contact date           | R        |
| 2 | A chart or table exploring repeat calls by market and problem type            | R        |
| 3 | Charts showcasing repeat calls by week, month, and quarter                    | D        |
| 4 | Insights into the types of customer issues that generate more repeat calls    | D        |
| 5 | Explore repeat-caller trends in the three different market cities             | R        |
| 6 | Design charts so stakeholders can view trends by week, month, quarter, year   | R        |

---

## Success Criteria (SMART)

- **Specific:** BI insights must clearly identify the specific characteristics of repeat calls, including how often customers are repeating calls.
- **Measurable:** Calls should be evaluated using measurable metrics, including frequency and volume. For example: do customers call with a specific problem more often than others? Which market city experiences the most calls? How many customers are calling more than once?
- **Action-oriented:** These outcomes must quantify the number of repeat callers under different circumstances to provide the Google Fiber team with insights into customer satisfaction.
- **Relevant:** All metrics must support the primary question: *How often are customers repeatedly contacting the customer service team?*
- **Time-bound:** Analyze data that spans at least one year to understand how repeat callers change over time. Exploring data that spans multiple months will capture peaks and valleys in usage.

## User Journeys

Stakeholders will use the dashboard to filter repeat-call data by **market city**, **problem type**, and **time period (week, month, quarter, year)**. This will allow the Google Fiber team to identify which markets and problem types generate the highest volume of repeat calls, enabling them to prioritize customer outreach and allocate resources more effectively to reduce call volume and improve customer satisfaction.

## Data Sources

The primary dataset is a fictionalized version of Google Fiber's actual call-center data, provided in `.csv` format. The dataset covers three city service areas, recorded as `market_1`, `market_2`, and `market_3`. It includes repeat-call records spanning at least one year, tracking customer contacts over seven-day periods from the initial contact date. The data has been pre-approved for use and requires no additional anonymization.

## Assumptions

The dataset uses anonymized labels:

**Markets** — `market_1`, `market_2`, `market_3` represent three different city service areas.

**Problem types:**

| Code   | Meaning                  |
|--------|--------------------------|
| Type_1 | Account management       |
| Type_2 | Technician troubleshooting|
| Type_3 | Scheduling               |
| Type_4 | Construction             |
| Type_5 | Internet and WiFi        |

**Repeat-call columns:** the initial contact date is listed as `contacts_n`. The other call columns are `contacts_n_<days since first call>` — for example, `contacts_n_6` indicates six days since first contact.

## Compliance and Privacy

The datasets are fictionalized versions of the actual data this team works with. The data is already anonymized and approved. However, stakeholders must have data access to all datasets so they can explore the steps you've taken.

## Accessibility

The dashboard will be delivered as a published Tableau dashboard, connected to the repeat-calls dataset. The dashboard should offer text alternatives including large print and text-to-speech compatibility to ensure accessibility for all stakeholders. All charts and tables should include descriptive titles and labels to support screen reader tools.

## Roll-out Plan

Stakeholders have requested a completed BI tool within **2 weeks**, following the milestones below:

- **Week 1** — Data preparation, exploration, and initial dashboard draft.
- **Week 2** — Stakeholder review, revisions, and final delivery.
