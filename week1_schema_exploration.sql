-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 1: Schema Exploration — Learn the Database Before You Query It
-- Tables: All three tables
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Discover what tables exist in the database
SHOW TABLES; -- List all the table exist

SELECT TABLE_NAME, -- Select each table in the database
TABLE_ROWS, -- Return the approximate amount of rows per table
ROUND(DATA_LENGTH / 1024 / 1024, 2) AS size_mb -- The size of the table is currently in byte, so we convert it to megabyte, then round to two decimal places, the result will be stored in a new column
FROM INFORMATION_SCHEMA.TABLES -- Retrieve from the system database (data about the data) where it contains information about all databases
WHERE TABLE_SCHEMA = 'rets' -- Instead of retrieving from all databases, we want to filter to certain one only
ORDER BY TABLE_ROWS DESC; -- Sort the tables, so largest table (in term of rows) will be display first

-- 2. Understand the structure of the tables
DESCRIBE rets_property; -- Column overview

SELECT COLUMN_NAME, -- Each column from the table
DATA_TYPE, -- Data type of each column
IS_NULLABLE, -- See whether a column allow such values (yes and no)
CHARACTER_MAXIMUM_LENGTH -- The maximum number of characters a text column can store (so inapplicable to integer)
FROM INFORMATION_SCHEMA.COLUMNS -- Specify the data source (the metadata about all columns in all tables)
WHERE TABLE_SCHEMA = 'rets' -- Specify what schema to look into
AND TABLE_NAME = 'rets_property' -- Specify the table name within that schema
ORDER BY ORDINAL_POSITION; -- Sort the result by the column order within the table

-- 3. Run the quality check on the data before performing any cleaning
SELECT -- Read data, perform request, then return output
COUNT(*) AS total_rows, -- Count every row regardless of the type, and then store the result in a variable
SUM(CASE WHEN L_SystemPrice IS NULL THEN 1 ELSE 0 END) AS price_nulls, -- Count the total rows that have invalid values
SUM(CASE WHEN L_Keyword2 IS NULL THEN 1 ELSE 0 END) AS beds_nulls, -- Count the number of invalid beds from this column
SUM(CASE WHEN LM_Int2_3 IS NULL THEN 1 ELSE 0 END) AS sqft_nulls, -- Same idea
SUM(CASE WHEN L_City IS NULL THEN 1 ELSE 0 END) AS city_nulls -- Count missing city values
FROM rets_property; -- The table we retrieve data from

SELECT L_Status, -- This is the column I want to return
COUNT(*) AS total -- Count how many rows exist in each status group
FROM rets_property -- Table to retrieve
GROUP BY L_Status -- Group rows that share the same value
ORDER BY total DESC; -- Sort the output (number of row per group) from large to small

SELECT -- Read data, perform algorithm, then return output
MIN(L_SystemPrice) AS min_price, MAX(L_SystemPrice) AS max_price, -- See if the minimum and maximum price look realistic
MIN(L_Keyword2) AS min_beds, MAX(L_Keyword2) AS max_beds, -- Same for the bed
MIN(LM_Int2_3) AS min_sqft, MAX(LM_Int2_3) AS max_sqft -- Same idea to check square feet
FROM rets_property -- The table to analyze
WHERE L_SystemPrice IS NOT NULL; -- Filter rows before aggregation (only proceed with rows having valid price)

-- 4. Check for duplicate
SELECT COUNT(*) AS total_rows, -- Select and count all rows within the table
COUNT(DISTINCT L_DisplayId) AS distinct_ids, -- Count all unique values after removing duplicates
COUNT(*) - COUNT(DISTINCT L_DisplayId) AS duplicates -- Take the total rows subtract the unique values to get the total number of duplicates
FROM rets_property; -- Table to retrieve

SELECT L_DisplayId, COUNT(*) AS occurrences -- Take each identification, and count the number of time it appears
FROM rets_property -- Read the data from this table
GROUP BY L_DisplayId -- Group rows that have the same identification
HAVING COUNT(*) > 1 -- Only show group with identification appears more than 1
ORDER BY occurrences DESC -- Sort the number of duplicate from highest to lowest for each identification

-- 5. Verify relationship between table before performing any join
SELECT -- Return the calculated data
COUNT(DISTINCT L_DisplayId) AS distinct_listings, -- Count the number of unique listing in the table
COUNT(*) AS total_rows, -- Count all rows in the table
ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT L_DisplayId), 1) AS avg_rows_per_listing -- How many rows belong to each listing
FROM rets_openhouse; -- Table to retrieve

SELECT COUNT(*) AS listing_without_openhouse -- Count how many listing satisfy the condition
FROM rets_property p -- From which table
WHERE NOT EXISTS ( -- Only keep listing where open house does not exist
SELECT 1 FROM rets_openhouse o WHERE o.L_DisplayId = p.L_DisplayId -- Cross check between 2 table to see if a identification exists in both table, if not then return which house does not have matching record
);

-- 6. Figure out whether city names match between the two tables
SELECT DISTINCT L_City -- Select distinct city from a column given a table
FROM california_sold -- Table to retrieve from
WHERE L_City NOT IN ( -- Only keep the cities that are not in the other list
SELECT DISTINCT L_City FROM rets_property -- Retrieve the distinct cities from another table
WHERE L_City IS NOT NULL -- Only return valid
)
ORDER BY L_City -- Sort the cities alphabetically
LIMIT 20; -- Only show 20 results

-- Debug exercise
SELECT COUNT(*) AS missing_prices
FROM rets_property
WHERE L_SystemPrice = NULL; -- This is not a value so you cannot compare it with the equal sign