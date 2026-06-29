<<<<<<< HEAD
# Google Fiber - First Call Resolution (FCR) Capstone Project

> **Capstone project สำหรับ [Google Business Intelligence Professional Certificate](https://www.coursera.org/professional-certificates/google-business-intelligence)**  
> วิเคราะห์ข้อมูล repeat caller ของ Google Fiber เพื่อหา insight เกี่ยวกับการโรแจ้งปัญหาของลูกค้า

---

## โจทย์ธุรกิจ

Google Fiber ต้องการเข้าใจว่าลูกค้าในแต่ละ **Market (1–3)** โทรซ้ำเข้า call center บ่อยแค่ไหนและด้วยปัญหาประเภทใด เป้าหมายหลักคือ **ลดปริมาณสาย** และ **เพิ่ม First Call Resolution (FCR)** ซึ่งวัดว่าทีมสามารถแก้ปัญหาให้ลูกค้าได้สำเร็จในการโทรครั้งแรกโดยไม่ต้องโทรซ้ำ

**Stakeholders:**

| ชื่อ | บทบาท |
| --- | --- |
| Emma Santiago | Hiring Manager |
| Keith Portone | Project Manager |
| Minna Rah | Lead BI Analyst |

---

## โครงสร้างโปรเจค

``` 
google-fiber-fcr-capstone-classic/
│
├── data/
│   ├── raw/                  ← ข้อมูลดิบแยกตาม Market (market_1–3.csv)
│   └── mart/
│       └── google_fiber_case.csv   ← ตาราง Mart ที่ผ่าน Union แล้ว พร้อมใช้กับ BI tool
│
├── sql/
│   ├── 01_data_union.sql     ← รวม 3 Market เป็นตารางเดียวด้วย UNION ALL พร้อม Cast และ จักการค่า Null
│   └── 02_data_quality_check.sql   ← ตรวจสอบ NULL / Duplicate / Range / Negative
│
├── dashboards/
│   ├── tableau_version/      ← Google Fiber Dashboard.twbx (ต้นฉบับ)
│   ├── powerbi_version/      ← Google-Fiber-FCR-Dashboard.pbix
│   ├── data_studio_version/  ← URL ดูได้สาธารณะ (ดูรายละเอียดใน README ใน folder)
│   └── mockups/              ← Lo-fi mockup ก่อนสร้าง Dashboard
│
└── docs/
    ├── 01_stakeholder_requirements.docx
    ├── 02_project_requirements.docx
    ├── 03_strategy_document.docx
    └── 04_roccc_data_assessment.docx
```

---

## ข้อมูล (Data)

### Schema ของ Raw Files และ Mart Table

| Column | คำอธิบาย |
| --- | --- |
| `date_created` | วันที่รับสายครั้งแรก |
| `contacts_n` | จำนวน initial contacts ในวันนั้น |
| `contacts_n_1` … `contacts_n_7` | จำนวน repeat contacts ที่เกิดขึ้น 1–7 วันหลังจากสายแรก |
| `new_type` | ประเภทปัญหา (type_1 – type_5+) |
| `new_market` | ตลาด/พื้นที่ให้บริการ (market_1 – market_3) |

**ช่วงเวลาของข้อมูล:** Q1 2022 (มกราคม – มีนาคม 2022)

### Data Pipeline

```
Raw CSVs (market_1–3)
    └── 01_data_union.sql (BigQuery UNION ALL + COALESCE null → 0)
            └── google_fiber_case.csv (Mart Table)
                    └── Dashboard (Tableau / Power BI / Data Studio)
```

> SQL เขียนด้วย **BigQuery dialect** - หากใช้ SQL ต่างตัว ให้ปรับ syntax เช่น `SAFE_CAST`

---

## Data Quality Checks (`02_data_quality_check.sql`)

ไฟล์นี้แบ่งเป็น 7 session ดังนี้:

| Session | สิ่งที่ตรวจ | Expected Result |
| --- | --- | --- |
| 1 | Row count by Market | ทุก Market มีข้อมูล (> 0 rows) |
| 2 | NULL ทุก Column | ไม่มี NULL |
| 3 | Duplicate rows | ไม่มีซ้ำ |
| 4 | Date range | อยู่ใน Jan–Mar 2022 |
| 5 | Negative contacts | ไม่มีค่าติดลบ |
| 6 | Distinct values ของ new_type / new_market | ตรงกับ business rules |
| 7 | Summary report (optional) | ภาพรวมทุกอย่างใน query เดียว |

---

## Dashboards

Dashboard ทั้ง 3 ตัวใช้ **ข้อมูลชุดเดียวกัน** และตอบคำถามเดิม

| BI Tool | รูปแบบไฟล์ | หมายเหตุ |
| --- | --- | --- |
| **Tableau** | `.twbx` | ต้นฉบับ เปิดด้วย Tableau |
| **Power BI** | `.pbix` | เปิดด้วย Power BI Desktop |
| **Data Studio** | URL (public link) | เปิดใน browser ได้เลย ดู README ใน `data_studio_version/` |

**Mockups** ใน `dashboards/mockups/` คือ Lo-fidelity mockup ที่ทำในช่วง Planning เพื่อ align กับ Stakeholders ก่อนสร้าง Dashboard จริง รูปร่างอาจต่างจากตัว final

---

## เอกสารโปรเจค (docs/)

| ไฟล์ | เนื้อหา |
| --- | --- |
| `01_stakeholder_requirements.docx` | ความต้องการของ Stakeholder |
| `02_project_requirements.docx` | Requirements ระดับโปรเจค |
| `03_strategy_document.docx` | Strategy การวิเคราะห์และนำเสนอ |
| `04_roccc_data_assessment.docx` | ประเมินคุณภาพข้อมูลตามเกณฑ์ ROCCC |

มีฉบับ .md เพื่อให้ง่ายแก่การดูใน GitHub แต่ต้นฉบับจริงถูกทำเป็น .docx

---

## วิธีใช้งาน (Quick Start)

1. **เปิด Dashboard** → โหลดไฟล์นำเข้า BI tool ที่ต้องการ ไม่จำเป้นต้องโหลดข้อมูล เพราะ ไฟล์มีการ embeded ข้อมูลให้แล้ว
2. **สร้าง Mart จาก Raw Data เอง** → โหลด raw data จากนั้นรัน `sql/01_data_union.sql` บน BigQuery (หรือ SQL engine ที่ใช้อยู่) แล้ว export ผลลัพท์ออกมาเป็น .csv
3. **ตรวจสอบคุณภาพข้อมูล** → รัน `sql/02_data_quality_check.sql` ทีละ Session ตัวไหนไม่ต้องการ run ต้อง comment ไว้ก่อน ดูว่าเครื่องหมาย ; มันจบตรงไหนตรงนั้นแหละจบ session (SQL engine บางตัวอาจจะ run พร้อมกันได้ ขึ้นอยู่กับโชคชะตาของแต่ละคนครับ)

---

## คำถามที่ Dashboard ตอบได้

- Market ไหนมี repeat caller สูงที่สุด ?
- ปัญหาประเภทใด (new_type) ทำให้ลูกค้าโทรซ้ำมากที่สุด ?
- FCR rate ของแต่ละ Market และปัญหาแต่ละประเภทเป็นเท่าไร ?
- Trend ของ repeat call เปลี่ยนแปลงอย่างไรใน Q1 2022 ?
=======
# Hero Readme
>>>>>>> b1fc1e2242cbcc78d11e88d8aa81352934888907
