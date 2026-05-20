-- macros/generate_dq_summary.sql
-- Macro สำหรับ generate DQ summary report ใช้ใน analyses/

{% macro generate_dq_summary(model_name) %}

WITH base AS (
    SELECT * FROM {{ ref(model_name) }}
)

SELECT
    -- ── Row count ──────────────────────────────────────
    COUNT(*)                                    AS total_rows,

    -- ── NULL checks ────────────────────────────────────
    COUNTIF(date_created IS NULL)               AS null_date_created,
    COUNTIF(new_type IS NULL)                   AS null_new_type,
    COUNTIF(new_market IS NULL)                 AS null_new_market,
    COUNTIF(contacts_n IS NULL)                 AS null_contacts_n,

    -- ── Negative checks ────────────────────────────────
    COUNTIF(contacts_n < 0)                     AS neg_contacts_n,
    COUNTIF(contacts_n_1 < 0)                   AS neg_contacts_n_1,
    COUNTIF(contacts_n_2 < 0)                   AS neg_contacts_n_2,
    COUNTIF(contacts_n_3 < 0)                   AS neg_contacts_n_3,
    COUNTIF(contacts_n_4 < 0)                   AS neg_contacts_n_4,
    COUNTIF(contacts_n_5 < 0)                   AS neg_contacts_n_5,
    COUNTIF(contacts_n_6 < 0)                   AS neg_contacts_n_6,
    COUNTIF(contacts_n_7 < 0)                   AS neg_contacts_n_7,

    -- ── Date range ─────────────────────────────────────
    MIN(date_created)                           AS min_date,
    MAX(date_created)                           AS max_date,
    COUNT(DISTINCT date_created)                AS distinct_dates,

    -- ── Cardinality ────────────────────────────────────
    COUNT(DISTINCT new_type)                    AS distinct_types,
    COUNT(DISTINCT new_market)                  AS distinct_markets,

    -- ── Future date check ──────────────────────────────
    COUNTIF(date_created > CURRENT_DATE())      AS future_dates,

    -- ── Metadata ───────────────────────────────────────
    CURRENT_TIMESTAMP()                         AS report_generated_at

FROM base

{% endmacro %}
