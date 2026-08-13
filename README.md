# 🏨 Hotel Booking Data Pipeline

## 📋 Project Overview
An end-to-end data engineering pipeline built entirely in Snowflake using Medallion Architecture (Bronze → Silver → Gold) to process and analyze hotel booking data.

---

## 🏗️ Architecture
```
Raw CSV File
     ↓
  BRONZE LAYER
(Raw data landing)
     ↓
  SILVER LAYER
(Cleaned & validated)
     ↓
   GOLD LAYER
(Business ready reports)
```

---

## 🛠️ Tech Stack
- **Snowflake** — Cloud data warehouse
- **SQL** — Data transformation and analysis
- **Medallion Architecture** — Bronze/Silver/Gold layers
- **Git & GitHub** — Version control

---

## 📁 Project Structure
```
snowflake-hotel-booking-project/
│
├── setup/
│   └── 01_setup.sql         # Database, schemas, file format, stage
│
├── bronze/
│   └── 02_bronze.sql        # Raw data loading
│
├── silver/
│   └── 03_silver.sql        # Data cleaning and validation
│
├── gold/
│   └── 04_gold.sql          # Business ready reports
│
└── automation/
    └── 05_streams_tasks.sql  # Automated pipeline (coming soon!)
```

---

## 🥉 Bronze Layer
- Loaded raw CSV data into Snowflake using COPY INTO
- All columns stored as VARCHAR to accept any data
- No transformations applied
- Source of truth — raw data always preserved!

---

## 🥈 Silver Layer
Data quality issues identified and fixed:

| Issue | Fix Applied |
|-------|-------------|
| Invalid emails | Validated using LIKE '%@%.%' |
| Negative amounts | Converted using ABS() |
| Invalid dates (31-02-2024) | Converted to NULL using TRY_TO_DATE() |
| Status typos (Confirmeeed) | Standardized using CASE WHEN |
| Mixed case values | Standardized using UPPER/INITCAP/TRIM |
| NULL booking IDs | Filtered out using WHERE clause |
| Wrong data types | Converted using TRY_TO_NUMBER/TRY_TO_DATE |

---

## 🥇 Gold Layer
Business ready aggregated tables:

| Table | Business Question Answered |
|-------|---------------------------|
| revenue_by_city | Which city generates most revenue? |
| bookings_by_room_type | Which room type is most popular? |
| booking_status_summary | Confirmed vs Cancelled ratio? |
| revenue_by_currency | Revenue breakdown by currency? |
| monthly_trends | How do bookings trend over time? |

---

## 📊 Dataset
- **Source:** Hotel bookings raw CSV
- **Total Records:** ~2001 rows
- **Columns:** 13 columns including booking details, customer info, dates and amounts

---

## 🔍 Key Learnings
- Implemented Medallion Architecture in Snowflake
- Handled real world messy data quality issues
- Applied proper data types in Silver layer
- Built business ready aggregations in Gold layer
- Used Snowflake stages and file formats
- Version controlled SQL code using Git

---

## 🚀 How to Run
```
1. Run setup/01_setup.sql
   → Creates database, schemas, file format and stage

2. Upload hotel_bookings_raw.csv to stage manually

3. Run bronze/02_bronze.sql
   → Loads raw data into bronze table

4. Run silver/03_silver.sql
   → Cleans and validates data

5. Run gold/04_gold.sql
   → Creates business ready reports
```

---

## 📈 Future Improvements
- [ ] Add Snowflake Streams for change detection
- [ ] Add Snowflake Tasks for pipeline automation
- [ ] Add Streamlit dashboard for visualization
- [ ] Connect dbt for version controlled transformations
- [ ] Add Airflow for full pipeline orchestration

---

## 👩‍💻 Author
Maneesha
