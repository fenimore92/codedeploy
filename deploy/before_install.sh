#!/bin/bash

# Exit on error
set -o errexit -o pipefail

touch /home/ubuntu/mylog.log

# Update apt-get
apt-get update -y

echo '[before_install.sh] linea 11' >> /home/ubuntu/mylog.log

# Install packages
apt-get install -y curl
apt-get install -y git
apt-get install -y unzip zip

echo '[before_install.sh] linea 18' >> /home/ubuntu/mylog.log

# Remove current apache & php
apt-get -y remove apache2* php*

echo '[before_install.sh] linea 23' >> /home/ubuntu/mylog.log

# Install Apache 2.4
apt-get -y install apache2

echo '[before_install.sh] linea 28' >> /home/ubuntu/mylog.log

apt-get -y install python-software-properties
add-apt-repository -y ppa:ondrej/php

echo '[before_install.sh] linea 33' >> /home/ubuntu/mylog.log

apt-get -y update

echo '[before_install.sh] linea 37' >> /home/ubuntu/mylog.log

# Install PHP 7.1
apt-get -y install php7.1 php7.1-xml php7.1-mbstring php7.1-mysql php7.1-json php7.1-curl php7.1-cli php7.1-common php7.1-mcrypt php7.1-gd libapache2-mod-php7.1 php7.1-zip

echo '[before_install.sh] linea 42' >> /home/ubuntu/mylog.log

a2enmod rewrite

echo '[before_install.sh] linea 46' >> /home/ubuntu/mylog.log

# Allow URL rewrites
sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/apache2.conf

echo '[before_install.sh] linea 51' >> /home/ubuntu/mylog.log

# Change apache document root
mkdir -p /var/www/html/public
sed -i 's#\<DocumentRoot /var/www/html\>#DocumentRoot /var/www/html/public#' /etc/apache2/sites-available/000-default.conf

echo '[before_install.sh] linea 57' >> /home/ubuntu/mylog.log

# Change apache directory index
sed -e 's/DirectoryIndex.*/DirectoryIndex index.html index.php/' -i /etc/apache2/mods-enabled/dir.conf

echo '[before_install.sh] linea 62' >> /home/ubuntu/mylog.log

echo '[before_install.sh] linea 66' >> /home/ubuntu/mylog.log

# Get Composer, and install to /usr/local/bin
if [ ! -f "/usr/bin/composer" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/bin --filename=composer
    php -r "unlink('composer-setup.php');"
else
    /usr/bin/composer self-update --stable --no-ansi --no-interaction
fi

# Restart apache
service apache2 start

# Ensure aws-cli is installed and configured
if [ ! -f "/usr/bin/aws" ]; then
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    unzip awscli-bundle.zip
    ./awscli-bundle/install -b /usr/bin/aws
fi

# Ensure AWS Variables are available
if [[ -z "$AWS_ACCOUNT_ID" || -z "$AWS_DEFAULT_REGION " ]]; then
    echo "AWS Variables Not Set.  Either AWS_ACCOUNT_ID or AWS_DEFAULT_REGION"
fi