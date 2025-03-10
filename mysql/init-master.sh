#!/bin/bash
set -e

echo "Initializing MySQL Master..."

mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Wait for MySQL to fully start
echo "Waiting for MySQL master ($MASTER_HOST) to be available..."
until mysqladmin ping -h "$MASTER_HOST" -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
    echo "Waiting for master..."
    sleep 2
done

sleep 5

# Create replication user
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
CREATE USER IF NOT EXISTS '$REPL_USER'@'$MASTER_HOST' IDENTIFIED WITH mysql_native_password BY '$REPL_PASSWORD';
GRANT REPLICATION SLAVE ON *.* TO '$REPL_USER'@'$MASTER_HOST';
FLUSH PRIVILEGES;
"

echo "✅ Master initialized."
