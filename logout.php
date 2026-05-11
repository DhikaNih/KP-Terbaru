<?php
session_start();
session_destroy(); // Menghapus semua data login
header("Location: login.php"); // Tendang balik ke login
exit;
?>