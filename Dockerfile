FROM php:8.2-apache

# 1. FIX ULTRA-AGRESIVO PARA EL ERROR MPM
# En vez de desactivarlo, borramos físicamente los enlaces simbólicos de 'event'.
# Esto elimina el error "More than one MPM loaded" de raíz.
RUN rm -f /etc/apache2/mods-enabled/mpm_event.conf \
    && rm -f /etc/apache2/mods-enabled/mpm_event.load \
    && a2enmod mpm_prefork

# 2. INSTALACIÓN DE MYSQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 3. CONFIGURACIÓN DEL PUERTO 8080
# Sobrescribimos los archivos para obligar al uso del puerto 8080.
RUN echo "Listen 8080" > /etc/apache2/ports.conf

# Creamos el VirtualHost manualmente para el 8080
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
