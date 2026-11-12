<?php
session_start();

$_SESSION = [];

// Eliminar la cookie PHPSESSID
setcookie(
    'PHPSESSID',
    '',
    [
        'expires' => time() - 3600,
        'path' => '/',
        'httponly' => true,
        'samesite' => 'Lax'
    ]
);

session_destroy();

header("Content-Type: application/json; charset=UTF-8");

echo json_encode([
    "status" => "ok"
]);