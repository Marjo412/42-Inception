FROM debian:bookworm

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Create directories needed by MariaDB
RUN mkdir -p /run/mysqld /var/log/mysql \
    && chown -R mysql:mysql /run/mysqld /var/log/mysql \
    && chmod 755 /run/mysqld

# Copy MariaDB configuration
COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# Make initialization script executable
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]