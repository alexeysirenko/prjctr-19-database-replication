#!/bin/bash
set -e

echo "Initializing MySQL Slave..."

mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Wait for MySQL to fully start
echo "Waiting for MySQL master ($MASTER_HOST) to be available..."
until mysqladmin ping -h "$MASTER_HOST" -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
    echo "Waiting for master..."
    sleep 2
done

sleep 5

# Get master log file and position dynamically
MASTER_LOG_FILE=$(mysql -h $MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW BINARY LOG STATUS;" | awk 'NR==2 {print $1}')
MASTER_LOG_POS=$(mysql -h $MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW BINARY LOG STATUS;" | awk 'NR==2 {print $2}')

echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD"
echo "MASTER_HOST=$MASTER_HOST"
echo "REPL_USER=$REPL_USER"
echo "REPL_PASSWORD=$REPL_PASSWORD"
echo "MASTER_LOG_FILE=$MASTER_LOG_FILE"
echo "MASTER_LOG_POS=$MASTER_LOG_POS"

mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "STOP REPLICA;"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "RESET REPLICA ALL;"

mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='$MASTER_HOST', SOURCE_USER='$REPL_USER', SOURCE_PASSWORD='$REPL_PASSWORD', SOURCE_LOG_FILE='$MASTER_LOG_FILE', SOURCE_LOG_POS=$MASTER_LOG_POS;"

mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "START REPLICA;"

echo "✅ Slave initialized."
