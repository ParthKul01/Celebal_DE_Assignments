# Indian Startup Funding Data Engineering Project

## Project Overview

The **Indian Startup Funding Data Engineering Project** is an end-to-end
cloud data engineering solution developed to ingest, process, validate,
transform, orchestrate, and analyze Indian startup funding data.

The project demonstrates a modern **Azure + Databricks Lakehouse
architecture** using the **Medallion Architecture**, with data flowing
through:

``` text
Source Data
    ↓
Azure Data Lake Storage Gen2
    ↓
Bronze Layer
    ↓
Silver Layer
    ↓
Gold Layer
    ↓
Databricks SQL Analytics
```

The solution uses **Azure Data Factory (ADF)** to orchestrate the data
pipeline, **Azure Data Lake Storage Gen2 (ADLS Gen2)** for cloud
storage, **Azure Databricks** and **PySpark/Python** for data
processing, **Delta Lake** for reliable data storage, and **Databricks
SQL** for analytical queries.

The project focuses on Indian startup funding information and produces
business-ready datasets for analyzing funding by industry, year, city,
investor, investment type, and other dimensions.

------------------------------------------------------------------------

## Architecture

``` text
                    INDIAN STARTUP FUNDING DATA
                              |
                              v
                  +--------------------------+
                  | Azure Data Lake Storage  |
                  |         Gen2             |
                  +------------+-------------+
                               |
                               v
                  +--------------------------+
                  |      BRONZE LAYER        |
                  | Raw / Ingested Data      |
                  +------------+-------------+
                               |
                               v
                  +--------------------------+
                  |      SILVER LAYER        |
                  | Cleaned & Validated Data |
                  +------------+-------------+
                               |
                               v
                  +--------------------------+
                  |       GOLD LAYER         |
                  | Business-Ready Data      |
                  +------------+-------------+
                               |
                               v
                  +--------------------------+
                  |     DATABRICKS SQL       |
                  |     Analytics & Reports   |
                  +--------------------------+


             AZURE DATA FACTORY ORCHESTRATION

                    Bronze_Layer
                         |
                         v
                    Silver_Layer
                         |
                         v
                     Gold_Layer
```

------------------------------------------------------------------------

## Technology Stack

  -----------------------------------------------------------------------
  Technology                          Purpose
  ----------------------------------- -----------------------------------
  Microsoft Azure                     Cloud platform

  Azure Data Factory                  Pipeline orchestration and
                                      scheduling

  Azure Data Lake Storage Gen2        Cloud-based data storage

  Azure Databricks                    Data engineering and transformation

  PySpark                             Distributed data processing

  Python                              Data processing and validation

  Delta Lake                          Reliable transactional data storage

  Databricks SQL                      Analytical querying

  SQL                                 Data analysis

  Unity Catalog / Databricks Catalog  Data organization and governance

  GitHub                              Source control and documentation
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 1. Azure Storage Layer

The project uses an Azure Storage Account named:

``` text
startupfundingstorage
```

The storage account contains the following containers:

``` text
startupfundingstorage
│
├── raw
├── bronze
├── silver
├── gold
└── $logs
```

### Raw Container

The `raw` container is used for the original/source startup funding
data.

``` text
raw
└── Source Startup Funding Data
```

The raw layer provides the initial landing location before the data is
processed through the Medallion Architecture.

### Bronze Container

The `bronze` container stores the ingested Bronze-layer data.

``` text
bronze
└── Bronze Data
```

### Silver Container

The `silver` container stores the cleaned and standardized Silver data.

``` text
silver
└── startup_funding
```

### Gold Container

The `gold` container stores the business-ready analytical datasets
generated from the Silver layer.

``` text
gold
├── top_funded_sectors
├── city_funding_ranking
├── sector_yearly_funding
├── sector_yoy_snapshot
├── investor_deal_count
├── average_deal_by_stage
└── SCD Type 2 related datasets
```

------------------------------------------------------------------------

# 2. Medallion Architecture

The project follows the **Medallion Architecture**, which separates data
processing into Bronze, Silver, and Gold layers.

