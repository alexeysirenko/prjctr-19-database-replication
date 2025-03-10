import mysql.connector
import os

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "mysql-m"),
    "user": os.getenv("DB_USER", "user"),
    "password": os.getenv("DB_PASSWORD", "password"),
    "database": os.getenv("DB_NAME", "testdb"),
    "port": int(os.getenv("DB_PORT", 3306)),
}

def seed_database():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    cursor.execute("DROP TABLE IF EXISTS payments;")
    cursor.execute("DROP TABLE IF EXISTS users;")

    cursor.execute("""
        CREATE TABLE users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL
        );
    """)

    cursor.execute("""
        CREATE TABLE payments (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            amount DECIMAL(10,2) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        );
    """)

    cursor.executemany("""
        INSERT INTO users (name, email) VALUES (%s, %s);
    """, [
        ("Alice", "alice@example.com"),
        ("Bob", "bob@example.com"),
        ("Charlie", "charlie@example.com"),
        ("David", "david@example.com"),
        ("Eve", "eve@example.com"),
    ])
    
    conn.commit()
    cursor.close()
    conn.close()
    print("✅ Database setup completed successfully!")


if __name__ == "__main__":
    seed_database()
