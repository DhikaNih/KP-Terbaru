<?php
$password_asli = "braille2026";

$password_hash = password_hash($password_asli, PASSWORD_DEFAULT);

echo "<h3>Berhasil Membuat Hash Password!</h3>";
echo "Copy kode di bawah ini dan masukkan ke kolom <b>password</b> di tabel admin phpMyAdmin:<br><br>";
echo "<textarea style='width:100%; padding:10px;'>" . $password_hash . "</textarea>";
echo "<br><br><small>Gunakan username <b><admin></b> untuk login nanti.</small>";
?>