<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "db_yayasan");

$input = file_get_contents("php://input");
$dataBuku = json_decode($input, true);

if (!empty($dataBuku)) {
    $conn->begin_transaction(); 
    $jumlah_sukses = 0;
    $jumlah_gagal = 0;

    try {
        foreach ($dataBuku as $buku) {
            $judul   = $conn->real_escape_string($buku['judul']);
            $penulis = $conn->real_escape_string($buku['penulis']);
            $kode    = $conn->real_escape_string($buku['kode']);
            $lembar  = (int)$buku['lembar'];
            $volume  = (int)$buku['volume'];
            $k_ukur  = $conn->real_escape_string($buku['kode_ukuran']);
            $u_buku  = $conn->real_escape_string($buku['ukuran_buku']);
            $tahun   = (int)$buku['tahun'];
            $harga   = (float)$buku['harga'];

            // Cek duplikasi berdasarkan Kode (jika bukan '-') atau Judul
            $cek = $conn->query("SELECT id_buku FROM buku WHERE (kode_buku = '$kode' AND kode_buku != '-') OR judul_buku = '$judul'");
            
            if ($cek && $cek->num_rows > 0) {
                $jumlah_gagal++;
                continue;
            }

            // Eksekusi INSERT (Tanpa kolom kategori)
            $sql = "INSERT INTO buku (kode_buku, judul_buku, penulis, jumlah_lembar, volume, kode_ukuran, ukuran_buku, tahun_terbit, harga) 
                    VALUES ('$kode', '$judul', '$penulis', $lembar, $volume, '$k_ukur', '$u_buku', $tahun, $harga)";
            
            if ($conn->query($sql)) {
                $jumlah_sukses++;
            } else {
                throw new Exception($conn->error);
            }
        }

        // Simpan log riwayat konversi
        $nama_file = "Upload_" . date("Ymd_His") . ".xlsx";
        $conn->query("INSERT INTO log_konversi (nama_file, jumlah_sukses, jumlah_gagal) VALUES ('$nama_file', $jumlah_sukses, $jumlah_gagal)");
        
        $conn->commit();
        echo json_encode(["status" => "success", "message" => "$jumlah_sukses data berhasil disimpan, $jumlah_gagal duplikat dilewati."]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => "Error: " . $e->getMessage()]);
    }
}
$conn->close();
?>