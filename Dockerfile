FROM php:8.2-apache

# 1. Instalamos dependencias PRIMERO
# (Dejamos que el sistema haga lo que quiera aquí, si rompe la config, la arreglamos luego)
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 2. Copiamos los archivos de tu web
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 3. FIX FINAL Y CRÍTICO (ESTO ES LO IMPORTANTE)
# Ejecutamos esto AL FINAL para que sea la configuración definitiva.
# Borramos cualquier rastro de 'event' o 'worker' y forzamos el puerto 8080.

RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
    && rm -f /etc/apache2/mods-enabled/mpm_event.conf \
    && rm -f /etc/apache2/mods-enabled/mpm_worker.load \
    && rm -f /etc/apache2/mods-enabled/mpm_worker.conf \
    && a2enmod mpm_prefork \
    && sed -i 's/80/8080/g' /etc/apache2/ports.conf \
    && sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf

# 4. Arrancamos
EXPOSE 8080
CMD ["apache2-foreground"]
