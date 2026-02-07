-- Creación de la tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserción de datos iniciales
-- Usamos 'INSERT IGNORE' para evitar errores si los datos ya existen
INSERT IGNORE INTO users (name, email) 
VALUES 
    ('Admin', 'admin@ejemplo.com'),
    ('Alvaro Mulero', 'alvaromj1201@gmail.es');