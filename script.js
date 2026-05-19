// ==================== script.js ====================
// State Global
let files = [];
let rawRows = [];
let headers = [];
let valCfg = {};
let simData = [];
let simOK = false;

// Konstanta mapping dan filter
const DB_COLS = [
    { id: 'judul', label: 'Judul Buku', req: true },
    { id: 'penulis', label: 'Penulis', req: false },
    { id: 'kode', label: 'Kode Buku', req: false },
    { id: 'lembar', label: 'Jml Lembar', req: false },
    { id: 'volume', label: 'Volume', req: false },
    { id: 'kode_ukuran', label: 'Kode Ukuran', req: false },
    { id: 'ukuran', label: 'Detail Ukuran', req: false },
    { id: 'harga', label: 'Harga', req: false }
];

const AUTO_HINT = {
    judul: ['nama buku', 'judul', 'title', 'book name'],
    penulis: ['penulis', 'pengarang', 'author', 'writer'],
    kode: ['kode', 'code', 'no.', 'nomor', 'id'],
    lembar: ['lembar', 'halaman', 'page', 'hlm'],
    volume: ['volume', 'vol', 'jilid'],
    kode_ukuran: ['kode ukuran', 'kode_ukuran', 'ukuran', 'size'],
    ukuran: ['detail ukuran', 'detail', 'dimensi', 'dimension'],
    harga: ['harga', 'price', 'biaya', 'cost']
};

const JABATAN_KW = ['MENGETAHUI', 'KEPALA', 'NIP', 'PEMBINA', 'KETUA', 'YAYASAN', 'PENGURUS', 'SEKRETARIS', 'BENDAHARA', 'DIREKTUR', 'PETUGAS', 'PERPUSTAKAAN', 'MANAGER'];
const GELAR_RE = [/\bS\.?[A-Z]{1,3}\.?\b/i, /\bM\.?[A-Z]{1,3}\.?\b/i, /\b(Drs|Dra|Prof|Dr|H|Hj)\.?\b/i];
const LOKASI_KW = [
  'TANGERANG', 'JAKARTA', 'BOGOR', 'DEPOK', 'BEKASI', 'BANDUNG', 'SEMARANG', 'SURABAYA',
  'KABUPATEN', 'KOTA', 'PROVINSI', 'KECAMATAN', 'DESA', 'KELURAHAN',
  'JANUARI', 'FEBRUARI', 'MARET', 'APRIL', 'MEI', 'JUNI', 'JULI', 'AGUSTUS', 'SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DESEMBER'
];

// Helper
function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/[&<>]/g, m => m === '&' ? '&amp;' : (m === '<' ? '&lt;' : '&gt;'));
}

function toast(msg, type = 'info', dur = 3500) {
    const icons = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
    const el = document.createElement('div');
    el.className = `toast t-${type}`;
    el.innerHTML = `<span>${icons[type] || 'ℹ️'}</span><span>${msg}</span>`;
    document.getElementById('toastStack').appendChild(el);
    setTimeout(() => {
        el.style.opacity = '0';
        el.style.transform = 'translateX(40px)';
        setTimeout(() => el.remove(), 300);
    }, dur);
}

// ==================== API Calls ke Backend ====================
async function apiCall(action, data = {}, method = 'GET') {
    const options = { method, headers: { 'Content-Type': 'application/json' } };
    let url = `api.php?action=${action}`;
    if (method === 'POST') options.body = JSON.stringify(data);
    else if (method === 'GET' && Object.keys(data).length) url += '&' + new URLSearchParams(data).toString();
    const res = await fetch(url, options);
    const json = await res.json();
    if (!json.success) throw new Error(json.error || 'Terjadi kesalahan');
    return json;
}

