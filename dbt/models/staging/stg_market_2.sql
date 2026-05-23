-- models/staging/stg_market_2.sql
-- Contact-count columns: COALESCE(SAFE_CAST(...), 0) because a "null"
-- value means "no contact" = 0. See stg_market_1.sql for the full rationale.

WITH source AS (
    SELECT * FROM {{ source('fiber', 'market_2') }}
),

cleaned AS (
    SELECT
        SAFE_CAST(date_created AS DATE)               AS date_created,
        COALESCE(SAFE_CAST(contacts_n   AS INT64), 0) AS contacts_n,
        COALESCE(SAFE_CAST(contacts_n_1 AS INT64), 0) AS contacts_n_1,
        COALESCE(SAFE_CAST(contacts_n_2 AS INT64), 0) AS contacts_n_2,
        COALESCE(SAFE_CAST(contacts_n_3 AS INT64), 0) AS contacts_n_3,
        COALESCE(SAFE_CAST(contacts_n_4 AS INT64), 0) AS contacts_n_4,
        COALESCE(SAFE_CAST(contacts_n_5 AS INT64), 0) AS contacts_n_5,
        COALESCE(SAFE_CAST(contacts_n_6 AS INT64), 0) AS contacts_n_6,
        COALESCE(SAFE_CAST(contacts_n_7 AS INT64), 0) AS contacts_n_7,
        TRIM(UPPER(new_type))                         AS new_type,
        TRIM(UPPER(new_market))                       AS new_market
    FROM source
)

SELECT * FROM cleaned
