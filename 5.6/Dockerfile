FROM alpine:3.4

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Configuration
ENV DOCUMENT_ROOT="/app/public" \
  UPLOAD_MAX_FILESIZE="2M" \
  POST_MAX_SIZE="8M" \
  MEMORY_LIMIT="128M" \
  TIMEZONE="UTC"

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
  php5 \
  php5-common \
  php5-cli \
  php5-fpm \
  php5-opcache \
  php5-xml \
  php5-ctype \
  php5-ftp \
  php5-gd \
  php5-json \
  php5-posix \
  php5-curl \
  php5-dom \
  php5-pdo \
  php5-pdo_mysql \
  php5-sockets \
  php5-zlib \
  php5-mcrypt \
  php5-pcntl \
  php5-mysql \
  php5-mysqli \
  php5-sqlite3 \
  php5-bz2 \
  php5-pear \
  php5-exif \
  php5-phar \
  php5-openssl \
  php5-posix \
  php5-zip \
  php5-calendar \
  php5-iconv \
  php5-imap \
  php5-soap \
  php5-memcache \
  php5-xsl \
  php5-ldap \
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

# Replace configuration placeholder values 
ONBUILD RUN sed -i "s|@{{DOCUMENT_ROOT}}|$DOCUMENT_ROOT|g" /etc/nginx/nginx.conf \
  && sed -i "s|@{{UPLOAD_MAX_FILESIZE}}|$UPLOAD_MAX_FILESIZE|g" /etc/php7/php.ini \
  && sed -i "s|@{{POST_MAX_SIZE}}|$POST_MAX_SIZE|g" /etc/php7/php.ini \
  && sed -i "s|@{{MEMORY_LIMIT}}|$MEMORY_LIMIT|g" /etc/php7/php.ini; \
  sed -i "s|@{{TIMEZONE}}|$TIMEZONE|g" /etc/php7/php.ini

# Set our workdir
WORKDIR /app

# Copy dependency files
ONBUILD COPY composer.json /app

# Add project files
ONBUILD COPY . /app

# Run composer install, source available
ONBUILD RUN composer install

# Expose ports
EXPOSE 80 443

# Build something amazing
CMD ["sh", "/usr/local/bin/start"]