## Bronze Layer

The Bronze Layer represents the raw or initially ingested version of the
source data.

### Responsibilities

-   Ingest source data
-   Preserve source-level information
-   Store the initial processed copy
-   Provide input for Silver-layer transformation
-   Maintain a clear separation between ingestion and transformation

``` text
Source Data
    ↓
Bronze Layer
```

------------------------------------------------------------------------

# 3. Silver Layer

The Silver Layer is responsible for cleaning, standardizing, validating,
and preparing the Bronze data for analytical processing.

The Silver notebook processes the startup funding data using
Databricks/PySpark.

### Main Silver-Layer Operations

-   Data ingestion from Bronze
-   Column standardization
-   Data type conversion
-   Date conversion
-   Funding year extraction
-   Data cleaning
-   Duplicate detection
-   Duplicate removal
-   Null validation
-   Schema validation
-   Delta Lake writing
-   Post-write validation

------------------------------------------------------------------------

## Silver Layer Schema

The final Silver dataset contains **9 columns**:

``` text
funding_date
funding_year
startup_name
industry_vertical
sub_vertical
city
investor_names
investment_type
amount_usd
```

### Data Types

``` text
funding_date      : date
funding_year      : integer
startup_name      : string
industry_vertical : string
sub_vertical      : string
city              : string
investor_names    : string
investment_type   : string
amount_usd        : double
```

------------------------------------------------------------------------

## Silver Layer Validation

The project includes explicit validation checks after Silver-layer
processing.

### Row Count

The processed Silver dataset contains:

``` text
Silver Rows: 1100
```

The Bronze and Silver row counts shown during validation are:

``` text
Bronze Rows: 1100
Silver Rows: 1100
```

### Column Count

``` text
Silver Columns: 9
```

### Duplicate Validation

The duplicate validation result is:

``` text
Total Rows      : 1100
Distinct Rows   : 1100
Duplicate Rows  : 0
```

Therefore:

``` text
0 duplicate records
```

were present in the validated Silver dataset.

### Null Validation

The project also performs a null-value validation across the Silver
dataset. The displayed validation output shows zero null values for the
validated columns.

### Schema Validation

The Silver schema is printed and validated after transformation to
confirm that the expected columns and data types are present before the
data is consumed by the Gold layer.

------------------------------------------------------------------------

# 4. Silver Delta Lake Storage

The Silver data is written in Delta format to Azure Data Lake Storage
Gen2.

The demonstrated Silver Delta path is:

``` text
abfss://silver@startupfundingstorage.dfs.core.windows.net/startup_funding
```

Delta Lake provides reliable storage for the processed dataset and
allows the downstream Gold-layer transformations to consume a consistent
Silver dataset.

------------------------------------------------------------------------

# 5. Gold Layer

The Gold Layer converts the validated Silver data into business-ready
analytical datasets.

The Gold layer is designed to answer business questions related to
startup funding trends.

The project includes analytical outputs covering:

1.  Top Funded Sectors
2.  City Funding Ranking
3.  Sector Yearly Funding
4.  Sector Year-over-Year Funding
5.  Investor Deal Count
6.  Average Deal by Stage
7.  Historical/SCD Type 2 analysis

------------------------------------------------------------------------

# 6. Gold Dataset - Top Funded Sectors

The `top_funded_sectors` dataset provides sector-level funding
statistics.

The dataset contains:

``` text
industry_vertical
total_funding_usd
deal_count
average_deal_usd
```

The demonstrated Databricks SQL query is:

``` sql
SELECT
    industry_vertical,
    total_funding_usd,
    deal_count,
    average_deal_usd
FROM my_workspace.gold.top_funded_sectors
ORDER BY total_funding_usd DESC;
```

The result can be used to identify the industries receiving the largest
amount of startup funding.

### Example Business Question

> Which startup sectors have received the highest total funding?

The demonstrated result contains sector-level records ordered by total
funding.

------------------------------------------------------------------------

# 7. Gold Dataset - City Funding Ranking

