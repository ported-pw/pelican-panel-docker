FROM ubuntu:24.04
# Configure the release to install, defaulting to latest
ARG release=latest

LABEL org.opencontainers.image.title="Pelican Panel"
LABEL org.opencontainers.image.authors="contact@ported.pw"
LABEL org.opencontainers.image.source="https://github.com/ported-pw/pelican-panel-docker"
LABEL org.opencontainers.image.version="${release}"
LABEL org.opencontainers.image.licenses="AGPLv3"

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

# Install desired Panel release
RUN curl -L https://github.com/pelican-dev/panel/releases/tag/${release}/download/panel.tar.gz | tar -xzv
RUN composer install --no-dev --optimize-autoloader
# Extra directory for database file to make mounting easier
RUN mkdir /var/www/pelican/database/data

# Copy all configs
COPY ./root/ /
RUN rm /etc/nginx/sites-enabled/default

CMD ["/bin/bash", "/docker-entrypoint.sh"]