FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    php8.3 \
    php8.3-gd \
    php8.3-mysql \
    php8.3-mbstring \
    php8.3-bcmath \
    php8.3-xml \
    php8.3-curl \
    php8.3-zip \
    php8.3-intl \
    php8.3-sqlite3 \
    php8.3-fpm \
    nginx \
    curl \
    supervisor \
    cron \
 && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/www/pelican
WORKDIR /var/www/pelican

# Install latest Panel release
RUN curl -L https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | tar -xzv
RUN composer install --no-dev --optimize-autoloader
# Extra directory for database file to make mounting easier
RUN mkdir /var/www/pelican/database/data

# Copy all configs
COPY ./root/ /
RUN rm /etc/nginx/sites-enabled/default

CMD ["/bin/bash", "/docker-entrypoint.sh"]