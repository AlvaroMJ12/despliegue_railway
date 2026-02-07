# Usamos PHP con Apache
FROM php:8.2-apache

# Instalamos la extensión necesaria para MySQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Copiamos el contenido de tu carpeta local /src a la carpeta del servidor
COPY src/ /var/www/html/

# Ajustamos permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
