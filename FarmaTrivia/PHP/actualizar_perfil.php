<?php

session_start();

header("Content-Type: application/json; charset=UTF-8");

// Evitar cache
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: 0");

// Validar sesión
if (!isset($_SESSION['usuario'])) {
    http_response_code(401);

    echo json_encode([
        "exito" => false,
        "mensaje" => "Sesión no válida"
    ]);

    exit();
}

$nombre_usuario = $_SESSION['usuario'];

// Conexión a la base de datos
$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

$conn = new mysqli(
    $servername,
    $usernameDB,
    $passwordDB,
    $dbname
);

if ($conn->connect_error) {
    http_response_code(500);

    echo json_encode([
        "exito" => false,
        "mensaje" => "Error de conexión con la base de datos."
    ]);

    exit();
}

// Obtener información del usuario
$sql = "SELECT id_usuario, foto_perfil 
        FROM datos_usuario 
        WHERE nombre_usuario = ?";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    http_response_code(500);

    echo json_encode([
        "exito" => false,
        "mensaje" => "No se pudo preparar la consulta."
    ]);

    $conn->close();
    exit();
}

$stmt->bind_param("s", $nombre_usuario);
$stmt->execute();

$result = $stmt->get_result();
$user = $result->fetch_assoc();

$stmt->close();

if (!$user) {
    http_response_code(404);

    echo json_encode([
        "exito" => false,
        "mensaje" => "Usuario no encontrado."
    ]);

    $conn->close();
    exit();
}

$id_usuario = $user['id_usuario'];

if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    echo json_encode([
        "exito" => true,
        "foto_perfil" => $user['foto_perfil'] ?? "user.webp"
    ]);

    $conn->close();
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Variable para saber si realmente se actualizó algo
    $actualizado = false;

    if (
        isset($_FILES['foto_perfil']) &&
        $_FILES['foto_perfil']['error'] === UPLOAD_ERR_OK
    ) {

        $directorioDestino = "../Resource/";

        $nombreOriginal = basename($_FILES['foto_perfil']['name']);

        $extension = strtolower(
            pathinfo($nombreOriginal, PATHINFO_EXTENSION)
        );

        $formatosPermitidos = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp'
        ];

        if (!in_array($extension, $formatosPermitidos)) {

            http_response_code(400);

            echo json_encode([
                "exito" => false,
                "mensaje" => "El formato de imagen no está permitido."
            ]);

            $conn->close();
            exit();
        }

        $nombreArchivo =
            "perfil_" .
            $id_usuario .
            "_" .
            $nombreOriginal;

        $rutaDestino =
            $directorioDestino .
            $nombreArchivo;

        if (
            !move_uploaded_file(
                $_FILES['foto_perfil']['tmp_name'],
                $rutaDestino
            )
        ) {

            http_response_code(500);

            echo json_encode([
                "exito" => false,
                "mensaje" => "No se pudo guardar la imagen."
            ]);

            $conn->close();
            exit();
        }

        $sql_foto =
            "UPDATE datos_usuario
             SET foto_perfil = ?
             WHERE id_usuario = ?";

        $stmt = $conn->prepare($sql_foto);

        if (!$stmt) {

            http_response_code(500);

            echo json_encode([
                "exito" => false,
                "mensaje" => "No se pudo actualizar la foto."
            ]);

            $conn->close();
            exit();
        }

        $stmt->bind_param(
            "si",
            $nombreArchivo,
            $id_usuario
        );

        $stmt->execute();
        $stmt->close();

        echo json_encode([
            "exito" => true,
            "mensaje" => "La foto de perfil se actualizó correctamente.",
            "foto_perfil" => $nombreArchivo
        ]);

        $conn->close();
        exit();
    }

    if (
        isset($_POST['nueva_contrasena']) &&
        trim($_POST['nueva_contrasena']) !== ''
    ) {

        $nueva_contrasena = trim($_POST['nueva_contrasena']);

        $contrasena_hash =
            password_hash(
                $nueva_contrasena,
                PASSWORD_DEFAULT
            );

        $sql_pass =
            "UPDATE datos_usuario
             SET contrasena = ?
             WHERE id_usuario = ?";

        $stmt = $conn->prepare($sql_pass);

        if (!$stmt) {

            http_response_code(500);

            echo json_encode([
                "exito" => false,
                "mensaje" => "No se pudo actualizar la contraseña."
            ]);

            $conn->close();
            exit();
        }

        $stmt->bind_param(
            "si",
            $contrasena_hash,
            $id_usuario
        );

        $stmt->execute();
        $stmt->close();

        echo json_encode([
            "exito" => true,
            "mensaje" => "La contraseña se actualizó correctamente."
        ]);

        $conn->close();
        exit();
    }

    http_response_code(400);

    echo json_encode([
        "exito" => false,
        "mensaje" => "No se recibió ninguna información para actualizar."
    ]);

    $conn->close();
    exit();
}

http_response_code(405);

echo json_encode([
    "exito" => false,
    "mensaje" => "Método no permitido."
]);

$conn->close();

?>