// ==================== Dashboard & Status ====================
async function refreshStatus() {
    try {
        const stats = await apiCall('get_stats');
        document.getElementById('stTotal').textContent = stats.total_buku.toLocaleString('id-ID');
        document.getElementById('stSukses').textContent = stats.total_sukses.toLocaleString('id-ID');
        document.getElementById('stGagal').textContent = stats.total_gagal.toLocaleString('id-ID');
        document.getElementById('stSesi').textContent = stats.total_sesi.toLocaleString('id-ID');
        const sb = document.getElementById('statusBar');
        if (stats.total_buku === 0) {
            sb.className = 'status-bar empty';
            sb.textContent = '⚠️ Database kosong – belum ada data buku.';
        } else {
            sb.className = 'status-bar ok';
            sb.textContent = `✅ Database aktif – ${stats.total_buku.toLocaleString('id-ID')} buku tersimpan.`;
        }
    } catch (e) {
        toast(e.message, 'error');
    }
}

// ==================== Database View (Tab Database) ====================
async function renderDB() {
    try {
        const search = document.getElementById('dbSearch')?.value || '';
        const data = await apiCall('get_books', { search });
        const wrap = document.getElementById('dbWrap');
        if (!data.books.length) {
            wrap.innerHTML = '<div class="empty-msg"><span class="empty-icon">📚</span>Database masih kosong.</div>';
            return;
        }
        
        let html = '<div class="t-wrap"><table id="tblDB">';
        html += '<thead><tr><th>#</th><th>Judul Buku</th><th>Penulis</th><th>Kode</th><th>Lembar</th><th>Vol</th><th>Ukuran</th><th>Harga (Rp)</th></tr></thead>';
        html += '<tbody>';
        
        data.books.forEach((b, i) => {
            html += '<tr>';
            html += '<td class="mono">' + (i + 1) + '</td>';
            html += '<td style="font-weight:600;" title="' + escapeHtml(b.judul_buku) + '">' + escapeHtml(b.judul_buku) + '</td>';
            html += '<td>' + escapeHtml(b.penulis) + '</td>';
            html += '<td><span class="badge b-teal">' + escapeHtml(b.kode_buku) + '</span></td>';
            html += '<td class="mono">' + (b.jumlah_lembar || 0) + '</td>';
            html += '<td class="mono">' + (b.volume || 0) + '</td>';
            html += '<td><span class="badge b-blue">' + escapeHtml(b.kode_ukuran || '-') + '</span></td>';
            html += '<td class="mono">' + parseInt(b.harga || 0).toLocaleString('id-ID') + '</td>';
            html += '</tr>';
        });
        
        html += '</tbody></table></div>';
        wrap.innerHTML = html;
    } catch (e) {
        toast(e.message, 'error');
    }
}

function filterDB() {
    renderDB(); // reload dengan filter
}

async function kosongkan() {
    if (!confirm('Hapus SEMUA data dari database? Tidak dapat dibatalkan!')) return;
    try {
        await apiCall('delete_all', {}, 'POST');
        toast('Database dikosongkan.', 'warning');
        refreshStatus();
        renderDB();
        renderLog();
        renderRollback();
    } catch (e) {
        toast(e.message, 'error');
    }
}

function exportCSV() {
    const tbl = document.getElementById('tblDB');
    if (!tbl) {
        toast('Tidak ada data untuk diekspor.', 'error');
        return;
    }
    let csv = "No,Judul,Penulis,Kode,Lembar,Volume,Kode Ukuran,Harga\n";
    const rows = tbl.querySelectorAll('tbody tr');
    rows.forEach((row, idx) => {
        const cells = row.cells;
        csv += `${idx + 1},"${cells[1].innerText}","${cells[2].innerText}","${cells[3].innerText}",${cells[4].innerText},${cells[5].innerText},"${cells[6].innerText}",${cells[7].innerText.replace(/\./g, '')}\n`;
    });
    const a = document.createElement('a');
    a.href = 'data:text/csv;charset=utf-8,\uFEFF' + encodeURIComponent(csv);
    a.download = 'database_buku_export.csv';
    a.click();
    toast('Export CSV berhasil.', 'success');
}

