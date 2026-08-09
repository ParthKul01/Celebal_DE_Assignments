-- ============================================================
-- E-COMMERCE ORDER ANALYTICS
-- BASIC SQL QUERIES
-- ============================================================


-- ============================================================
-- QUERY 1
-- Total Revenue Per Category
--
-- Revenue =
-- quantity * unit_price * (1 - discount_percent / 100)
-- ============================================================

SELECT
    p.category,
    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ),
        2
    ) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 2
-- Top 10 Customers By Total Order Value
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100.0)
        ),
        2
    ) AS total_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_order_value DESC
LIMIT 10;


-- ============================================================
-- QUERY 3
-- Month-Wise Order Count For The Last 12 Months
-- ============================================================

SELECT
    strftime('%Y-%m', order_date) AS order_month,
    COUNT(*) AS order_count
FROM orders
WHERE order_date >= date('now', '-12 months')
GROUP BY order_month
ORDER BY order_month;