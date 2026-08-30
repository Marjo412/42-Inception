FROM debian:bookworm

# Install PHP-FPM, PHP extensions and required tools
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-zip \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set WordPress working directory
WORKDIR /var/www/html

# Copy PHP-FPM configuration
COPY conf/wordpress.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy WordPress initialization script
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

# Make initialization script executable
RUN chmod +x /usr/local/bin/wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]