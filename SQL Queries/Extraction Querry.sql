CREATE DATABASE disco_analysis2;
go
USE disco_analysis;

-- Table 1: Consumption (main data)
CREATE TABLE consumption (
    household_id      VARCHAR(20),
    reading_datetime  DATETIME2,
    energy_kwh        FLOAT
);
-- Step 1: Create a Staging table for filter NUll values
CREATE TABLE consumption_staging (
    household_id      VARCHAR(20),
    reading_datetime  VARCHAR(50),
    energy_kwh        VARCHAR(20)
);

-- Step 2: Raw data import into staging table
BULK INSERT consumption_staging
FROM 'C:\Users\abdul\Desktop\DataWare Project\Data\Cleaned\block_5.csv' 
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Step 3: Clean data, Remove Duplicates, Standardize, and Load into Final Table
INSERT INTO consumption (household_id, reading_datetime, energy_kwh)
SELECT DISTINCT 
    UPPER(household_id),                        -- Standardize 
    TRY_CAST(reading_datetime AS DATETIME2),    -- TRY_CAST escape from error during insertion
    TRY_CAST(energy_kwh AS FLOAT)               
FROM consumption_staging
WHERE energy_kwh != 'Null'
AND energy_kwh IS NOT NULL
AND energy_kwh != ''
AND TRY_CAST(reading_datetime AS DATETIME2) IS NOT NULL; -- Sirf valid dates andar jayengi



select count(*) from consumption_staging
select count(*) from consumption

-- Staging table delete , if we wanna reduce trashes
DROP TABLE consumption_staging;





--========================================================================================
-- Table 2: Households (area info)
CREATE TABLE households (
    household_id  VARCHAR(20),
    tariff_type   VARCHAR(10),
    acorn_code    VARCHAR(20),
    area_group    VARCHAR(20)
);
BULK INSERT households
FROM 'C:\Users\abdul\Desktop\DataWare Project\Data\Cleaned\households.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
select * from households





-- Table 3: Weather (daily weather)
CREATE TABLE weather (
    temp_max          FLOAT,
    weather_icon      VARCHAR(50),
    cloud_cover       FLOAT,
    wind_speed        FLOAT,
    humidity          FLOAT,
    weather_date      DATETIME2,
    temp_min          FLOAT,
    weather_summary   VARCHAR(100)
);
BULK INSERT weather
FROM 'C:\Users\abdul\Desktop\DataWare Project\Data\Cleaned\weather.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
select * from weather
--===================================================================================================
