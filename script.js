let dataMentah = [];

document.addEventListener('DOMContentLoaded', () => {
    refreshDashboard();
    // Polling setiap 10 detik agar status & tabel update otomatis
    setInterval(refreshDashboard, 10000);

    const fileInput = document.getElementById('uploadExcel');
    if (fileInput) fileInput.addEventListener('change', handleFileUpload);
});

function refreshDashboard() {
    updateStatusDatabase();
    muatIsiBuku();
    muatRiwayat();
}

function muatIsiBuku() {
    fetch('admin_db.php?action=get_all_books')
        .then(res => res.json())
        .then(data => {
            const tbody = document.querySelector('#tabelIsiBuku tbody');
            if (!tbody) return;
            tbody.innerHTML = "";
            if (data.length === 0) {
                tbody.innerHTML = "<tr><td colspan='6' style='text-align:center; padding:20px;'>Data masih kosong.</td></tr>";
                return;
            }
            data.forEach(buku => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding:8px; border:1px solid #eee;">${buku.judul_buku}</td>
                    <td style="padding:8px; border:1px solid #eee;">${buku.penulis}</td>
                    <td style="padding:8px; border:1px solid #eee;">${buku.kode_buku}</td>
                    <td style="padding:8px; border:1px solid #eee; text-align:center;">${buku.jumlah_lembar}</td>
                    <td style="padding:8px; border:1px solid #eee; text-align:center;">${buku.volume}</td>
                    <td style="padding:8px; border:1px solid #eee;">${buku.kode_ukuran}</td>
                    <td style="padding:8px; border:1px solid #eee; text-align:center;">Rp ${parseFloat(buku.harga).toLocaleString('id-ID')}</td>
                `;
                tbody.appendChild(tr);
            });
        });
}

function updateStatusDatabase() {
    const statusDiv = document.getElementById('dbStatus');
    fetch('admin_db.php?action=check_status')
        .then(res => res.json())
        .then(data => {
            if (data.jumlah_data == 0) {
                statusDiv.style.background = "#fdf2f2";
                statusDiv.style.color = "#c0392b";
                statusDiv.innerHTML = "❌ <strong>Database Kosong:</strong> Belum ada data buku.";
            } else {
                statusDiv.style.background = "#eefdf2";
                statusDiv.style.color = "#27ae60";
                statusDiv.innerHTML = `✅ <strong>Terisi:</strong> Ada ${data.jumlah_data} data buku.`;
            }
        }).catch(err => console.error("Gagal update status"));
}

function lihatStruktur() {
    console.log("Membuka Struktur...");
    fetch('admin_db.php?action=get_structure')
        .then(res => res.json())
        .then(data => {
            const tbody = document.querySelector('#tabelStruktur tbody');
            tbody.innerHTML = "";
            data.forEach(col => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding:10px; border:1px solid #ddd;">${col.Field}</td>
                    <td style="padding:10px; border:1px solid #ddd;">${col.Type}</td>
                    <td style="padding:10px; border:1px solid #ddd;">${col.Null}</td>
                    <td style="padding:10px; border:1px solid #ddd;">${col.Key || '-'}</td>
                    <td style="padding:10px; border:1px solid #ddd;">${col.Default || 'NULL'}</td>`;
                tbody.appendChild(tr);
            });
            document.getElementById('modalStruktur').style.display = 'block';
        });
}

function tutupModal() {
    document.getElementById('modalStruktur').style.display = 'none';
}

function kosongkanData() {
    if (confirm("Hapus semua data permanen?")) {
        fetch('admin_db.php?action=truncate')
            .then(res => res.json())
            .then(res => {
                alert(res.message);
                location.reload();
            });
    }
}