The City Funding Ranking dataset aggregates funding information by city.

This analysis can be used to identify:

-   Cities with high startup funding activity
-   Major startup ecosystems
-   Geographic concentration of funding
-   Funding distribution across Indian cities

### Example Business Question

> Which Indian cities have attracted the highest amount of startup
> funding?

------------------------------------------------------------------------

# 8. Gold Dataset - Sector Yearly Funding

The Sector Yearly Funding dataset analyzes funding by:

``` text
Industry Vertical
+
Funding Year
```

The project includes funding years such as:

``` text
2020
2021
2022
2023
2024
2025
```

This dataset enables analysis of how funding for different industries
changes over time.

### Example Business Question

> How has startup funding for each industry changed year by year?

------------------------------------------------------------------------

# 9. Gold Dataset - Sector Year-over-Year Funding

The project implements Year-over-Year funding analysis through:

``` text
my_workspace.gold.sector_yoy_snapshot
```

The demonstrated dataset contains:

``` text
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
```

This dataset compares current-year funding against the previous year.

## YoY Change Calculation

The dollar change is:

``` text
YoY Change USD =
Current Year Funding - Previous Year Funding
```

The percentage change is:

``` text
YoY Change Percentage =
(Current Year Funding - Previous Year Funding)
/
Previous Year Funding
× 100
```

This makes it possible to identify sectors that experienced funding
growth or decline.

------------------------------------------------------------------------

# 10. SCD Type 2

The project demonstrates **Slowly Changing Dimension Type 2 (SCD Type
2)** concepts in the Gold layer.

SCD Type 2 is used when historical versions of records need to be
preserved instead of simply overwriting previous values.

The dataset includes fields such as:

``` text
effective_from
effective_to
is_current
```

These columns provide information about the validity period of each
version of a record.

Conceptually:

``` text
Original Record
      |
      | Change
      v
Historical Version
      |
      | Change
      v
Current Version
```

A record can therefore contain:

``` text
effective_from
effective_to
is_current
```

The current active record can be identified using:

``` text
is_current = true
```

This approach allows historical analysis while retaining the latest
version.

------------------------------------------------------------------------

# 11. Gold Dataset - Investor Deal Count

The Investor Deal Count dataset focuses on investor activity.

It can be used to analyze:

-   Number of deals associated with investors
-   Investor participation
-   Investor activity across startup funding
-   Relative deal involvement

### Example Business Question

> Which investors are associated with the highest number of startup
> funding deals?

------------------------------------------------------------------------

# 12. Gold Dataset - Average Deal by Stage

The Average Deal by Stage dataset analyzes funding based on
investment/funding stage.

The analysis provides information about:

-   Funding stage
-   Number of deals
-   Average deal size

Conceptually:

``` text
Funding Stage
     |
     +----> Deal Count
     |
     +----> Average Deal Size
```

### Example Business Question

> Which investment stage has the highest average deal size?

------------------------------------------------------------------------

# 13. Databricks SQL Analytics

Databricks SQL is used to query the Gold datasets.

Example:

``` sql
SELECT
    industry_vertical,
    total_funding_usd,
    deal_count,
    average_deal_usd
FROM my_workspace.gold.top_funded_sectors
ORDER BY total_funding_usd DESC;
```

Year-over-Year analysis:

``` sql
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
```

These queries demonstrate how the Gold layer can be consumed directly
for business analytics.

------------------------------------------------------------------------

# 14. Databricks Catalog Structure

The project uses a Databricks workspace/catalog structure that includes:

``` text
my_workspace
│
├── default
│
├── gold
│
└── information_schema
```

The Gold schema contains the analytical datasets created during
Gold-layer processing.

------------------------------------------------------------------------

# 15. Azure Data Factory Pipeline

Azure Data Factory is used as the orchestration layer for the entire
project.

The main pipeline is:

``` text
IndianStartupFundingPipeline
```

The pipeline contains three Databricks Notebook activities:

``` text
Bronze_Layer
     |
     v
Silver_Layer
     |
     v
Gold_Layer
```

