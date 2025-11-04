FROM php:8.1-apache

# Установка зависимостей и MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server mariadb-client \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip unzip wget curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip opcache

RUN a2enmod rewrite

COPY . /var/www/html/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Права
RUN chown -R www-data:www-data /var/www/html \
    && mkdir -p /var/www/html/core/cache /var/www/html/core/config /var/www/html/assets \
    && chmod -R 775 /var/www/html/core/cache /var/www/html/core/config /var/www/html/assets

# Настроить Apache
RUN echo '<Directory /var/www/html>\n\
  Options Indexes FollowSymLinks\n\
  AllowOverride All\n\
  Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

EXPOSE 80 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
