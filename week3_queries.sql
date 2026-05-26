-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 3: Aggregations & Grouping
-- Tables: rets_property
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Group findings by cities
SELECT L_City, -- Column to retrieve
COUNT(*) AS total_listings, -- Count the total listing in each city
ROUND(AVG(L_SystemPrice), 0) AS avg_list_price, -- Calculate the average listing price in each city, round to the whole dollar
MIN(L_SystemPrice) AS min_price, -- Cheapest property given a city
MAX(L_SystemPrice) AS max_price -- Most expensive property given a city
FROM rets_property -- Table to retrieve from
WHERE L_SystemPrice IS NOT NULL -- Only keep the valid
GROUP BY L_City -- Group city with the same name together
ORDER BY avg_list_price DESC; -- Order from largest to smallest

-- 2. Price per square foot
SELECT L_City, -- For each city
COUNT(*) AS listings, -- Count the total number of listings
ROUND(AVG(L_SystemPrice), 0) AS avg_price, -- Calculate the average price (round to nearest dollar)
ROUND(AVG(LM_Int2_3), 0) AS avg_sqft, -- Calculate average square foot
ROUND(AVG(L_SystemPrice / LM_Int2_3), 2) AS avg_price_per_sqft -- Average price per square foot (round to two decimal places)
FROM rets_property -- Table to retrieve from
WHERE LM_Int2_3 > 0 AND L_SystemPrice IS NOT NULL -- Avoid error in calculation
GROUP BY L_City -- Group city with the same name
ORDER BY avg_price_per_sqft DESC -- Highest price per square foot to cheapest
LIMIT 20;

-- 3. Where runs before grouping (filter individual rows) while having runs after grouping (filter entire group)
SELECT L_City, -- For each city
COUNT(*) AS total_listings, -- Count the total number of listing
ROUND(AVG(L_SystemPrice), 0) AS avg_price -- Calculate the average property price given that city
FROM rets_property -- Retrieve the data from this table
WHERE L_SystemPrice IS NOT NULL -- Only keep valid value to calculate
GROUP BY L_City -- Group city with the same name
HAVING COUNT(*) >= 10 -- Filter city with more than 10 listings
ORDER BY avg_price DESC; -- Order from largest to smallest price

-- 4. Inventory for each bedroom count
SELECT L_Keyword2 AS bedrooms, -- For each bedroom count
COUNT(*) AS total_listings, -- Count the total of listings for that bedroom count
ROUND(AVG(L_SystemPrice), 0) AS avg_price -- Calculate the average price for each bedroom count
FROM rets_property -- Table to retrieve
WHERE L_Keyword2 IS NOT NULL AND L_Keyword2 BETWEEN 1 AND 8 -- Keep valid values between certain range only
GROUP BY L_Keyword2 -- Group bed count with the same number
ORDER BY L_Keyword2; -- Smallest to largest

-- Debug exercise
SELECT L_City,
COUNT(*) AS total_listings,
ROUND(AVG(L_SystemPrice), 0) AS avg_price
FROM rets_property
WHERE AVG(L_SystemPrice) > 600000 -- This is happening after the aggregation, so we need to move it after
WHERE AVG(L_SystemPrice) > 600000 -- This happens after the aggregation, so we need to move it within the having instead of where
AND L_SystemPrice IS NOT NULL
GROUP BY L_City
HAVING COUNT(*) >= 5
ORDER BY avg_price DESC;