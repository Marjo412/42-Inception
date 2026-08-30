#!/bin/bash

set -e

WP_PATH="/var/www/html"

# Read passwords from secrets
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
WP_ADMIN_PASSWORD=$(cat "$WP_ADMIN_PASSWORD_FILE")
WP_USER_PASSWORD=$(cat "$WP_USER_PASSWORD_FILE")

# Wait for MariaDB
until mariadb -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    "$MYSQL_DATABASE" -e "SELECT 1;" > /dev/null 2>&1
do
    sleep 2
done

# Install WordPress if needed
if [ ! -f "$WP_PATH/wp-config.php" ]; then

    wp core download --allow-root

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

# Create second WordPress user if needed
if ! wp user get "$WP_USER" --allow-root > /dev/null 2>&1; then
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

chown -R www-data:www-data "$WP_PATH"

exec php-fpm8.2 -F