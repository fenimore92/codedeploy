#!/bin/bash

echo '[change_permissions.sh] linea 3' >> /home/ubuntu/mylog.log

# Fix user rights
sudo usermod -a -G www-data ubuntu

echo '[change_permissions.sh] linea 8' >> /home/ubuntu/mylog.log

sudo chown -R ubuntu:www-data /var/www

echo '[change_permissions.sh] linea 12' >> /home/ubuntu/mylog.log

sudo chmod 2775 /var/www

echo '[change_permissions.sh] linea 16' >> /home/ubuntu/mylog.log

find /var/www -type d -exec sudo chmod 2775 {} \;

echo '[change_permissions.sh] linea 20' >> /home/ubuntu/mylog.log

find /var/www -type f -exec sudo chmod 0664 {} \;