FROM alpine:3.4

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Fix volume mount permissions issues
RUN set -x \
  && addgroup -g 50 -S www-data \
  && adduser -u 1000 -D -S -G www-data www-data

# Install some dependencies
RUN apk --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
  supervisor \
  nginx \
  nano \
  curl \
  php5-cli \
  php5-curl \
  php5-dom \
  php5-gd \
  php5-fpm \
  php5-json \
  php5-mcrypt \
  php5-ctype \
  php5-mysql \
  php5-pdo_mysql \
  php5-phar \
  php5-openssl \
  php5-soap \
  php5-gmp \
  php5-pdo_odbc \
  php5-pdo \
  php5-zip \
  php5-sqlite3 \
  php5-apcu \
  php5-pdo_pgsql \
  php5-bcmath \
  php5-xcache \
  php5-odbc \
  php5-pdo_sqlite \
  php5-gettext \
  php5-xmlreader \
  php5-xmlrpc \
  php5-bz2 \
  php5-memcache \
  php5-mssql \
  php5-iconv \
  php5-pdo_dblib \
  php5-ctype \
  && rm -rf /var/cache/apk/*

# Add start script
ADD start /usr/local/bin/
RUN chmod +x /usr/local/bin/start

# Add copyenv script to pass env vars to nginx
ADD copyenv /usr/local/bin/
RUN chmod +x /usr/local/bin/copyenv

# Install composer and parallel install plugin
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo

# Configure nginx
ADD conf/nginx.conf /etc/nginx/

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

# Add project files
ONBUILD COPY . /app

# Run composer install, source available
ONBUILD RUN composer install

# Expose ports
EXPOSE 80 443

# Build something amazing
CMD ["sh", "/usr/local/bin/start"]
