FROM php:7.0-fpm

MAINTAINER Ben M <git@bmagg.com>

# Add customised config files
ADD ./php.ini /usr/local/etc/php/conf.d
ADD ./pool.conf /usr/local/etc/php-fpm.d/

# Install extensions 
RUN docker-php-ext-install \
    pdo_mysql 

# Install some dependencies
RUN apt-get update && apt-get install -yq \
	git \
	curl \
	nano \
	zip \
	unzip

# Install composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Empower `www-data` user 
RUN usermod -u 1000 www-data

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

# Give ownership of app to `www-data`
ONBUILD RUN chown -R www-data:www-data /app

# Expose port
EXPOSE 9000
