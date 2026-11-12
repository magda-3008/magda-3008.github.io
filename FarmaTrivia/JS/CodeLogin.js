const form = document.getElementById("loginForm");
const mensaje = document.getElementById("login-message");

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const nombre_usuario = document.getElementById("usuario").value;
  const clave = document.getElementById("clave").value;

  try {
    const res = await fetch("../PHP/loginController.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ nombre_usuario, clave })
    });

    const data = await res.json();

    if (data.success) {
      mensaje.textContent = "¡Login exitoso!";
      mensaje.style.color = "green";
      setTimeout(() => {
        window.location.href = "perfil.html";
      }, 1000);
    } else {
      mensaje.textContent = data.message;
      mensaje.style.color = "red";
    }
  } catch (err) {
    console.error(err);
    mensaje.textContent = "Error al conectar con el servidor";
    mensaje.style.color = "red";
  }
});

//mostrar u ocultar contraseña
const togglePassword = document.getElementById("togglePassword");
const inputClave = document.getElementById("clave");

togglePassword.addEventListener("click", () => {
  if (inputClave.type === "password") {
    inputClave.type = "text";
    togglePassword.classList.remove("bi-eye");
    togglePassword.classList.add("bi-eye-slash");
  } else {
    inputClave.type = "password";
    togglePassword.classList.remove("bi-eye-slash");
    togglePassword.classList.add("bi-eye");
  }
});