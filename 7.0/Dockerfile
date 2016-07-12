FROM php:7.0-fpm-alpine

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Install some dependencies
RUN apk add --update \
        supervisor \
        nginx \
        curl \
        nano \
    && rm -rf /var/cache/apk/*

# Install composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo # composer parallel install plugin

# Configure nginx
ADD conf/nginx.conf /etc/nginx/

# Configure php-fpm
ADD conf/php-fpm.conf /etc/php7/
ADD conf/php.ini /etc/php7/

# Configure supervisord
ADD conf/supervisord.conf /etc/supervisor/conf.d/

# Set our workdir
WORKDIR /app

# Copy dep files first to utilise caching
ONBUILD COPY composer.lock /app
ONBUILD COPY composer.json /app

# Run composer without scripts, app source not copied in yet
ONBUILD RUN composer install --no-scripts --no-autoloader

# Add project files
ONBUILD COPY . /app

# Finish composer install, source available
ONBUILD RUN composer install

# Expose ports
EXPOSE 80 443

# Build something amazing
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
