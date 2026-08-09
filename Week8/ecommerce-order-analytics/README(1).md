# E-Commerce Order Analytics System

## Intern Mini Project

An end-to-end data analytics system for processing, cleaning,
validating, storing, analyzing, and reporting e-commerce order data
using Python, Pandas, SQLite, and SQL.

------------------------------------------------------------------------

## 1. Project Overview

The E-Commerce Order Analytics System simulates a realistic business
data pipeline in which order information is received from multiple
sources and may contain missing values, invalid formats, inconsistent
text, invalid emails, returns, and referential-integrity problems.

The project builds a complete local analytics workflow:

``` text
Raw CSV Data
     |
     v
Python Data Generation
     |
     v
Intentional Data Inconsistencies
     |
     v
Pandas Data Cleaning & Validation
     |
     v
Cleaned CSV Files
     |
     v
SQLite Database
     |
     v
SQL Analytics
     |
     v
CLI Reporting Tool
     |
     v
Tests & Business Reports
```

The objective is to demonstrate practical skills in Python, Pandas, SQL,
database management, data validation, analytics, command-line
development, and problem solving.

------------------------------------------------------------------------

## 2. Project Objectives

The project is designed to:

-   Generate realistic e-commerce datasets.
-   Introduce intentional data-quality problems.
-   Clean and standardize the generated datasets.
-   Validate emails and referential integrity.
-   Preserve legitimate return transactions.
-   Load cleaned data into SQLite.
-   Perform basic, intermediate, and advanced SQL analysis.
-   Use joins, aggregations, CTEs, subqueries, and window functions.
-   Perform customer segmentation and cohort analysis.
-   Identify frequently purchased product combinations.
-   Build a command-line reporting application.
-   Handle invalid inputs and important edge cases.
-   Provide automated tests for data, database, and CLI functionality.

------------------------------------------------------------------------

## 3. Technologies Used

  -----------------------------------------------------------------------
  Technology                          Purpose
  ----------------------------------- -----------------------------------
  Python                              Data generation, cleaning,
                                      validation, database loading, CLI

  Pandas                              CSV processing and data cleaning

  Faker                               Realistic synthetic data generation

  SQLite                              Relational database

  SQL                                 Business analytics and reporting

  argparse                            Command-line argument handling

  sqlite3                             Python-to-SQLite integration

  pytest                              Automated testing

  VS Code                             Development environment

  DB Browser for SQLite               Database inspection and SQL
                                      execution

  Git / GitHub                        Version control and project
                                      submission
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 4. Dataset Design

The system uses four related CSV datasets.

### 4.1 Customers

File:

``` text
customers.csv
```

Important columns:

  Column              Description
  ------------------- ----------------------------
  customer_id         Unique customer identifier
  customer_name       Customer name
  email               Customer email
  registration_date   Customer registration date
  customer_type       REGULAR, PREMIUM, or VIP

------------------------------------------------------------------------

### 4.2 Products

File:

``` text
products.csv
```

Important columns:

  Column         Description
  -------------- ---------------------------
  product_id     Unique product identifier
  product_name   Product name
  category       Product category
  subcategory    Product subcategory
  cost_price     Product cost

Example categories include:

-   Electronics
-   Clothing
-   Home
-   Books

------------------------------------------------------------------------

### 4.3 Orders

File:

``` text
orders.csv
```

Important columns:

  Column        Description
  ------------- -------------------------------
  order_id      Unique order identifier
  customer_id   Customer who placed the order
  order_date    Date and time of order
  status        Order status
  region_code   Region associated with order

Supported statuses:

``` text
PLACED
SHIPPED
DELIVERED
CANCELLED
RETURNED
```

------------------------------------------------------------------------

### 4.4 Order Items

File:

``` text
order_items.csv
```

Important columns:

  Column             Description
  ------------------ ------------------------------
  item_id            Unique order-item identifier
  order_id           Related order
  product_id         Related product
  quantity           Number of units
  unit_price         Selling price
  discount_percent   Applied discount

Negative quantities represent legitimate return transactions.

------------------------------------------------------------------------

# 5. Intentional Data Issues

The raw datasets intentionally contain inconsistencies to simulate
real-world data.

The generated data includes:

