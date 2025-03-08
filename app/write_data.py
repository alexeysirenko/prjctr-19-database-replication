import mysql.connector
import time
import os
import random

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "mysql-m"),
    "user": os.getenv("DB_USER", "user"),
    "password": os.getenv("DB_PASSWORD", "password"),
    "database": os.getenv("DB_NAME", "testdb"),
    "port": int(os.getenv("DB_PORT", 3306)),
}

def write_to_db():
    while True:
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            cursor = conn.cursor()

            cursor.execute("SELECT id FROM users ORDER BY RAND() LIMIT 1;")
            user = cursor.fetchone()

            if user:
                user_id = user[0]
                amount = round(random.uniform(5, 500), 2)

                cursor.execute("INSERT INTO payments (user_id, amount) VALUES (%s, %s)", (user_id, amount))
                conn.commit()

                print(f"Inserted payment: User {user_id} -> ${amount}")
            else:
                print("No users found in the database.")

            cursor.close()
            conn.close()

        except mysql.connector.Error as e:
            print(f"Database error: {e}")

        time.sleep(1)

if __name__ == "__main__":
    write_to_db()
