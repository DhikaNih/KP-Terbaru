<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "db_yayasan");

// Ambil 10 riwayat terbaru
$result = $conn->query("SELECT * FROM log_konversi ORDER BY waktu_eksekusi DESC LIMIT 10");

$logs = [];
while ($row = $result->fetch_assoc()) {
    $logs[] = $row;
}

echo json_encode($logs);
$conn->close();
?>