// ==================== Log Proses (Tab Log) ====================
async function renderLog() {
    try {
        const data = await apiCall('get_logs');
        const el = document.getElementById('logWrap');
        if (!data.logs.length) {
            el.innerHTML = '<div class="empty-msg"><span class="empty-icon">📭</span>Belum ada log konversi.</div>';
            return;
        }
        let html = `<div style="display:grid;grid-template-columns:140px 1fr 70px 70px auto;gap:10px;padding:8px 14px;background:var(--teal5);border-bottom:1px solid var(--border);font-size:10px;font-weight:700;"><span>Waktu</span><span>File</span><span>Sukses</span><span>Gagal</span><span>Durasi</span></div>`;
        data.logs.forEach(log => {
            const waktu = new Date(log.waktu_eksekusi).toLocaleString('id-ID');
            html += `<div class="log-item">
                <div class="log-row" onclick="toggleLogDetail('${log.id_log}')">
                    <span class="log-time">${waktu}</span>
                    <span class="log-file" title="${escapeHtml(log.nama_file)}">${escapeHtml(log.nama_file)}</span>
                    <span><span class="badge b-green">${log.jumlah_sukses}</span></span>
                    <span><span class="badge b-red">${log.jumlah_gagal}</span></span>
                    <span style="font-size:11px;">-</span>
                </div>
                <div class="log-detail" id="ld_${log.id_log}">
                    <div><strong>Batch ID:</strong> <code>${escapeHtml(log.batch_id || '-')}</code></div>
                    ${log.detail_error ? `<div><strong>Error:</strong><pre class="err-list">${escapeHtml(log.detail_error)}</pre></div>` : '<span>✅ Tidak ada error detail.</span>'}
                </div>
            </div>`;
        });
        el.innerHTML = html;
    } catch (e) {
        toast(e.message, 'error');
    }
}

function toggleLogDetail(id) {
    const el = document.getElementById('ld_' + id);
    if (el) el.classList.toggle('open');
}

// ==================== Rollback (Tab Rollback) ====================
async function renderRollback() {
    try {
        const data = await apiCall('get_logs');
        const batches = data.logs.filter(l => l.batch_id && l.jumlah_sukses > 0 && !l.nama_file.startsWith('[ROLLBACK]'));
        const el = document.getElementById('rbList');
        if (!batches.length) {
            el.innerHTML = '<div class="empty-msg"><span class="empty-icon">↩️</span>Belum ada sesi yang bisa di-rollback.</div>';
            return;
        }
        el.innerHTML = batches.map(l => `
            <div class="rb-card">
                <div class="rb-info">
                    <div class="rb-name">📄 ${escapeHtml(l.nama_file)}</div>
                    <div class="rb-meta">${new Date(l.waktu_eksekusi).toLocaleString()} · ${l.jumlah_sukses} buku</div>
                    <div><code>${escapeHtml(l.batch_id)}</code></div>
                </div>
                <button class="btn btn-red btn-sm" onclick="jalanRollback('${l.batch_id}','${escapeHtml(l.nama_file)}',${l.jumlah_sukses})">Rollback</button>
            </div>
        `).join('');
    } catch (e) {
        toast(e.message, 'error');
    }
}

async function jalanRollback(batchId, namaFile, jumlah) {
    if (!confirm(`Rollback sesi "${namaFile}"?\n${jumlah} buku akan DIHAPUS dari database.\nTidak dapat dibatalkan.`)) return;
    try {
        const res = await fetch(`api.php?action=rollback`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `batch_id=${encodeURIComponent(batchId)}`
        });
        const json = await res.json();
        if (json.success) {
            toast(`Rollback berhasil, ${json.deleted} buku dihapus.`, 'success');
            refreshStatus();
            renderDB();
            renderLog();
            renderRollback();
        } else {
            throw new Error(json.error);
        }
    } catch (e) {
        toast(e.message, 'error');
    }
}

