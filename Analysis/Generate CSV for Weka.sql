	USE disco_analysis;

SELECT TOP 10000
    c.household_id,
    c.energy_kwh,
    h.area_group,
    h.tariff_type
FROM consumption c
JOIN households h ON c.household_id = h.household_id
WHERE c.energy_kwh IS NOT NULL;



