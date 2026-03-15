FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libzip-dev libxml2-dev libonig-dev curl git unzip

RUN docker-php-ext-install pdo pdo_mysql zip json
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY html/ /var/www/html/
COPY config/ /var/www/config/

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/files \
    && chmod -R 777 /var/www/html/config

EXPOSE 80
CMD ["apache2-foreground"]
