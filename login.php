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
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Masuk ke Dashboard</button>
        </form>
        <footer>© 2026 YAYASAN RAUDLATUL MAKFUFIN</footer>
    </div>
</body>
</html>