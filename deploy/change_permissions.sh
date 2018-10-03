#!/bin/bash

# Fix user rights
sudo usermod -a -G www-data ubuntu
sudo chown -R ubuntu:www-data /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;