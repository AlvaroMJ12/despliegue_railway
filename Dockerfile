FROM php:8.2-apache

# 1. FIX de MPM: Evitamos el error de "More than one MPM loaded"
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 2. CONFIGURACIÓN DE PUERTO 8080:
# Forzamos a Apache a escuchar en el 8080 que has configurado en Railway
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# 3. Extensiones para MySQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql

RUN a2enmod rewrite
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Exponemos el 8080 para que Railway sepa dónde mirar
EXPOSE 8080