The activities are connected using successful-completion dependencies.

This ensures that the next layer is processed only after the previous
layer completes successfully.

------------------------------------------------------------------------

## ADF Pipeline Activities

  -----------------------------------------------------------------------
  Activity                Type                    Purpose
  ----------------------- ----------------------- -----------------------
  Bronze_Layer            Databricks Notebook     Ingest/process Bronze
                                                  data

  Silver_Layer            Databricks Notebook     Clean, standardize, and
                                                  validate data

  Gold_Layer              Databricks Notebook     Generate analytical
                                                  datasets
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 16. Pipeline Execution

The Azure Data Factory pipeline execution shown in the project completed
successfully.

The execution status was:

``` text
Bronze_Layer → Succeeded
Silver_Layer → Succeeded
Gold_Layer   → Succeeded
```

Therefore, the complete workflow successfully executed from Bronze
through Gold.

The ADF monitor also shows individual execution durations for the three
notebook activities.

------------------------------------------------------------------------

# 17. ADF Schedule Trigger

The project includes a schedule trigger:

``` text
Daily_Trigger
```

Trigger type:

``` text
Schedule
```

The trigger is used to automate pipeline execution according to the
configured schedule.

This allows the Bronze → Silver → Gold workflow to be executed
automatically without requiring manual execution every time.

------------------------------------------------------------------------

# 18. End-to-End Data Flow

The complete workflow is:

``` text
                START
                  |
                  v
        Startup Funding Data
                  |
                  v
        Azure Data Lake Storage
                  |
                  v
           +-------------+
           |   BRONZE    |
           +------+------+
                  |
                  v
           +-------------+
           |   SILVER    |
           +------+------+
                  |
        +---------+---------+
        |         |         |
     Cleaning  Validation  Schema
        |         |         |
        +---------+---------+
                  |
                  v
           +-------------+
           |    GOLD     |
           +------+------+
                  |
       +----------+----------+
       |          |          |
     Sector     City      Investor
    Analysis   Analysis   Analysis
       |
       +----> Yearly Funding
       |
       +----> YoY Analysis
       |
       +----> Average Deal
       |
       +----> SCD Type 2
                  |
                  v
          Databricks SQL
                  |
                  v
               ANALYTICS
```

------------------------------------------------------------------------

# 19. Data Quality Summary

The implemented Silver-layer validation produced the following results:

  Validation                                       Result
  ------------------- -----------------------------------
  Bronze Rows                                        1100
  Silver Rows                                        1100
  Silver Columns                                        9
  Distinct Rows                                      1100
  Duplicate Rows                                        0
  Null Validation       0 for displayed validated columns
  Schema Validation                            Successful

The validation demonstrates that the Silver layer contains the expected
row count, schema, and data quality characteristics.

------------------------------------------------------------------------

# 20. Project Folder Structure

A recommended project structure is:

``` text
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
│   ├── azure-storage/
│   ├── bronze-layer/
│   ├── silver-layer/
│   ├── gold-layer/
│   ├── databricks-sql/
│   └── adf-pipeline/
│
└── requirements.txt
```

The actual folder structure can be adjusted to match the files included
in the submitted project ZIP.

------------------------------------------------------------------------

# 21. Screenshots and Implementation Evidence

The project documentation includes screenshots covering the major
components of the implementation.

The screenshots demonstrate:

-   Azure Data Factory workspace
-   ADF pipeline design
-   Bronze notebook activity
-   Silver notebook activity
-   Gold notebook activity
-   Successful ADF pipeline execution
-   ADF Daily Trigger
-   Azure Storage Account
-   ADLS Gen2 containers
-   Bronze container
-   Silver container
-   Gold container
-   Databricks Bronze notebook
-   Databricks Silver notebook
-   Silver schema
-   Silver row count
-   Null validation
-   Duplicate validation
-   Delta storage
-   Databricks Gold SQL analysis
-   Top funded sector analysis

These screenshots serve as visual evidence of the implementation and
successful execution of the pipeline.

