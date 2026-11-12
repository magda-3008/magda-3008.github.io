<?php
session_start();
$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

$conn = new mysqli($servername, $usernameDB, $passwordDB, $dbname);
if ($conn->connect_error) die("Conexión fallida: " . $conn->connect_error);

$id_usuario = $_SESSION['id_usuario'] ?? 1;
$id_nivel = intval($_POST['id_nivel']);
$puntos_obtenidos = intval($_POST['puntos']);

// Determinar si completó el nivel (60 o más puntos)
$completado = $puntos_obtenidos >= 60 ? 1 : 0;

// Verificar si ya existe un registro
$query = "SELECT id_progreso FROM progreso_usuario WHERE id_usuario = ? AND id_nivel = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $id_usuario, $id_nivel);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    // Ya existe: actualizar puntos y estado (sin perder el progreso si ya fue completado)
    $stmt->close();
    $update = $conn->prepare("
        UPDATE progreso_usuario 
        SET puntos_obtenidos = ?, 
            completado = GREATEST(completado, ?), 
            fecha_ultimo_intento = NOW() 
        WHERE id_usuario = ? AND id_nivel = ?
    ");
    $update->bind_param("iiii", $puntos_obtenidos, $completado, $id_usuario, $id_nivel);
    $update->execute();
    $update->close();
} else {
    // No existe: insertar nuevo registro
    $stmt->close();
    $insert = $conn->prepare("
        INSERT INTO progreso_usuario (id_usuario, id_nivel, puntos_obtenidos, completado) 
        VALUES (?, ?, ?, ?)
    ");
    $insert->bind_param("iiii", $id_usuario, $id_nivel, $puntos_obtenidos, $completado);
    $insert->execute();
    $insert->close();
}

echo json_encode(['status' => 'ok']);
$conn->close();
?>
