FROM php:8.2-apache

# 1. INSTALACIÓN DE DEPENDENCIAS (Hacemos esto primero)
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 2. CONFIGURACIÓN DEL PUERTO 8080
# Usamos 'sed' para cambiar todos los 80 por 8080 de golpe.
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# 3. COPIA DE ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 4. FIX DE MPM (LO HACEMOS AL FINAL PARA QUE NADIE LO SOBRESCRIBA)
# Borramos manualmente cualquier rastro de event o worker y forzamos prefork.
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
    && rm -f /etc/apache2/mods-enabled/mpm_event.conf \
    && rm -f /etc/apache2/mods-enabled/mpm_worker.load \
    && rm -f /etc/apache2/mods-enabled/mpm_worker.conf \
    && a2enmod mpm_prefork

# 5. ARRANQUE
EXPOSE 8080
CMD ["apache2-foreground"]
