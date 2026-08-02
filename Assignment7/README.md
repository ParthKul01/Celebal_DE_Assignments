# Week 7 - Delta Lake MERGE Implementation

## Internship
**Organization:** Celebal Technologies

**Week:** 7

**Technology:** Databricks | PySpark | Delta Lake

---

# Assignment Overview

The objective of this assignment is to implement **incremental data processing** using **Delta Lake MERGE** on the Databricks platform.

In real-world data engineering projects, organizations continuously receive new or modified data instead of loading the complete dataset every time. Delta Lake provides the **MERGE** operation, which allows efficient updating of existing records and inserting new records into a Delta table.

This assignment demonstrates how Delta Lake simplifies incremental data loading while maintaining data consistency and minimizing processing time.

---

# Objective

The primary objectives of this assignment are:

- Load a CSV dataset into Databricks.
- Perform basic data cleaning.
- Convert the cleaned dataset into a Delta Table.
- Create an incremental dataset.
- Simulate updates and inserts.
- Perform Delta Lake MERGE operation.
- Validate the final output after merging.

---

# Technologies Used

- Databricks Community Edition
- Apache Spark (PySpark)
- Delta Lake
- Python
- Unity Catalog Volume

---

# Dataset Used

**Dataset Name:** Sample - Superstore.csv

The dataset contains retail sales information including:

- Order ID
- Order Date
- Ship Date
- Customer Details
- Product Details
- Sales
- Quantity
- Discount
- Profit

The dataset was uploaded into **Unity Catalog Volume** and accessed from Databricks for processing.

---

# Assignment Workflow

## Step 1 – Data Loading

The Superstore CSV dataset was uploaded into the Unity Catalog Volume.

The dataset was then loaded into a Spark DataFrame using:

- Header = True
- Infer Schema = True

This automatically detected the column names and appropriate data types.

---

## Step 2 – Data Cleaning

The following preprocessing operations were performed:

- Checked for null values.
- Removed rows containing null values using `dropna()`.
- Removed duplicate records using `dropDuplicates()`.
- Renamed column names by replacing spaces with underscores to make them compatible with Delta Lake.

Example:

```
Customer Name
```

became

```
Customer_Name
```

This avoids invalid column name errors while creating the Delta Table.

---

## Step 3 – Delta Table Creation

The cleaned DataFrame was stored as a managed Delta Table using:

```python
.saveAsTable("superstore_master")
```

This Delta Table acts as the **Master Dataset**, which stores the latest version of the data.

---

## Step 4 – Creating Incremental Dataset

To simulate incremental data processing:

- Five existing records were selected from the master table.
- One existing customer record was modified to simulate an update.
- One completely new record was created with a new Order ID.

This incremental dataset represents new incoming business data.

---

## Step 5 – Simulating Record Update

An existing record was modified.

The Customer Name of one existing Order ID was updated from:

```
Sean O'Donnell
```

to

```
Sean O'Donnell (Updated)
```

This demonstrates how Delta Lake updates existing records.

---

## Step 6 – Simulating New Record

A completely new record was created.

Example:

```
Order_ID = CA-2026-999999
Customer_Name = John Smith
```

This record does not exist in the master table and therefore will be inserted during the MERGE operation.

---

## Step 7 – Delta Lake MERGE Operation

The incremental dataset was merged into the master Delta Table using the Delta Lake MERGE command.

MERGE performs two operations simultaneously:

### Update

If the Order ID already exists,

→ Update the existing record.

### Insert

If the Order ID does not exist,

→ Insert the record into the Delta Table.

This makes incremental processing efficient without reloading the complete dataset.

---

## Step 8 – Validation

After executing the MERGE operation, the following validations were performed:

### Updated Record Verification

Verified that the existing customer record was successfully updated.

---

### Inserted Record Verification

Verified that the new Order ID was successfully inserted.

---

### Row Count Validation

Compared the total number of rows before and after MERGE.

Example:

```
Rows Before Merge : 9994

Rows After Merge : 9995
```

The increase in row count confirms successful insertion of the new record.

---

### Final Delta Table

Displayed the final Delta Table to verify that both updates and inserts were correctly reflected.

---

# Folder Structure

```
delta-lake-assignment/

│── data/
│      Sample - Superstore.csv
│
│── notebooks/
│      delta_merge_assignment.ipynb
│
│── screenshots/
│
│      data_loading/
│
│      data_cleaning/
│
│      scd1/
│
│      scd2/
│
│      validation/
│
│      final_output/
│
│── report/
│      Week7_Delta_Lake_MERGE_Report.docx
│
└── README.md
```

---

# Screenshots Included

The repository contains screenshots for every major step:

- Dataset Loading
- Data Cleaning
- Delta Table Creation
- Incremental Dataset
- Updated Record
- Newly Created Record
- MERGE Execution
- Updated Record Verification
- Inserted Record Verification
- Row Count Validation
- Final Delta Table

---

# Learning Outcomes

Through this assignment, the following concepts were understood and implemented:

- Reading CSV files in Databricks
- Data Cleaning using PySpark
- Delta Table Creation
- Managed Delta Tables
- Unity Catalog Volume
- Incremental Data Processing
- Delta Lake MERGE
- Update Existing Records
- Insert New Records
- Data Validation after MERGE

---

# Conclusion

This assignment successfully demonstrated the implementation of **Delta Lake MERGE** for incremental data processing using Databricks.

A master Delta Table was created from the cleaned Superstore dataset. An incremental dataset containing updated and new records was prepared and merged into the master table using Delta Lake MERGE.

The final validation confirmed that:

- Existing records were updated successfully.
- New records were inserted successfully.
- Row count increased appropriately after insertion.
- The final Delta Table contained the latest version of the dataset.

This assignment highlights how Delta Lake enables efficient and reliable incremental data processing, making it an essential technology for modern Data Engineering pipelines.
