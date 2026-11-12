<?php
session_start();

// Evitar cache para que no se pueda volver atrás con el navegador
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// Si no hay sesión activa, devolver error
if (!isset($_SESSION['id_usuario'])) {
    http_response_code(401); // No autorizado
    echo json_encode(['error' => 'Sesión no iniciada']);
    exit();
}

$id_usuario = $_SESSION['id_usuario'];

// Conexión a la base de datos
$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

$conn = new mysqli($servername, $usernameDB, $passwordDB, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Consulta niveles y progreso del usuario actual
$query = "
  SELECT 
    n.id_nivel,
    n.descripcion,
    COALESCE(pu.puntos_obtenidos, 0) AS puntos_obtenidos,
    COALESCE(pu.completado, 0) AS completado
  FROM niveles n
  LEFT JOIN progreso_usuario pu 
    ON n.id_nivel = pu.id_nivel 
    AND pu.id_usuario = ?
  ORDER BY n.id_nivel ASC
";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $id_usuario);
$stmt->execute();
$result = $stmt->get_result();

$niveles = [];
while ($row = $result->fetch_assoc()) {
    $niveles[] = $row;
}

// Devolver JSON al frontend
header('Content-Type: application/json');
echo json_encode($niveles);

// Cerrar conexión
$stmt->close();
$conn->close();
?>
