import os
import sqlite3
import argparse
import sys


BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

DATABASE_FILE = os.path.join(
    BASE_DIR,
    "database",
    "ecommerce.db"
)


def connect_database():

    if not os.path.exists(DATABASE_FILE):

        print(
            "ERROR: Database file not found."
        )

        print(
            f"Expected location: {DATABASE_FILE}"
        )

        print(
            "Run database.py first."
        )

        sys.exit(1)

    try:

        connection = sqlite3.connect(
            DATABASE_FILE
        )

        connection.row_factory = (
            sqlite3.Row
        )

        return connection

    except sqlite3.Error as error:

        print(
            f"ERROR: Could not connect to database: {error}"
        )

        sys.exit(1)


def print_table(
    columns,
    rows
):

    if not rows:

        print("\nNo data found.")
        return

    widths = []

    for column in columns:

        width = len(column)

        for row in rows:

            value = str(
                row[column]
            )

            width = max(
                width,
                len(value)
            )

        widths.append(width)

    separator = "+"

    for width in widths:

        separator += (
            "-" * (width + 2)
            + "+"
        )

    print()
    print(separator)

    header = "|"

    for index, column in enumerate(columns):

        header += (
            f" {column:<{widths[index]}} |"
        )

    print(header)
    print(separator)

    for row in rows:

        line = "|"

        for index, column in enumerate(columns):

            value = str(
                row[column]
            )

            line += (
                f" {value:<{widths[index]}} |"
            )

        print(line)

    print(separator)


def revenue_report(connection):

    print("\n========================================")
    print("REVENUE BY CATEGORY")
    print("========================================")

    query = """
        SELECT
            p.category,

            ROUND(
                SUM(
                    oi.quantity
                    * oi.unit_price
                    * (
                        1
                        - oi.discount_percent / 100.0
                    )
                ),
                2
            ) AS total_revenue

        FROM order_items oi

        JOIN products p
            ON oi.product_id = p.product_id

        GROUP BY p.category

        ORDER BY total_revenue DESC;
    """

    try:

        cursor = connection.execute(
            query
        )

        rows = cursor.fetchall()

        print_table(
            ["category", "total_revenue"],
            rows
        )

    except sqlite3.Error as error:

        print(
            f"ERROR while generating revenue report: {error}"
        )


def top_customers_report(
    connection,
    limit
):

    print("\n========================================")
    print(f"TOP {limit} CUSTOMERS")
    print("========================================")

    query = """
        SELECT
            c.customer_id,
            c.customer_name,

            ROUND(
                SUM(
                    oi.quantity
                    * oi.unit_price
                    * (
                        1
                        - oi.discount_percent / 100.0
                    )
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

        LIMIT ?;
    """

    try:

        cursor = connection.execute(
            query,
            (limit,)
        )

        rows = cursor.fetchall()

        print_table(
            [
                "customer_id",
                "customer_name",
                "total_order_value"
            ],
            rows
        )

    except sqlite3.Error as error:

        print(
            f"ERROR while generating customer report: {error}"
        )


def retention_report(connection):

    print("\n========================================")
    print("CUSTOMER COHORT RETENTION")
    print("========================================")

    query = """
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

                COUNT(
                    DISTINCT customer_id
                ) AS active_customers

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
            ) AS month_0,

            MAX(
                CASE
                    WHEN rc.month_number = 1
                    THEN rc.active_customers
                    ELSE 0
                END
            ) AS month_1,

            MAX(
                CASE
                    WHEN rc.month_number = 2
                    THEN rc.active_customers
                    ELSE 0
                END
            ) AS month_2,

            MAX(
                CASE
                    WHEN rc.month_number = 3
                    THEN rc.active_customers
                    ELSE 0
                END
            ) AS month_3,

            ROUND(
                100.0
                * MAX(
                    CASE
                        WHEN rc.month_number = 1
                        THEN rc.active_customers
                        ELSE 0
                    END
                )
                / NULLIF(
                    cs.cohort_size,
                    0
                ),
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
                / NULLIF(
                    cs.cohort_size,
                    0
                ),
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
                / NULLIF(
                    cs.cohort_size,
                    0
                ),
                2
            ) AS month_3_retention_percent

        FROM retention_counts rc

        JOIN cohort_sizes cs
            ON rc.cohort_month = cs.cohort_month

        GROUP BY
            rc.cohort_month,
            cs.cohort_size

        ORDER BY
            rc.cohort_month;
    """

    try:

        cursor = connection.execute(
            query
        )

        rows = cursor.fetchall()

        print_table(
            [
                "cohort_month",
                "cohort_size",
                "month_0",
                "month_1",
                "month_2",
                "month_3",
                "month_1_retention_percent",
                "month_2_retention_percent",
                "month_3_retention_percent"
            ],
            rows
        )

    except sqlite3.Error as error:

        print(
            f"ERROR while generating retention report: {error}"
        )


