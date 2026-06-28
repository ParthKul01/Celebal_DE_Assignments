
## Week 2 Assignment - E-Commerce Sales Database Analysis

## Overview

This assignment focuses on analyzing an E-Commerce Sales Database using SQL. The objective is to understand how SQL can be used to retrieve, filter, summarize, and analyze business data to generate meaningful insights for decision-making.

The database consists of four relational tables representing customers, products, orders, and order items. Various SQL operations were performed to explore the data, analyze sales performance, and validate database integrity.

---

## Assignment Objectives

The main objectives of this assignment were:

- Create and load an E-Commerce Sales Database.
- Explore the database schema and verify the imported data.
- Perform data filtering using the WHERE clause.
- Use aggregate functions such as SUM(), COUNT(), AVG(), MIN(), and MAX().
- Apply GROUP BY and ORDER BY for data summarization.
- Perform business analysis using JOIN operations.
- Validate data quality and integrity.
- Generate meaningful business insights using SQL.

---

## Database Schema

The project consists of the following four tables:

### Customers
Stores customer information including:
- Customer ID
- Name
- Email
- City
- State
- Join Date
- Premium Membership Status

### Products
Stores product information including:
- Product ID
- Product Name
- Category
- Brand
- Unit Price
- Available Stock

### Orders
Stores order-related information including:
- Order ID
- Customer ID
- Order Date
- Order Status
- Total Amount

### Order Items
Stores product-level information for each order including:
- Item ID
- Order ID
- Product ID
- Quantity
- Unit Price
- Discount Percentage

---

## SQL Concepts Implemented

During this assignment, the following SQL concepts were implemented:

- Database Creation
- Table Creation
- Primary Keys
- Foreign Keys
- Constraints
- Data Insertion
- SELECT Statements
- WHERE Clause
- Aggregate Functions
- GROUP BY
- ORDER BY
- LIMIT
- INNER JOIN
- Data Validation
- Duplicate Detection

---

## Tasks Performed

### 1. Database Exploration

- Verified all tables.
- Examined table structures.
- Displayed sample data from each table.

Purpose:
To ensure that the database was created successfully and all records were inserted correctly.

---

### 2. Data Filtering

Filtered records based on:

- Order Status
- Product Category
- Product Price
- Customer State

Purpose:
To retrieve only the required business information from the database.

---

### 3. Data Aggregation

Performed calculations including:

- Total Revenue
- Average Product Price
- Total Orders
- Revenue by Order Status

Purpose:
To summarize business data and measure overall sales performance.

---

### 4. Sorting and Ranking

Sorted data to identify:

- Most Expensive Products
- Highest Spending Customers

Purpose:
To identify high-value products and customers.

---

### 5. Business Analysis

Used JOIN operations to analyze:

- Customer Purchases
- Best Selling Products
- Revenue by Product Category

Purpose:
To generate business insights from multiple related tables.

---

### 6. Data Validation

Performed validation by checking:

- Total Number of Records
- Duplicate Emails
- Invalid Product Prices

Purpose:
To ensure data accuracy and maintain database integrity.

---

## Business Insights

The SQL analysis provided several valuable insights:

- Delivered orders generated the highest overall revenue.
- Electronics products contributed significantly to sales.
- High-value customers were identified based on their total spending.
- Best-selling products were identified using order quantities.
- Revenue comparison across product categories helped determine the strongest-performing category.
- Database validation confirmed that no duplicate customer emails or invalid product prices existed.

---

## Technologies Used

- MySQL
- MySQL Workbench
- SQL

---

## Project Outcome

This assignment demonstrates how SQL can be used to perform real-world business analysis on an E-Commerce database. By applying filtering, aggregation, sorting, joins, and validation techniques, meaningful insights were generated to support better business decisions regarding sales, customers, products, and inventory.

---

## Conclusion

The E-Commerce Sales Database was successfully created and populated with sample data. SQL queries were used to explore the database, analyze sales trends, identify top-performing customers and products, and validate data quality. The assignment strengthened practical knowledge of SQL and demonstrated how relational databases can be used to solve real-world business problems efficiently.

---
