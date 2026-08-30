#indicates that the script must be run with Bash.
#!/bin/bash

#stops the script if a command fails.
set -e

# Read passwords from secrets
MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

# Create directories needed by MariaDB
mkdir -p /run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /run/mysqld /var/log/mysql /var/lib/mysql

# Initialize MariaDB only on the first launch
if [ ! -d "/var/lib/mysql/mysql" ]; then

    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB temporarily
    mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --user=mysql &
    pid="$!"

    # Wait for MariaDB
    until mysqladmin --socket=/run/mysqld/mysqld.sock ping > /dev/null 2>&1; do
        sleep 1
    done

    # Create database and user
    mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Stop temporary server
    mysqladmin --socket=/run/mysqld/mysqld.sock \
        -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    wait "$pid" || true
fi

# Start MariaDB
exec mysqld --user=mysql --datadir=/var/lib/mysql