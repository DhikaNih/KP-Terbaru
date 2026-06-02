<?php
require_once 'config.php';

// Jika sudah login, langsung ke index
if (isset($_SESSION['admin_logged']) && $_SESSION['admin_logged'] === true) {
    header('Location: index.php');
    exit;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    
    $stmt = $pdo->prepare("SELECT * FROM admin WHERE username = ?");
    $stmt->execute([$username]);
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($admin && password_verify($password, $admin['password'])) {
        $_SESSION['admin_logged'] = true;
        $_SESSION['admin_id'] = $admin['id_admin'];
        $_SESSION['admin_user'] = $admin['username'];
        header('Location: index.php');
        exit;
    } else {
        $error = 'Username atau password salah!';
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Konverter Excel ke MySQL</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #0f766e 0%, #0d9488 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-card {
            background: white;
            border-radius: 24px;
            padding: 32px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 35px rgba(0,0,0,0.2);
            text-align: center;
        }
        .logo { font-size: 48px; margin-bottom: 16px; }
        
        .login-logo {
            text-align: center;
            margin-bottom: 24px;
        }

        .logo-img {
            max-width: 180px;
            height: auto;
            display: inline-block;
        }

        h2,h4 { color: #0f766e; margin-bottom: 24px; }
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        label {
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            display: block;
            margin-bottom: 6px;
        }
        input {
            width: 100%;
            padding: 12px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            outline: none;
            transition: 0.2s;
        }
        input:focus {
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(13,148,136,0.2);
        }
        button {
            background: #0d9488;
            color: white;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
        }
        button:hover { background: #0f766e; }
        .error {
            background: #fef2f2;
            color: #991b1b;
            padding: 10px;
            border-radius: 10px;
            font-size: 12px;
            margin-bottom: 16px;
        }
        footer {
            margin-top: 20px;
            font-size: 11px;
            color: #94a3b8;
        }
        .password-group {
            position: relative;
        }
        #togglePassword {
            font-size: 18px;
            opacity: 0.7;
            transition: 0.2s;
        }
        #togglePassword:hover {
            opacity: 1;
        }
        .password-wrapper {
            position: relative;
        }

        .toggle-eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            cursor: pointer;
            opacity: 0.6;
            transition: opacity 0.2s;
        }

        .toggle-eye:hover {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-logo">
        <img src="logo.png" alt="Logo Braille Yarfin" class="logo-img">
        </div>
        <h4>Konverter Katalog Buku Braille Yarfin</h4>
        <h2>Login Admin</h2>
        <?php if ($error): ?>
            <div class="error">⚠️ <?= htmlspecialchars($error) ?></div>
        <?php endif; ?>
        <form method="POST">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required autofocus>
            </div>
            <div class="input-group password-group">
                <label>Password</label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="password" required>
                    <img src="eye-off-svgrepo-com.svg" alt="Tampilkan password" id="togglePassword" class="toggle-eye">
                </div>
            </div>
            <button type="submit">Masuk ke Dashboard</button>
        </form>
        <footer>© 2026 YAYASAN RAUDLATUL MAKFUFIN</footer>
    </div>
    <script>
            const togglePassword = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');

            togglePassword.addEventListener('click', function() {
                // Toggle tipe input
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                
                // Ganti ikon
                if (type === 'text') {
                    this.src = 'eye-off-svgrepo-com.svg';
                    this.alt = 'Sembunyikan password';
                } else {
                    this.src = 'eye-show-svgrepo-com.svg';
                    this.alt = 'Tampilkan password';
                }
            });
    </script>
</body>
</html>