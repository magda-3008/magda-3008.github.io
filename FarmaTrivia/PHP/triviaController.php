<?php
session_start();
$servername = "localhost";
$usernameDB = "root";
$passwordDB = "";
$dbname = "farmatriviabdd";

$conn = new mysqli($servername, $usernameDB, $passwordDB, $dbname);
if ($conn->connect_error) die("Conexión fallida: " . $conn->connect_error);

$id_nivel = intval($_GET['id_nivel'] ?? 1);

// Obtener preguntas y respuestas del nivel
$query = "
  SELECT p.id_pregunta, p.texto_pregunta, r.id_respuesta, r.texto_respuesta, r.es_correcta
  FROM preguntas p
  LEFT JOIN respuestas r ON p.id_pregunta = r.id_pregunta
  WHERE p.id_nivel = ?
  ORDER BY p.id_pregunta, r.id_respuesta
";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $id_nivel);
$stmt->execute();
$result = $stmt->get_result();

$preguntas = [];
while ($row = $result->fetch_assoc()) {
    $id_pregunta = $row['id_pregunta'];
    if (!isset($preguntas[$id_pregunta])) {
        $preguntas[$id_pregunta] = [
            'id_pregunta' => $id_pregunta,
            'texto_pregunta' => $row['texto_pregunta'],
            'respuestas' => []
        ];
    }
    $preguntas[$id_pregunta]['respuestas'][] = [
        'id_respuesta' => $row['id_respuesta'],
        'texto_respuesta' => $row['texto_respuesta'],
        'es_correcta' => (bool)$row['es_correcta']
    ];
}

header('Content-Type: application/json');
echo json_encode(array_values($preguntas));

$stmt->close();
$conn->close();
