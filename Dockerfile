FROM php:8.2-apache

# 1. FIX MPM: Esto es vital para que Apache no se líe con los procesos (lo que vimos en tus logs)
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 2. CONFIGURACIÓN PUERTO 8080:
# Hacemos el cambio de puerto igual que el profesor, pero asegurando que se cambie en todos lados
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# 3. INSTALACIÓN DE EXTENSIONES (MySQL):
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 4. COPIA DE ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 5. SCRIPT DE ARRANQUE (IGUAL QUE EL PROFESOR)
# Creamos el archivo docker-entrypoint.sh dentro del contenedor
RUN printf '#!/bin/bash\n\
set -e\n\
echo "Iniciando Apache en puerto 8080..."\n\
exec apache2-foreground\n\
' > /usr/local/bin/docker-entrypoint.sh

# Le damos permisos de ejecución (chmod +x)
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 6. CONFIGURACIÓN FINAL
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