### Missing Customer IDs

Approximately 5% of orders may contain a missing `customer_id`.

### Negative Quantities

Approximately 3% of order items may contain negative quantities.

Negative quantity values represent returns and should not automatically
be removed.

### Incorrect Date Formats

Some order dates are intentionally generated in:

``` text
DD-MM-YYYY
```

instead of:

``` text
YYYY-MM-DD HH:MM:SS
```

### Product Name Inconsistency

Some product names contain:

-   Leading spaces
-   Trailing spaces
-   Mixed capitalization

### Invalid Emails

Approximately 2% of customer emails are intentionally invalid.

Examples include missing:

``` text
@
```

or missing a valid domain.

### Referential Integrity Issues

Order-item records are checked against the orders table to identify
references to nonexistent orders.

------------------------------------------------------------------------

# 6. Data Generation

The data-generation process is implemented in:

``` text
scripts/generate_data.py
```

The script creates:

``` text
data/
└── raw/
    ├── customers.csv
    ├── products.csv
    ├── orders.csv
    └── order_items.csv
```

The generated data is designed to be realistic enough for SQL and
business analytics while still containing controlled inconsistencies for
the cleaning phase.

Run:

``` bash
python scripts/generate_data.py
```

------------------------------------------------------------------------

# 7. Data Cleaning and Validation

The cleaning pipeline is implemented in:

``` text
scripts/data_cleaning.py
```

The cleaning process performs operations such as:

-   Date format normalization.
-   Missing-value handling.
-   Product-name normalization.
-   Email validation.
-   Referential-integrity checks.
-   Data-type conversion.
-   Duplicate and primary-key validation.
-   Preservation of negative quantities as returns.

The cleaned files are written to:

``` text
data/
└── cleaned/
    ├── customers.csv
    ├── products.csv
    ├── orders.csv
    └── order_items.csv
```

A data-quality report is stored in:

``` text
reports/data_quality_report.txt
```

------------------------------------------------------------------------

# 8. Data Validation

The validation stage checks:

### Primary Keys

-   `customers.customer_id`
-   `products.product_id`
-   `orders.order_id`
-   `order_items.item_id`

### Referential Integrity

The relationship between:

``` text
orders.order_id
        |
        v
order_items.order_id
```

is validated.

### Email Validation

Invalid customer emails are identified and reported.

### Date Validation

Order dates are standardized and validated.

### Business Rules

Important business conditions such as negative quantities representing
returns are preserved.

------------------------------------------------------------------------

# 9. Database Layer

The SQLite database is created by:

``` text
scripts/database.py
```

Database location:

``` text
database/ecommerce.db
```

The database contains:

``` text
customers
products
orders
order_items
```

The relational structure is:

``` text
customers
    |
    | customer_id
    v
orders
    |
    | order_id
    v
order_items
    |
    | product_id
    v
products
```

This structure enables multi-table SQL analysis.

Run:

``` bash
python scripts/database.py
```

------------------------------------------------------------------------

# 10. SQL Analytics

The SQL analysis is organized into separate SQL files.

``` text
sql/
├── 01_basic_queries.sql
├── 02_intermediate_queries.sql
├── 03_advanced_queries.sql
├── 04_cohort_analysis.sql
└── 05_product_pair_analysis.sql
```

SQL scripts can be executed using DB Browser for SQLite or another
SQLite-compatible SQL environment.

------------------------------------------------------------------------

## 10.1 Basic Queries

The basic SQL analysis includes:

### Total Revenue Per Category

Revenue is calculated as:

``` text
quantity × unit_price × (1 - discount_percent / 100)
```

### Top 10 Customers

Customers are ranked by total order value.

### Month-Wise Order Count

Orders are grouped by month for trend analysis.

------------------------------------------------------------------------

# 11. Intermediate SQL Analysis

The intermediate queries include:

### Customers With Orders But No Delivered Item

Identifies customers who placed orders but never had a delivered item.

### Products With More Returns Than Purchases

Compares purchase quantities with returned quantities.

### Return Rate Per Category

The return rate is calculated as:

``` text
returned items / total items × 100
```

------------------------------------------------------------------------

# 12. Advanced SQL Analysis

The advanced SQL stage demonstrates several SQL concepts.

