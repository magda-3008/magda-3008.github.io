<?php

session_start();

header("Content-Type: application/json; charset=UTF-8");

// Validar sesión
if (!isset($_SESSION['usuario'])) {
    http_response_code(401);

    echo json_encode([
        "error" => "Sesión no válida"
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
        "error" => "Conexión fallida a la base de datos"
    ]);

    exit();
}

// Obtener datos del usuario
$sql = "
    SELECT *
    FROM datos_usuario
    WHERE nombre_usuario = ?
";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $nombre_usuario);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows !== 1) {

    http_response_code(404);

    echo json_encode([
        "error" => "Usuario no encontrado"
    ]);

    $stmt->close();
    $conn->close();

    exit();
}

$user = $result->fetch_assoc();

$id_usuario = $user['id_usuario'];

$stmt->close();

//Obtener progreso
$sql_progreso = "
    SELECT id_nivel, puntos_obtenidos, completado
    FROM progreso_usuario
    WHERE id_usuario = ?
    ORDER BY id_nivel ASC
";

$stmt = $conn->prepare($sql_progreso);
$stmt->bind_param("i", $id_usuario);
$stmt->execute();

$result_progreso = $stmt->get_result();

$progreso_por_nivel = [];

while ($row = $result_progreso->fetch_assoc()) {

    $progreso_por_nivel[$row['id_nivel']] = [
        'puntos' => $row['puntos_obtenidos'],
        'completado' => $row['completado']
    ];
}

$stmt->close();


$total_pts = 0;
$totalNiveles = 5;

for ($i = 1; $i <= $totalNiveles; $i++) {

    if (!isset($progreso_por_nivel[$i])) {

        $sql_insert = "
            INSERT INTO progreso_usuario
            (id_usuario, id_nivel, puntos_obtenidos, completado)
            VALUES (?, ?, 0, 0)
        ";

        $stmt = $conn->prepare($sql_insert);

        $stmt->bind_param(
            "ii",
            $id_usuario,
            $i
        );

        $stmt->execute();
        $stmt->close();

        $progreso_por_nivel[$i] = [
            'puntos' => 0,
            'completado' => 0
        ];
    }


    $ptsNivel =
        $progreso_por_nivel[$i]['puntos'];

    $completado =
        $progreso_por_nivel[$i]['completado'];


    // Marcar nivel como completado
    if ($ptsNivel >= 100 && !$completado) {

        $sql_update = "
            UPDATE progreso_usuario
            SET completado = 1
            WHERE id_usuario = ?
            AND id_nivel = ?
        ";

        $stmt = $conn->prepare($sql_update);

        $stmt->bind_param(
            "ii",
            $id_usuario,
            $i
        );

        $stmt->execute();
        $stmt->close();

        $progreso_por_nivel[$i]['completado'] = 1;
    }

    $total_pts += $ptsNivel;
}

//Determinar nivel actual
$nuevo_nivel_actual = $user['nivel_actual'];

for ($i = 1; $i <= $totalNiveles; $i++) {

    if ($progreso_por_nivel[$i]['completado'] == 0) {

        $nuevo_nivel_actual = $i;

        break;

    } else {

        $nuevo_nivel_actual = $totalNiveles;
    }
}

//actualizar datos del usuario
if (
    $nuevo_nivel_actual != $user['nivel_actual'] ||
    $total_pts != $user['pts_totales']
) {

    $sql_update_user = "
        UPDATE datos_usuario
        SET nivel_actual = ?,
            pts_totales = ?
        WHERE id_usuario = ?
    ";

    $stmt = $conn->prepare($sql_update_user);

    $stmt->bind_param(
        "iii",
        $nuevo_nivel_actual,
        $total_pts,
        $id_usuario
    );

    $stmt->execute();
    $stmt->close();
}

$niveles = [
    1 => "Principiante",
    2 => "Intermedio",
    3 => "Avanzado",
    4 => "Experto",
    5 => "Maestro"
];

$nivel_actual_text =
    $niveles[$nuevo_nivel_actual] ?? "Principiante";

$response = [
    "nombre_usuario" => $user['nombre_usuario'],
    "email" => $user['email'],
    "foto_perfil" => $user['foto_perfil'] ?? "user.webp",
    "nivel_actual" => $nuevo_nivel_actual,
    "nivel_actual_text" => $nivel_actual_text,
    "pts_totales" => $total_pts,
    "progreso" => $progreso_por_nivel
];

$conn->close();

echo json_encode($response);

?>