import os
import sqlite3
import pandas as pd


BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

CLEANED_DIR = os.path.join(
    BASE_DIR,
    "data",
    "cleaned"
)

DATABASE_DIR = os.path.join(
    BASE_DIR,
    "database"
)

DATABASE_FILE = os.path.join(
    DATABASE_DIR,
    "ecommerce.db"
)


CUSTOMERS_FILE = os.path.join(
    CLEANED_DIR,
    "customers.csv"
)

PRODUCTS_FILE = os.path.join(
    CLEANED_DIR,
    "products.csv"
)

ORDERS_FILE = os.path.join(
    CLEANED_DIR,
    "orders.csv"
)

ORDER_ITEMS_FILE = os.path.join(
    CLEANED_DIR,
    "order_items.csv"
)


def create_database_directory():

    os.makedirs(
        DATABASE_DIR,
        exist_ok=True
    )


def create_tables(connection):

    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS customers (
            customer_id TEXT PRIMARY KEY,
            customer_name TEXT NOT NULL,
            email TEXT,
            registration_date DATE,
            customer_type TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS products (
            product_id TEXT PRIMARY KEY,
            product_name TEXT NOT NULL,
            category TEXT,
            subcategory TEXT,
            cost_price REAL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS orders (
            order_id TEXT PRIMARY KEY,
            customer_id TEXT,
            order_date DATETIME,
            status TEXT,
            region_code TEXT,
            FOREIGN KEY (customer_id)
                REFERENCES customers(customer_id)
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS order_items (
            item_id TEXT PRIMARY KEY,
            order_id TEXT NOT NULL,
            product_id TEXT NOT NULL,
            quantity INTEGER,
            unit_price REAL,
            discount_percent REAL,
            FOREIGN KEY (order_id)
                REFERENCES orders(order_id),
            FOREIGN KEY (product_id)
                REFERENCES products(product_id)
        )
    """)

    connection.commit()


def clear_existing_data(connection):

    cursor = connection.cursor()

    cursor.execute(
        "DELETE FROM order_items"
    )

    cursor.execute(
        "DELETE FROM orders"
    )

    cursor.execute(
        "DELETE FROM products"
    )

    cursor.execute(
        "DELETE FROM customers"
    )

    connection.commit()


def load_data(connection):

    customers_df = pd.read_csv(
        CUSTOMERS_FILE
    )

    products_df = pd.read_csv(
        PRODUCTS_FILE
    )

    orders_df = pd.read_csv(
        ORDERS_FILE
    )

    order_items_df = pd.read_csv(
        ORDER_ITEMS_FILE
    )

    customers_df.to_sql(
        "customers",
        connection,
        if_exists="append",
        index=False
    )

    products_df.to_sql(
        "products",
        connection,
        if_exists="append",
        index=False
    )

    orders_df.to_sql(
        "orders",
        connection,
        if_exists="append",
        index=False
    )

    order_items_df.to_sql(
        "order_items",
        connection,
        if_exists="append",
        index=False
    )


def verify_database(connection):

    cursor = connection.cursor()

    tables = [
        "customers",
        "products",
        "orders",
        "order_items"
    ]

    print("\nDATABASE VERIFICATION")
    print("=" * 50)

    for table in tables:

        cursor.execute(
            f"SELECT COUNT(*) FROM {table}"
        )

        count = cursor.fetchone()[0]

        print(
            f"{table:<15} : {count} rows"
        )

    print("=" * 50)

    print("\nSample customer:")

    cursor.execute("""
        SELECT *
        FROM customers
        LIMIT 1
    """)

    print(
        cursor.fetchone()
    )

    print("\nSample product:")

    cursor.execute("""
        SELECT *
        FROM products
        LIMIT 1
    """)

    print(
        cursor.fetchone()
    )

    print("\nSample order:")

    cursor.execute("""
        SELECT *
        FROM orders
        LIMIT 1
    """)

    print(
        cursor.fetchone()
    )

    print("\nSample order item:")

    cursor.execute("""
        SELECT *
        FROM order_items
        LIMIT 1
    """)

    print(
        cursor.fetchone()
    )


def check_foreign_keys(connection):

    cursor = connection.cursor()

    cursor.execute("""
        PRAGMA foreign_key_check
    """)

    violations = cursor.fetchall()

    print("\nFOREIGN KEY CHECK")
    print("=" * 50)

    if violations:

        print(
            "Foreign key violations found:"
        )

        for violation in violations:
            print(violation)

    else:

        print(
            "No foreign key violations found."
        )

    print("=" * 50)


def main():

    print("Creating database directory...")

    create_database_directory()

    print("Connecting to SQLite database...")

    connection = sqlite3.connect(
        DATABASE_FILE
    )

    connection.execute(
        "PRAGMA foreign_keys = ON"
    )

    print("Creating tables...")

    create_tables(
        connection
    )

    print("Clearing existing data...")

    clear_existing_data(
        connection
    )

    print("Loading cleaned CSV files...")

    load_data(
        connection
    )

    print("Verifying database...")

    verify_database(
        connection
    )

    check_foreign_keys(
        connection
    )

    connection.close()

    print("\nDatabase creation completed!")

    print(
        "Database:",
        os.path.abspath(DATABASE_FILE)
    )


if __name__ == "__main__":
    main()