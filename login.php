<?php
session_start();
if (isset($_SESSION['is_logged_in']) && $_SESSION['is_logged_in'] === true) {
    header("Location: index.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Konverter Katalog Braille</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="login-body">
    <div class="login-container">
        <div style="font-size: 50px; margin-bottom: 10px;">📖</div>
        <h2>Login Admin</h2>
        <p>Silakan masuk untuk mengelola konversi katalog</p>

        <div id="errorBox">Username atau Password salah!</div>

        <form id="loginForm">
            <div class="form-group">
                <label>Username</label>
                <input type="text" id="username" name="username" placeholder="Masukkan username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" name="password" placeholder="Masukkan password" required>
            </div>
            <button type="submit" class="btn-login">Masuk ke Sistem</button>
        </form>

        <p style="margin-top: 30px; font-size: 11px; color: #bdc3c7; letter-spacing: 1px;">
            &copy; 2026 YAYASAN RAUDLATUL MAKFUFIN
        </p>
    </div>

    <script src="login-script.js"></script>
</body>
</html>