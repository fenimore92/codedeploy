#!/bin/bash

# Exit on error
set -o errexit -o pipefail

# Update apt-get
apt-get update -y

# Install packages
apt-get install -y curl
apt-get install -y git

# Remove current apache & php
apt-get -y remove apache2* php*

# Install Apache 2.4
apt-get -y install apache2

apt-get -y install python-software-properties
add-apt-repository -y ppa:ondrej/php

apt-get -y update

# Install PHP 7.1
apt-get -y install php7.1 php7.1-xml php7.1-mbstring php7.1-mysql php7.1-json php7.1-curl php7.1-cli php7.1-common php7.1-mcrypt php7.1-gd libapache2-mod-php7.1 php7.1-zip

# Allow URL rewrites
#sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/conf/httpd.conf

# Change apache document root
mkdir -p /var/www/html/public
sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/public#' /etc/apache2/sites-available/000-default.conf

# Change apache directory index
sed -e 's/DirectoryIndex.*/DirectoryIndex index.html index.php/' -i /etc/apache2/mods-enabled/dir.conf

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