<?php
session_start();
if (!isset($_SESSION['is_logged_in']) || $_SESSION['is_logged_in'] !== true) {
    header("Location: login.html");
    exit;
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Konverter Katalog Buku Braille Yarfin</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="script.js" defer></script>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>Konverter Katalog Buku Braille Yarfin</h1>
                <p>Alat bantu digitalisasi data katalog buku Excel ke Database MySQL</p>
            </div>
            <div class="user-nav">
                <span>Administrator</span> | 
                <a href="logout.php" class="link-logout">Keluar</a>
            </div>
        </header>

        <div class="main-layout">
            <section class="content-area">
                <div id="dbStatus">Memeriksa status database...</div>

                <div class="card">
                    <div class="card-header-flex">
                        <h3>Isi Tabel Buku</h3>
                        <input type="text" id="cariBuku" placeholder="Cari judul atau penulis..." onkeyup="filterTabelBuku()">
                    </div>
                    <div class="table-container">
                        <table id="tabelIsiBuku">
                            <thead>
                                <tr>
                                    <th>Judul Buku</th>
                                    <th>Penulis</th>
                                    <th>Kode</th>
                                    <th>Lbr</th>
                                    <th>Vol</th>
                                    <th>Ukuran</th>
                                    <th>Harga</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="card">
                    <h3>Riwayat Konversi</h3>
                    <div id="logContent">Memuat riwayat...</div>
                </div>
            </section>

            <aside class="sidebar-area">
                <div class="card card-accent">
                    <h3>Upload Katalog</h3>
                    <p class="text-muted">Pilih file Excel (.xlsx) untuk sinkronisasi database.</p>
                    <input type="file" id="uploadExcel" accept=".xlsx, .xls">
                </div>

                <div id="mappingSection" class="card card-warning" style="display:none;">
                    <h3>Pencocokan Kolom</h3>
                    <div class="mapping-grid">
                        <div class="mapping-item"><label>Judul:</label><select id="mapJudul"></select></div>
                        <div class="mapping-item"><label>Penulis:</label><select id="mapPenulis"></select></div>
                        <div class="mapping-item"><label>Kode:</label><select id="mapKode"></select></div>
                        <div class="mapping-item"><label>Lembar:</label><select id="mapLembar"></select></div>
                        <div class="mapping-item"><label>Volume:</label><select id="mapVol"></select></div>
                        <div class="mapping-item"><label>Kode Ukuran:</label><select id="mapKodeUkuran"></select></div>
                        <div class="mapping-item"><label>Detail Ukuran:</label><select id="mapDetailUkuran"></select></div>
                        <div class="mapping-item"><label>Harga:</label><select id="mapHarga"></select></div>
                        <button onclick="prosesKonversi()" class="btn btn-primary">Mulai Konversi</button>
                    </div>
                </div>

                <div class="card">
                    <h3>Administrasi</h3>
                    <div class="btn-group-vertical">
                        <button onclick="lihatStruktur()" class="btn btn-secondary">Struktur Tabel</button>
                        <a href="backup_db.php" class="btn-link">
                            <button type="button" class="btn btn-info">Backup Database (.sql)</button>
                        </a>
                        <hr class="separator">
                        <button onclick="kosongkanData()" class="btn btn-danger">Kosongkan Data</button>
                    </div>
                </div>
            </aside>
        </div>

        <div id="modalStruktur" class="modal-overlay">
            <div class="modal-content">
                <span onclick="tutupModal()" class="modal-close">Tutup [x]</span>
                <h3>Informasi Struktur Database</h3>
                <div class="table-container-modal">
                    <table id="tabelStruktur">
                        <thead>
                            <tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>