// ==================== Upload Excel & Preview ====================
function addFiles(fileList) {
    if (!fileList || fileList.length === 0) return;
    for (let f of fileList) {
        if (!f.name.match(/\.(xlsx|xls)$/i)) {
            toast(`"${f.name}" bukan format Excel!`, 'error');
            continue;
        }
        if (files.find(x => x.name === f.name)) {
            toast(`"${f.name}" sudah ada.`, 'warning');
            continue;
        }
        files.push({ name: f.name, size: f.size, file: f });
    }
    renderFileChips();
    document.getElementById('fi').value = '';
}

function renderFileChips() {
    const el = document.getElementById('fileList');
    if (files.length === 0) {
        el.innerHTML = '';
        document.getElementById('btnBaca').style.display = 'none';
        return;
    }
    el.innerHTML = files.map((f, i) => `
        <div class="file-chip">
            <span>📄</span>
            <span class="fn">${escapeHtml(f.name)}</span>
            <span class="fs">${(f.size / 1024).toFixed(1)} KB</span>
            <span class="fd" onclick="delFile(${i})">✕</span>
        </div>
    `).join('');
    document.getElementById('btnBaca').style.display = 'flex';
}

function delFile(i) {
    files.splice(i, 1);
    renderFileChips();
}

function bacaFile() {
    if (!files.length) {
        toast('Tidak ada file.', 'error');
        return;
    }
    Promise.all(files.map(f => new Promise((res, rej) => {
        const r = new FileReader();
        r.onload = e => {
            try {
                const wb = XLSX.read(new Uint8Array(e.target.result), { type: 'array' });
                f.wb = wb;
                res();
            } catch { rej(f.name); }
        };
        r.readAsArrayBuffer(f.file);
    }))).then(() => {
        const wb0 = files[0].wb;
        const ws0 = wb0.Sheets[wb0.SheetNames[0]];
        const all = XLSX.utils.sheet_to_json(ws0, { header: 1, defval: '' });
        let ih = all.findIndex(r => r.join('|').toUpperCase().match(/NAMA BUKU|JUDUL BUKU|JUDUL/));
        if (ih < 0) ih = Math.min(4, all.length - 2);
        headers = all[ih] || [];
        rawRows = all.slice(ih + 1).filter(r => r.some(c => c !== ''));
        files.slice(1).forEach(f => {
            const ws = f.wb.Sheets[f.wb.SheetNames[0]];
            const a = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });
            let ih2 = a.findIndex(r => r.join('|').toUpperCase().match(/NAMA BUKU|JUDUL BUKU|JUDUL/));
            if (ih2 < 0) ih2 = Math.min(4, a.length - 2);
            rawRows = rawRows.concat(a.slice(ih2 + 1).filter(r => r.some(c => c !== '')));
        });
        renderPreview();
        buildMapping();
        markDone('s1');
        activateStep('s2');
        showGuide(false);
        toast(`${rawRows.length} baris dari ${files.length} file berhasil dibaca.`, 'success');
    }).catch(name => toast(`Gagal membaca: ${name}`, 'error'));
}

function renderPreview() {
    const pc = document.getElementById('previewCard');
    const pm = document.getElementById('prevMeta');
    const pct = document.getElementById('previewContent');
    pc.style.display = 'block';
    const mc = Math.max(...rawRows.slice(0, 20).map(r => r.length), headers.length);
    const h = headers.slice(0, mc);
    pm.textContent = `${rawRows.length} baris · ${h.length} kolom · ${files.length} file`;
    let th = `<tr>${h.map(x => `<th>${x || '–'}</th>`).join('')}</tr>`;
    let tb = rawRows.slice(0, 15).map((r, i) =>
        `<tr><td class="mono" style="color:var(--text3)">${i + 1}</td>${h.map((_, ci) => `<td>${r[ci] ?? '–'}</td>`).join('')}</tr>`
    ).join('');
    pct.innerHTML = `
        <div class="preview-hdr">
            <span>Menampilkan ${Math.min(15, rawRows.length)} dari ${rawRows.length} baris pertama</span>
            <span>${files.map(f => f.name).join(', ')}</span>
        </div>
        <div class="preview-scroll">
            <table>
                <thead><tr><th>#</th>${th.slice(4)}</thead>
                <tbody>${tb}</tbody>
            </table>
        </div>`;
}

