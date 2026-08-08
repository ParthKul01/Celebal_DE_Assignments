SHOW TABLES;

SHOW SCHEMAS IN my_workspace;

CREATE SCHEMA IF NOT EXISTS my_workspace.gold;

CREATE TABLE IF NOT EXISTS my_workspace.gold.top_funded_sectors
USING DELTA
LOCATION 'abfss://gold@startupfundingstorage.dfs.core.windows.net/top_funded_sectors';

CREATE TABLE IF NOT EXISTS my_workspace.gold.city_funding_rank
USING DELTA
LOCATION 'abfss://gold@startupfundingstorage.dfs.core.windows.net/city_funding_rank';

CREATE TABLE IF NOT EXISTS my_workspace.gold.sector_yoy_snapshot
USING DELTA
LOCATION 'abfss://gold@startupfundingstorage.dfs.core.windows.net/sector_yoy_snapshot';

CREATE TABLE IF NOT EXISTS my_workspace.gold.investor_deal_count
USING DELTA
LOCATION 'abfss://gold@startupfundingstorage.dfs.core.windows.net/investor_deal_count';

CREATE TABLE IF NOT EXISTS my_workspace.gold.avg_deal_by_stage
USING DELTA
LOCATION 'abfss://gold@startupfundingstorage.dfs.core.windows.net/avg_deal_by_stage';

SHOW TABLES IN my_workspace.gold;

SELECT *
FROM my_workspace.gold.top_funded_sectors
LIMIT 10;


-- Top Funded Sector 

SELECT
    industry_vertical,
    total_funding_usd,
    deal_count,
    average_deal_usd
FROM my_workspace.gold.top_funded_sectors
ORDER BY total_funding_usd DESC;

-- City Funding Ranking

SELECT
    city,
    total_funding_usd,
    deal_count,
    funding_rank
FROM my_workspace.gold.city_funding_rank
ORDER BY funding_rank;

-- Sector Year-Over-Year Funding 

SELECT
    industry_vertical,
    funding_year,
    total_funding_usd,
    previous_year_funding_usd,
    yoy_change_usd,
    yoy_change_percentage,
    deal_count,
    effective_from,
    effective_to,
    is_current
FROM my_workspace.gold.sector_yoy_snapshot
ORDER BY
    industry_vertical,
    funding_year;

-- Most Active Investors

SELECT
    investor,
    deal_count,
    total_investment_usd,
    average_deal_usd
FROM my_workspace.gold.investor_deal_count
ORDER BY deal_count DESC;


-- Average Deal Size by Funding Stage

SELECT
    funding_stage,
    average_deal_usd,
    deal_count,
    total_funding_usd
FROM my_workspace.gold.avg_deal_by_stage
ORDER BY average_deal_usd DESC;


SELECT
    industry_vertical,
    funding_year,
    total_funding_usd,
    previous_year_funding_usd,
    yoy_change_usd,
    yoy_change_percentage,
    effective_from,
    effective_to,
    is_current
FROM my_workspace.gold.sector_yoy_snapshot
ORDER BY industry_vertical, funding_year;