// Fungsi untuk memfilter tampilan tabel buku berdasarkan input pencarian
function filterTabelBuku() {
    const input = document.getElementById('cariBuku');
    const filter = input.value.toUpperCase();
    const table = document.getElementById('tabelIsiBuku');
    const tr = table.getElementsByTagName('tr');

    // Mulai loop dari index 1 untuk melewati header tabel
    for (let i = 1; i < tr.length; i++) {
        // Mengambil kolom Judul (index 0) dan Penulis (index 1)
        const tdJudul = tr[i].getElementsByTagName('td')[0];
        const tdPenulis = tr[i].getElementsByTagName('td')[1];

        if (tdJudul || tdPenulis) {
            const txtValueJudul = tdJudul.textContent || tdJudul.innerText;
            const txtValuePenulis = tdPenulis.textContent || tdPenulis.innerText;

            // Cek apakah kata kunci ada di Judul ATAU Penulis
            if (txtValueJudul.toUpperCase().indexOf(filter) > -1 ||
                txtValuePenulis.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
}

// Logika Excel (Tetap seperti versi sebelumnya kamu)
function handleFileUpload(e) {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = function (event) {
        const data = new Uint8Array(event.target.result);
        const workbook = XLSX.read(data, { type: 'array' });
        const worksheet = workbook.Sheets[workbook.SheetNames[0]];
        const allRows = XLSX.utils.sheet_to_json(worksheet, { header: 1, defval: "" });
        let indexHeaderReal = allRows.findIndex(row => row.join("|").toUpperCase().includes("NAMA BUKU"));
        if (indexHeaderReal === -1) indexHeaderReal = 4;
        const headerTerpilih = allRows[indexHeaderReal];
        dataMentah = allRows.slice(indexHeaderReal + 1);
        document.getElementById('mappingSection').style.display = 'block';
        isiMapping(headerTerpilih);
        tampilkanPreview(dataMentah);
    };
    reader.readAsArrayBuffer(file);
}

function isiMapping(headers) {
    const ids = ['mapJudul', 'mapPenulis', 'mapKode', 'mapLembar', 'mapVol', 'mapKodeUkuran', 'mapDetailUkuran', 'mapHarga'];
    ids.forEach(id => {
        const select = document.getElementById(id);
        select.innerHTML = '<option value="">-- Pilih Kolom --</option>';
        headers.forEach((h, index) => {
            if (h) {
                const opt = document.createElement('option');
                opt.value = index;
                opt.textContent = h.toString().trim();
                select.appendChild(opt);
            }
        });
    });
}

function prosesKonversi() {
    const m = (id) => document.getElementById(id).value;

    // Validasi awal: Kolom Judul wajib di-mapping
    if (m('mapJudul') === "") {
        alert("Pilih kolom Judul terlebih dahulu!");
        return;
    }

    // 1. Daftar Kata Kunci Jabatan/Footer (Tetap digunakan sebagai filter tambahan)
    const kataKunciJabatan = [
        "MENGETAHUI", "KEPALA", "NIP", "PEMBINA", "MANAGER", "ADMIN",
        "KETUA", "YAYASAN", "PENGURUS", "SEKRETARIS", "BENDAHARA",
        "DIREKTUR", "TANGERANG", "PETUGAS", "PERPUSTAKAAN"
    ];

    // 2. Daftar Pola Gelar (Gunakan Regex agar lebih fleksibel)
    const polaGelar = [
        /\bS\.?[A-Z]{1,3}\.?\b/i,
        /\bM\.?[A-Z]{1,3}\.?\b/i,
        /\b(Drs|Dra|Prof|Dr|H|Hj)\.?\b/i
    ];

    const dataSiapSimpan = dataMentah.map(row => {
        // Ambil data berdasarkan mapping user
        let judul = row[m('mapJudul')] ? row[m('mapJudul')].toString().trim() : "";
        let penulis = row[m('mapPenulis')] ? row[m('mapPenulis')].toString().trim() : "Tidak Ada";
        let lembar = row[m('mapLembar')] ? row[m('mapLembar')].toString().trim() : "";
        let vol = row[m('mapVol')] ? row[m('mapVol')].toString().trim() : "";
        let kodeUkuran = row[m('mapKodeUkuran')] ? row[m('mapKodeUkuran')].toString().trim() : "-";
        let detailUkuran = row[m('mapDetailUkuran')] ? row[m('mapDetailUkuran')].toString().trim() : "-";
        let kodeBuku = row[m('mapKode')] ? row[m('mapKode')].toString().trim() : "-";
        let hargaMentah = row[m('mapHarga')] ? row[m('mapHarga')].toString().trim() : "0";
        // Bersihkan karakter non-angka seperti Rp, titik, atau koma agar menjadi angka murni
        let hargaBersih = hargaMentah.replace(/[^0-9]/g, "");

        // --- FILTER STRATEGI NOMOR 2 ---

        // A. Jika judul kosong atau sangat pendek, buang.
        if (!judul || judul.length < 3) return null;

        // B. Cek apakah baris ini memiliki ciri-ciri "Tanda Tangan" (Lembar & Vol Kosong)
        // Jika keduanya kosong, kita periksa lebih ketat apakah ini nama orang/jabatan
        if (lembar === "" && vol === "") {

            // Cek apakah mengandung kata kunci jabatan (Ketua, Bendahara, dll)
            const isJabatan = kataKunciJabatan.some(k => judul.toUpperCase().includes(k));
            if (isJabatan) return null;

            // Cek apakah mengandung gelar (S.Pd, M.Kom, dll)
            const isOrangBergelar = polaGelar.some(pattern => pattern.test(judul));
            if (isOrangBergelar) return null;

            // Cek apakah judul isinya angka panjang (NIP)
            if (/^\d{10,}$/.test(judul.replace(/[\s.-]/g, ""))) return null;
        }

        // Jika lolos seleksi di atas, maka dianggap sebagai data BUKU VALID
        return {
            judul: judul,
            penulis: penulis,
            kode: kodeBuku,
            lembar: parseInt(lembar) || 0,
            volume: parseInt(vol) || 0,
            kode_ukuran: kodeUkuran,
            ukuran_buku: detailUkuran,
            tahun: 0,
            harga: parseInt(hargaBersih) || 0
        };
    }).filter(item => item !== null); // Hapus baris yang ditandai null

    // Konfirmasi jumlah data yang akan dikirim
    if (dataSiapSimpan.length === 0) {
        alert("Tidak ada data valid yang ditemukan. Periksa kembali mapping kolom Anda.");
        return;
    }

    if (!confirm(`Ditemukan ${dataSiapSimpan.length} data buku valid. Simpan ke database?`)) {
        return;
    }

    // Eksekusi Simpan ke database melalui simpan.php
    fetch('simpan.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(dataSiapSimpan)
    })
        .then(res => res.json())
        .then(res => {
            alert(res.message);
            refreshDashboard(); // Update tabel dan status di dashboard
            document.getElementById('mappingSection').style.display = 'none';
            document.getElementById('uploadExcel').value = "";
        })
        .catch(err => {
            console.error(err);
            alert("Gagal terhubung ke server saat menyimpan data.");
        });
}

function muatRiwayat() {
    fetch('ambil_log.php').then(r => r.json()).then(data => {
        const container = document.getElementById('logContent');
        if (data.length === 0) return container.innerHTML = "<p>Belum ada riwayat.</p>";
        let html = `<table class="log-table" style="width:100%;"><thead><tr><th>Waktu</th><th>File</th><th>Sukses</th><th>Gagal/Duplikat</th></tr></thead><tbody>`;
        data.forEach(log => {
            html += `<tr><td>${log.waktu_eksekusi}</td><td>${log.nama_file}</td><td>${log.jumlah_sukses}</td><td>${log.jumlah_gagal}</td></tr>`;
        });
        container.innerHTML = html + "</tbody></table>";
    });
}

// Tambahkan fungsi ini di bawah muatRiwayat()
function tampilkanPreview(data) {
    const previewSection = document.getElementById('previewSection'); // Pastikan ID ini ada di HTML
    const tbody = document.querySelector('#tabelPreview tbody'); // Pastikan ID ini ada di HTML
    
    if (!previewSection || !tbody) {
        console.warn("Elemen pratinjau tidak ditemukan di HTML.");
        return;
    }

    tbody.innerHTML = ""; // Bersihkan pratinjau lama
    previewSection.style.display = 'block';

    // Tampilkan hanya 5-10 baris pertama sebagai sampel agar tidak berat
    const sampelData = data.slice(0, 10);

    sampelData.forEach((row, index) => {
        const tr = document.createElement('tr');
        // Buat kolom berdasarkan data mentah excel
        let cells = row.map(cell => `<td style="padding:5px; border:1px solid #ddd; font-size:12px;">${cell || "-"}</td>`).join("");
        tr.innerHTML = `<td style="background:#f9f9f9; text-align:center;">${index + 1}</td>${cells}`;
        tbody.appendChild(tr);
    });
}

window.onclick = (e) => { if (e.target == document.getElementById('modalStruktur')) tutupModal(); }