// ==================== Mapping Kolom ====================
function buildMapping() {
    const opts = '<option value="">– Pilih –</option>' +
        headers.map((h, i) => h ? `<option value="${i}">${escapeHtml(h.toString().trim())}</option>` : '').join('');
    const tbody = document.getElementById('mapBody');
    tbody.innerHTML = DB_COLS.map(col => {
        const auto = autoDetect(col.id, headers);
        return `<tr>
            <td>${col.req ? `<span class="req-star">*</span> ` : ''}${col.label}</td>
            <td><select id="mp_${col.id}">${opts.replace(`value="${auto}"`, `value="${auto}" selected`)}</select></td>
        </tr>`;
    }).join('');
}

function autoDetect(colId, hdrs) {
    const hints = AUTO_HINT[colId] || [];
    return hdrs.findIndex(h => h && hints.some(k => h.toString().toLowerCase().includes(k)));
}

function mv(id) {
    return document.getElementById('mp_' + id)?.value ?? '';
}

function lanjutValidasi() {
    if (mv('judul') === '') {
        toast('Kolom Judul wajib dipilih!', 'error');
        return;
    }
    buildValidasi();
    markDone('s2');
    activateStep('s3');
}

// ==================== Validasi Data ====================
function buildValidasi() {
    valCfg = {};
    const jPendek = rawRows.filter(r => { const v = r[mv('judul')]; return !v || v.toString().trim().length < 3; }).length;
    const jKosong = rawRows.filter(r => (!r[mv('lembar')] && !r[mv('volume')])).length;
    const jHarga = rawRows.filter(r => { const v = r[mv('harga')] || ''; return /[Rp.,]/i.test(v.toString()); }).length;
    const jTipe = rawRows.filter(r => { const v = r[mv('lembar')] || ''; return isNaN(parseInt(v)) && v !== ''; }).length;

    const isu = [
        { id: 'judulPendek', icon: '⚠️', title: 'Judul Terlalu Pendek (< 3 karakter)', badge: jPendek, badgeC: 'b-red', desc: 'Baris dengan judul sangat pendek kemungkinan bukan data buku valid.', actions: [{ l: 'Lewati baris', k: 'skip', c: 'skip' }, { l: 'Tetap simpan', k: 'keep', c: 'fix' }], def: 'skip' },
        { id: 'duplikat', icon: '🔁', title: 'Deteksi Data Duplikat', badge: null, desc: 'Baris dengan judul atau kode yang sama akan terdeteksi saat penyimpanan.', actions: [{ l: 'Lewati duplikat', k: 'skip', c: 'skip' }, { l: 'Perbarui data', k: 'update', c: 'fix' }], def: 'skip' },
        { id: 'barisKosong', icon: '🗑️', title: 'Baris Kosong / Footer / Tanda Tangan', badge: jKosong, badgeC: 'b-amber', desc: 'Baris tanpa nilai Lembar & Volume (kemungkinan tanda tangan pejabat).', actions: [{ l: 'Filter otomatis', k: 'skip', c: 'skip' }, { l: 'Tetap simpan', k: 'keep', c: 'fix' }], def: 'skip' },
        { id: 'hargaFormat', icon: '💸', title: 'Format Harga Tidak Standar', badge: jHarga, badgeC: 'b-amber', desc: 'Karakter "Rp", titik, koma akan dibersihkan menjadi angka murni.', actions: [{ l: 'Bersihkan otomatis', k: 'fix', c: 'fix' }, { l: 'Biarkan apa adanya', k: 'keep', c: 'skip' }], def: 'fix' },
        { id: 'tipeSalah', icon: '🔢', title: 'Nilai Numerik Tidak Valid', badge: jTipe, badgeC: 'b-red', desc: 'Kolom Lembar/Volume berisi teks → akan diset ke 0.', actions: [{ l: 'Set ke 0', k: 'fix', c: 'fix' }, { l: 'Lewati baris', k: 'skip', c: 'skip' }], def: 'fix' }
    ];

    const el = document.getElementById('valBody');
    el.innerHTML = isu.map(item => {
        valCfg[item.id] = item.def;
        const badgeHtml = item.badge > 0 ? `<span class="badge ${item.badgeC}" style="margin-left:6px;">${item.badge} baris</span>` : '';
        return `<div class="val-item">
            <div style="font-size:18px;flex-shrink:0;">${item.icon}</div>
            <div class="vi-body">
                <div class="vi-title">${item.title}${badgeHtml}</div>
                <div class="vi-desc">${item.desc}</div>
                <div class="vi-actions" id="va_${item.id}">
                    ${item.actions.map(a => `<button class="va ${a.c} ${a.k === item.def ? 'active' : ''}" onclick="pilihVal('${item.id}','${a.k}',this)">${a.l}</button>`).join('')}
                </div>
            </div>
        </div>`;
    }).join('') + `<button class="btn btn-teal" onclick="lanjutTransformasi()">Lanjut → Transformasi ›</button>`;
}

