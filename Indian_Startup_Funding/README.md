Indian Startup Funding Data Engineering Project
📌 Project Overview

The Indian Startup Funding Data Engineering Project is an end-to-end cloud data engineering pipeline designed to ingest, clean, transform, store, orchestrate, and analyze Indian startup funding data.

The project demonstrates a modern Azure + Databricks Lakehouse architecture using the Medallion Architecture, consisting of:

🥉 Bronze Layer – Raw data ingestion
🥈 Silver Layer – Data cleaning, standardization, validation, and deduplication
🥇 Gold Layer – Business-level aggregations and analytical datasets

The pipeline is orchestrated using Azure Data Factory (ADF), while Azure Data Lake Storage Gen2 (ADLS Gen2) is used for cloud-based data storage and Databricks Delta Lake is used for reliable data processing and storage.

The final Gold datasets are queried using Databricks SQL to generate business insights such as:

Top funded startup sectors
City-wise funding rankings
Year-wise sector funding
Year-over-year funding changes
Investor deal counts
Average deal size
Funding-stage analysis
Slowly Changing Dimension (SCD) Type 2 snapshots
🏗️ Architecture
                    ┌──────────────────────────┐
                    │     Startup Funding      │
                    │       Source Data        │
                    └────────────┬─────────────┘
                                 │
                                 ▼
                    ┌──────────────────────────┐
                    │ Azure Data Lake Storage   │
                    │        ADLS Gen2         │
                    │                          │
                    │ raw / bronze / silver    │
                    │          / gold          │
                    └────────────┬─────────────┘
                                 │
                                 ▼
                    ┌──────────────────────────┐
                    │       Databricks         │
                    │                          │
                    │  Data Processing Engine   │
                    │      + Delta Lake        │
                    └────────────┬─────────────┘
                                 │
             ┌───────────────────┼───────────────────┐
             │                   │                   │
             ▼                   ▼                   ▼
      ┌────────────┐      ┌────────────┐      ┌────────────┐
      │   Bronze   │ ───► │   Silver   │ ───► │    Gold    │
      │    Layer   │      │    Layer   │      │    Layer   │
      └────────────┘      └────────────┘      └─────┬──────┘
                                                     │
                                                     ▼
                                           ┌──────────────────┐
                                           │  Databricks SQL  │
                                           │    Analytics     │
                                           └────────┬─────────┘
                                                    │
                                                    ▼
                                           Business Insights

                         ┌─────────────────────────────┐
                         │     Azure Data Factory       │
                         │      Pipeline Orchestration  │
                         │                             │
                         │ Bronze → Silver → Gold      │
                         └─────────────────────────────┘
☁️ Technology Stack
Technology	Purpose
Microsoft Azure	Cloud infrastructure
Azure Data Factory	Pipeline orchestration
Azure Data Lake Storage Gen2	Cloud data storage
Azure Databricks	Data engineering and transformation
Delta Lake	Reliable transactional data storage
Databricks SQL	Analytical queries
SQL	Data analysis and business reporting
Python / PySpark	Data processing and transformation
Unity Catalog / Databricks Catalog	Data governance and organization
GitHub	Source code and project documentation
📂 Azure Storage Architecture

The Azure Storage Account used in the project is:

startupfundingstorage

The storage account contains separate containers representing different stages of the data pipeline:

startupfundingstorage
│
├── raw
│
├── bronze
│
├── silver
│
├── gold
│
└── $logs
Container Responsibilities
raw

Contains the source/raw data before data engineering transformations.

raw
│
└── Source Startup Funding Data
bronze

Contains the ingested version of the source data.

bronze
│
└── Bronze Delta Data
silver

Contains cleaned and standardized data.

silver
│
└── startup_funding
gold

Contains business-ready analytical datasets.

gold
│
├── top_funded_sectors
├── city_funding_ranking
├── sector_yearly_funding
├── sector_yoy_snapshot
├── investor_deal_count
├── average_deal_by_stage
└── SCD Type 2 datasets
🥉 Bronze Layer

The Bronze Layer represents the first processing stage of the data pipeline.