def product_pairs_report(
    connection,
    limit
):

    print("\n========================================")
    print("FREQUENTLY BOUGHT TOGETHER")
    print("========================================")

    query = """
        SELECT
            p1.product_name AS product_a,
            p2.product_name AS product_b,

            COUNT(
                DISTINCT oi1.order_id
            ) AS times_bought_together

        FROM order_items oi1

        JOIN order_items oi2
            ON oi1.order_id = oi2.order_id
            AND oi1.product_id < oi2.product_id

        JOIN products p1
            ON oi1.product_id = p1.product_id

        JOIN products p2
            ON oi2.product_id = p2.product_id

        GROUP BY
            oi1.product_id,
            oi2.product_id,
            p1.product_name,
            p2.product_name

        ORDER BY
            times_bought_together DESC

        LIMIT ?;
    """

    try:

        cursor = connection.execute(
            query,
            (limit,)
        )

        rows = cursor.fetchall()

        print_table(
            [
                "product_a",
                "product_b",
                "times_bought_together"
            ],
            rows
        )

    except sqlite3.Error as error:

        print(
            f"ERROR while generating product pair report: {error}"
        )


def database_summary(connection):

    print("\n========================================")
    print("DATABASE SUMMARY")
    print("========================================")

    tables = [
        "customers",
        "products",
        "orders",
        "order_items"
    ]

    for table in tables:

        try:

            cursor = connection.execute(
                f"SELECT COUNT(*) AS count FROM {table}"
            )

            row = cursor.fetchone()

            print(
                f"{table:<15}: {row['count']} rows"
            )

        except sqlite3.Error as error:

            print(
                f"{table:<15}: ERROR - {error}"
            )


def run_all_reports(
    connection,
    limit
):

    database_summary(
        connection
    )

    revenue_report(
        connection
    )

    top_customers_report(
        connection,
        limit
    )

    retention_report(
        connection
    )

    product_pairs_report(
        connection,
        limit
    )


def parse_arguments():

    parser = argparse.ArgumentParser(
        description=(
            "E-Commerce Order Analytics "
            "CLI Reporting Tool"
        )
    )

    parser.add_argument(
        "--report",
        required=True,
        choices=[
            "revenue",
            "top_customers",
            "retention",
            "product_pairs",
            "all"
        ],
        help="Report to generate"
    )

    parser.add_argument(
        "--limit",
        type=int,
        default=10,
        help=(
            "Number of records for reports "
            "that support limits"
        )
    )

    return parser.parse_args()


def main():

    args = parse_arguments()

    if args.limit <= 0:

        print(
            "ERROR: --limit must be greater than zero."
        )

        sys.exit(1)

    connection = connect_database()

    try:

        if args.report == "revenue":

            revenue_report(
                connection
            )

        elif args.report == "top_customers":

            top_customers_report(
                connection,
                args.limit
            )

        elif args.report == "retention":

            retention_report(
                connection
            )

        elif args.report == "product_pairs":

            product_pairs_report(
                connection,
                args.limit
            )

        elif args.report == "all":

            run_all_reports(
                connection,
                args.limit
            )

    finally:

        connection.close()


if __name__ == "__main__":
    main()