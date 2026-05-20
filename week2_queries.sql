-- ============================================================
-- IDX Exchange — Data Analyst Internship
-- Week 2: SELECT, WHERE & ORDER BY
-- Tables: rets_property
-- Author: Sonny Nguyen
-- ============================================================

-- 1. Select specific columns
SELECT L_DisplayId, L_Address, L_City, L_SystemPrice, -- Select specific columns
L_Keyword2, LM_Dec_3 -- Select some more columns
FROM rets_property -- The table to retrieve from
LIMIT 20; -- Limit to 20 rows

-- 2. Filtering before aggregation
SELECT L_DisplayId, L_Address, L_SystemPrice, L_Keyword2 -- Specify the columns we would like to take a look
FROM rets_property -- The table to retrieve the columns from
WHERE L_City = 'Portland' -- Filter to only keep columns that have rows match the requirement
LIMIT 20; -- Limit to certain results

SELECT L_Address, L_City, L_SystemPrice, L_Keyword2 -- Specify the columns
FROM rets_property -- Specify the table
WHERE L_Keyword2 >= 3 -- First condition, only keep the rows that have more than 3 bedrooms
AND L_SystemPrice < 700000 -- Second condition, keep only house that below that price
ORDER BY L_SystemPrice ASC; -- Order by smallest to largest

-- 3. Define the range and filter by keyword
SELECT L_Address, L_City, L_SystemPrice -- Specify the columns to return
FROM rets_property -- Table to retrieve
WHERE L_SystemPrice BETWEEN 400000 AND 600000 -- Define the range of the price to keep
ORDER BY L_SystemPrice; -- Default ascending (smallest to largest)

SELECT DISTINCT L_City -- Return the unique value of cities
FROM rets_property -- Table to retrieve
WHERE L_City LIKE 'San%'; -- Starting with that keyword, follow by 0 or more characters of any kind

-- 4. Classify invalid and valid values
SELECT L_DisplayId, L_Address, L_City -- Specify the columns to return
FROM rets_property -- Table to retrieve from
WHERE LM_Int2_3 IS NULL; -- Filter to only keep invalid values (missing square footage)

SELECT L_DisplayId, L_Address, L_City, LM_Int2_3 -- Columns to return
FROM rets_property -- Table to retrieve data from
WHERE LM_Int2_3 IS NOT NULL -- Only keep valid values (have square footage)
ORDER BY LM_Int2_3 DESC -- Order from largest to smallest
LIMIT 10; -- Keep it to certain amount

-- Debug exercise
SELECT L_Address, L_City, L_SystemPrice
FROM rets_property
WHERE L_City = Portland -- Missing quotation mark
AND L_SystemPrice IS NOT NULL
ORDER BY L_SystemPrice ASC
LIMIT '10'; -- Remove quotation mark