Its primary purpose is to preserve the ingested data in a structured form before applying extensive business transformations.

Bronze Layer Responsibilities
Ingest source data
Preserve source-level information
Store data in the Bronze container
Prepare the dataset for Silver-layer processing
Provide a reliable intermediate layer

The Bronze Layer is connected to the downstream Silver Layer through the Databricks processing workflow.

🥈 Silver Layer

The Silver Layer is responsible for cleaning, standardizing, validating, and preparing the data for analytical processing.

The Silver processing shown in the project includes:

Column standardization
Data type handling
Date processing
Funding year extraction
Data cleaning
Deduplication
Null validation
Schema validation
Delta Lake storage
📊 Silver Layer Schema

The validated Silver dataset contains 9 columns:

funding_date
funding_year
startup_name
industry_vertical
sub_vertical
city
investor_names
investment_type
amount_usd
Data Types
funding_date      : date
funding_year      : integer
startup_name      : string
industry_vertical : string
sub_vertical      : string
city              : string
investor_names    : string
investment_type   : string
amount_usd        : double
🧹 Data Validation

The Silver Layer includes validation checks to ensure that the transformed dataset is suitable for downstream analytics.

Row Count

The Silver dataset contains:

Silver Rows: 1100
Column Count
Silver Columns: 9
Duplicate Validation

The project validates duplicate records.

Result:

Total Rows      : 1100
Distinct Rows   : 1100
Duplicate Rows  : 0

Therefore:

Duplicate records = 0
Null Validation

The screenshot shows the null validation result with zero null values across the displayed Silver columns.

This indicates that the cleaned Silver dataset passed the implemented null validation.

💾 Silver Delta Storage

The Silver dataset is stored as Delta data.

The demonstrated storage path is:

abfss://silver@startupfundingstorage.dfs.core.windows.net/startup_funding

This provides a persistent Delta-based Silver layer in Azure Data Lake Storage.

🥇 Gold Layer

The Gold Layer contains business-oriented datasets generated from the cleaned Silver data.

Instead of exposing raw or partially processed records, the Gold Layer organizes the data into datasets that are directly useful for analytical queries and reporting.

The project creates analytical datasets covering:

Top Funded Sectors
City Funding Ranking
Sector Yearly Funding
Sector Year-over-Year Funding
SCD Type 2 Current Snapshot
Investor Deal Count
Average Deal by Stage
SCD Type 2 Query Results
📈 Gold Dataset 1 — Top Funded Sectors

The top_funded_sectors dataset provides sector-level funding statistics.

The SQL query demonstrated in Databricks is based on:

SELECT
    industry_vertical,
    total_funding_usd,
    deal_count,
    average_deal_usd
FROM my_workspace.gold.top_funded_sectors
ORDER BY total_funding_usd DESC;
Metrics

The dataset contains:

industry_vertical
total_funding_usd
deal_count
average_deal_usd

This allows sectors to be ranked according to their total startup funding.

Example Business Question

Which industry sectors have received the highest total startup funding?

🏙️ Gold Dataset 2 — City Funding Ranking

The City Funding Ranking dataset aggregates startup funding by city.

It can be used to identify:

Cities receiving the highest funding
Funding concentration by location
Startup ecosystem strength by city
Example Business Question

Which Indian cities have attracted the largest amount of startup funding?

📅 Gold Dataset 3 — Sector Yearly Funding

The Sector Yearly Funding dataset analyzes funding at the intersection of:

Industry Vertical + Funding Year

This makes it possible to study how funding changes over time for individual sectors.

The data shown in the SQL output covers funding years such as:

2020
2021
2022
2023
2024
2025
Example Business Question

How did funding for a particular startup sector change from one year to another?

📊 Gold Dataset 4 — Sector Year-over-Year Funding

The project also implements a Year-over-Year funding analysis.

The demonstrated dataset:

my_workspace.gold.sector_yoy_snapshot

contains fields including:

industry_vertical
funding_year
total_funding_usd
previous_year_funding_usd
yoy_change_usd
yoy_change_percentage
deal_count
effective_from
effective_to
is_current
Example

For a sector, the dataset compares:

Current Year Funding
        │
        ▼
Previous Year Funding
        │
        ▼
YoY Change
        │
        ▼
YoY Percentage

This makes it possible to determine whether funding increased or decreased year-over-year.

📌 Example YoY Calculation

The conceptual calculation is:

YoY Change USD
=
Current Year Funding
-
Previous Year Funding

and:

YoY Change %
=
(Current Year Funding - Previous Year Funding)
/
Previous Year Funding
× 100

The Gold output contains both the absolute funding change and percentage change.

🔄 SCD Type 2 Implementation

The project demonstrates Slowly Changing Dimension Type 2 (SCD Type 2) concepts.

SCD Type 2 is used when historical changes need to be preserved instead of simply overwriting the previous value.

The Gold dataset contains fields such as:

effective_from
effective_to
is_current

These fields allow different versions of records to be tracked over time.

SCD Type 2 Structure

Conceptually:

Record Version 1
       │
       │ change
       ▼
Record Version 2
       │
       │ change
       ▼
Record Version 3

Each version can have:

effective_from
effective_to
is_current

The current version can be identified using:

is_current = true

while historical records retain their previous validity periods.

💼 Gold Dataset 5 — Investor Deal Count

The Investor Deal Count dataset analyzes investor participation.

It can be used to determine:

Number of deals associated with investors
Investor activity
Relative participation across funding records
Example Business Question

Which investors are associated with the highest number of startup funding deals?

💰 Gold Dataset 6 — Average Deal by Stage

The project also calculates average funding amounts based on funding/investment stage.

This allows analysis of:

Funding Stage
      ↓
Number of Deals
      ↓
Average Deal Size
Example Business Question

Which funding stage has the highest average deal size?

🧮 Databricks SQL Analytics

The Gold datasets are queried using Databricks SQL.

The project demonstrates SQL-based analysis of the processed Delta datasets.

Examples include:

SELECT
    industry_vertical,
    total_funding_usd,
    deal_count,
    average_deal_usd
FROM my_workspace.gold.top_funded_sectors
ORDER BY total_funding_usd DESC;

And:

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
🔐 Databricks Governance and Storage Access

The project also demonstrates Databricks configuration for accessing Azure Data Lake Storage.

The screenshots include:

Databricks workspace
ADLS connection
Storage credentials
External locations
Catalog configuration

This provides a governed mechanism for Databricks to access cloud storage.

The project uses the Databricks catalog structure:

my_workspace
│
├── gold
│
└── information_schema

The Gold catalog/schema contains the analytical datasets.

🔗 Azure Data Factory Pipeline

Azure Data Factory is used to orchestrate the complete data processing workflow.

The implemented pipeline is:

Bronze Layer
     │
     ▼
Silver Layer
     │
     ▼
Gold Layer

The ADF pipeline shown in the screenshots is:

IndianStartupFundingPipeline

It contains three Databricks Notebook activities:

┌──────────────┐
│ Bronze_Layer │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Silver_Layer │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Gold_Layer  │
└──────────────┘

The dependency between activities ensures that the downstream layer runs after the preceding layer completes successfully.

✅ ADF Pipeline Execution

The pipeline execution shown in the screenshots completed successfully.

The execution contains:

Activity	Type	Status
Bronze_Layer	Notebook	✅ Succeeded
Silver_Layer	Notebook	✅ Succeeded
Gold_Layer	Notebook	✅ Succeeded

This confirms the successful orchestration of:

Bronze → Silver → Gold
⏰ Pipeline Scheduling

The ADF pipeline also has a schedule trigger configured.

The screenshot shows:

Daily_Trigger
Type: Schedule

This allows the pipeline to be executed automatically according to the configured schedule rather than requiring manual execution every time.

🔄 End-to-End Data Flow

