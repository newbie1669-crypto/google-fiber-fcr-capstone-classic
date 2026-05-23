-- models/marts/mart_fiber_fcr.sql
-- Final mart: รวมทุก market + คำนวณ FCR metrics พร้อม connect Tableau

WITH combined AS (
    SELECT * FROM {{ ref('stg_market_1') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_market_2') }}
    UNION ALL
    SELECT * FROM {{ ref('stg_market_3') }}
),

-- DATA-QUALITY GATE: drop rows that cannot produce a FCR value.
-- In staging, a raw "null" in contacts_n is COALESCE'd to 0. For the
-- follow-up columns 0 = "no follow-up" (correct), but for contacts_n
-- (first contacts = the FCR denominator) a 0 means the first-contact
-- count is missing/unknown, NOT "zero contacts" — some of those rows
-- even have follow-up contacts, which is impossible with 0 originals.
-- SAFE_DIVIDE by a 0 denominator returns NULL, so FCR "was not
-- calculated" for those rows. They are excluded here.
valid AS (
    SELECT * FROM combined
    WHERE contacts_n > 0
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
        -- GREATEST(..., 0): repeat contacts สามารถ "มากกว่า" first contacts ได้
        -- (1 เคสโทรซ้ำหลายครั้ง) ทำให้ numerator ติดลบ → rate < 0.
        -- จำนวน contact ที่ "ปิดจบในครั้งเดียว" ติดลบไม่ได้ จึง floor ไว้ที่ 0
        -- (ถ้า repeat ล้น first contacts ในวันนั้น FCR = 0%).
        SAFE_DIVIDE(
            GREATEST(contacts_n - contacts_n_1, 0),
            contacts_n
        ) AS fcr_day1_rate,

        -- 7-day FCR Rate: ไม่มี repeat ใน 7 วัน (floor ที่ 0 ด้วยเหตุผลเดียวกัน)
        SAFE_DIVIDE(
            GREATEST(
                contacts_n - (contacts_n_1 + contacts_n_2 + contacts_n_3 +
                              contacts_n_4 + contacts_n_5 + contacts_n_6 + contacts_n_7),
                0
            ),
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

    FROM valid
)

SELECT * FROM with_metrics
