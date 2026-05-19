<?php
require_once 'config.php';
if (!isset($_SESSION['admin_logged']) || $_SESSION['admin_logged'] !== true) {
    header('Location: login.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Konverter Excel ke MySQL</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
<link rel="stylesheet" href="style.css">
<script src="script.js" defer></script>
</head>
<body>
<!-- NAVBAR -->
<nav class="navbar">
  <div class="nav-brand">
    <div class="nav-logo">📊</div>
    <div>
      <div class="nav-title">Konverter Katalog Buku Braille Yarfin</div>
      <div class="nav-sub">Alat bantu digitalisasi data katalog buku Excel ke Database MySQL</div>
    </div>
  </div>
  <div class="nav-tabs">
    <button class="nav-tab active" onclick="showPanel('dashboard')">Dashboard</button>
    <button class="nav-tab" onclick="showPanel('log')">Log Proses</button>
    <button class="nav-tab" onclick="showPanel('rollback')">Rollback</button>
    <button class="nav-tab" onclick="showPanel('database')">Database</button>
    <button class="nav-tab" onclick="location.href='logout.php'">Logout</button>
  </div>
</nav>

<!-- STATUS BAR -->
<div id="statusBar" class="status-bar">Memeriksa status...</div>

<div class="main">
<!-- SIDEBAR WIZARD -->
<aside class="sidebar">
  <!-- STEP 1 -->
  <div class="step-card active open" id="s1">
    <div class="step-head" onclick="toggleStep('s1')">
      <div class="step-n"><span class="step-n-num">1</span></div>
      <div class="step-info"><div class="step-title">Upload File Excel</div><div class="step-desc">Unggah file .xlsx / .xls</div></div>
      <span class="step-chev">▾</span>
    </div>
    <div class="step-body">
      <div class="upload-zone" id="uploadZone" onclick="document.getElementById('fi').click()">
        <div class="uz-icon"></div>
        <div class="uz-title">Klik atau seret file ke sini</div>
        <div class="uz-sub">Mendukung .xlsx dan .xls · Multi-file</div>
      </div>
      <input type="file" id="fi" accept=".xlsx,.xls" multiple style="display:none">
      <div id="fileList"></div>
      <button class="btn btn-teal" id="btnBaca" onclick="bacaFile()" style="display:none">Baca &amp; Preview Data</button>
    </div>
  </div>

  <!-- STEP 2 -->
  <div class="step-card locked" id="s2">
    <div class="step-head" onclick="toggleStep('s2')">
      <div class="step-n"><span class="step-n-num">2</span></div>
      <div class="step-info"><div class="step-title">Mapping Kolom</div><div class="step-desc">Petakan kolom Excel ke database</div></div>
      <span class="step-chev">▾</span>
    </div>
    <div class="step-body">
      <p style="font-size:11px;color:var(--text2);margin-bottom:8px;">Kolom <span class="req-star">*</span> wajib dipilih.</p>
      <table class="map-tbl" id="mapTbl">
        <thead><tr><th>Kolom Database</th><th>Kolom Excel</th></tr></thead>
        <tbody id="mapBody"></tbody>
      </table>
      <button class="btn btn-teal" onclick="lanjutValidasi()">Lanjut → Validasi ›</button>
    </div>
  </div>

  <!-- STEP 3 -->
  <div class="step-card locked" id="s3">
    <div class="step-head" onclick="toggleStep('s3')">
      <div class="step-n"><span class="step-n-num">3</span></div>
      <div class="step-info"><div class="step-title">Validasi &amp; Bersihkan</div><div class="step-desc">Pilih tindakan per isu data</div></div>
      <span class="step-chev">▾</span>
    </div>
    <div class="step-body" id="valBody">
    </div>
  </div>

  <!-- STEP 4 -->
  <div class="step-card locked" id="s4">
    <div class="step-head" onclick="toggleStep('s4')">
      <div class="step-n"><span class="step-n-num">4</span></div>
      <div class="step-info"><div class="step-title">Transformasi Data</div><div class="step-desc">Ubah format data sebelum simpan</div></div>
      <span class="step-chev">▾</span>
    </div>
    <div class="step-body">
      <div class="tx-row"><label class="tx-label">Kapitalisasi Judul</label><label class="toggle"><input type="checkbox" id="txKap" checked><span class="tslider"></span></label></div>
      <div class="tx-row"><label class="tx-label">UPPERCASE Kode</label><label class="toggle"><input type="checkbox" id="txUp" checked><span class="tslider"></span></label></div>
      <div class="tx-row"><label class="tx-label">Bersihkan Harga (Rp,.)</label><label class="toggle"><input type="checkbox" id="txHarga" checked><span class="tslider"></span></label></div>
      <div class="tx-row"><label class="tx-label">Tanggal DD/MM/YYYY→YYYY-MM-DD</label><label class="toggle"><input type="checkbox" id="txTgl"><span class="tslider"></span></label></div>
      <div class="tx-row"><label class="tx-label">Hapus Spasi Berlebih</label><label class="toggle"><input type="checkbox" id="txTrim" checked><span class="tslider"></span></label></div>
      <button class="btn btn-amber" onclick="jalanSimulasi()">Jalankan Simulasi Konversi</button>
    </div>
  </div>

  <!-- STEP 5 -->
  <div class="step-card locked" id="s5">
    <div class="step-head" onclick="toggleStep('s5')">
      <div class="step-n"><span class="step-n-num">5</span></div>
      <div class="step-info"><div class="step-title">Konversi &amp; Simpan</div><div class="step-desc">Simpan ke database setelah simulasi</div></div>
      <span class="step-chev">▾</span>
    </div>
    <div class="step-body">
      <div id="simBox" style="display:none;margin-bottom:10px;"></div>
      <button class="btn btn-teal" id="btnSimpan" onclick="simpanData()" disabled>Simpan ke Database</button>
      <button class="btn btn-red" onclick="resetAll()" style="margin-top:6px;">Reset Wizard</button>
    </div>
  </div>
</aside>

<!-- CONTENT PANELS -->
<main class="content">

  <!-- DASHBOARD -->
  <div class="content-panel active" id="p-dashboard">
    <div class="stats-row">
      <div class="stat"><div class="stat-n" id="stTotal">0</div><div class="stat-l">Total Buku di DB</div></div>
      <div class="stat"><div class="stat-n" id="stSukses">0</div><div class="stat-l">Total Sukses Konversi</div></div>
      <div class="stat"><div class="stat-n" id="stGagal">0</div><div class="stat-l">Total Gagal/Duplikat</div></div>
      <div class="stat"><div class="stat-n" id="stSesi">0</div><div class="stat-l">Total Sesi Upload</div></div>
    </div>

    <!-- PREVIEW PANEL -->
    <div class="card" id="previewCard" style="display:none;">
      <div class="card-head">
        <span class="card-title">Preview Data Excel</span>
        <span id="prevMeta" style="font-size:11px;color:var(--text3);"></span>
      </div>
      <div id="previewContent"></div>
    </div>

    <!-- QUICK GUIDE -->
    <div class="card" id="guideCard">
      <div class="card-head"><span class="card-title">Panduan 8 Fitur Aplikasi</span></div>
      <div class="card-body">
        <div class="info-grid">
          <div class="info-item"><div class="info-key">Fitur 1</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Upload Multi-File Excel</div><div style="font-size:11px;color:var(--text2);">Upload .xlsx/.xls dari sidebar kiri</div></div>
          <div class="info-item"><div class="info-key">Fitur 2</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Preview Data Excel</div><div style="font-size:11px;color:var(--text2);">Tampil otomatis setelah upload</div></div>
          <div class="info-item"><div class="info-key">Fitur 3</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Mapping Kolom Interaktif</div><div style="font-size:11px;color:var(--text2);">Dropdown + auto-detect di Step 2</div></div>
          <div class="info-item"><div class="info-key">Fitur 4</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Validasi &amp; Pembersihan Data</div><div style="font-size:11px;color:var(--text2);">Pilih Skip/Fix per isu di Step 3</div></div>
          <div class="info-item"><div class="info-key">Fitur 5</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Transformasi Data</div><div style="font-size:11px;color:var(--text2);">Toggle format di Step 4</div></div>
          <div class="info-item"><div class="info-key">Fitur 6</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Simulasi Konversi</div><div style="font-size:11px;color:var(--text2);">Cek hasil tanpa ubah database</div></div>
          <div class="info-item"><div class="info-key">Fitur 7</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Logging Proses</div><div style="font-size:11px;color:var(--text2);">Lihat riwayat di tab Log Proses</div></div>
          <div class="info-item"><div class="info-key">Fitur 8</div><div style="font-size:12px;font-weight:700;color:var(--teal-darker);margin-top:2px;">Rollback Mechanism</div><div style="font-size:11px;color:var(--text2);">Batalkan import di tab Rollback</div></div>
        </div>
      </div>
    </div>
  </div>

  <!-- LOG PROSES -->
  <div class="content-panel" id="p-log">
    <div class="card">
      <div class="card-head">
        <span class="card-title">Log Proses Konversi</span>
        <span style="font-size:11px;color:var(--text3);">Klik baris untuk lihat detail error</span>
      </div>
      <div id="logWrap">
        <div class="empty-msg"><span class="empty-icon"></span>Belum ada log konversi.</div>
      </div>
    </div>
  </div>

  <!-- ROLLBACK -->
  <div class="content-panel" id="p-rollback">
    <div class="card">
      <div class="card-head"><span class="card-title">Rollback Mechanism</span></div>
      <div class="card-body">
        <div class="alert alert-warning"><strong>Perhatian:</strong> Rollback akan menghapus semua data yang diimport pada sesi tersebut secara permanen dari database.</div>
        <div id="rbList"><div class="empty-msg"><span class="empty-icon"></span>Belum ada sesi yang bisa di-rollback.</div></div>
      </div>
    </div>
  </div>

  <!-- DATABASE -->
  <div class="content-panel" id="p-database">
    <div class="card">
      <div class="card-head">
        <span class="card-title">Isi Database (Simulasi MySQL)</span>
        <div style="display:flex;gap:6px;">
          <button class="btn btn-teal btn-sm" onclick="renderDB()">Refresh</button>
          <button class="btn btn-red btn-sm" onclick="kosongkan()">Kosongkan</button>
          <button class="btn btn-blue btn-sm" onclick="exportCSV()">Export CSV</button>
        </div>
      </div>
      <div class="card-body">
        <div class="search-row">
          <input type="text" class="search-input" id="dbSearch" placeholder="Cari judul, penulis, kode..." onkeyup="filterDB()">
        </div>
        <div id="dbWrap"><div class="sk"></div><div class="sk"></div><div class="sk"></div></div>
      </div>
    </div>
  </div>

</main>
</div>

<!-- TOAST STACK -->
<div class="toast-stack" id="toastStack"></div>
</body>
</html>