### Running Total

Revenue is accumulated over time for each region using window functions.

### Product Ranking

Products are ranked within each category using:

``` sql
DENSE_RANK()
```

Products with equal revenue receive the same rank.

### Customer Order Gap Analysis

Uses:

``` sql
LAG()
```

to compare consecutive customer orders.

Customers whose average order gap is greater than 30 days are flagged
as:

``` text
At Risk
```

### Multi-Level CTE

Monthly customer revenue is calculated and customers are categorized as:

``` text
High
Medium
Low
```

### Customer Segmentation

Customers are divided into four groups using:

``` sql
NTILE(4)
```

The groups are:

``` text
Platinum
Gold
Silver
Bronze
```

### Year-over-Year Analysis

Monthly revenue is compared with the same month in the previous year.

### First / Most Recent Purchased Category

The first and most recently purchased product categories are identified.

### Cumulative Revenue Distribution

The system calculates cumulative revenue and cumulative revenue
percentage to understand revenue concentration among customers.

------------------------------------------------------------------------

# 13. Cohort Analysis

The cohort analysis is implemented in:

``` text
sql/04_cohort_analysis.sql
```

Customers are grouped according to their registration month.

The analysis calculates:

-   Month 0 activity.
-   Month 1 activity.
-   Month 2 activity.
-   Month 3 activity.
-   Retention percentage for each month.

Conceptually:

``` text
Registration Month
       |
       +---- Month 0
       |
       +---- Month 1
       |
       +---- Month 2
       |
       +---- Month 3
```

Retention rate:

``` text
active customers in month N
-------------------------------- × 100
cohort size
```

This allows the business to understand customer retention behavior over
time.

------------------------------------------------------------------------

# 14. Frequently Bought Together Analysis

The product-pair analysis is implemented in:

``` text
sql/05_product_pair_analysis.sql
```

A self-join is used to identify products appearing in the same order.

The output contains:

``` text
product_a
product_b
times_bought_together
```

Duplicate combinations are avoided.

For example:

``` text
Product A + Product B
```

and:

``` text
Product B + Product A
```

are treated as one pair.

Same-product combinations are excluded.

This analysis can support:

-   Product bundling.
-   Cross-selling.
-   Recommendation systems.
-   Promotional campaigns.
-   Basket analysis.

------------------------------------------------------------------------

# 15. Command-Line Reporting Tool

The CLI application is implemented in:

``` text
scripts/cli.py
```

The CLI connects directly to:

``` text
database/ecommerce.db
```

and executes SQL-backed reports.

Current report commands include:

``` bash
python scripts/cli.py --report revenue
```

``` bash
python scripts/cli.py --report top_customers
```

``` bash
python scripts/cli.py --report retention
```

``` bash
python scripts/cli.py --report product_pairs
```

To run all available reports:

``` bash
python scripts/cli.py --report all
```

------------------------------------------------------------------------

## 15.1 Top Customer Limit

The CLI supports a configurable limit:

``` bash
python scripts/cli.py --report top_customers --limit 5
```

For example:

``` bash
python scripts/cli.py --report product_pairs --limit 20
```

------------------------------------------------------------------------

## 15.2 CLI Error Handling

The CLI handles situations such as:

-   Missing database file.
-   SQLite connection errors.
-   Invalid report names.
-   Invalid limits.
-   Empty query results.
-   SQL execution errors.

Example:

``` bash
python scripts/cli.py --report top_customers --limit 0
```

The application reports that the limit must be greater than zero rather
than silently producing an invalid result.

------------------------------------------------------------------------

# 16. Testing

Automated tests are stored in:

``` text
tests/
```

Current test modules include:

``` text
tests/
├── test_database.py
├── test_data_quality.py
├── test_cli.py
└── test_edge_cases.py
```

The tests cover:

### Database Tests

-   Database existence.
-   Required table existence.
-   Non-empty tables.
-   Foreign-key validation.

### Data Quality Tests

-   Cleaned file existence.
-   Primary-key uniqueness.
-   Required columns.
-   Basic data integrity.

### CLI Tests

-   Revenue report.
-   Top customer report.
-   Retention report.
-   Product-pair report.
-   Invalid limit handling.
-   Invalid report handling.

