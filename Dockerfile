FROM php:8.2-apache

# 1. FIX DEFINITIVO (NUCLEAR): Limpieza total de MPMs
# Usamos un wildcard (*) para borrar cualquier rastro de mpm_event, mpm_worker, etc.
# Esto garantiza que la carpeta quede limpia antes de activar prefork.
RUN rm -f /etc/apache2/mods-enabled/mpm_* \
    && a2enmod mpm_prefork

# 2. INSTALACIÓN DE MYSQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 3. CONFIGURACIÓN DEL PUERTO 8080
# Sobrescribimos la configuración para forzar el puerto 8080
RUN echo "Listen 8080" > /etc/apache2/ports.conf

RUN echo "<VirtualHost *:8080>\n\
    ServerAdmin webmaster@localhost\n\
    DocumentRoot /var/www/html\n\
    ErrorLog \${APACHE_LOG_DIR}/error.log\n\
    CustomLog \${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# 4. COPIA DE ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 5. ARRANQUE
EXPOSE 8080
CMD ["apache2-foreground"]
