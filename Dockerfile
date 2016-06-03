FROM php:7.0-fpm

MAINTAINER Ben M <git@bmagg.com>

# Add customised config files
ADD ./php.ini /usr/local/etc/php/conf.d
ADD ./pool.conf /usr/local/etc/php-fpm.d/

# Install extensions 
RUN docker-php-ext-install \
    pdo_mysql 

# Empower `www-data` user 
RUN usermod -u 1000 www-data

# Set our workdir
WORKDIR /app

# Expose port
EXPOSE 9000
