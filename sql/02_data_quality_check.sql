-- ============================================================
-- Google Fiber Capstone Project
-- File: 02 Google Fiber Query -- Data Quality Check
-- Purpose: ตรวจสอบคุณภาพข้อมูลหลังจาก Union ทั้ง 3 markets
-- ============================================================
-- วิธีใช้: รันแต่ละ Section แยกกัน เพื่อตรวจสอบผลลัพธ์ทีละขั้น
-- ============================================================


-- ============================================================
-- BASE CTE: รวมข้อมูลจาก 3 markets (อ้างอิงจาก 01)
-- ============================================================
WITH combined_data AS (
  SELECT
    date_created,
    contacts_n,
    contacts_n_1,
    contacts_n_2,
    contacts_n_3,
    contacts_n_4,
    contacts_n_5,
    contacts_n_6,
    contacts_n_7,
    new_type,
    new_market
  FROM `gbi-test.fiber.market_1`

  UNION ALL

  SELECT
    date_created,
    contacts_n,
    contacts_n_1,
    contacts_n_2,
    contacts_n_3,
    contacts_n_4,
    contacts_n_5,
    contacts_n_6,
    contacts_n_7,
    new_type,
    new_market
  FROM `gbi-test.fiber.market_2`

  UNION ALL

  SELECT
    date_created,
    contacts_n,
    contacts_n_1,
    contacts_n_2,
    contacts_n_3,
    contacts_n_4,
    contacts_n_5,
    contacts_n_6,
    contacts_n_7,
    new_type,
    new_market
  FROM `gbi-test.fiber.market_3`
)


-- ============================================================
-- CHECK 1: จำนวน Record ทั้งหมด และแยกตาม Market
-- ผลลัพธ์ที่คาดหวัง: ทุก market ต้องมีข้อมูล (> 0 rows)
-- ============================================================
SELECT
  new_market,
  COUNT(*)                        AS total_rows
FROM combined_data
GROUP BY new_market
ORDER BY new_market;


-- ============================================================
-- CHECK 2: ตรวจหาค่า NULL ในทุก Column
-- ผลลัพธ์ที่คาดหวัง: ค่าทุกช่อง = 0 (ไม่มี NULL)
-- ============================================================

SELECT
  COUNTIF(date_created IS NULL)  AS null_date_created,
  COUNTIF(contacts_n    IS NULL) AS null_contacts_n,
  COUNTIF(contacts_n_1  IS NULL) AS null_contacts_n_1,
  COUNTIF(contacts_n_2  IS NULL) AS null_contacts_n_2,
  COUNTIF(contacts_n_3  IS NULL) AS null_contacts_n_3,
  COUNTIF(contacts_n_4  IS NULL) AS null_contacts_n_4,
  COUNTIF(contacts_n_5  IS NULL) AS null_contacts_n_5,
  COUNTIF(contacts_n_6  IS NULL) AS null_contacts_n_6,
  COUNTIF(contacts_n_7  IS NULL) AS null_contacts_n_7,
  COUNTIF(new_type      IS NULL) AS null_new_type,
  COUNTIF(new_market    IS NULL) AS null_new_market
FROM combined_data;



-- ============================================================
-- CHECK 3: ตรวจหา Duplicate Rows
-- ผลลัพธ์ที่คาดหวัง: ไม่มีแถวใดที่ count > 1
-- ถ้ามีผลลัพธ์ออกมา = พบ duplicate ต้องกลับไปตรวจ source data
-- ============================================================

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



-- ============================================================
-- CHECK 4: ตรวจสอบช่วงวันที่ (Date Range)
-- ผลลัพธ์ที่คาดหวัง: วันที่อยู่ในช่วงที่สมเหตุสมผล
-- ============================================================

SELECT
  MIN(date_created) AS earliest_date,
  MAX(date_created) AS latest_date,
  COUNT(DISTINCT date_created) AS distinct_dates
FROM combined_data;


-- ============================================================
-- CHECK 5: ตรวจหาค่าติดลบในคอลัมน์ contacts
-- ผลลัพธ์ที่คาดหวัง: จำนวน contacts ต้องไม่ติดลบ (>= 0 ทุกช่อง)
-- ============================================================

SELECT
  COUNTIF(contacts_n   < 0) AS neg_contacts_n,
  COUNTIF(contacts_n_1 < 0) AS neg_contacts_n_1,
  COUNTIF(contacts_n_2 < 0) AS neg_contacts_n_2,
  COUNTIF(contacts_n_3 < 0) AS neg_contacts_n_3,
  COUNTIF(contacts_n_4 < 0) AS neg_contacts_n_4,
  COUNTIF(contacts_n_5 < 0) AS neg_contacts_n_5,
  COUNTIF(contacts_n_6 < 0) AS neg_contacts_n_6,
  COUNTIF(contacts_n_7 < 0) AS neg_contacts_n_7
FROM combined_data;



-- ============================================================
-- CHECK 6: ตรวจสอบค่า Distinct ของ new_type และ new_market
-- ผลลัพธ์ที่คาดหวัง: ค่าต้องอยู่ใน set ที่กำหนดไว้เท่านั้น
-- ============================================================

-- 6a: ค่าที่ปรากฏใน new_type
SELECT
  new_type,
  COUNT(*) AS record_count
FROM combined_data
GROUP BY new_type
ORDER BY record_count DESC;


-- 6b: ค่าที่ปรากฏใน new_market
SELECT
  new_market,
  COUNT(*) AS record_count
FROM combined_data
GROUP BY new_market
ORDER BY new_market;


-- ============================================================
-- CHECK 7: Summary Report — ภาพรวมคุณภาพข้อมูลทั้งหมด
-- รันอันนี้เพื่อดูสรุปรวมในครั้งเดียว
-- ============================================================

SELECT
  -- Row counts
  COUNT(*)                                                          AS total_rows,

  -- NULL checks
  COUNTIF(date_created IS NULL)                                     AS null_date_created,
  COUNTIF(new_type     IS NULL)                                     AS null_new_type,
  COUNTIF(new_market   IS NULL)                                     AS null_new_market,
  COUNTIF(contacts_n   IS NULL)                                     AS null_contacts_n,

  -- Negative value checks
  COUNTIF(contacts_n   < 0)                                        AS neg_contacts_n,
  COUNTIF(contacts_n_1 < 0)                                        AS neg_contacts_n_1,

  -- Date range
  MIN(date_created)                                                 AS min_date,
  MAX(date_created)                                                 AS max_date,

  -- Distinct counts
  COUNT(DISTINCT new_type)                                          AS distinct_types,
  COUNT(DISTINCT new_market)                                        AS distinct_markets
FROM combined_data;
