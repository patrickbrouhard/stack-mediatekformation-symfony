FROM php:8.3-fpm

# Dépendances système
RUN apt-get update && apt-get install -y \
    git unzip curl \
    libicu-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install \
    pdo pdo_mysql intl zip opcache \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Config Xdebug (désactivé par défaut)
RUN echo "xdebug.mode=off" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini

# Désactiver opcache en dev
RUN echo "opcache.enable=0" > /usr/local/etc/php/conf.d/opcache.ini

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/mediatekformation