-- Data Quality Check
-- How To Use : Run each CHECK SESSION seperately.
-- Some syntax are native to BigQuery SQL. Convert the syntax to your native SQL. 


-- Base CTE query (Do not mute).
WITH combined_data AS (
  select
    date_created,
    coalesce(safe_cast(contacts_n AS int64), 0) AS contacts_n,
    coalesce(safe_cast(contacts_n_1 AS int64), 0) AS contacts_n_1,
    coalesce(safe_cast(contacts_n_2 AS int64), 0) AS contacts_n_2,
    coalesce(safe_cast(contacts_n_3 AS int64), 0) AS contacts_n_3,
    coalesce(safe_cast(contacts_n_4 AS int64), 0) AS contacts_n_4,
    coalesce(safe_cast(contacts_n_5 AS int64), 0) AS contacts_n_5,
    coalesce(safe_cast(contacts_n_6 AS int64), 0) AS contacts_n_6,
    coalesce(safe_cast(contacts_n_7 AS int64), 0) AS contacts_n_7,
    new_type,
    new_market
  from
    `data/raw/market_1.csv` -- adjust to your path.
  union all
  select
    date_created,
    coalesce(safe_cast(contacts_n AS int64), 0) AS contacts_n,
    coalesce(safe_cast(contacts_n_1 AS int64), 0) AS contacts_n_1,
    coalesce(safe_cast(contacts_n_2 AS int64), 0) AS contacts_n_2,
    coalesce(safe_cast(contacts_n_3 AS int64), 0) AS contacts_n_3,
    coalesce(safe_cast(contacts_n_4 AS int64), 0) AS contacts_n_4,
    coalesce(safe_cast(contacts_n_5 AS int64), 0) AS contacts_n_5,
    coalesce(safe_cast(contacts_n_6 AS int64), 0) AS contacts_n_6,
    coalesce(safe_cast(contacts_n_7 AS int64), 0) AS contacts_n_7,
    new_type,
    new_market
  from
    `data/raw/market_2.csv`
  union all
  select
    date_created,
    coalesce(safe_cast(contacts_n AS int64), 0) AS contacts_n,
    coalesce(safe_cast(contacts_n_1 AS int64), 0) AS contacts_n_1,
    coalesce(safe_cast(contacts_n_2 AS int64), 0) AS contacts_n_2,
    coalesce(safe_cast(contacts_n_3 AS int64), 0) AS contacts_n_3,
    coalesce(safe_cast(contacts_n_4 AS int64), 0) AS contacts_n_4,
    coalesce(safe_cast(contacts_n_5 AS int64), 0) AS contacts_n_5,
    coalesce(safe_cast(contacts_n_6 AS int64), 0) AS contacts_n_6,
    coalesce(safe_cast(contacts_n_7 AS int64), 0) AS contacts_n_7,
    new_type,
    new_market
  from
    `data/raw/market_3.csv`
)


-- CHECK SESSION 1: Record by Market
-- Expected result : Every market contain data (> 0 rows).

SELECT
  new_market,
  COUNT(*)  AS total_rows
FROM combined_data
GROUP BY new_market
ORDER BY new_market;


-- CHECK SESSION 2: NULL in Every Column
-- Expected result : No Null

SELECT
  COUNTIF(date_created IS NULL) AS null_date_created,
  COUNTIF(contacts_n IS NULL) AS null_contacts_n,
  COUNTIF(contacts_n_1 IS NULL) AS null_contacts_n_1,
  COUNTIF(contacts_n_2 IS NULL) AS null_contacts_n_2,
  COUNTIF(contacts_n_3 IS NULL) AS null_contacts_n_3,
  COUNTIF(contacts_n_4 IS NULL) AS null_contacts_n_4,
  COUNTIF(contacts_n_5 IS NULL) AS null_contacts_n_5,
  COUNTIF(contacts_n_6 IS NULL) AS null_contacts_n_6,
  COUNTIF(contacts_n_7 IS NULL) AS null_contacts_n_7,
  COUNTIF(new_type IS NULL) AS null_new_type,
  COUNTIF(new_market IS NULL) AS null_new_market
FROM combined_data;


-- CHECK SESSION 3: Duplicate Rows Check
-- Expected result : No count > 1

SELECT
  date_created,
  new_type,
  new_market,
  COUNT(*) AS duplicate_count
FROM combined_data
GROUP BY
  date_created,
  new_type,
  new_market
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- CHECK SESSION 4: Date Range Check
-- Expected result : Date range must be in the right range (Jan - March 2022).

SELECT
  MIN(date_created) AS earliest_date,
  MAX(date_created) AS latest_date,
  COUNT(DISTINCT date_created) AS distinct_dates
FROM combined_data;


-- CHECK SESSION 5: Check for Negative Contact
-- Expected result : No negative contact.

SELECT
  COUNTIF(contacts_n < 0) AS neg_contacts_n,
  COUNTIF(contacts_n_1 < 0) AS neg_contacts_n_1,
  COUNTIF(contacts_n_2 < 0) AS neg_contacts_n_2,
  COUNTIF(contacts_n_3 < 0) AS neg_contacts_n_3,
  COUNTIF(contacts_n_4 < 0) AS neg_contacts_n_4,
  COUNTIF(contacts_n_5 < 0) AS neg_contacts_n_5,
  COUNTIF(contacts_n_6 < 0) AS neg_contacts_n_6,
  COUNTIF(contacts_n_7 < 0) AS neg_contacts_n_7
FROM combined_data;


-- CHECK SESSION 6: Check Distinct Value of new_type and new_market
-- Expected result : Values must match the business rules.

-- 6a: Values in new_type
SELECT
  new_type,
  COUNT(*) AS record_count
FROM combined_data
GROUP BY new_type
ORDER BY record_count DESC;

-- 6b: Values in new_market
SELECT
  new_market,
  COUNT(*) AS record_count
FROM combined_data
GROUP BY new_market
ORDER BY new_market;


-- CHECK SESSION 7 (optional) : Summary Report
-- For overall check in one query

SELECT
  -- Row counts
  COUNT(*) AS total_rows,

  -- NULL checks
  COUNTIF(date_created IS NULL) AS null_date_created,
  COUNTIF(new_type IS NULL) AS null_new_type,
  COUNTIF(new_market IS NULL) AS null_new_market,
  COUNTIF(contacts_n IS NULL) AS null_contacts_n,

  -- Negative value checks
  COUNTIF(contacts_n < 0) AS neg_contacts_n,
  COUNTIF(contacts_n_1 < 0) AS neg_contacts_n_1,

  -- Date range
  MIN(date_created) AS min_date,
  MAX(date_created) AS max_date,

  -- Distinct counts
  COUNT(DISTINCT new_type) AS distinct_types,
  COUNT(DISTINCT new_market) AS distinct_markets

FROM combined_data;


-- ================================================================
-- SUMMARY
-- Just use DBT your life would be a lot easier lol.
-- ================================================================