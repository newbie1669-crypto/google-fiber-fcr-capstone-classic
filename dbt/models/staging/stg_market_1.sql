-- models/staging/stg_market_1.sql
-- Staging layer: clean + rename columns from the raw source.
--
-- SAFE_CAST (not CAST) is used so dirty values such as the literal string
-- "null" do not raise a hard error. For the contact-count columns a "null"
-- means "no contact", so SAFE_CAST is wrapped in COALESCE(..., 0) to turn
-- those into a real 0. date_created stays SAFE_CAST only (a bad date stays
-- NULL and is caught by the not_null test).

WITH source AS (
    SELECT * FROM {{ source('fiber', 'market_1') }}
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
