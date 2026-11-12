<?php
header('Content-Type: application/json');
session_start();

$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

$conn = new mysqli($servername, $usernameDB, $passwordDB, $dbname);
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Conexión fallida"]);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);
$nombre_usuario = $data['nombre_usuario'] ?? '';
$clave = $data['clave'] ?? '';

if (empty($nombre_usuario) || empty($clave)) {
    echo json_encode(["success" => false, "message" => "Campos vacíos"]);
    exit();
}

// Buscar usuario en la base de datos
$sql = "SELECT * FROM datos_usuario WHERE nombre_usuario = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $nombre_usuario);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $row = $result->fetch_assoc();
    if (password_verify($clave, $row['contrasena'])) {
        // Guardar ID y nombre de usuario en sesión
        $_SESSION['id_usuario'] = $row['id_usuario'];
        $_SESSION['usuario'] = $row['nombre_usuario'];

        echo json_encode(["success" => true, "message" => "Login exitoso"]);
    } else {
        echo json_encode(["success" => false, "message" => "Contraseña incorrecta"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Usuario no encontrado"]);
}

$stmt->close();
$conn->close();
?>
