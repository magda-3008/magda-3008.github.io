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

$es_localhost =
    $_SERVER['HTTP_HOST'] === 'localhost' ||
    $_SERVER['HTTP_HOST'] === '127.0.0.1';

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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {

    http_response_code(405);
    responder(
        false,
        "Método no permitido."
    );
}

$email =
    trim($_POST['email'] ?? '');


if (empty($email)) {

    http_response_code(400);

    responder(
        false,
        "Por favor ingresa tu email."
    );
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {

    http_response_code(400);

    responder(
        false,
        "Ingresa un email válido."
    );
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
        "Error de conexión con la base de datos."
    );
}

$sql = "
    SELECT
        id_usuario,
        nombre_usuario,
        email
    FROM datos_usuario
    WHERE email = ?
";

$stmt = $conn->prepare($sql);


if (!$stmt) {

    $conn->close();

    http_response_code(500);

    responder(
        false,
        "No se pudo preparar la consulta."
    );
}


$stmt->bind_param(
    "s",
    $email
);

$stmt->execute();

$result =
    $stmt->get_result();

if ($result->num_rows !== 1) {

    $stmt->close();
    $conn->close();

    responder(
        true,
        "Si el email existe en nuestro sistema, recibirás un enlace de recuperación."
    );
}


$user =
    $result->fetch_assoc();

$stmt->close();

try {

    $token =
        bin2hex(random_bytes(32));

} catch (Exception $e) {

    $conn->close();

    http_response_code(500);

    responder(
        false,
        "No se pudo generar el enlace de recuperación."
    );
}

$expiracion =
    date(
        'Y-m-d H:i:s',
        strtotime('+1 hour')
    );

$sql_update = "
    UPDATE datos_usuario
    SET
        token_recuperacion = ?,
        token_expiracion = ?
    WHERE id_usuario = ?
";

$stmt_update =
    $conn->prepare($sql_update);


if (!$stmt_update) {

    $conn->close();

    http_response_code(500);

    responder(
        false,
        "No se pudo procesar la solicitud."
    );
}


$stmt_update->bind_param(
    "ssi",
    $token,
    $expiracion,
    $user['id_usuario']
);


if (!$stmt_update->execute()) {

    $stmt_update->close();
    $conn->close();

    http_response_code(500);

    responder(
        false,
        "No se pudo procesar la solicitud."
    );
}


$stmt_update->close();

$protocolo =
    (
        isset($_SERVER['HTTPS']) &&
        $_SERVER['HTTPS'] === 'on'
    )
        ? "https"
        : "http";

$host =
    $_SERVER['HTTP_HOST'];

$enlace_recuperacion =
    $protocolo .
    "://" .
    $host .
    "/FarmaTrivia/HTML/nueva_contrasena.html?token=" .
    urlencode($token);

if ($es_localhost) {

    $conn->close();

    responder(
        true,
        "✓ Enlace de recuperación generado correctamente.",
        [
            "enlace_recuperacion" =>
                $enlace_recuperacion
        ]
    );
}

?>