FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libzip-dev libxml2-dev libonig-dev curl git unzip \
    default-mysql-client libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) pdo json zip
RUN docker-php-ext-install -j$(nproc) pdo_mysql

RUN a2enmod rewrite

WORKDIR /var/www/html
COPY html/ /var/www/html/
COPY config/ /var/www/config/

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/files \
    && chmod -R 777 /var/www/html/config

ENV DB_HOST=${DB_HOST:-localhost}
ENV DB_PORT=${DB_PORT:-3306}
ENV DB_NAME=${DB_NAME:-formalms}
ENV DB_USER=${DB_USER:-formalms}
ENV DB_PASS=${DB_PASS:-}

EXPOSE 80
CMD ["apache2-foreground"]
