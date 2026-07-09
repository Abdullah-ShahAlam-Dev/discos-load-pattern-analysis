# Consumer Load Pattern Analysis and Demand Forecasting for Electric Distribution Companies (DISCOs)

### Semester Lab Project | Tools: SQL · Weka · Power BI
### Student: Abdullah | Batch 17

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement](#2-problem-statement)
3. [Business Need](#3-business-need)
4. [Dataset Description](#4-dataset-description)
5. [Tools Used](#5-tools-used)
6. [Project Architecture / Flow](#6-project-architecture--flow)
7. [Phase 1 — Data Collection & Cleaning](#phase-1--data-collection--cleaning-week-1-day-1-2)
8. [Phase 2 — SQL Database & Queries](#phase-2--sql-database--queries-week-1-day-3-7)
9. [Phase 3 — Data Mining with Weka](#phase-3--data-mining-with-weka-week-2)
10. [Phase 4 — Power BI Dashboard](#phase-4--power-bi-dashboard-week-3)
11. [Phase 5 — Report & Presentation](#phase-5--report--presentation-week-4)
12. [Key Findings (To Be Filled)](#12-key-findings-to-be-filled-after-analysis)
13. [Folder Structure](#13-folder-structure)

---

## 1. Project Overview

This project performs a **data-driven analysis of electricity consumption patterns** across different consumer groups, modeled on how a real Distribution Company (DISCO) like K-Electric would manage and analyze power demand.

Real K-Electric operational data is not publicly available. Therefore, we use the **"Smart Meters in London" dataset** from Kaggle — a real-world dataset containing half-hourly electricity readings from thousands of households. The consumer groups (called "Acorn Groups") in this dataset represent different socioeconomic area types, which we treat as equivalent to **K-Electric's distribution feeders or area zones** in Karachi.

The goal is to extract **business insights** from raw consumption data using three tools:
- **SQL** for data storage, querying, and aggregation
- **Weka** for data mining (pattern discovery, clustering, classification)
- **Power BI** for interactive visual dashboards

---

## 2. Problem Statement

> *"Electric Distribution Companies (DISCOs) struggle to efficiently manage electricity supply across different consumer zones. Without proper analysis of historical consumption data, they cannot predict peak demand periods, identify high-consumption areas, or make informed load management decisions — leading to unplanned outages and poor resource planning."*

---

## 3. Business Need

A DISCO like K-Electric needs to answer these critical questions:

| Business Question | How We Answer It |
|---|---|
| Which areas consume the most electricity? | SQL aggregation + Power BI bar chart |
| When is electricity demand at its peak? | SQL time-based queries + Power BI heatmap |
| Can we group consumers by usage behavior? | Weka K-Means Clustering |
| What factors predict high consumption? | Weka J48 Decision Tree |
| Is there a relation between weather and demand? | SQL join + Power BI trend line |
| How should the DISCO plan load distribution? | Dashboard insights + business recommendations |

---

## 4. Dataset Description

**Source:** Kaggle — "Smart Meters in London" by Jean-Michel D.
**Link:** https://www.kaggle.com/datasets/jeanmidev/smart-meters-in-london
**Real data period:** November 2011 – February 2014

### Files We Are Using:

---

### File 1: `block_0.csv` → Renamed to `consumption.csv`

This is the **main data file**. It contains half-hourly electricity readings for thousands of households.

| Original Column | Renamed To | Description |
|---|---|---|
| LCLid | household_id | Unique ID for each household/meter |
| tstp | reading_datetime | Date and time of the reading |
| energy(kWh/hh) | energy_kwh | Electricity consumed in that half-hour (kilowatt-hours) |

**We KEEP:** All 3 columns
**We DELETE:** Nothing from this file

---

### File 2: `informations_households.csv` → Renamed to `households.csv`

This file tells us **which area group** each household belongs to. This is how we simulate K-Electric's feeder/zone classification.

| Original Column | Renamed To | Keep or Delete? |
|---|---|---|
| LCLid | household_id | ✅ KEEP |
| stdorToU | tariff_type | ✅ KEEP |
| Acorn | acorn_code | ✅ KEEP |
| Acorn_grouped | area_group | ✅ KEEP |
| file | source_file | ❌ DELETE |

**We KEEP:** 4 columns
**We DELETE:** `file` column (it's just internal Kaggle info, useless for us)

---

### File 3: `weather_daily_darksky.csv` → Renamed to `weather.csv`

This file contains **daily weather data** for London. We use it to analyze if weather affects electricity demand.

| Original Column | Renamed To | Keep or Delete? |
|---|---|---|
| time | weather_date | ✅ KEEP |
| temperatureMax | temp_max | ✅ KEEP |
| temperatureMin | temp_min | ✅ KEEP |
| humidity | humidity | ✅ KEEP |
| windSpeed | wind_speed | ✅ KEEP |
| cloudCover | cloud_cover | ✅ KEEP |
| summary | weather_summary | ✅ KEEP |
| icon | weather_icon | ✅ KEEP |
| temperatureMaxTime | ❌ DELETE | Not needed |
| windBearing | ❌ DELETE | Not needed |
| dewPoint | ❌ DELETE | Too technical |
| temperatureMinTime | ❌ DELETE | Not needed |
| pressure | ❌ DELETE | Not needed |
| apparentTemperatureMinTime | ❌ DELETE | Not needed |
| apparentTemperatureHigh | ❌ DELETE | Duplicate info |
| precipType | ❌ DELETE | Not needed |
| visibility | ❌ DELETE | Not needed |
| apparentTemperatureHighTime | ❌ DELETE | Not needed |
| apparentTemperatureLow | ❌ DELETE | Duplicate |
| apparentTemperatureMax | ❌ DELETE | Duplicate |
| uvIndex | ❌ DELETE | Not needed |
| sunsetTime | ❌ DELETE | Not needed |
| temperatureLow | ❌ DELETE | Duplicate |
| temperatureHigh | ❌ DELETE | Duplicate |
| sunriseTime | ❌ DELETE | Not needed |
| temperatureHighTime | ❌ DELETE | Not needed |
| uvIndexTime | ❌ DELETE | Not needed |
| temperatureLowTime | ❌ DELETE | Not needed |
| apparentTemperatureMin | ❌ DELETE | Duplicate |
| apparentTemperatureMaxTime | ❌ DELETE | Not needed |
| apparentTemperatureLowTime | ❌ DELETE | Not needed |
| moonPhase | ❌ DELETE | Not needed |

**We KEEP:** 8 columns only
**We DELETE:** 24 columns

---

## 5. Tools Used

| Tool | Version | Purpose |
|---|---|---|
| Microsoft Excel | Any | Data cleaning and column renaming |
| MySQL + MySQL Workbench | 8.0+ | Database creation, table import, SQL queries |
| Weka | 3.8.x | Data mining — clustering, classification, association rules |
| Power BI Desktop | Latest (Free) | Interactive visual dashboard |
| Microsoft Word | Any | Final project report |
| PowerPoint | Any | Presentation slides |

---

## 6. Project Architecture / Flow

```
RAW DATA (Kaggle CSVs)
        |
        v
[ PHASE 1: Excel Cleaning ]
  - Delete unwanted columns
  - Rename columns
  - Save as clean CSVs
        |
        v
[ PHASE 2: SQL ]
  - Create database: disco_analysis
  - Create 3 tables: consumption, households, weather
  - Import clean CSVs
  - Write 15+ queries
  - Export results for Weka
        |
        v
[ PHASE 3: Weka Data Mining ]
  - Load SQL-exported CSV
  - K-Means Clustering (group areas by usage)
  - J48 Decision Tree (predict high/low demand)
  - Apriori Association Rules (find patterns)
        |
        v
[ PHASE 4: Power BI Dashboard ]
  - Connect to SQL database
  - Build 5-6 interactive visuals
  - Final DISCO load analysis dashboard
        |
        v
[ PHASE 5: Report + Presentation ]
  - Word document report
  - PowerPoint slides
  - Submit and present
```

---

## Phase 1 — Data Collection & Cleaning (Week 1, Day 1-2)

### Status: 🔄 IN PROGRESS

### Files Downloaded:
- [x] block_0.csv
- [x] informations_households.csv
- [x] weather_daily_darksky.csv

### Excel Cleaning Steps:

**For block_0.csv:**
1. Open in Excel
2. Rename columns: LCLid → household_id, tstp → reading_datetime, energy(kWh/hh) → energy_kwh
3. Delete rows where energy_kwh = "Null"
4. Save As → `consumption.csv`

**For informations_households.csv:**
1. Open in Excel
2. Delete the `file` column
3. Rename: LCLid → household_id, stdorToU → tariff_type, Acorn → acorn_code, Acorn_grouped → area_group
4. Save As → `households.csv`

**For weather_daily_darksky.csv:**
1. Open in Excel
2. Keep only 8 columns (listed above), delete all others
3. Rename columns as listed above
4. Save As → `weather.csv`

---

## Phase 2 — SQL Database & Queries (Week 1, Day 3-7)

### Status: ⏳ NOT STARTED

### Database Name: `disco_analysis`

### Tables to Create:
- `consumption` — main electricity readings
- `households` — area/zone info per household
- `weather` — daily weather data

### Planned Queries (15 Total):
1. Total consumption per area group
2. Average daily consumption
3. Peak hour identification
4. Monthly consumption trend
5. Top 10 highest consuming households
6. Seasonal consumption comparison
7. Weather vs consumption correlation
8. Area-wise ranking
9. Tariff type comparison (Standard vs Time-of-Use)
10. Anomaly detection (abnormally high days)
11. Weekday vs Weekend consumption
12. Yearly trend analysis
13. Low consumption identification
14. Morning vs Evening vs Night comparison
15. Area summary for Weka export

---

## Phase 3 — Data Mining with Weka (Week 2)

### Status: ⏳ NOT STARTED

### Techniques to Apply:

**1. K-Means Clustering**
- Goal: Group households into Low / Medium / High consumption clusters
- This tells DISCO: which zones need more supply

**2. J48 Decision Tree Classification**
- Goal: Predict if a time period will be High or Low demand
- Input: hour, day, area_group, weather
- Output: High / Low label

**3. Apriori Association Rules**
- Goal: Find patterns like "Evening + Winter → High Load"
- Useful for DISCO's load planning schedule

---

## Phase 4 — Power BI Dashboard (Week 3)

### Status: ⏳ NOT STARTED

### Planned Visuals (6 Total):

| Visual | Type | What It Shows |
|---|---|---|
| Monthly Consumption Trend | Line Chart | How demand changes month by month |
| Area-wise Total Consumption | Bar Chart | Which zone uses most electricity |
| Peak Hour Heatmap | Matrix/Heatmap | Hour vs Day consumption intensity |
| Consumer Segment Distribution | Pie Chart | How many households in each cluster |
| Weather vs Consumption | Scatter Plot | Temperature impact on demand |
| KPI Cards | Cards | Total units, Avg daily load, Peak hour |

---

## Phase 5 — Report & Presentation (Week 4)

### Status: ⏳ NOT STARTED

### Report Chapters:
1. Introduction & Problem Statement
2. Dataset Description
3. SQL Queries & Results
4. Weka Mining Results
5. Power BI Dashboard
6. Conclusions & Business Recommendations

### Presentation (12-15 Slides):
- Problem → Data → SQL → Weka → Power BI → Findings → Recommendations

---

## 12. Key Findings (To Be Filled After Analysis)

> *(This section will be filled after Phases 2, 3, and 4 are complete)*

- Top consuming area group: **TBD**
- Peak demand hour: **TBD**
- Number of consumer clusters identified: **TBD**
- Strongest association rule found: **TBD**
- Weather impact on consumption: **TBD**

---

## 13. Folder Structure

```
DISCO_Project/
│
├── README.md                     ← This file
│
├── 1_Data/
│   ├── Raw/
│   │   ├── block_0.csv
│   │   ├── informations_households.csv
│   │   └── weather_daily_darksky.csv
│   └── Cleaned/
│       ├── consumption.csv
│       ├── households.csv
│       └── weather.csv
│
├── 2_SQL/
│   ├── create_tables.sql
│   ├── import_data.sql
│   └── queries.sql
│
├── 3_Weka/
│   ├── weka_input.csv
│   ├── clustering_results.png
│   ├── classification_results.png
│   └── association_rules.png
│
├── 4_PowerBI/
│   └── disco_dashboard.pbix
│
└── 5_Report/
    ├── Project_Report.docx
    └── Presentation.pptx
```

---

*Project guided step-by-step. Each phase will be completed before moving to the next.*
*Last Updated: Phase 1 — Data Collection*
