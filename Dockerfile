# Utilize the official Docker image for PHP 7.4 with Apache
FROM php:7.4-apache

# Install necessary PHP extensions
RUN docker-php-ext-install pdo_mysql

# Install required tools
RUN apt-get update && apt-get install -y git unzip p7zip-full

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application files into the container
COPY . /var/www/html/

# Install application dependencies
RUN composer install --verbose

# Adjust permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Modify Apache configuration to point to the public directory
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable the Apache Rewrite module
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
