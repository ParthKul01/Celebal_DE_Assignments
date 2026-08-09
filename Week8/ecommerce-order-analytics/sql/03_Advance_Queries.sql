-- ============================================================
-- E-COMMERCE ORDER ANALYTICS
-- ADVANCED SQL QUERIES
-- Window Functions, CTEs, LAG, LEAD, NTILE
-- ============================================================


-- ============================================================
-- QUERY 7
-- Running Total Of Revenue Per Region
-- Ordered By Date
--
-- Output:
-- region_code
-- order_date
-- daily_revenue
-- running_total
-- ============================================================

WITH daily_revenue AS (

    SELECT
        o.region_code,
        DATE(o.order_date) AS order_date,

        ROUND(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS daily_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.region_code,
        DATE(o.order_date)
)

SELECT
    region_code,
    order_date,
    daily_revenue,

    ROUND(
        SUM(daily_revenue) OVER (
            PARTITION BY region_code
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS running_total

FROM daily_revenue

ORDER BY
    region_code,
    order_date;


-- ============================================================
-- QUERY 8
-- Product Ranking Within Each Category
-- Using DENSE_RANK
--
-- Products With Same Revenue Get Same Rank
-- ============================================================

WITH product_revenue AS (

    SELECT
        p.category,
        p.product_id,
        p.product_name,

        ROUND(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ),
            2
        ) AS total_revenue

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    GROUP BY
        p.category,
        p.product_id,
        p.product_name
)

SELECT
    category,
    product_name,
    total_revenue,

    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS rank_in_category

FROM product_revenue

ORDER BY
    category,
    rank_in_category;


-- ============================================================
-- QUERY 9
-- LAG / LEAD Analysis
--
-- Calculate days between consecutive orders
-- For each customer.
-- Flag customers whose average gap > 30 days as At Risk.
-- ============================================================

WITH customer_orders AS (

    SELECT
        customer_id,
        DATE(order_date) AS order_date,

        LAG(
            DATE(order_date)
        ) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date

    FROM orders

    WHERE customer_id IS NOT NULL
),

order_gaps AS (

    SELECT
        customer_id,
        order_date,
        previous_order_date,

        CASE
            WHEN previous_order_date IS NOT NULL
            THEN CAST(
                JULIANDAY(order_date)
                - JULIANDAY(previous_order_date)
                AS INTEGER
            )
        END AS days_gap

    FROM customer_orders
),

customer_average_gap AS (

    SELECT
        customer_id,
        AVG(days_gap) AS average_gap

    FROM order_gaps

    WHERE days_gap IS NOT NULL

    GROUP BY customer_id
)

SELECT
    og.customer_id,
    og.order_date,
    og.previous_order_date,
    og.days_gap,

    CASE
        WHEN cag.average_gap > 30
        THEN 'At Risk'
        ELSE 'Active'
    END AS customer_status

FROM order_gaps og

JOIN customer_average_gap cag
    ON og.customer_id = cag.customer_id

ORDER BY
    og.customer_id,
    og.order_date;


-- ============================================================
-- QUERY 10
-- CTE With Multiple Levels
--
-- 1. Monthly revenue per customer
-- 2. Categorize customers:
--    High   > 10000
--    Medium 5000 - 10000
--    Low    < 5000
-- 3. Count customers in each category per month
-- ============================================================

WITH monthly_customer_revenue AS (

    SELECT
        o.customer_id,
        strftime(
            '%Y-%m',
            o.order_date
        ) AS order_month,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS monthly_revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.customer_id IS NOT NULL

    GROUP BY
        o.customer_id,
        order_month
),

customer_categories AS (

    SELECT
        customer_id,
        order_month,
        monthly_revenue,

        CASE
            WHEN monthly_revenue > 10000
                THEN 'High'

            WHEN monthly_revenue >= 5000
                 AND monthly_revenue <= 10000
                THEN 'Medium'

            ELSE 'Low'
        END AS revenue_category

    FROM monthly_customer_revenue
)

SELECT
    order_month,
    revenue_category,
    COUNT(DISTINCT customer_id)
        AS customer_count

FROM customer_categories

GROUP BY
    order_month,
    revenue_category

ORDER BY
    order_month,
    CASE revenue_category
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low' THEN 3
    END;


-- ============================================================
-- QUERY 11
-- NTILE Customer Segmentation
--
-- Divide customers into 4 quartiles based on
-- total lifetime value.
--
-- 1 = Platinum
-- 2 = Gold
-- 3 = Silver
-- 4 = Bronze
-- ============================================================

WITH customer_lifetime_value AS (

    SELECT
        c.customer_id,

        COALESCE(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ),
            0
        ) AS total_value

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_id
),

customer_quartiles AS (

    SELECT
        customer_id,
        ROUND(total_value, 2)
            AS total_value,

        NTILE(4) OVER (
            ORDER BY total_value DESC
        ) AS quartile

    FROM customer_lifetime_value
)

SELECT
    customer_id,
    total_value,
    quartile,

    CASE quartile
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        WHEN 4 THEN 'Bronze'
    END AS quartile_label

FROM customer_quartiles

ORDER BY quartile, total_value DESC;


-- ============================================================
-- QUERY 12
-- Year-Over-Year Revenue Comparison
--
-- Compare each month with the same month
-- in the previous year.
-- ============================================================

WITH monthly_revenue AS (

    SELECT
        strftime(
            '%Y',
            o.order_date
        ) AS year,

        strftime(
            '%m',
            o.order_date
        ) AS month,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ) AS revenue

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY
        year,
        month
),

