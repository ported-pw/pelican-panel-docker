#/bin/bash

# Create file in volume that will be mounted
touch /var/www/pelican/database/data/database.sqlite
# Symlink to it
ln -sf /var/www/pelican/database/data/database.sqlite /var/www/pelican/database/database.sqlite
# Run DB migrations
php artisan migrate --no-interaction --force

chown -R www-data:www-data /var/www/pelican/storage /var/www/pelican/bootstrap/cache/ /var/www/pelican/database/database.sqlite /var/www/pelican/database/data
chmod -R 755 /var/www/pelican/storage /var/www/pelican/bootstrap/cache/ /var/www/pelican/database/database.sqlite /var/www/pelican/database/data

exec supervisord