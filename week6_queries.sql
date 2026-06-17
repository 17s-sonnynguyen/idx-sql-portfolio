-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 6: Window Functions & Advanced Analytics
-- Tables: rets_property + california_sold
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Restart the calculation for each city
SELECT L_DisplayId, L_Address, L_City, L_SystemPrice, -- What columns to display, so 4 of them
ROUND(AVG(ListPrice) OVER (PARTITION BY L_City), 0) AS city_avg_price, -- Create a new column, calculate the average price of that city
ROUND(L_SystemPrice - AVG(L_SystemPrice) OVER -- Calculate the difference of actual listing to city average
(PARTITION BY L_City), 0) AS diff_from_city_avg, -- Round it
RANK() OVER ( -- Create a separate ranking for each city
PARTITION BY City ORDER BY ListPrice DESC -- From most expensive to cheapest
) AS rank_in_city -- New column
FROM rets_property -- Table to retrieve from
WHERE ListPrice IS NOT NULL -- Only keep the valid
ORDER BY L_City, rank_in_city LIMIT 30; -- Order

-- 2. Find price outlier
WITH city_stats AS ( -- Create a new table
SELECT City, -- For each city
AVG(ListPrice) AS city_avg, -- Calculate the average price
STDDEV(ListPrice) AS city_stddev -- Calculate the standard deviation
FROM rets_property -- Table to retrieve
WHERE ListPrice IS NOT NULL -- Only keep the valid
GROUP BY City HAVING COUNT(*) >= 5 -- Keep only cities with more than 5 listing
) -- Close new table
SELECT p.L_DisplayId, p.L_Address, p.L_City, p.L_SystemPrice, -- Columns to retrieve
ROUND(cs.city_avg, 0) AS city_avg_price, -- From the second table
ROUND(p.L_SystemPrice / cs.city_avg * 100, 1) AS pct_of_city_avg -- Price compare to the city average
FROM rets_property p -- First table abbreviation
JOIN city_stats cs ON p.L_City = cs.City -- Join with the second table
WHERE p.L_SystemPrice > cs.city_avg * 1.5 -- Detect outliers
ORDER BY pct_of_city_avg DESC LIMIT 20; -- Keep highest to lowest

-- 3. Sold price quartiles
WITH quartiles AS ( -- Create a temporary table
SELECT ClosePrice, City, -- Columns to retrieve
NTILE(4) OVER (ORDER BY ClosePrice) AS price_quartile -- Sort price lowest to highest, then divide them into 4 groups
FROM california_sold WHERE ClosePrice IS NOT NULL -- Table to retrieve, column to filter out
) -- Close it
SELECT price_quartile, -- For each of the quartile
COUNT(*) AS num_sold, -- Count the total of sold listings
ROUND(MIN(ClosePrice), 0) AS min_price, -- Find the cheapest listing, store in new column
ROUND(MAX(ClosePrice), 0) AS max_price, -- Same idea but most expensive listing
ROUND(AVG(ClosePrice), 0) AS avg_price -- Average price for that quartile
FROM quartiles -- Using the table created above
GROUP BY price_quartile ORDER BY price_quartile; -- Group and sort

-- 4. Running totals
WITH monthly AS ( -- Create a temporary table
SELECT DATE_FORMAT(ListingContractDate, '%Y-%m') AS list_month, -- Extract the year and month from that column
COUNT(*) AS new_listings -- Count the relevant new listings given that year and month
FROM rets_property WHERE ListingContractDate IS NOT NULL -- Specify
GROUP BY DATE_FORMAT(ListingContractDate, '%Y-%m') -- Example of grouping date
) -- Close
SELECT list_month, new_listings, -- Retrieve month (with year) and new listings
SUM(new_listings) OVER ( -- Window function to calculate the sum
ORDER BY list_month ROWS UNBOUNDED PRECEDING -- Start from the first row, and include up until the current row
) AS running_total -- Column name
FROM monthly ORDER BY list_month; -- Sort

-- Debug exercise
SELECT L_DisplayId, L_Address, City, ListPrice,
RANK() OVER (
PARTITION BY City ORDER BY ListPrice DESC
) AS rank_in_city
FROM rets_property
WHERE ListPrice IS NOT NULL
AND rank_in_city = 1 -- This will not work, we will need to wrap it within common table expression
ORDER BY City;