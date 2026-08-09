import os
import sqlite3


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


def test_database_exists():

    assert os.path.exists(
        DATABASE_FILE
    ), "Database file does not exist"


def test_required_tables_exist():

    connection = sqlite3.connect(
        DATABASE_FILE
    )

    cursor = connection.cursor()

    cursor.execute("""
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
    """)

    tables = {
        row[0]
        for row in cursor.fetchall()
    }

    required_tables = {
        "customers",
        "products",
        "orders",
        "order_items"
    }

    assert required_tables.issubset(
        tables
    )

    connection.close()


def test_tables_contain_data():

    connection = sqlite3.connect(
        DATABASE_FILE
    )

    cursor = connection.cursor()

    tables = [
        "customers",
        "products",
        "orders",
        "order_items"
    ]

    for table in tables:

        cursor.execute(
            f"SELECT COUNT(*) FROM {table}"
        )

        count = cursor.fetchone()[0]

        assert count > 0, (
            f"{table} table is empty"
        )

    connection.close()


def test_foreign_keys():

    connection = sqlite3.connect(
        DATABASE_FILE
    )

    cursor = connection.cursor()

    cursor.execute(
        "PRAGMA foreign_key_check"
    )

    violations = cursor.fetchall()

    assert not violations, (
        f"Foreign key violations: {violations}"
    )

    connection.close()