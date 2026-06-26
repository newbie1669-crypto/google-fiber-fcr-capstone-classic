-- Union all market into a single csv for BI tools.
-- Some syntax are native to BigQuery SQL. Convert the syntax to your native SQL. 

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
