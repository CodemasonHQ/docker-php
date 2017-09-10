FROM codemasonhq/php:base

# Maintainer 
MAINTAINER Ben M <git@bmagg.com>

# Copy dependency files
ONBUILD COPY composer.json /app

# Add project files
ONBUILD COPY . /app

# Run composer install, source available
ONBUILD RUN composer install