function pilihVal(id, key, btn) {
    valCfg[id] = key;
    document.getElementById('va_' + id).querySelectorAll('.va').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
}

function lanjutTransformasi() {
    markDone('s3');
    activateStep('s4');
}

// ==================== Transformasi Data ====================
function transformField(val, field) {
    if (!val && val !== 0) return val;
    let v = val.toString();
    if (document.getElementById('txTrim')?.checked) v = v.replace(/\s+/g, ' ').trim();
    if (field === 'judul' && document.getElementById('txKap')?.checked)
        v = v.replace(/\w\S*/g, w => w[0].toUpperCase() + w.slice(1).toLowerCase());
    if (field === 'kode' && document.getElementById('txUp')?.checked) v = v.toUpperCase();
    if (field === 'harga' && document.getElementById('txHarga')?.checked) v = v.replace(/[^0-9]/g, '');
    if (field === 'tanggal' && document.getElementById('txTgl')?.checked)
        v = v.replace(/^(\d{2})\/(\d{2})\/(\d{4})$/, '$3-$2-$1');
    return v;
}

function konversi() {
    const hasil = [];
    const errors = [];
    rawRows.forEach((row, idx) => {
        const rn = idx + 1;
        let judul = row[mv('judul')]?.toString().trim() || '';
        let penulis = row[mv('penulis')]?.toString().trim() || 'Tidak Ada';
        let kode = row[mv('kode')]?.toString().trim() || '-';
        let lembarR = row[mv('lembar')]?.toString().trim() || '';
        let volR = row[mv('volume')]?.toString().trim() || '';
        let kUkuran = row[mv('kode_ukuran')]?.toString().trim() || '-';
        let dUkuran = row[mv('ukuran')]?.toString().trim() || '-';
        let hargaR = row[mv('harga')]?.toString().trim() || '0';

        judul = transformField(judul, 'judul');
        kode = transformField(kode, 'kode');
        hargaR = transformField(hargaR, 'harga');
        penulis = transformField(penulis, '');
        kUkuran = transformField(kUkuran, '');
        dUkuran = transformField(dUkuran, '');

        if (!judul || judul.length < 3) {
            if (valCfg.judulPendek === 'skip') {
                errors.push(`Baris ${rn}: judul terlalu pendek ("${judul}") → dilewati`);
                return;
            }
        }
        if (!lembarR && !volR) {
            if (valCfg.barisKosong === 'skip') {
                const isJ = JABATAN_KW.some(k => judul.toUpperCase().includes(k));
                const isG = GELAR_RE.some(p => p.test(judul));
                const isN = /^\d{10,}$/.test(judul.replace(/[\s.-]/g, ''));
                const isLokasi = LOKASI_KW.some(k => judul.toUpperCase().includes(k)); 
                if (isJ || isG || isN || isLokasi) {
                    errors.push(`Baris ${rn}: "${judul}" → filtered (footer/lokasi/tanggal)`);
                    return;
                }
            }
        }
        const lembar = parseInt(lembarR) || 0;
        const volume = parseInt(volR) || 0;
        if (isNaN(parseInt(lembarR)) && lembarR !== '') {
            if (valCfg.tipeSalah === 'skip') {
                errors.push(`Baris ${rn}: lembar="${lembarR}" non-numerik → dilewati`);
                return;
            }
            errors.push(`Baris ${rn}: lembar="${lembarR}" non-numerik → diset 0`);
        }
        const harga = parseInt(hargaR.replace(/[^0-9]/g, '')) || 0;
        hasil.push({ judul, penulis, kode, lembar, volume, kode_ukuran: kUkuran, ukuran_buku: dUkuran, tahun: 0, harga });
    });
    return { data: hasil, errors };
}

