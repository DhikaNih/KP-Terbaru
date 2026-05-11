document.getElementById('loginForm').addEventListener('submit', function (e) {
    e.preventDefault(); // Mencegah halaman refresh

    const user = document.getElementById('username').value;
    const pass = document.getElementById('password').value;
    const errorBox = document.getElementById('errorBox');

    // Kirim data login ke server
    fetch('auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username: user, password: pass })
    })
        .then(res => res.json())
        .then(result => {
            if (result.status === 'success') {
                // Jika sukses, pindah ke halaman utama (index.html)
                window.location.href = 'index.php';
            } else {
                // Jika gagal, tampilkan pesan error
                errorBox.innerText = result.message;
                errorBox.style.display = 'block';
            }
        })
        .catch(err => console.error('Error:', err));
});