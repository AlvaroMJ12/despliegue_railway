FROM php:8.2-apache

# 1. FIX DE PROCESOS (MPM)
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 2. INSTALAR MYSQL
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 3. CONFIGURACIÓN SIMPLE DEL PUERTO 8080
# Esto sobrescribe la configuración de Apache para obligarlo a usar el 8080
RUN echo "Listen 8080" > /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# 4. COPIAR ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 5. ARRANQUE ESTÁNDAR (Sin scripts complejos)
EXPOSE 8080
CMD ["apache2-foreground"]
