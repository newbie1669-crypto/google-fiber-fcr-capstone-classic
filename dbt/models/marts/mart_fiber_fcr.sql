-- models/marts/mart_fiber_fcr.sql
-- Final mart: รวมทุก market + คำนวณ FCR metrics พร้อม connect Tableau

WITH combined AS (
    SELECT * FROM {{ ref('stg_market_1') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_market_2') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_market_3') }}
),

with_metrics AS (
    SELECT
        date_created,
        new_type,
        new_market,

        -- Raw contact counts
        contacts_n,
        contacts_n_1,
        contacts_n_2,
        contacts_n_3,
        contacts_n_4,
        contacts_n_5,
        contacts_n_6,
        contacts_n_7,

        -- Total repeat contacts (day 1-7)
        (contacts_n_1 + contacts_n_2 + contacts_n_3 +
         contacts_n_4 + contacts_n_5 + contacts_n_6 + contacts_n_7) AS total_repeat_contacts,

        -- FCR Rate: % ของ first contacts ที่ไม่มี follow-up วันถัดไป
        SAFE_DIVIDE(
            contacts_n - contacts_n_1,
            contacts_n
        ) AS fcr_day1_rate,

        -- 7-day FCR Rate: ไม่มี repeat ใน 7 วัน
        SAFE_DIVIDE(
            contacts_n - (contacts_n_1 + contacts_n_2 + contacts_n_3 +
                          contacts_n_4 + contacts_n_5 + contacts_n_6 + contacts_n_7),
            contacts_n
        ) AS fcr_7day_rate,

        -- Repeat rate per day (สำหรับ trend chart ใน Tableau)
        SAFE_DIVIDE(contacts_n_1, contacts_n) AS repeat_rate_day1,
        SAFE_DIVIDE(contacts_n_2, contacts_n) AS repeat_rate_day2,
        SAFE_DIVIDE(contacts_n_3, contacts_n) AS repeat_rate_day3,
        SAFE_DIVIDE(contacts_n_4, contacts_n) AS repeat_rate_day4,
        SAFE_DIVIDE(contacts_n_5, contacts_n) AS repeat_rate_day5,
        SAFE_DIVIDE(contacts_n_6, contacts_n) AS repeat_rate_day6,
        SAFE_DIVIDE(contacts_n_7, contacts_n) AS repeat_rate_day7,

        -- Metadata
        CURRENT_TIMESTAMP() AS dbt_updated_at

    FROM combined
)

SELECT * FROM with_metrics
