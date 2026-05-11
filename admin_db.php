<?php
session_start();
header("Content-Type: application/json");

if (!isset($_SESSION['is_logged_in'])) {
    echo json_encode(["status" => "error", "message" => "Akses ditolak"]);
    exit;
}

$conn = new mysqli("localhost", "root", "", "db_yayasan");
$action = $_GET['action'] ?? '';

switch ($action) {
    case 'check_status':
        $res = $conn->query("SELECT COUNT(*) as total FROM buku");
        $row = $res->fetch_assoc();
        echo json_encode(["jumlah_data" => $row['total']]);
        break;

    case 'get_all_books':
        // Mengambil semua data buku untuk ditampilkan di dashboard
        $result = $conn->query("SELECT * FROM buku ORDER BY id_buku ASC");
        $data = [];
        while ($row = $result->fetch_assoc()) { $data[] = $row; }
        echo json_encode($data);
        break;

    case 'get_structure':
        $result = $conn->query("DESCRIBE buku");
        $data = [];
        while ($row = $result->fetch_assoc()) { $data[] = $row; }
        echo json_encode($data);
        break;

    case 'truncate':
        if ($conn->query("TRUNCATE TABLE buku")) {
            echo json_encode(["status" => "success", "message" => "Berhasil dikosongkan"]);
        } else {
            echo json_encode(["status" => "error", "message" => $conn->error]);
        }
        break;
}
$conn->close();