Run all tests with:

``` bash
pytest
```

A successful test run confirms that the implemented components are
functioning as expected.

------------------------------------------------------------------------

# 17. Reports

Generated and supporting reports are stored under:

``` text
reports/
```

Recommended files include:

``` text
reports/
├── data_quality_report.txt
├── revenue_report.txt
├── top_customers_report.txt
├── retention_report.txt
├── product_pairs_report.txt
└── cli_summary_report.txt
```

These files provide human-readable documentation of data-quality
findings and analytical outputs.

------------------------------------------------------------------------

# 18. Project Structure

``` text
ecommerce-order-analytics/
│
├── data/
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── products.csv
│   │   ├── orders.csv
│   │   └── order_items.csv
│   │
│   └── cleaned/
│       ├── customers.csv
│       ├── products.csv
│       ├── orders.csv
│       └── order_items.csv
│
├── database/
│   └── ecommerce.db
│
├── reports/
│   ├── data_quality_report.txt
│   ├── revenue_report.txt
│   ├── top_customers_report.txt
│   ├── retention_report.txt
│   ├── product_pairs_report.txt
│   └── cli_summary_report.txt
│
├── scripts/
│   ├── generate_data.py
│   ├── data_cleaning.py
│   ├── database.py
│   └── cli.py
│
├── sql/
│   ├── 01_basic_queries.sql
│   ├── 02_intermediate_queries.sql
│   ├── 03_advanced_queries.sql
│   ├── 04_cohort_analysis.sql
│   └── 05_product_pair_analysis.sql
│
├── tests/
│   ├── test_database.py
│   ├── test_data_quality.py
│   ├── test_cli.py
│   └── test_edge_cases.py
│
├── requirements.txt
└── README.md
```

------------------------------------------------------------------------

# 19. Installation

Create and activate a Python virtual environment if desired.

### Windows

``` bash
python -m venv .venv
```

Activate it:

``` bash
.venv\Scripts\activate
```

Install dependencies:

``` bash
pip install -r requirements.txt
```

The main external packages used by the project are:

``` text
pandas
faker
pytest
```

SQLite is provided through Python's standard library.

------------------------------------------------------------------------

# 20. Complete Execution Workflow

The complete project can be executed in the following order.

## Step 1 --- Generate Data

``` bash
python scripts/generate_data.py
```

This creates the raw CSV files.

------------------------------------------------------------------------

## Step 2 --- Clean and Validate Data

``` bash
python scripts/data_cleaning.py
```

This creates cleaned CSV files and the data-quality report.

------------------------------------------------------------------------

## Step 3 --- Build SQLite Database

``` bash
python scripts/database.py
```

This loads the cleaned datasets into:

``` text
database/ecommerce.db
```

------------------------------------------------------------------------

## Step 4 --- Execute SQL Analysis

Open:

``` text
database/ecommerce.db
```

in DB Browser for SQLite.

Execute:

``` text
sql/01_basic_queries.sql
sql/02_intermediate_queries.sql
sql/03_advanced_queries.sql
sql/04_cohort_analysis.sql
sql/05_product_pair_analysis.sql
```

------------------------------------------------------------------------

## Step 5 --- Run CLI Reports

Revenue:

``` bash
python scripts/cli.py --report revenue
```

Top customers:

``` bash
python scripts/cli.py --report top_customers
```

Retention:

``` bash
python scripts/cli.py --report retention
```

Product pairs:

``` bash
python scripts/cli.py --report product_pairs
```

All reports:

``` bash
python scripts/cli.py --report all
```

------------------------------------------------------------------------

## Step 6 --- Run Tests

``` bash
pytest
```

------------------------------------------------------------------------

# 21. Business Insights Supported By the System

The system can be used to answer important business questions.

### Revenue

-   Which product category generates the most revenue?
-   How does revenue change over time?
-   Which regions contribute the most revenue?

### Customers

-   Who are the highest-value customers?
-   Which customers may be at risk because of long ordering gaps?
-   Which customers belong to Platinum, Gold, Silver, or Bronze
    segments?

### Products

-   Which products generate the highest revenue?
-   Which products have unusually high return volumes?
-   Which products are frequently purchased together?

### Retention

