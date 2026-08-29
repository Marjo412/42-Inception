#indicates that the script must be run with Bash.
#!/bin/bash

#stops the script if a command fails.
set -e

echo "Starting MariaDB..."

# Create directories needed by MariaDB
mkdir -p /run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /run/mysqld /var/log/mysql /var/lib/mysql

# Initialize MariaDB only on the first launch
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB temporarily without network access
    echo "Starting temporary MariaDB server..."
    mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --user=mysql &
    pid="$!"

    # Wait until MariaDB is ready
    echo "Waiting for MariaDB..."
    until mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
        sleep 1
    done

    # Create WordPress database and user
    echo "Creating database and user..."
    mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Stop temporary MariaDB server
    echo "Stopping temporary MariaDB server..."
    mysqladmin --socket=/run/mysqld/mysqld.sock \
        -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    wait "$pid" || true

    echo "MariaDB initialization complete."
fi

# Start MariaDB as the main container process
echo "Starting MariaDB server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql