FROM php:8.2-apache

# 1. SOLO CAMBIAMOS EL PUERTO (Sin instalar nada más)
# Usamos el método simple para ver si el servidor arranca.
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# 2. COPIAMOS ARCHIVOS
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# 3. ARRANQUE
EXPOSE 8080
CMD ["apache2-foreground"]