------------------------------------------------------------------------

# 22. Key Business Questions

The Gold datasets allow the following types of questions to be answered.

### Sector Analysis

Which startup industries have received the highest total funding?

### Geographic Analysis

Which cities have the highest startup funding activity?

### Yearly Analysis

How has funding changed across different years?

### Year-over-Year Analysis

Which industries experienced the largest increase or decrease in funding
compared with the previous year?

### Investor Analysis

Which investors are associated with the highest number of deals?

### Deal Analysis

Which investment stage has the highest average deal size?

### Historical Analysis

How did sector-level information change over time?

------------------------------------------------------------------------

# 23. Project Workflow Summary

The project can be summarized in the following stages:

## Stage 1 - Data Ingestion

Source startup funding data is made available in the Azure Data Lake
Storage environment.

## Stage 2 - Bronze Processing

The source data is ingested into the Bronze layer.

## Stage 3 - Silver Transformation

The Bronze data is cleaned and standardized.

Operations include:

-   Data type conversion
-   Date processing
-   Year extraction
-   Column standardization
-   Deduplication
-   Null validation
-   Schema validation

## Stage 4 - Delta Storage

The validated Silver data is written to Delta format in Azure Data Lake
Storage.

## Stage 5 - Gold Transformation

Business-level analytical datasets are generated.

## Stage 6 - SQL Analytics

Databricks SQL is used to query the Gold datasets.

## Stage 7 - Pipeline Orchestration

Azure Data Factory orchestrates:

``` text
Bronze → Silver → Gold
```

## Stage 8 - Scheduling

The Daily Trigger automates pipeline execution.

------------------------------------------------------------------------

# 24. Key Project Outcomes

The project demonstrates practical implementation of:

-   Cloud data engineering
-   Azure Data Lake Storage Gen2
-   Azure Data Factory
-   Azure Databricks
-   PySpark
-   Python
-   SQL
-   Delta Lake
-   Medallion Architecture
-   Data cleaning
-   Data standardization
-   Data validation
-   Duplicate detection
-   Null validation
-   Schema validation
-   SCD Type 2
-   Year-over-Year analysis
-   Sector analysis
-   City analysis
-   Investor analysis
-   Investment-stage analysis
-   Pipeline orchestration
-   Scheduled execution

------------------------------------------------------------------------

# 25. Future Enhancements

The project can be extended with additional data engineering and
analytics capabilities.

## Power BI Dashboard

Gold datasets can be connected to Power BI to create dashboards
containing:

-   Total funding
-   Funding by industry
-   Funding by city
-   Funding trends
-   Investor activity
-   Average deal size
-   Year-over-Year growth

## Incremental Processing

The pipeline can be extended to process only new or changed records.

``` text
New Data
   ↓
Incremental Processing
   ↓
Delta MERGE
   ↓
Updated Silver/Gold Data
```

## Advanced Data Quality

Additional rules can validate:

-   Invalid dates
-   Invalid funding years
-   Negative funding amounts
-   Missing startup names
-   Invalid investment types
-   Unexpected category values

## Monitoring and Alerting

The pipeline can be extended with notifications for:

-   Pipeline failures
-   Data quality failures
-   Unexpected row counts
-   Processing errors

## CI/CD

GitHub-based CI/CD can be introduced for automated deployment of:

-   Databricks notebooks
-   SQL scripts
-   ADF pipelines
-   Configuration files

------------------------------------------------------------------------

# 26. Learning Outcomes

This project provides hands-on experience with a complete cloud data
engineering workflow.

The major learning outcomes include:

1.  Understanding the Medallion Architecture.
2.  Working with Azure Data Lake Storage Gen2.
3.  Building Databricks notebooks for data processing.
4.  Using PySpark for transformations.
5.  Storing data using Delta Lake.
6.  Performing data quality checks.
7.  Implementing deduplication.
8.  Performing schema and null validation.
9.  Building analytical Gold datasets.
10. Performing SQL-based analytics.
11. Understanding SCD Type 2.
12. Building Azure Data Factory pipelines.
13. Creating dependencies between pipeline activities.
14. Scheduling data pipelines.
15. Understanding an end-to-end cloud data engineering architecture.

