FROM alpine:3.5

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
RUN apk --update add \
  supervisor \
  nginx \
  nano \
  curl \
  php7 \
  php7-common \
  php7-fpm \
  php7-bcmath \
  php7-dom \
  php7-ctype \
  php7-curl \
  php7-gd \
  php7-iconv \
  php7-intl \
  php7-json \
  php7-mbstring \
  php7-mcrypt \
  php7-mysqlnd \
  php7-opcache \
  php7-openssl \
  php7-pdo \
  php7-pdo_mysql \
  php7-pdo_pgsql \
  php7-pdo_sqlite \
  php7-phar \
  php7-posix \
  php7-session \
  php7-soap \
  php7-xml \
  php7-zip \
  php7-zlib \
  && ln -s /usr/bin/php7 /usr/bin/php \
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
ADD conf/php-fpm.conf /etc/php7/
ADD conf/php.ini /etc/php7/

# Configure supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/

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
