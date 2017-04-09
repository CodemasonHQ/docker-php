FROM alpine:3.5

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Fix volume mount permissions issues
RUN set -x \
  && addgroup -g 50 -S www-data \
  && adduser -u 1000 -D -S -G www-data www-data

# Install some dependencies
RUN apk --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
  libssh2 libpng freetype libjpeg-turbo libgcc libxml2 libstdc++ icu-libs libltdl libmcrypt \
  supervisor \
  nginx \
  nano \
  curl \
  php7 \
  php7-common \
  php7-cli \
  php7-fpm \
  php7-pdo_mysql \
  php7-mysqli \
  php7-mysqlnd \
  php7-mcrypt \
  php7-session \
  php7-json \
  php7-zlib \
  php7-xml \
  php7-xmlwriter \
  php7-pdo \
  php7-curl \
  php7-opcache \
  php7-ctype \
  php7-mbstring \
  php7-soap \
  php7-bcmath \
  php7-dom \
  php7-xmlreader \
  php7-openssl \
  php7-phar \
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
