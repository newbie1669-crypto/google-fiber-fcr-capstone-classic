# Google Fiber FCR — dbt Project

Pipeline: **BigQuery (raw)** → **dbt staging** → **dbt mart** → **Tableau / Power BI / Looker Studio**

> CI workflow (`dbt_ci.yml`) lives at the **repo root** under `.github/workflows/`, not inside this folder — GitHub Actions only discovers workflows at the root.

---

## Project layout

```
dbt/
├── dbt_project.yml              # Project config
├── profiles.yml.example         # Template — copy to ~/.dbt/profiles.yml
├── packages.yml                 # dbt dependencies (dbt-utils, dbt-expectations)
├── models/
│   ├── staging/
│   │   ├── _sources.yml         # Declares raw tables in BigQuery
│   │   ├── _schema.yml          # DQ tests for staging
│   │   ├── stg_market_1.sql     # Clean + cast types
│   │   ├── stg_market_2.sql
│   │   └── stg_market_3.sql
│   └── marts/
│       ├── _schema.yml          # DQ tests covering CHECK 1-7
│       └── mart_fiber_fcr.sql   # UNION 3 markets + FCR metrics
├── macros/
│   └── generate_dq_summary.sql  # Macro for DQ summary report
└── analyses/
    └── dq_summary_report.sql    # Ad-hoc DQ summary (compile-only)
```

---

## 1. Setup ครั้งแรก (ทำครั้งเดียว)

### ติดตั้ง dbt

```bash
pip install dbt-bigquery
```

### Copy profiles.yml.example to ~/.dbt/profiles.yml

```bash
mkdir -p ~/.dbt
cp dbt/profiles.yml.example ~/.dbt/profiles.yml
```

> ⚠️ The real `profiles.yml` is **gitignored** — it lives only at `~/.dbt/profiles.yml`, never in the repo. Only the `.example` template is versioned.

### Edit ~/.dbt/profiles.yml

Replace the placeholders:

```yaml
project: your-gcp-project-id   # ← your real GCP Project ID (e.g. gbi-test)
```

For the `prod` target, also point `keyfile` to your service-account JSON.

### Login GCP (สำหรับ dev)

```bash
gcloud auth application-default login
```

### Install dbt packages

```bash
cd dbt
dbt deps
```

### ตรวจสอบ connection

```bash
dbt debug
```

ผลที่คาดหวัง: `All checks passed!`

---

## 2. การรันประจำวัน

### รัน models ทั้งหมด (staging + marts)

```bash
dbt run
```

### รัน DQ tests ทั้งหมด

```bash
dbt test
```

ถ้า test ผ่าน:
```
Completed successfully
Done. PASS=12 WARN=0 ERROR=0 SKIP=0 TOTAL=12
```

ถ้า test ไม่ผ่าน:
```
Failure in test not_null_mart_fiber_fcr_date_created (...)
  Got 5 results, configured to fail if != 0
```

### รันทั้งคู่ในคำสั่งเดียว

```bash
dbt build   # = dbt run + dbt test รวมกัน
```

---

## 3. คำสั่งที่ใช้บ่อย

| คำสั่ง | ความหมาย |
|--------|-----------|
| `dbt run` | รัน models ทั้งหมด |
| `dbt test` | รัน DQ tests ทั้งหมด |
| `dbt build` | run + test รวม |
| `dbt run -s stg_market_1` | รันเฉพาะ model นี้ |
| `dbt test -s mart_fiber_fcr` | test เฉพาะ mart |
| `dbt run --target prod` | รันบน production dataset |
| `dbt docs generate` | สร้าง documentation site |
| `dbt docs serve` | เปิด docs ที่ localhost:8080 |
| `dbt compile --select dq_summary_report` | compile DQ summary SQL |

---

## 4. ดู DQ Summary Report (ad-hoc)

```bash
dbt compile --select dq_summary_report
```

แล้ว copy SQL จาก `target/compiled/.../dq_summary_report.sql` ไปรันใน BigQuery Console

---

## 5. Connect a BI tool

Per-tool setup guides live in `dashboards/tableau/`, `dashboards/powerbi/`, and `dashboards/looker_studio/`. All three connect to the same table:

1. Connect → **Google BigQuery**
2. Project: `your-gcp-project-id`
3. Dataset: `dbt_prod` (or `dbt_dev` for development)
4. Table: `mart_fiber_fcr`

Columns ready to use in any BI tool:

| Column | ใช้ทำ |
|--------|-------|
| `fcr_day1_rate` | KPI card FCR หลัก |
| `fcr_7day_rate` | KPI card 7-day FCR |
| `repeat_rate_day1..7` | Line chart แสดง decay curve |
| `new_market` | Filter / breakdown |
| `new_type` | Filter / breakdown |
| `date_created` | Time series axis |

---

## 6. GitHub Actions (CI/CD)

On every push or PR to `main`, GitHub Actions runs `.github/workflows/dbt_ci.yml` (located at the **repo root**, not inside this folder):

1. Installs `dbt-bigquery`
2. Authenticates to GCP using the `GCP_SA_KEY` secret
3. Runs `dbt run --target prod`
4. Runs `dbt test --target prod` — any failure blocks the merge

### Set the GCP secret

1. GitHub repo → **Settings → Secrets and variables → Actions**
2. **New repository secret** → name it `GCP_SA_KEY`
3. Paste the **entire content** of your service-account JSON key

---

## 7. DQ Tests ที่ครอบคลุม (map จาก CHECK เดิม)

| CHECK เดิม | dbt test ที่ใช้ |
|-----------|----------------|
| CHECK 1: rows by market | `dbt run` + ดูใน BigQuery |
| CHECK 2: NULL checks | `not_null` ทุก column |
| CHECK 3: duplicates | `unique_combination_of_columns` |
| CHECK 4: date range | `dbt_expectations.expect_column_values_to_be_between` |
| CHECK 5: negatives | `expression_is_true: ">= 0"` |
| CHECK 6: accepted values | `accepted_values` |
| CHECK 7: summary | `analyses/dq_summary_report.sql` |
