<?php
session_start();

header("Content-Type: application/json; charset=UTF-8");

// Evitar cache
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: 0");

$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

function responder($exito, $mensaje, $datos = [])
{
    echo json_encode(
        array_merge(
            [
                "exito" => $exito,
                "mensaje" => $mensaje
            ],
            $datos
        )
    );

    exit();
}

$conn = new mysqli(
    $servername,
    $usernameDB,
    $passwordDB,
    $dbname
);

if ($conn->connect_error) {

    http_response_code(500);

    responder(
        false,
        "No se pudo conectar con la base de datos."
    );
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $token = $_GET['token'] ?? '';
    if (empty($token)) {

        http_response_code(400);

        responder(
            false,
            "No se proporcionó un token de recuperación."
        );
    }

    $sql = "
        SELECT
            id_usuario,
            nombre_usuario,
            token_expiracion
        FROM datos_usuario
        WHERE token_recuperacion = ?
    ";

    $stmt = $conn->prepare($sql);

    if (!$stmt) {

        http_response_code(500);
        $conn->close();
        responder(
            false,
            "No se pudo preparar la consulta."
        );
    }

    $stmt->bind_param(
        "s",
        $token
    );
    $stmt->execute();

    $result = $stmt->get_result();

    if ($result->num_rows !== 1) {

        $stmt->close();
        $conn->close();

        http_response_code(400);

        responder(
            false,
            "Enlace inválido o ya utilizado."
        );
    }

    $user = $result->fetch_assoc();
    if (
        empty($user['token_expiracion']) ||
        strtotime($user['token_expiracion']) < time()
    ) {

        $stmt->close();
        $conn->close();

        http_response_code(400);

        responder(
            false,
            "El enlace ha expirado. Por favor solicita uno nuevo."
        );
    }

    $_SESSION['reset_usuario'] =
        $user['id_usuario'];

    $_SESSION['reset_token'] =
        $token;

    $_SESSION['reset_nombre'] =
        $user['nombre_usuario'];


    $stmt->close();
    $conn->close();


    responder(
        true,
        "Token válido.",
        [
            "nombre_usuario" =>
                $user['nombre_usuario']
        ]
    );
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token =
        $_POST['token'] ?? '';

    $nueva_contrasena =
        $_POST['nueva_contrasena'] ?? '';

    $confirmar_contrasena =
        $_POST['confirmar_contrasena'] ?? '';

    if (
        empty($token) ||
        empty($nueva_contrasena) ||
        empty($confirmar_contrasena)
    ) {

        $conn->close();
        http_response_code(400);
        responder(
            false,
            "Todos los campos son requeridos."
        );
    }

    if (
        $nueva_contrasena !==
        $confirmar_contrasena
    ) {

        $conn->close();
        http_response_code(400);
        responder(
            false,
            "Las contraseñas no coinciden."
        );
    }

    if (
        strlen($nueva_contrasena) < 6
    ) {
        $conn->close();
        http_response_code(400);
        responder(
            false,
            "La contraseña debe tener al menos 6 caracteres."
        );
    }

    $sql = "
        SELECT
            id_usuario,
            token_expiracion
        FROM datos_usuario
        WHERE token_recuperacion = ?
    ";

    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        $conn->close();
        http_response_code(500);
        responder(
            false,
            "No se pudo verificar el enlace."
        );
    }

    $stmt->bind_param(
        "s",
        $token
    );

    $stmt->execute();

    $result = $stmt->get_result();

    if ($result->num_rows !== 1) {

        $stmt->close();
        $conn->close();
        http_response_code(400);
        responder(
            false,
            "El enlace ya no es válido."
        );
    }

    $user = $result->fetch_assoc();

    if (
        empty($user['token_expiracion']) ||
        strtotime($user['token_expiracion']) < time()
    ) {

        $stmt->close();
        $conn->close();

        http_response_code(400);

        responder(
            false,
            "El enlace ha expirado. Solicita uno nuevo."
        );
    }

    $stmt->close();
    $contrasena_hash =
        password_hash(
            $nueva_contrasena,
            PASSWORD_DEFAULT
        );

    $sql_update = "
        UPDATE datos_usuario
        SET
            contrasena = ?,
            token_recuperacion = NULL,
            token_expiracion = NULL
        WHERE id_usuario = ?
    ";

    $stmt_update =
        $conn->prepare($sql_update);

    if (!$stmt_update) {

        $conn->close();
        http_response_code(500);
        responder(
            false,
            "No se pudo actualizar la contraseña."
        );
    }

    $stmt_update->bind_param(
        "si",
        $contrasena_hash,
        $user['id_usuario']
    );

    if (!$stmt_update->execute()) {

        $stmt_update->close();
        $conn->close();

        http_response_code(500);

        responder(
            false,
            "Error al actualizar la contraseña."
        );
    }

    $stmt_update->close();

    unset(
        $_SESSION['reset_usuario'],
        $_SESSION['reset_token'],
        $_SESSION['reset_nombre']
    );

    $conn->close();

    responder(
        true,
        "✓ Contraseña actualizada correctamente. Ahora puedes iniciar sesión con tu nueva contraseña."
    );
}

$conn->close();
http_response_code(405);
responder(
    false,
    "Método no permitido."
);

?>
