-- =========================================================
-- SQL Project: Sustainability Impact Analysis for Intel
-- =========================================================
-- Author: Allison Cunningham
-- Description: Queries used to analyze Intel’s device 
-- repurposing program (2024 dataset).
-- =========================================================

-------------------------------------------------------------
-- Task 1: Organizing and Understanding the Data
-------------------------------------------------------------

-- A. Join device data with impact data
SELECT *
FROM intel.device_data AS a
FULL OUTER JOIN intel.impact_data AS b 
  ON a.device_id = b.device_id;

-- B. Add device_age column
SELECT *, 
       2024 - model_year AS device_age
FROM intel.device_data AS a
FULL OUTER JOIN intel.impact_data AS b 
  ON a.device_id = b.device_id;

-- C. Order by model_year
SELECT *, 
       2024 - model_year AS device_age
FROM intel.device_data AS a
FULL OUTER JOIN intel.impact_data AS b 
  ON a.device_id = b.device_id
ORDER BY model_year;

-- D. Add device_age_bucket column
SELECT *, 
       CASE 
         WHEN 2024 - model_year <= 3 THEN 'newer'
         WHEN 2024 - model_year <= 6 THEN 'mid-age'
         ELSE 'older'
       END AS device_age_bucket
FROM intel.device_data AS a
FULL OUTER JOIN intel.impact_data AS b 
  ON a.device_id = b.device_id;

-------------------------------------------------------------
-- Task 2: Key Insights
-------------------------------------------------------------

-- B. Summary statistics for repurposed devices
WITH device_age AS (
  SELECT *, 
         2024 - model_year AS device_age,
         CASE 
           WHEN 2024 - model_year <= 3 THEN 'newer'
           WHEN 2024 - model_year <= 6 THEN 'mid-age'
           ELSE 'older'
         END AS device_age_bucket
  FROM intel.device_data AS a
  FULL OUTER JOIN intel.impact_data AS b 
    ON a.device_id = b.device_id
)
SELECT COUNT(*) AS total_devices,
       AVG(device_age) AS avg_age,
       AVG(energy_savings_yr) AS avg_energy_savings,
       SUM(co2_saved_kg_yr) / 1000 AS co2_saved_tons
FROM device_age;

-------------------------------------------------------------
-- Task 3: Identifying Trends & Maximizing Sustainability
-------------------------------------------------------------

-- A. Group by device_type
WITH device_age AS (
  SELECT *, 
         2024 - model_year AS device_age,
         CASE 
           WHEN 2024 - model_year <= 3 THEN 'newer'
           WHEN 2024 - model_year <= 6 THEN 'mid-age'
           ELSE 'older'
         END AS device_age_bucket
  FROM intel.device_data AS a
  FULL OUTER JOIN intel.impact_data AS b 
    ON a.device_id = b.device_id
)
SELECT device_type,
       COUNT(*) AS total_devices,
       AVG(energy_savings_yr) AS avg_energy_savings,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM device_age
GROUP BY device_type;

-- C. Group by device_age_bucket
WITH device_age AS (
  SELECT *, 
         2024 - model_year AS device_age,
         CASE 
           WHEN 2024 - model_year <= 3 THEN 'newer'
           WHEN 2024 - model_year <= 6 THEN 'mid-age'
           ELSE 'older'
         END AS device_age_bucket
  FROM intel.device_data AS a
  FULL OUTER JOIN intel.impact_data AS b 
    ON a.device_id = b.device_id
)
SELECT device_age_bucket,
       COUNT(*) AS total_devices,
       AVG(energy_savings_yr) AS avg_energy_savings,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM device_age
GROUP BY device_age_bucket;

-- E. Group by region
WITH device_age AS (
  SELECT *, 
         2024 - model_year AS device_age,
         CASE 
           WHEN 2024 - model_year <= 3 THEN 'newer'
           WHEN 2024 - model_year <= 6 THEN 'mid-age'
           ELSE 'older'
         END AS device_age_bucket
  FROM intel.device_data AS a
  FULL OUTER JOIN intel.impact_data AS b 
    ON a.device_id = b.device_id
)
SELECT region,
       COUNT(*) AS total_devices,
       AVG(energy_savings_yr) AS avg_energy_savings,
       AVG(co2_saved_kg_yr) / 1000 AS avg_co2_saved_tons
FROM device_age
GROUP BY region;

