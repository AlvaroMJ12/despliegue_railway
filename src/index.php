<?php
// 1. En Railway, la variable suele llamarse MYSQL_URL
$databaseUrl = getenv('MYSQL_URL') ?: getenv('DATABASE_URL');

if (!$databaseUrl) {
    die("Error: No se encontró la variable de entorno de la base de datos.");
}

// 2. Parsear la URL
$dbConfig = parse_url($databaseUrl);

$host = $dbConfig['host'];
$port = $dbConfig['port'] ?? 3306;
$user = $dbConfig['user'];
$pass = $dbConfig['pass'];
$dbname = ltrim($dbConfig['path'], '/');

// 3. DSN para MySQL
$dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]);

    echo "<h1>🐬 Conexión exitosa a MySQL en Railway</h1>";

    $stmt = $pdo->query("SELECT id, name, email FROM users");
    $users = $stmt->fetchAll();

    if ($users) {
        echo "<h3>Lista de Usuarios:</h3><ul>";
        foreach ($users as $user) {
            echo "<li><strong>ID:</strong> {$user['id']} - <strong>Nombre:</strong> {$user['name']}</li>";
        }
        echo "</ul>";
    } else {
        echo "<p>No hay datos. Ejecuta el script SQL en el panel de Railway.</p>";
    }

} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage();
}
?>
