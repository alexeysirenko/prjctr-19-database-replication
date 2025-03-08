#!/bin/bash
set -e

echo "Initializing MySQL Master..."

# Wait for MySQL to fully start
sleep 10

# Create replication user
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
CREATE USER IF NOT EXISTS '$REPL_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$REPL_PASSWORD';
GRANT REPLICATION SLAVE ON *.* TO '$REPL_USER'@'%';
FLUSH PRIVILEGES;
"

echo "✅ Master initialized."
