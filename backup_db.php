<?php
session_start();
if (!isset($_SESSION['is_logged_in'])) exit("Akses ditolak");

$conn = new mysqli("localhost", "root", "", "db_yayasan");
if ($conn->connect_error) die("Koneksi gagal: " . $conn->connect_error);

// Ambil semua daftar tabel yang ada di database secara otomatis
$tables = [];
$result = $conn->query("SHOW TABLES");
while ($row = $result->fetch_row()) {
    $tables[] = $row[0];
}

$sql_content = "-- Backup Database Yayasan Braille (Lengkap)\n";
$sql_content .= "-- Dihasilkan pada: " . date("Y-m-d H:i:s") . "\n\n";

foreach ($tables as $table) {
    // 1. Ambil struktur CREATE TABLE
    $resStructure = $conn->query("SHOW CREATE TABLE `$table`");
    $rowStructure = $resStructure->fetch_row();
    $sql_content .= "DROP TABLE IF EXISTS `$table`;\n" . $rowStructure[1] . ";\n\n";

    // 2. Ambil semua data di dalam tabel tersebut
    $resData = $conn->query("SELECT * FROM `$table`");
    while ($rowData = $resData->fetch_assoc()) {
        $values = array_map(function($val) use ($conn) {
            if ($val === null) return "NULL";
            return "'" . $conn->real_escape_string($val) . "'";
        }, array_values($rowData));
        
        $sql_content .= "INSERT INTO `$table` VALUES (" . implode(", ", $values) . ");\n";
    }
    $sql_content .= "\n\n";
}

$fileName = "backup_total_" . date("Ymd_His") . ".sql";
header('Content-Type: application/octet-stream');
header("Content-Disposition: attachment; filename=$fileName");
echo $sql_content;
exit;
?>