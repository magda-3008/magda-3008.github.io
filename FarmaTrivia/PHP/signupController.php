<?php
header('Content-Type: application/json');

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
$email = $data['email'] ?? '';
$clave = $data['clave'] ?? '';

if (empty($nombre_usuario) || empty($email) || empty($clave)) {
    echo json_encode(["success" => false, "message" => "Campos vacíos"]);
    exit();
}

// Verificar si el usuario ya existe
$sql = "SELECT id_usuario FROM datos_usuario WHERE nombre_usuario = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $nombre_usuario);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "El usuario ya existe"]);
    exit();
}

// Insertar usuario con contraseña hasheada
$claveHash = password_hash($clave, PASSWORD_DEFAULT);
$sqlInsert = "INSERT INTO datos_usuario (nombre_usuario, email, contrasena) VALUES (?, ?, ?)";
$stmtInsert = $conn->prepare($sqlInsert);
$stmtInsert->bind_param("sss", $nombre_usuario, $email, $claveHash);

if ($stmtInsert->execute()) {
    echo json_encode(["success" => true, "message" => "Registro exitoso, ya puedes iniciar sesión"]);
} else {
    echo json_encode(["success" => false, "message" => "Error al registrar usuario"]);
}

$stmt->close();
$stmtInsert->close();
$conn->close();
?>
