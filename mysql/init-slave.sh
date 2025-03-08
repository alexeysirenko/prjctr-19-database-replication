#!/bin/bash
set -e

echo "Initializing MySQL Slave..."

# Wait for MySQL to fully start
sleep 10

# Get master log file and position dynamically
MASTER_LOG_FILE=$(mysql -h $MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW MASTER STATUS;" | awk 'NR==2 {print $1}')
MASTER_LOG_POS=$(mysql -h $MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW MASTER STATUS;" | awk 'NR==2 {print $2}')

# Configure slave
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
CHANGE MASTER TO 
    MASTER_HOST='$MASTER_HOST', 
    MASTER_USER='$REPL_USER', 
    MASTER_PASSWORD='$REPL_PASSWORD', 
    MASTER_LOG_FILE='$MASTER_LOG_FILE', 
    MASTER_LOG_POS=$MASTER_LOG_POS;
START SLAVE;
"

echo "✅ Slave initialized."
