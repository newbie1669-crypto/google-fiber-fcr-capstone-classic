-- models/staging/stg_market_2.sql
WITH source AS (
    SELECT * FROM {{ source('fiber', 'market_2') }}
),

cleaned AS (
    SELECT
        CAST(date_created AS DATE)  AS date_created,
        CAST(contacts_n   AS INT64) AS contacts_n,
        CAST(contacts_n_1 AS INT64) AS contacts_n_1,
        CAST(contacts_n_2 AS INT64) AS contacts_n_2,
        CAST(contacts_n_3 AS INT64) AS contacts_n_3,
        CAST(contacts_n_4 AS INT64) AS contacts_n_4,
        CAST(contacts_n_5 AS INT64) AS contacts_n_5,
        CAST(contacts_n_6 AS INT64) AS contacts_n_6,
        CAST(contacts_n_7 AS INT64) AS contacts_n_7,
        TRIM(UPPER(new_type))       AS new_type,
        TRIM(UPPER(new_market))     AS new_market
    FROM source
)

SELECT * FROM cleaned
