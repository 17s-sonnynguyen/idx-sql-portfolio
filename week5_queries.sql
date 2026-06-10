-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 5: Subqueries & CTEs
-- Tables: rets_property + california_sold
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Explore sold properties
SELECT City, -- For each city
COUNT(*) AS total_sold, -- Count the number of sold properties
ROUND(AVG(ClosePrice), 0) AS avg_sold_price, -- Calculate the average sold price
ROUND(AVG(ListPrice), 0) AS avg_list_price, -- Calculate the average list price
ROUND(AVG(ClosePrice / ListPrice) * 100, 1) AS avg_sale_to_list_pct -- Calculate the ratio between sold and list price
FROM california_sold -- Table to retrieve
WHERE ClosePrice IS NOT NULL AND ListPrice > 0 -- Filter to only keep the valid values
GROUP BY City -- Group city with the same name
HAVING COUNT(*) >= 10 -- Keep only cities with more than 10 sold properties
ORDER BY avg_sale_to_list_pct DESC -- Highest (at top) mean sold exactly at list price
LIMIT 20; -- Keep only 20 results

-- 2. Seasonal trends
SELECT YEAR(CloseDate) AS sale_year, -- For each year exist in the table
MONTH(CloseDate) AS sale_month, -- And for each month in the table
COUNT(*) AS homes_sold, -- Count the total house sold within that timeline
ROUND(AVG(ClosePrice), 0) AS avg_sold_price -- Calculate the average home value
FROM california_sold -- Table to retrieve
WHERE CloseDate IS NOT NULL -- Keep only valid
GROUP BY YEAR(CloseDate), MONTH(CloseDate) -- Group values with the same
ORDER BY sale_year, sale_month; -- Default order

-- Debug exercise
WITH historical AS (
SELECT City, ROUND(AVG(ClosePrice), 0) AS avg_sold
FROM california_sold
WHERE ClosePrice IS NOT NULL
GROUP BY City
)
SELECT p.L_City,
ROUND(AVG(p.L_SystemPrice), 0) AS avg_active_price,
h.avg_sold,
ROUND((AVG(p.L_SystemPrice) - h.avg_sold)
/ h.avg_sold * 100, 1) AS pct_diff_from_historical
FROM rets_property p
LEFT JOIN historical h ON p.L_City = h.City -- Should lowercase both side for matching
GROUP BY p.L_City, h.avg_sold
ORDER BY avg_active_price DESC;