-   How many customers return after registration?
-   Which registration cohorts retain customers better?
-   How does retention change from month 0 to month 3?

### Revenue Concentration

-   What percentage of revenue is generated by the highest-value
    customers?
-   Is the business heavily dependent on a small customer segment?

------------------------------------------------------------------------

# 22. Edge Cases

The system considers important real-world edge cases.

### Missing Customer ID

Orders with missing customer identifiers are handled during cleaning and
excluded or treated appropriately in customer-level analytics.

### Invalid Emails

Invalid email addresses are identified and reported.

### Negative Quantity

Negative quantity is treated as a return transaction rather than simply
being deleted.

### Invalid Order References

Order-item records referencing nonexistent orders are detected during
referential-integrity validation.

### Zero Quantity

Zero quantity records are considered invalid or require explicit
handling during validation.

### Discount Greater Than 100

Discount values above 100% violate the business rule and should be
identified during validation.

### Future Order Dates

Order dates in the future are treated as invalid business data and
should be identified during validation.

### Empty Query Results

The CLI displays a clear message instead of crashing when a report has
no results.

### Missing Database

The CLI checks whether the SQLite database exists before attempting a
connection.

------------------------------------------------------------------------

# 23. Reproducibility

The project is designed so that another developer can reproduce the
complete pipeline.

Starting from the project root:

``` bash
python scripts/generate_data.py
python scripts/data_cleaning.py
python scripts/database.py
pytest
python scripts/cli.py --report all
```

The SQL scripts can then be executed against:

``` text
database/ecommerce.db
```

------------------------------------------------------------------------

# 24. Key SQL Concepts Demonstrated

This project demonstrates practical SQL concepts including:

-   SELECT
-   WHERE
-   GROUP BY
-   HAVING
-   ORDER BY
-   LIMIT
-   INNER JOIN
-   LEFT JOIN
-   SELF JOIN
-   CASE
-   EXISTS
-   NOT EXISTS
-   Subqueries
-   Common Table Expressions
-   Window Functions
-   SUM OVER
-   LAG
-   LEAD
-   DENSE_RANK
-   NTILE
-   FIRST_VALUE
-   Date functions
-   Conditional aggregation
-   Cohort analysis

------------------------------------------------------------------------

# 25. Key Python Concepts Demonstrated

The project demonstrates:

-   File handling.
-   CSV processing.
-   Pandas DataFrames.
-   Data type conversion.
-   Missing-value handling.
-   String normalization.
-   Date parsing.
-   Validation functions.
-   SQLite connections.
-   SQL execution from Python.
-   Command-line argument parsing.
-   Exception handling.
-   Automated testing.
-   Modular Python functions.

------------------------------------------------------------------------

# 26. Final Outcome

The completed system provides an end-to-end analytics workflow:

``` text
             REALISTIC RAW DATA
                    |
                    v
          DATA GENERATION
                    |
                    v
          INTENTIONAL ISSUES
                    |
                    v
       PANDAS CLEANING & VALIDATION
                    |
                    v
             CLEAN CSV DATA
                    |
                    v
             SQLITE DATABASE
                    |
                    v
             SQL ANALYTICS
                    |
          +---------+---------+
          |         |         |
          v         v         v
       Revenue   Customer   Product
       Analysis  Analysis   Analysis
          |         |         |
          +---------+---------+
                    |
                    v
             CLI REPORTING
                    |
                    v
               TESTING
                    |
                    v
             BUSINESS INSIGHTS
```

The project demonstrates how raw operational data can be transformed
into reliable analytical information through a structured
data-engineering and analytics pipeline.

------------------------------------------------------------------------

# 27. Author

**Project:** E-Commerce Order Analytics System

**Type:** Intern Mini Project

**Primary Skills:** Python, Pandas, SQL, SQLite, Data Cleaning, Data
Validation, Data Analytics, CLI Development, Testing

------------------------------------------------------------------------

## Conclusion

This project combines Python programming, data cleaning, database
design, SQL analytics, command-line reporting, and automated testing
into a single end-to-end e-commerce analytics system.

The final architecture separates data generation, data preparation,
database management, SQL analysis, reporting, and testing into
independent components, making the project easier to understand,
maintain, test, and extend.