The complete project workflow can be summarized as:

              SOURCE DATA
                   │
                   ▼
        ┌─────────────────────┐
        │ Azure Data Lake     │
        │      RAW            │
        └──────────┬──────────┘
                   │
                   ▼
        ┌─────────────────────┐
        │    BRONZE LAYER     │
        │                     │
        │ Raw/Ingested Data   │
        └──────────┬──────────┘
                   │
                   ▼
        ┌─────────────────────┐
        │    SILVER LAYER     │
        │                     │
        │ Cleaning            │
        │ Standardization     │
        │ Validation          │
        │ Deduplication       │
        │ Schema Handling     │
        └──────────┬──────────┘
                   │
                   ▼
        ┌─────────────────────┐
        │     GOLD LAYER      │
        │                     │
        │ Business Analytics  │
        │ Aggregations        │
        │ SCD Type 2          │
        └──────────┬──────────┘
                   │
                   ▼
        ┌─────────────────────┐
        │   DATABRICKS SQL    │
        │                     │
        │ Analytical Queries  │
        └─────────────────────┘
📊 Data Quality Checks

Data quality validation is performed before the data moves into analytical processing.

The demonstrated validations include:

1. Row Count Validation
Bronze Rows : 1100
Silver Rows : 1100
2. Column Validation
Silver Columns : 9
3. Duplicate Validation
Total Rows     : 1100
Distinct Rows  : 1100
Duplicate Rows : 0
4. Null Validation

The Silver-layer validation output shows zero null values for the displayed columns.

5. Schema Validation

The Silver schema is explicitly displayed and validated.

🧱 Medallion Architecture

This project follows the Medallion Architecture.

Bronze
Purpose:
Raw / ingested data

Characteristics:
- Minimal transformation
- Preserves source information
- First processing layer
Silver
Purpose:
Cleaned and standardized data

Characteristics:
- Data type handling
- Standardization
- Deduplication
- Validation
- Data quality checks
Gold
Purpose:
Business-ready analytical data

Characteristics:
- Aggregations
- Rankings
- Yearly analysis
- YoY analysis
- Investor analysis
- Average deal analysis
- SCD Type 2
📁 Suggested Repository Structure

A recommended GitHub repository structure for this project is:

Indian-Startup-Funding-Data-Engineering/
│
├── README.md
│
├── data/
│   └── startup_funding.csv
│
├── notebooks/
│   ├── 01_Bronze_Layer
│   ├── 02_Silver_Layer
│   └── 03_Gold_Layer
│
├── sql/
│   ├── top_funded_sectors.sql
│   ├── city_funding_ranking.sql
│   ├── sector_yearly_funding.sql
│   ├── sector_yoy_analysis.sql
│   ├── investor_deal_count.sql
│   └── average_deal_by_stage.sql
│
├── adf/
│   └── IndianStartupFundingPipeline
│
├── screenshots/
│   ├── 01_Azure_Infrastructure/
│   ├── 02_Databricks_Setup_and_Governance/
│   ├── 03_Bronze_Layer/
│   ├── 04_Silver_Layer/
│   ├── 05_Gold_Layer/
│   ├── 06_SQL_Analytics/
│   └── 07_ADF_Pipeline/
│
└── requirements.txt

Adjust the repository structure above to match the actual files you commit to GitHub.

📸 Project Evidence

Screenshots documenting the implementation are included in the project evidence folder.

The screenshots demonstrate:

Azure Infrastructure
Azure Data Factory creation
Storage account configuration
Storage containers
Access/role configuration
Databricks
Databricks workspace
ADLS connection
Storage credential
External locations
Catalog configuration
Data Engineering
Bronze Layer processing
Silver Layer schema
Silver Layer validation
Duplicate validation
Null validation
Delta storage
Analytics
Top funded sectors
City funding ranking
Sector yearly funding
Sector YoY funding
Investor deal counts
Average deal size
SCD Type 2 output
Orchestration
Azure Data Factory pipeline
Bronze → Silver → Gold dependency
Successful pipeline execution
Daily trigger configuration
🎯 Key Project Outcomes

The project demonstrates an end-to-end cloud data engineering workflow capable of:

