# forma.lms Dockerfile for Render.com (or any Docker host)

FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    curl \
    git \
    unzip \
    default-mysql-client \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip json

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY html/ /var/www/html/
COPY config/ /var/www/config/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/files \
    && chmod -R 777 /var/www/html/config

# Environment variables for database (to be set in Render dashboard)
ENV DB_HOST=${DB_HOST:-localhost}
ENV DB_PORT=${DB_PORT:-3306}
ENV DB_NAME=${DB_NAME:-formalms}
ENV DB_USER=${DB_USER:-formalms}
ENV DB_PASS=${DB_PASS:-}

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
