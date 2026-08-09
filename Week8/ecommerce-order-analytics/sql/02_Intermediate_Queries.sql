-- ============================================================
-- E-COMMERCE ORDER ANALYTICS
-- INTERMEDIATE SQL QUERIES
-- ============================================================


-- ============================================================
-- QUERY 4
-- Customers Who Placed Orders But Never Had Any
-- Delivered Item
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.customer_id = c.customer_id
      AND o.status = 'DELIVERED'
)
ORDER BY c.customer_id;


-- ============================================================
-- QUERY 5
-- Products That Were Ordered But Had More Returns
-- Than Purchases
--
-- Negative quantity = return
-- Positive quantity = purchase
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(
        CASE
            WHEN oi.quantity > 0
            THEN oi.quantity
            ELSE 0
        END
    ) AS total_purchases,
    SUM(
        CASE
            WHEN oi.quantity < 0
            THEN ABS(oi.quantity)
            ELSE 0
        END
    ) AS total_returns
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING total_returns > total_purchases
ORDER BY total_returns DESC;


-- ============================================================
-- QUERY 6
-- Return Rate Per Category
--
-- Return Rate =
-- returned items / total items
-- ============================================================

SELECT
    p.category,

    SUM(
        CASE
            WHEN oi.quantity < 0
            THEN ABS(oi.quantity)
            ELSE 0
        END
    ) AS returned_items,

    SUM(
        ABS(oi.quantity)
    ) AS total_items,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN oi.quantity < 0
                THEN ABS(oi.quantity)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(ABS(oi.quantity)),
            0
        ),
        2
    ) AS return_rate_percent

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY p.category

ORDER BY return_rate_percent DESC;