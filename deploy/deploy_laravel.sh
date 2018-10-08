#!/bin/bash

echo '[deploy_laravel.sh] linea 3' >> /home/ubuntu/mylog.log

# Enter html directory
cd /var/www/html/

echo '[deploy_laravel.sh] linea 8' >> /home/ubuntu/mylog.log

# Create cache and chmod folders
mkdir -p /var/www/html/bootstrap/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/framework/cache
#mkdir -p /var/www/html/public/files/

echo '[deploy_laravel.sh] linea 17' >> /home/ubuntu/mylog.log

# Install dependencies
export COMPOSER_ALLOW_SUPERUSER=1
composer install -d /var/www/html/

echo '[deploy_laravel.sh] linea 23' >> /home/ubuntu/mylog.log

# Copy configuration from /var/www/.env, see README.MD for more information
#cp /var/www/.env /var/www/html/.env

echo '[deploy_laravel.sh] linea 28' >> /home/ubuntu/mylog.log

# Migrate all tables
#php /var/www/html/artisan migrate

# Clear any previous cached views
php /var/www/html/artisan config:clear
php /var/www/html/artisan cache:clear
php /var/www/html/artisan view:clear

echo '[deploy_laravel.sh] linea 38' >> /home/ubuntu/mylog.log

# Optimize the application
php /var/www/html/artisan config:cache
php /var/www/html/artisan optimize
#php /var/www/html/artisan route:cache

echo '[deploy_laravel.sh] linea 45' >> /home/ubuntu/mylog.log

# Change rights
chmod 777 -R /var/www/html/bootstrap/cache
chmod 777 -R /var/www/html/storage
#chmod 777 -R /var/www/html/public/files/

echo '[deploy_laravel.sh] linea 52' >> /home/ubuntu/mylog.log

# Bring up application
php /var/www/html/artisan up