document.getElementById('logout-btn').addEventListener('click', () => {
    fetch('../PHP/logout.php')
        .then(() => {
            // Redirigir a login después de cerrar sesión
            window.location.href = 'login.html';
        })
        .catch(err => console.error(err));
});