Building a cloud-based data lake architecture
Connecting Azure Data Lake Storage with Databricks
Implementing Medallion Architecture
Processing raw startup funding data
Cleaning and standardizing datasets
Performing data quality validation
Removing duplicate records
Validating null values
Defining structured schemas
Writing data using Delta Lake
Building business-level Gold datasets
Implementing SCD Type 2 concepts
Performing SQL-based analytics
Creating year-over-year funding analysis
Ranking sectors and cities
Analyzing investor activity
Calculating average deal sizes
Orchestrating notebooks through Azure Data Factory
Configuring scheduled pipeline execution
📈 Business Insights Enabled

The resulting Gold datasets allow analysts and decision-makers to answer questions such as:

Sector Analysis

Which startup sectors have received the most funding?

Geographic Analysis

Which cities have attracted the highest startup funding?

Time-Series Analysis

How has funding changed across different years?

YoY Analysis

Which sectors experienced the largest increase or decrease in funding?

Investor Analysis

Which investors participated in the highest number of deals?

Deal Analysis

Which funding stage has the highest average deal value?

Historical Analysis

How have sector-level records changed over time?

🚀 Future Enhancements

The project can be extended further with:

1. Power BI Dashboard

Connect Power BI to the Gold layer to create interactive dashboards for:

Funding by sector
Funding by city
Funding trends
Investor activity
Average deal size
YoY growth
2. Incremental Data Processing

Instead of processing the complete dataset every time, incremental processing can be implemented using:

New Records
     ↓
Incremental Processing
     ↓
Delta MERGE
3. Advanced Data Quality Framework

Additional checks can be introduced for:

Invalid dates
Negative funding amounts
Invalid years
Missing startup names
Invalid investment types
4. Monitoring and Alerting

ADF and Azure monitoring can be extended to send alerts when:

Pipeline Failed
       OR
Data Quality Failed
       OR
Unexpected Row Count
5. CI/CD

The project can be integrated with GitHub-based CI/CD to automate deployment of:

Databricks notebooks
SQL scripts
ADF pipelines
Configuration files
🧠 What This Project Demonstrates

This project demonstrates practical knowledge of:

Cloud Data Engineering
        ↓
Azure Data Lake Storage
        ↓
Databricks
        ↓
PySpark / Python
        ↓
Delta Lake
        ↓
Medallion Architecture
        ↓
Data Quality
        ↓
SCD Type 2
        ↓
SQL Analytics
        ↓
Azure Data Factory
        ↓
Pipeline Automation

It therefore represents a complete cloud-based data engineering pipeline, rather than only an isolated data analysis project.

🏁 Conclusion

The Indian Startup Funding Data Engineering Project demonstrates how raw startup funding data can be transformed into reliable, structured, and analytics-ready datasets using modern Azure data engineering technologies.

The implementation follows a layered architecture:

Raw Data
   ↓
Bronze
   ↓
Silver
   ↓
Gold
   ↓
SQL Analytics

Azure Data Factory provides orchestration, Azure Data Lake Storage provides cloud storage, Databricks performs data processing, Delta Lake provides the storage format for processed datasets, and Databricks SQL enables analytical exploration.

The successful ADF execution of the:

Bronze_Layer
      ↓
Silver_Layer
      ↓
Gold_Layer

pipeline demonstrates the complete flow from ingestion to business-ready analytics.

👨‍💻 Author

Parth Milind Kulkarni

Computer Engineering Student | Cloud & Data Engineering Enthusiast

Technologies
Azure
Azure Data Factory
Azure Data Lake Storage Gen2
Databricks
PySpark
Python
SQL
Delta Lake
SCD Type 2
GitHub
⭐ Project Highlights
✅ Azure Cloud Infrastructure
✅ ADLS Gen2 Data Lake
✅ Databricks Data Processing
✅ Medallion Architecture
✅ Bronze / Silver / Gold Layers
✅ Delta Lake
✅ Data Quality Validation
✅ 1100 Silver Records
✅ 9 Silver Columns
✅ 0 Duplicate Records
✅ Null Validation
✅ SCD Type 2
✅ Year-over-Year Funding Analysis
✅ Sector Analysis
✅ City Funding Analysis
✅ Investor Analysis
✅ Average Deal Analysis
✅ Databricks SQL
✅ Azure Data Factory
✅ Bronze → Silver → Gold Orchestration
✅ Daily Pipeline Trigger
