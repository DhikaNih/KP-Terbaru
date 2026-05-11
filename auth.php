<?php
session_start(); // Memulai session untuk mencatat status login
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "db_yayasan");

// Mengambil input JSON dari JavaScript
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (!empty($data)) {
    $user = $conn->real_escape_string($data['username']);
    $pass = $data['password'];

    // Mencari user di tabel admin
    $result = $conn->query("SELECT * FROM admin WHERE username = '$user'");
    
    if ($result->num_rows > 0) {
        $admin = $result->fetch_assoc();
        
        // Membandingkan password input dengan hash di database
        if (password_verify($pass, $admin['password'])) {
            // Jika benar, simpan status login di session
            $_SESSION['is_logged_in'] = true;
            $_SESSION['admin_user'] = $admin['username'];
            
            echo json_encode(["status" => "success"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Password salah!"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Username tidak ditemukan!"]);
    }
}
$conn->close();
?>