document.addEventListener("DOMContentLoaded", () => {
    document
        .getElementById("formRecuperacion")
        .addEventListener("submit", solicitarRecuperacion);
});


function solicitarRecuperacion(event) {
    event.preventDefault();

    const email = document.getElementById("email").value.trim();

    if (!email) {
        mostrarMensaje("Por favor ingresa tu email.", "error");
        return;
    }

    const formData = new FormData();
    formData.append("email", email);

    fetch("../PHP/OlvidoContra.php", {
        method: "POST",
        credentials: "include",
        body: formData
    })
        .then(response => {
            return response.json();
        })
        .then(data => {
            if (!data.exito) {
                mostrarMensaje(data.mensaje, "error");
                return;
            }

            mostrarMensaje(data.mensaje, "success");

            if (data.enlace_recuperacion) {
                const contenedor = document.getElementById("contenedorEnlace");
                const enlace = document.getElementById("enlaceRecuperacion");

                enlace.href = data.enlace_recuperacion;
                enlace.textContent = data.enlace_recuperacion;

                contenedor.style.display = "block";
            }

            document.getElementById("formRecuperacion").style.display = "none";
        })
        .catch(error => {
            console.error("Error:", error);
            mostrarMensaje(
                "Ocurrió un error al procesar la solicitud.",
                "error"
            );
        });
}

function mostrarMensaje(texto, tipo) {
    const mensaje = document.getElementById("mensaje");

    mensaje.textContent = texto;
    mensaje.className = "message " + tipo;
    mensaje.style.display = "block";
}