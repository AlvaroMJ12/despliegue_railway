# 1. Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# 2. FIX CRÍTICO: Deshabilitamos mpm_event y habilitamos mpm_prefork 
# Esto elimina el error "More than one MPM loaded"
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 3. Instalamos las dependencias para MySQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql

# 4. Habilitamos el módulo rewrite
RUN a2enmod rewrite

# 5. Copiamos tu código fuente
COPY src/ /var/www/html/

# 6. Ajustamos permisos para el servidor
RUN chown -R www-data:www-data /var/www/html

# Railway detectará el puerto automáticamente, pero dejamos el 80 por defecto
EXPOSE 80
