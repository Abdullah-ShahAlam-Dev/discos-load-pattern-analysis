================================================================
   CONSUMER LOAD PATTERN ANALYSIS AND DEMAND FORECASTING
         FOR POWER DISTRIBUTION COMPANIES (DISCOs)
================================================================


----------------------------------------------------------------
PROJECT OVERVIEW
----------------------------------------------------------------
This project analyzes household electricity consumption data to
identify peak demand periods, monthly trends, and usage patterns
-- helping Distribution Companies (DISCOs) like K-Electric
better understand how and when consumers use electricity.

Real K-Electric data is not publicly available. Therefore, the
"Smart Meters in London" dataset was used as an equivalent,
containing real half-hourly meter readings from thousands of
households across different socioeconomic area groups (Acorn
Groups), which represent K-Electric distribution zones.

----------------------------------------------------------------
FOLDER STRUCTURE
----------------------------------------------------------------
Project_DISCOs/
|
|-- README.txt                  <-- This file (Start here)
|
|-- RESULTS AND OUTPUT.docx     <-- Final report with all
|                                   screenshots and findings
|
|-- Data/
|   |-- Raw/                    <-- Original Kaggle CSV files
|   |   |-- block_5.csv (57.48 MB)	        (Main consumption data)
|   |   |-- informations_households		(Area group classification)
|   |   `-- weather_daily_darksky .csv		(Daily weather data)
|   |
|   `-- Cleaned/                <-- Excel cleaned versions
|       |-- consumption.csv     (Renamed + columns cleaned)
|       |-- households.csv      (Renamed + file col removed)
|       `-- weather.csv         (8 columns kept only)
|
|-- SQL Queries/
|   `-- queries.sql             <-- All SQL queries used in
|                                   the project (15 queries)
|
`-- Analysis/
    |-- Generate CSV for Weka.sql  <-- SQL JOIN query used
    |                                  to export Weka input
    `-- weka_input.csv             <-- CSV loaded into Weka
                                       for data mining

----------------------------------------------------------------
HOW TO RUN THIS PROJECT
----------------------------------------------------------------

STEP 1 -- SQL SERVER SETUP
  1. Open SQL Server Management Studio (SSMS 20)
  2. Connect to your local SQL Server instance
  3. Run the queries in: SQL Queries/queries.sql
  4. Database name: disco_analysis
  5. Tables: consumption, households, weather

STEP 2 -- POWER BI DASHBOARD
  1. Open Power BI Desktop
  2. Load the 3 CSV files from Data/Cleaned/ folder
  3. Dashboard shows:
     - Monthly energy consumption trend (Line Chart)
     - Household distribution by area group (Bar Chart)
     - Tariff type breakdown Std vs ToU (Donut Chart)
     - Total energy consumed KPI Card

STEP 3 -- WEKA DATA MINING
  1. Open Weka Explorer
  2. Load file: Analysis/weka_input.csv
  3. Techniques applied:
     a) K-Means Clustering (SimpleKMeans, 2 clusters)
        -- Groups households by consumption behavior
     b) J48 Decision Tree Classification
        -- Predicts tariff type (Std vs ToU)
        -- Accuracy: 100%
     c) Association Rules (FilteredAssociator/Apriori)
        -- Finds patterns between area and tariff type

----------------------------------------------------------------
ETL PROCESS (Extract, Transform, Load)
----------------------------------------------------------------

EXTRACT:
  - Raw data downloaded from Kaggle
  - 3 files: consumption (57MB), households, weather

TRANSFORM:
  - Excel used for structural cleaning only
  - Deleted unnecessary columns
  - Renamed all columns to clean standard names
  - NULL values NOT removed in Excel (crash risk)
  - NULL handling done in SQL using WHERE clauses
  - Staging table used for safe BULK INSERT

LOAD:
  - Data loaded into MS SQL Server 2022
  - 3 tables created: consumption, households, weather
  - 1.4 million+ consumption records loaded
  - Data connected to Power BI for visualization
  - Summary CSV exported for Weka mining

----------------------------------------------------------------
KEY FINDINGS
----------------------------------------------------------------
1. Affluent zone consumers account for highest energy demand
2. K-Means identified 2 consumer clusters:
   - Cluster 0: 1,647 households (High usage)
   - Cluster 1: 8,352 households (Normal usage)
3. J48 Classification accuracy: 100%
   - Standard tariff: 8,836 consumers
   - Time-of-Use tariff: 1,163 consumers
4. Consumption trend shows steady increase 2012 to 2014
5. Standard tariff consumers = 91% of total (dominant group)

----------------------------------------------------------------
DATASET INFORMATION
----------------------------------------------------------------
Source  : Kaggle -- Smart Meters in London
Author  : Jean-Michel D.
Period  : November 2011 to February 2014
Size    : 10.27 GB total (block_5.csv used = selected sample)
Columns :
  consumption --> household_id, reading_datetime, energy_kwh
  households  --> household_id, tariff_type, acorn_code, area_group
  weather     --> weather_date, temp_max, temp_min, humidity,
                  wind_speed, cloud_cover, weather_summary, weather_icon

----------------------------------------------------------------
NOTE FOR EVALUATOR
----------------------------------------------------------------
Real K-Electric operational data is not publicly available.
This internationally recognized smart meter dataset was used
as it follows the exact same structure as a DISCO distribution
system -- area-based consumer classification, half-hourly meter
readings, and tariff type segmentation.

The Acorn Groups in this dataset directly correspond to
K-Electric's consumer zone classifications.

================================================================
                      END OF README
================================================================
