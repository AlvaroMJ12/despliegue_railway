# 1. Usamos la imagen oficial de PHP 8.2 con Apache
FROM php:8.2-apache

# 2. FIX DE MPM: Deshabilitamos mpm_event y habilitamos mpm_prefork.
# Esto soluciona el error "More than one MPM loaded" que aparecía en tus logs.
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 3. CONFIGURACIÓN DEL PUERTO 8080:
# Forzamos a Apache a escuchar en el puerto 8080 en todos sus archivos de configuración.
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/g' /etc/apache2/sites-available/000-default.conf

# 4. INSTALACIÓN DE EXTENSIONES:
# Instalamos las librerías necesarias para que PHP pueda comunicarse con MySQL (PDO).
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 5. MÓDULOS DE APACHE:
# Habilitamos mod_rewrite, muy común para el manejo de rutas en aplicaciones PHP.
RUN a2enmod rewrite

# 6. COPIA DE ARCHIVOS:
# Copiamos el contenido de tu carpeta local /src a la carpeta pública del servidor.
COPY src/ /var/www/html/

# 7. PERMISOS:
# Aseguramos que el usuario de Apache (www-data) tenga permisos sobre los archivos.
RUN chown -R www-data:www-data /var/www/html

# 8. PUERTO:
# Exponemos el puerto 8080 para que Railway sepa dónde buscar la aplicación.
EXPOSE 8080
