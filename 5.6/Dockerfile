FROM alpine:3.4

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Install some dependencies
RUN apk --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
  supervisor \
  nginx \
  nano \
  curl \
  shadow \
  php5-cli \
  php5-curl \
  php5-dom \
  php5-gd \
  php5-fpm \
  php5-json \
  php5-mcrypt \
  php5-mysql \
  php5-pdo_mysql \
  php5-phar \
  php5-openssl \
  && rm -rf /var/cache/apk/*

# Fix volume mount permissions issue
RUN usermod --uid 1000 nginx && groupmod --gid 50 www-data

# Install composer and parallel install plugin
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

# Configure nginx
ADD conf/nginx.conf /etc/nginx/
ADD copyenv /usr/local/bin/
RUN chmod 755 /usr/local/bin/copyenv

# Configure php-fpm
ADD conf/php-fpm.conf /etc/php5/
ADD conf/php.ini /etc/php5/

# Configure supervisor
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

# Give ownership of app to `nginx`
ONBUILD RUN chown -R nginx:www-data /app

# Expose ports
EXPOSE 80 443

# Build something amazing
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
