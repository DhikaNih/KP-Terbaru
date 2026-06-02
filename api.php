<?php
require_once 'config.php';

if (!isset($_SESSION['admin_logged']) || $_SESSION['admin_logged'] !== true) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

header('Content-Type: application/json');

$action = $_GET['action'] ?? $_POST['action'] ?? '';

try {
    switch ($action) {
        case 'get_stats':
            // Total buku, total sukses (dari log), total gagal, total sesi
            $stmt = $pdo->query("SELECT COUNT(*) as total FROM buku");
            $totalBuku = $stmt->fetch(PDO::FETCH_ASSOC)['total'];
            
            $stmt = $pdo->query("SELECT SUM(jumlah_sukses) as sukses, SUM(jumlah_gagal) as gagal, COUNT(*) as sesi FROM log_konversi");
            $logSum = $stmt->fetch(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'success' => true,
                'total_buku' => (int)$totalBuku,
                'total_sukses' => (int)($logSum['sukses'] ?? 0),
                'total_gagal' => (int)($logSum['gagal'] ?? 0),
                'total_sesi' => (int)($logSum['sesi'] ?? 0)
            ]);
            break;
            
        case 'get_books':
            $search = $_GET['search'] ?? '';
            $sql = "SELECT id_buku, judul_buku, penulis, kode_buku, jumlah_lembar, volume, kode_ukuran, ukuran_buku, harga, batch_id FROM buku";
            if ($search) {
                $sql .= " WHERE judul_buku LIKE :search OR penulis LIKE :search OR kode_buku LIKE :search";
                $stmt = $pdo->prepare($sql);
                $stmt->execute(['search' => "%$search%"]);
            } else {
                $stmt = $pdo->query($sql);
            }
            $books = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['success' => true, 'books' => $books]);
            break;
            
        case 'get_logs':
            $stmt = $pdo->query("SELECT id_log, nama_file, jumlah_sukses, jumlah_gagal, waktu_eksekusi, batch_id, detail_error FROM log_konversi ORDER BY id_log DESC");
            $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['success' => true, 'logs' => $logs]);
            break;
            
        case 'save_data':
            $input = json_decode(file_get_contents('php://input'), true);
            if (!isset($input['books']) || !is_array($input['books'])) {
                throw new Exception('Data buku tidak valid');
            }
            $books = $input['books'];
            $namaFile = $input['nama_file'] ?? 'Upload_' . date('Ymd_His') . '.xlsx';
            $batchId = 'batch_' . date('YmdHis') . '_' . bin2hex(random_bytes(4));
            
            $sukses = 0;
            $gagal = 0;
            $errors = [];
            
            $pdo->beginTransaction();
            try {
                $stmtInsert = $pdo->prepare("INSERT INTO buku 
                    (kode_buku, judul_buku, penulis, jumlah_lembar, volume, kode_ukuran, ukuran_buku, tahun_terbit, harga, batch_id)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                
                foreach ($books as $book) {
                    // Cek duplikat berdasarkan kode_buku (jika tidak kosong) atau judul_buku
                    $kode = $book['kode'] ?? '-';
                    $judul = $book['judul'] ?? '';
                    $cek = $pdo->prepare("SELECT id_buku FROM buku WHERE (kode_buku = ? AND kode_buku != '-') OR (judul_buku = ?) LIMIT 1");
                    $cek->execute([$kode, $judul]);
                    if ($cek->fetch()) {
                        $gagal++;
                        $errors[] = "Duplikat: $judul (kode: $kode)";
                        continue;
                    }
                    
                    $stmtInsert->execute([
                        $kode,
                        $judul,
                        $book['penulis'] ?? 'Tidak Ada',
                        (int)($book['lembar'] ?? 0),
                        (int)($book['volume'] ?? 0),
                        $book['kode_ukuran'] ?? '-',
                        $book['ukuran_buku'] ?? '-',
                        (int)($book['tahun'] ?? 0),
                        (float)($book['harga'] ?? 0),
                        $batchId
                    ]);
                    $sukses++;
                }
                
                // Simpan log konversi
                $stmtLog = $pdo->prepare("INSERT INTO log_konversi (nama_file, jumlah_sukses, jumlah_gagal, batch_id, detail_error) VALUES (?, ?, ?, ?, ?)");
                $detailError = !empty($errors) ? implode("\n", $errors) : null;
                $stmtLog->execute([$namaFile, $sukses, $gagal, $batchId, $detailError]);
                
                $pdo->commit();
                echo json_encode(['success' => true, 'sukses' => $sukses, 'gagal' => $gagal, 'batch_id' => $batchId]);
            } catch (Exception $e) {
                $pdo->rollBack();
                throw $e;
            }
            break;
            
        case 'rollback':
            $batchId = $_POST['batch_id'] ?? '';
            if (!$batchId) {
                throw new Exception('batch_id diperlukan');
            }
            // Hapus buku dengan batch_id tersebut
            $stmt = $pdo->prepare("DELETE FROM buku WHERE batch_id = ?");
            $stmt->execute([$batchId]);
            $deleted = $stmt->rowCount();
            
            // Catat log rollback
            $logStmt = $pdo->prepare("INSERT INTO log_konversi (nama_file, jumlah_sukses, jumlah_gagal, batch_id, detail_error) VALUES (?, ?, ?, ?, ?)");
            $logStmt->execute(["[ROLLBACK] Batch $batchId", 0, 0, $batchId, "Rollback menghapus $deleted buku"]);
            
            echo json_encode(['success' => true, 'deleted' => $deleted]);
            break;
            
        case 'delete_all':
            $pdo->exec("DELETE FROM buku");
            $pdo->exec("DELETE FROM log_konversi WHERE nama_file NOT LIKE '[ROLLBACK]%'");
            echo json_encode(['success' => true]);
            break;
            
        case 'backup_sql':
            // Set header untuk download file .sql
            header('Content-Type: application/sql');
            header('Content-Disposition: attachment; filename="backup_' . date('Y-m-d_H-i-s') . '.sql"');
            
            $output = "-- MySQL dump\n";
            $output .= "-- Generated by Konverter Excel to MySQL\n";
            $output .= "-- Date: " . date('Y-m-d H:i:s') . "\n\n";
            $output .= "SET SQL_MODE = \"NO_AUTO_VALUE_ON_ZERO\";\n";
            $output .= "START TRANSACTION;\n";
            $output .= "SET time_zone = \"+00:00\";\n\n";
            
            // Ambil semua tabel yang ingin di-backup
            $tables = ['buku', 'log_konversi', 'admin']; // tambahkan tabel lain jika perlu
            
            foreach ($tables as $table) {
                // Struktur tabel
                $stmt = $pdo->query("SHOW CREATE TABLE `$table`");
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                $output .= "--\n-- Table structure for table `$table`\n--\n";
                $output .= "DROP TABLE IF EXISTS `$table`;\n";
                $output .= $row['Create Table'] . ";\n\n";
                
                // Data tabel
                $stmtData = $pdo->query("SELECT * FROM `$table`");
                $rows = $stmtData->fetchAll(PDO::FETCH_ASSOC);
                if (count($rows) > 0) {
                    $output .= "--\n-- Dumping data for table `$table`\n--\n";
                    foreach ($rows as $rowData) {
                        $columns = array_keys($rowData);
                        $escapedValues = array_map(function($value) use ($pdo) {
                            if ($value === null) return 'NULL';
                            return $pdo->quote($value);
                        }, array_values($rowData));
                        $output .= "INSERT INTO `$table` (`" . implode("`, `", $columns) . "`) VALUES (" . implode(", ", $escapedValues) . ");\n";
                    }
                    $output .= "\n";
                }
            }
            
            $output .= "COMMIT;\n";
            echo $output;
            break;
            
        default:
            throw new Exception('Aksi tidak dikenal');
    }
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>