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
$token = $data['token'] ?? '';

if (empty($token)) {
    echo json_encode(["success" => false, "message" => "Token no proporcionado"]);
    exit();
}

$sql = "SELECT id_usuario, nombre_usuario FROM datos_usuario WHERE token = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $row = $result->fetch_assoc();
    echo json_encode(["success" => true, "usuario" => $row['nombre_usuario']]);
} else {
    echo json_encode(["success" => false, "message" => "Token inválido"]);
}

$stmt->close();
$conn->close();
?>
