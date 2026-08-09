-- ============================================================
-- E-COMMERCE ORDER ANALYTICS
-- COHORT ANALYSIS
-- ============================================================


-- ============================================================
-- QUERY 15
-- Customer Cohort Analysis
--
-- Month 0 = Registration month
-- Month 1 = One month after registration
-- Month 2 = Two months after registration
-- Month 3 = Three months after registration
-- ============================================================

WITH customer_cohorts AS (

    SELECT
        customer_id,

        DATE(
            registration_date,
            'start of month'
        ) AS cohort_month

    FROM customers
),

customer_orders AS (

    SELECT
        o.customer_id,

        DATE(
            o.order_date,
            'start of month'
        ) AS order_month

    FROM orders o

    WHERE o.customer_id IS NOT NULL

    GROUP BY
        o.customer_id,
        order_month
),

cohort_activity AS (

    SELECT
        cc.customer_id,
        cc.cohort_month,
        co.order_month,

        (
            (
                CAST(
                    strftime(
                        '%Y',
                        co.order_month
                    ) AS INTEGER
                )
                -
                CAST(
                    strftime(
                        '%Y',
                        cc.cohort_month
                    ) AS INTEGER
                )
            ) * 12
            +
            (
                CAST(
                    strftime(
                        '%m',
                        co.order_month
                    ) AS INTEGER
                )
                -
                CAST(
                    strftime(
                        '%m',
                        cc.cohort_month
                    ) AS INTEGER
                )
            )
        ) AS month_number

    FROM customer_cohorts cc

    JOIN customer_orders co
        ON cc.customer_id = co.customer_id
),

cohort_sizes AS (

    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id)
            AS cohort_size

    FROM customer_cohorts

    GROUP BY cohort_month
),

retention_counts AS (

    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id)
            AS active_customers

    FROM cohort_activity

    WHERE month_number BETWEEN 0 AND 3

    GROUP BY
        cohort_month,
        month_number
)

SELECT
    rc.cohort_month,
    cs.cohort_size,

    MAX(
        CASE
            WHEN rc.month_number = 0
            THEN rc.active_customers
            ELSE 0
        END
    ) AS month_0_customers,

    MAX(
        CASE
            WHEN rc.month_number = 1
            THEN rc.active_customers
            ELSE 0
        END
    ) AS month_1_customers,

    MAX(
        CASE
            WHEN rc.month_number = 2
            THEN rc.active_customers
            ELSE 0
        END
    ) AS month_2_customers,

    MAX(
        CASE
            WHEN rc.month_number = 3
            THEN rc.active_customers
            ELSE 0
        END
    ) AS month_3_customers,

    ROUND(
        100.0
        * MAX(
            CASE
                WHEN rc.month_number = 0
                THEN rc.active_customers
                ELSE 0
            END
        )
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_0_retention_percent,

    ROUND(
        100.0
        * MAX(
            CASE
                WHEN rc.month_number = 1
                THEN rc.active_customers
                ELSE 0
            END
        )
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_1_retention_percent,

    ROUND(
        100.0
        * MAX(
            CASE
                WHEN rc.month_number = 2
                THEN rc.active_customers
                ELSE 0
            END
        )
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_2_retention_percent,

    ROUND(
        100.0
        * MAX(
            CASE
                WHEN rc.month_number = 3
                THEN rc.active_customers
                ELSE 0
            END
        )
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_3_retention_percent

FROM retention_counts rc

JOIN cohort_sizes cs
    ON rc.cohort_month = cs.cohort_month

GROUP BY
    rc.cohort_month,
    cs.cohort_size

ORDER BY rc.cohort_month;