// ==================== Simulasi ====================
function jalanSimulasi() {
    const { data, errors } = konversi();
    simData = data;
    simOK = false;
    const total = rawRows.length, valid = data.length, difilter = total - valid;
    const pV = total ? Math.round(valid / total * 100) : 0;
    const pF = 100 - pV;

    // Estimasi duplikat tidak bisa dari client karena data ada di server, abaikan sementara
    const errSample = errors.slice(0, 8).map(e => `• ${e}`).join('\n');
    document.getElementById('simBox').style.display = 'block';
    document.getElementById('simBox').innerHTML = `
        <div style="font-size:10px;font-weight:700;color:var(--text2);text-transform:uppercase;margin-bottom:10px;">Hasil Simulasi (database tidak diubah)</div>
        <div class="sim-stats">
            <div class="sim-s"><div class="sn" style="color:var(--text)">${total}</div><div class="sl">Total Baris</div></div>
            <div class="sim-s"><div class="sn" style="color:var(--teal)">${valid}</div><div class="sl">Akan Disimpan</div></div>
            <div class="sim-s"><div class="sn" style="color:var(--red)">${difilter}</div><div class="sl">Difilter</div></div>
        </div>
        <div class="bar-wrap"><div class="bar-lbl"><span>Data Valid</span><span>${pV}%</span></div><div class="bar-track"><div class="bar-fill bf-teal" id="bv" style="width:0%"></div></div></div>
        <div class="bar-wrap"><div class="bar-lbl"><span>Difilter</span><span>${pF}%</span></div><div class="bar-track"><div class="bar-fill bf-red" id="bf" style="width:0%"></div></div></div>
        ${errors.length ? `<div class="alert alert-danger; style="overflow-x:auto;"><pre style="font-family:mono;font-size:10px;white-space:pre-wrap;word-break:break-word;">${errSample}</pre></div>` : '<div class="alert alert-success">✅ Tidak ada error terdeteksi.</div>'}
    `;
    setTimeout(() => {
        const bv = document.getElementById('bv');
        if (bv) bv.style.width = pV + '%';
        const bf = document.getElementById('bf');
        if (bf) bf.style.width = pF + '%';
    }, 80);
    simOK = true;
    document.getElementById('btnSimpan').disabled = false;
    markDone('s4');
    activateStep('s5');
    toast(`Simulasi selesai: ${valid} dari ${total} baris siap disimpan.`, valid > 0 ? 'success' : 'warning', 4500);
}

// ==================== Simpan ke Database (via API) ====================
async function simpanData() {
    if (!simOK || !simData.length) {
        toast('Jalankan simulasi dulu!', 'error');
        return;
    }
    if (!confirm(`Simpan ${simData.length} buku ke database?\n\nProses ini dapat di-rollback nanti.`)) return;
    const btn = document.getElementById('btnSimpan');
    btn.innerHTML = '⏳ Menyimpan...';
    btn.disabled = true;
    const namaFile = files.map(f => f.name).join(', ');
    try {
        const result = await apiCall('save_data', { books: simData, nama_file: namaFile }, 'POST');
        toast(`✅ ${result.sukses} data berhasil, ${result.gagal} duplikat/gagal.`, 'success');
        refreshStatus();
        renderDB();
        renderLog();
        renderRollback();
        markDone('s5');
        resetAll(); // reset wizard setelah sukses
    } catch (e) {
        toast(e.message, 'error');
    }
    btn.innerHTML = 'Simpan ke Database';
    btn.disabled = false;
}

// ==================== Wizard Navigation ====================
function showPanel(name) {
    document.querySelectorAll('.content-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.nav-tab').forEach(b => b.classList.remove('active'));
    document.getElementById('p-' + name).classList.add('active');
    event.target.classList.add('active');
    if (name === 'log') renderLog();
    if (name === 'rollback') renderRollback();
    if (name === 'database') renderDB();
}

function toggleStep(id) {
    const el = document.getElementById(id);
    if (el.classList.contains('locked')) return;
    el.classList.toggle('open');
    el.querySelector('.step-chev').style.transform = el.classList.contains('open') ? 'rotate(180deg)' : '';
}

function activateStep(id) {
    ['s1', 's2', 's3', 's4', 's5'].forEach(s => {
        const el = document.getElementById(s);
        el.classList.remove('active', 'open');
        if (s !== id && !el.classList.contains('done')) el.classList.add('locked');
    });
    const el = document.getElementById(id);
    el.classList.remove('locked');
    el.classList.add('active', 'open');
    el.querySelector('.step-chev').style.transform = 'rotate(180deg)';
}

function markDone(id) {
    const el = document.getElementById(id);
    el.classList.remove('active', 'open', 'locked');
    el.classList.add('done');
    el.querySelector('.step-n').innerHTML = '✓';
}

function resetAll() {
    if (!confirm('Reset semua langkah dan mulai dari awal?')) return;
    files = [];
    rawRows = [];
    headers = [];
    valCfg = {};
    simData = [];
    simOK = false;
    document.getElementById('fileList').innerHTML = '';
    document.getElementById('btnBaca').style.display = 'none';
    document.getElementById('simBox').style.display = 'none';
    document.getElementById('btnSimpan').disabled = true;
    document.getElementById('previewCard').style.display = 'none';
    document.getElementById('guideCard').style.display = '';
    ['s2', 's3', 's4', 's5'].forEach(s => {
        const el = document.getElementById(s);
        el.classList.remove('done', 'active', 'open');
        el.classList.add('locked');
        el.querySelector('.step-n').innerHTML = '<span class="step-n-num">' + s[1] + '</span>';
    });
    document.getElementById('s1').classList.remove('done');
    document.getElementById('s1').classList.add('active', 'open');
    document.getElementById('s1').querySelector('.step-n').innerHTML = '<span class="step-n-num">1</span>';
    toast('Wizard direset.', 'info');
}

function showGuide(show) {
    document.getElementById('guideCard').style.display = show ? '' : 'none';
}

// ==================== Event Listeners ====================
document.addEventListener('DOMContentLoaded', () => {
    // Upload file via tombol
    const fi = document.getElementById('fi');
    if (fi) fi.addEventListener('change', e => addFiles(e.target.files));
    // Drag & drop area
    const uz = document.getElementById('uploadZone');
    if (uz) {
        uz.addEventListener('dragover', e => { e.preventDefault(); uz.classList.add('drag'); });
        uz.addEventListener('dragleave', () => uz.classList.remove('drag'));
        uz.addEventListener('drop', e => { e.preventDefault(); uz.classList.remove('drag'); addFiles(e.dataTransfer.files); });
    }
    // Initial load
    refreshStatus();
    renderDB();
    renderLog();
    renderRollback();
    showGuide(true);
});