revenue_with_previous_year AS (

    SELECT
        year,
        month,
        revenue,

        LAG(revenue, 12) OVER (
            ORDER BY year, month
        ) AS prev_year_revenue

    FROM monthly_revenue
)

SELECT
    year,
    month,

    ROUND(
        revenue,
        2
    ) AS revenue,

    ROUND(
        prev_year_revenue,
        2
    ) AS prev_year_revenue,

    CASE
        WHEN prev_year_revenue IS NULL
            THEN NULL

        WHEN prev_year_revenue = 0
            THEN NULL

        ELSE ROUND(
            (
                (revenue - prev_year_revenue)
                / prev_year_revenue
            ) * 100,
            2
        )
    END AS yoy_growth_percent

FROM revenue_with_previous_year

ORDER BY
    year,
    month;


-- ============================================================
-- QUERY 13
-- First / Last Purchased Category
--
-- Show first purchased category
-- and most recent purchased category.
--
-- Flag category shift as Yes / No.
-- ============================================================

WITH customer_category_orders AS (

    SELECT
        o.customer_id,
        DATE(o.order_date) AS order_date,
        p.category

    FROM orders o

    JOIN order_items oi
        ON o.order_id = oi.order_id

    JOIN products p
        ON oi.product_id = p.product_id

    WHERE o.customer_id IS NOT NULL
),

category_analysis AS (

    SELECT
        customer_id,

        FIRST_VALUE(category) OVER (
            PARTITION BY customer_id
            ORDER BY order_date ASC
        ) AS first_category,

        FIRST_VALUE(category) OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS recent_category

    FROM customer_category_orders
)

SELECT DISTINCT
    customer_id,
    first_category,
    recent_category,

    CASE
        WHEN first_category = recent_category
            THEN 'No'
        ELSE 'Yes'
    END AS category_shift

FROM category_analysis

ORDER BY customer_id;


-- ============================================================
-- QUERY 14
-- Cumulative Distribution / Revenue Concentration
--
-- Show:
-- customer_id
-- revenue
-- cumulative_revenue
-- cumulative_percent
--
-- This shows how much total revenue is generated
-- by the highest-value customers.
-- ============================================================

WITH customer_revenue AS (

    SELECT
        c.customer_id,

        COALESCE(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100.0)
            ),
            0
        ) AS revenue

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id

    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_id
),

ranked_customers AS (

    SELECT
        customer_id,
        revenue,

        SUM(revenue) OVER (
            ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(revenue) OVER () AS total_revenue

    FROM customer_revenue
)

SELECT
    customer_id,

    ROUND(
        revenue,
        2
    ) AS revenue,

    ROUND(
        cumulative_revenue,
        2
    ) AS cumulative_revenue,

    ROUND(
        100.0
        * cumulative_revenue
        / NULLIF(total_revenue, 0),
        2
    ) AS cumulative_percent

FROM ranked_customers

ORDER BY revenue DESC;