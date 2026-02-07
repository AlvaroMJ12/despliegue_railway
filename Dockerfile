FROM php:8.2-apache

# 1. INSTALACIÓN DE DEPENDENCIAS
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# 2. CONFIGURACIÓN "A PRUEBA DE BALAS" DEL PUERTO 8080
# En lugar de editar el archivo, lo creamos de nuevo con SOLO lo que necesitamos.
RUN echo "Listen 8080" > /etc/apache2/ports.conf

# 3. CONFIGURACIÓN DEL VIRTUALHOST
# Configuramos los Logs para que salgan por la consola de Railway (stderr/stdout)
# Esto es vital para ver por qué falla si vuelve a pasar.
RUN echo "<VirtualHost *:8080>\n\
    ServerAdmin webmaster@localhost\n\
    DocumentRoot /var/www/html\n\
    ErrorLog /dev/stderr\n\
    CustomLog /dev/stdout combined\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# 4. ARREGLO DE MPM (MÉTODO SEGURO)
# Usamos las herramientas de Apache (a2dismod) en lugar de 'rm'.
# El "|| true" hace que si el módulo no existe, no de error y continúe.
RUN (a2dismod mpm_event || true) \
    && (a2dismod mpm_worker || true) \
    && a2enmod mpm_prefork

# 5. COPIA DE ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 6. ARRANQUE
EXPOSE 8080
CMD ["apache2-foreground"]
