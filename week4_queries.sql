-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 4: Multi-Table Analysis with JOINs
-- Tables: rets_property + rets_openhouse
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Find listings with open houses
SELECT p.L_DisplayId, p.L_Address, p.L_City, p.L_SystemPrice, -- Column to retrieve from the first table
o.OpenHouseDate, o.OH_StartTime, o.OH_EndTime -- Columns to retrieve from the second table
FROM rets_property p -- Short form for the table name
INNER JOIN rets_openhouse o ON p.L_DisplayId = o.L_DisplayId -- Match property with their corresponding open house record
ORDER BY o.OpenHouseDate -- Earliest to latest date
LIMIT 20; -- Only show certain amount

-- 2. Count open houses per listing
SELECT p.L_DisplayId, p.L_Address, p.L_City, p.L_SystemPrice, -- Column to retrieve in first table
COUNT(o.OpenHouseDate) AS num_open_houses -- Second table
FROM rets_property p -- First table
INNER JOIN rets_openhouse o ON p.L_DisplayId = o.L_DisplayId -- Condition to match between tables
GROUP BY p.L_DisplayId, p.L_Address, p.L_City, p.L_SystemPrice -- Group by the same identification
ORDER BY num_open_houses DESC -- Sort from most to least open houses
LIMIT 20; -- Limit to certain range

-- 3. What percentage have open houses
SELECT -- What to return
COUNT(DISTINCT p.L_DisplayId) AS total_listings, -- Count the total number of unique listings in the first table
COUNT(DISTINCT o.L_DisplayId) AS listings_with_openhouse, -- Count the total number of unique identification in the second table
ROUND(100.0 * COUNT(DISTINCT o.L_DisplayId) -- Take the number of open houses
/ COUNT(DISTINCT p.L_DisplayId), 1) AS pct_with_openhouse -- Divide by total listings to get a ratio (or percentage)
FROM rets_property p -- Take the first table
LEFT JOIN rets_openhouse o ON p.L_DisplayId = o.L_DisplayId; -- Left join keep all properties on the first table, even when they have no open houses

-- 4. Analyze listings and open house by city
SELECT p.L_City, -- For each city
COUNT(DISTINCT p.L_DisplayId) AS total_listings, -- Count the number of unique listings (in a city) to get the total
COUNT(o.OpenHouseDate) AS total_open_houses, -- Count the total number of open houses given that city
ROUND(100.0 * COUNT(DISTINCT o.L_DisplayId) -- Take the total listing (home that has at least 1 open house)
/ COUNT(DISTINCT p.L_DisplayId), 1) AS pct_with_openhouse -- Divide by the total listing (from open houses above) to get the rate
FROM rets_property p -- Retrieve from the first table
LEFT JOIN rets_openhouse o ON p.L_DisplayId = o.L_DisplayId -- Match properties with open house record
GROUP BY p.L_City -- Group city with the same name
HAVING COUNT(DISTINCT p.L_DisplayId) >= 10 -- Keep city that have total listings above certain range
ORDER BY total_open_houses DESC -- Largest to smallest
LIMIT 20; -- Keep only 20 results

-- 5. Most popular open house date
SELECT DAYNAME(OpenHouseDate) AS day_of_week, -- Take the full date, then return the name of that day
COUNT(*) AS num_open_houses -- For each day, count the total open houses take place
FROM rets_openhouse -- Table to retrieve
WHERE OpenHouseDate IS NOT NULL -- Only take account valid value
GROUP BY DAYNAME(OpenHouseDate), DAYOFWEEK(OpenHouseDate) -- Take day with the same numerical value (for sorting later)
ORDER BY DAYOFWEEK(OpenHouseDate); -- Sunday is the start

-- Debug exercise
SELECT p.L_City,
COUNT(*) AS listing_count, -- Should count the distinct to avoid duplicate
ROUND(AVG(p.L_SystemPrice), 0) AS avg_price
FROM rets_property p
INNER JOIN rets_openhouse o ON p.L_DisplayId = o.L_DisplayId
GROUP BY p.L_City
ORDER BY avg_price DESC
LIMIT 15;