------------------------------------------------------------------------

# 27. Final Architecture

``` text
                         ┌─────────────────────────┐
                         │   Startup Funding Data  │
                         └────────────┬────────────┘
                                      │
                                      ▼
                    ┌──────────────────────────────┐
                    │ Azure Data Lake Storage Gen2  │
                    │                              │
                    │       Raw / Bronze           │
                    └──────────────┬───────────────┘
                                   │
                                   ▼
                         ┌──────────────────┐
                         │  Bronze Layer    │
                         │  Databricks      │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │  Silver Layer    │
                         │                  │
                         │ Cleaning         │
                         │ Standardization  │
                         │ Validation       │
                         │ Deduplication    │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │   Gold Layer     │
                         │                  │
                         │ Aggregations     │
                         │ Rankings         │
                         │ YoY Analysis     │
                         │ SCD Type 2       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Databricks SQL   │
                         │ Analytics        │
                         └──────────────────┘


                  ┌─────────────────────────────┐
                  │      Azure Data Factory     │
                  │                             │
                  │ Bronze → Silver → Gold      │
                  │                             │
                  │ Daily Trigger               │
                  └─────────────────────────────┘
```

------------------------------------------------------------------------

# 28. Conclusion

The **Indian Startup Funding Data Engineering Project** demonstrates an
end-to-end Azure-based data engineering pipeline for transforming
startup funding data into reliable, validated, and analytics-ready
datasets.

The solution combines:

``` text
Azure Data Lake Storage Gen2
          +
Azure Databricks
          +
PySpark / Python
          +
Delta Lake
          +
Databricks SQL
          +
Azure Data Factory
```

The Medallion Architecture separates the data into Bronze, Silver, and
Gold layers, making the pipeline easier to maintain, validate, and
consume.

The Silver layer successfully processes **1,100 records across 9
columns**, with validation showing **1,100 distinct records and 0
duplicate records**. The project also performs null and schema
validation.

The Gold layer converts the validated data into business-oriented
datasets for sector, city, investor, yearly, Year-over-Year,
investment-stage, and historical analysis.

Azure Data Factory provides orchestration through the:

``` text
Bronze_Layer
      ↓
Silver_Layer
      ↓
Gold_Layer
```

workflow, and the configured `Daily_Trigger` provides scheduled
execution.

Overall, this project demonstrates the complete journey from raw startup
funding data to cloud-based, validated, transformed, and business-ready
analytical data.

------------------------------------------------------------------------

# Author

## Parth Milind Kulkarni

**Computer Engineering Student \| Cloud & Data Engineering Enthusiast**

### Core Technologies

``` text
Microsoft Azure
Azure Data Factory
Azure Data Lake Storage Gen2
Azure Databricks
PySpark
Python
SQL
Delta Lake
SCD Type 2
Databricks SQL
GitHub
```

------------------------------------------------------------------------

# Project Highlights

``` text
✓ End-to-End Cloud Data Engineering
✓ Azure Data Lake Storage Gen2
✓ Azure Data Factory
✓ Azure Databricks
✓ Medallion Architecture
✓ Bronze / Silver / Gold Layers
✓ Delta Lake
✓ PySpark / Python
✓ Databricks SQL
✓ Data Cleaning
✓ Data Standardization
✓ Data Quality Validation
✓ Schema Validation
✓ Null Validation
✓ Duplicate Validation
✓ 1100 Silver Records
✓ 9 Silver Columns
✓ 0 Duplicate Records
✓ SCD Type 2
✓ Year-over-Year Funding Analysis
✓ Sector Funding Analysis
✓ City Funding Analysis
✓ Investor Deal Analysis
✓ Average Deal Analysis
✓ ADF Pipeline Orchestration
✓ Daily Pipeline Scheduling
```

------------------------------------------------------------------------

## License

This project is intended for educational, portfolio, and demonstration
purposes.
