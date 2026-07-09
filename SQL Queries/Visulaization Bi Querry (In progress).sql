USE disco_analysis;
--USE disco_analysis2;

--========================================================================================


select count(*) from weather

SELECT COUNT(*) AS households_count FROM households;
SELECT COUNT(*) AS weather_count    FROM weather;
SELECT COUNT(*) AS consumption_count FROM consumption;
--====================================================================
--for Total Demand Enegry Consumption in Area Zones
--************************--This querry in progress for Bi visuals( in progress)
USE disco_analysis;

SELECT 
    h.area_group,
    SUM(c.energy_kwh) AS total_energy_kwh,
    COUNT(DISTINCT c.household_id) AS total_households
FROM consumption c
JOIN households h ON c.household_id = h.household_id
GROUP BY h.area_group
ORDER BY total_energy_kwh DESC;
--========================================================================================




SELECT COUNT(*) AS households_count 
FROM households 
WHERE tariff_type = 'Std';






