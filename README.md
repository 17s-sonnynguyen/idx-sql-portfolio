# IDX Exchange — SQL Portfolio
SQL analysis of 40,000+ real estate MLS listings using MySQL and DBeaver.
## What I Analyzed
- Pricing trends across 50+ California cities
- Open house activity patterns by city and day of week
- Historical sold vs. active list price comparisons
- Advanced analytics using window functions and CTEs
## Key Findings
- [City X] has the highest price per sqft at $NNN/sqft
- [City Y] consistently sells above asking price (avg NNN% sale-to-list ratio)
- Saturday is the most popular open house day, accounting for NN% of all events
## Tools Used
- MySQL 8.0 (via Docker)
- DBeaver Community Edition
- GitHub
## How to Run
1. Start MySQL container: docker start idx-mysql-local
2. Open DBeaver and connect to localhost:3306 / rets / root
3. Open any .sql file in the DBeaver SQL Editor
4. Press Cmd+Enter / Ctrl+Enter to run
## Repository Structure
week1_schema_exploration.sql — Data quality and schema discovery
week2_queries.sql — SELECT, WHERE, ORDER BY
week3_queries.sql — Aggregations and GROUP BY
week4_queries.sql — JOINs across two tables
week5_queries.sql — Subqueries and CTEs
week6_queries.sql — Window functions
week7_final.sql — Final open-ended challenge
exports/ — CSV exports from DBeaver
