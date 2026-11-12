document.addEventListener("DOMContentLoaded", () => {
	verificarToken();
	configurarMostrarContrasenas();
	document.getElementById("formNuevaContrasena").addEventListener("submit", actualizarContrasena);
});

function obtenerToken() {
	const parametros = new URLSearchParams(window.location.search);
	return parametros.get("token");
}

function verificarToken() {
	const token = obtenerToken();
	if (!token) {
		mostrarMensaje("No se proporcionó un enlace de recuperación válido.", "error");
		document.getElementById("nuevoEnlace").style.display = "inline";
		return;
	}
	fetch("../PHP/resetPassword.php?token=" + encodeURIComponent(token), {
		method: "GET",
		credentials: "include",
		cache: "no-store"
	}).then(response => {
		return response.json();
	}).then(data => {
		if (!data.exito) {
			mostrarMensaje(data.mensaje, "error");
			document.getElementById("nuevoEnlace").style.display = "inline";
			return;
		}
	
		document.getElementById("usuarioInfo").style.display = "block";
		document.getElementById("nombreUsuario").textContent = data.nombre_usuario;
		document.getElementById("contenedorFormulario").style.display = "block";
	}).catch(error => {
		console.error("Error:", error);
		mostrarMensaje("No se pudo verificar el enlace de recuperación.", "error");
	});
}

function actualizarContrasena(event) {
	event.preventDefault();
	const nuevaContrasena = document.getElementById("nueva_contrasena").value;
	const confirmarContrasena = document.getElementById("confirmar_contrasena").value;

	if (!nuevaContrasena.trim() || !confirmarContrasena.trim()) {
		mostrarMensaje("Todos los campos son requeridos.", "error");
		return;
	}
	if (nuevaContrasena !== confirmarContrasena) {
		mostrarMensaje("Las contraseñas no coinciden.", "error");
		return;
	}
	if (nuevaContrasena.length < 6) {
		mostrarMensaje("La contraseña debe tener al menos 6 caracteres.", "error");
		return;
	}
	const token = obtenerToken();

	const formData = new FormData();
	formData.append("token", token);
	formData.append("nueva_contrasena", nuevaContrasena);
	formData.append("confirmar_contrasena", confirmarContrasena);
	fetch("../PHP/resetPassword.php", {
		method: "POST",
		credentials: "include",
		body: formData
	}).then(response => {
		return response.json();
	}).then(data => {
		if (!data.exito) {
			mostrarMensaje(data.mensaje, "error");
			return;
		}

		mostrarMensaje(data.mensaje, "success");
		document.getElementById("formNuevaContrasena").style.display = "none";
		document.getElementById("contenedorFormulario").querySelector("p").style.display = "none";
		
		document.getElementById("nuevoEnlace").style.display = "none";
	
		document.getElementById("nueva_contrasena").value = "";
		document.getElementById("confirmar_contrasena").value = "";
	}).catch(error => {
		console.error("Error:", error);
		mostrarMensaje("Ocurrió un error al actualizar la contraseña.", "error");
	});
}

function configurarMostrarContrasenas() {
	const toggle1 = document.getElementById("togglePassword1");
	const toggle2 = document.getElementById("togglePassword2");
	if (toggle1) {
		toggle1.addEventListener("click", function() {
			const input = document.getElementById("nueva_contrasena");
			const tipo = input.getAttribute("type") === "password" ? "text" : "password";
			input.setAttribute("type", tipo);
			this.classList.toggle("bi-eye");
			this.classList.toggle("bi-eye-slash");
		});
	}
	if (toggle2) {
		toggle2.addEventListener("click", function() {
			const input = document.getElementById("confirmar_contrasena");
			const tipo = input.getAttribute("type") === "password" ? "text" : "password";
			input.setAttribute("type", tipo);
			this.classList.toggle("bi-eye");
			this.classList.toggle("bi-eye-slash");
		});
	}
}

function mostrarMensaje(texto, tipo) {
	const mensaje = document.getElementById("mensaje");
	mensaje.textContent = texto;
	mensaje.className = "message " + tipo;
	mensaje.style.display = "block";
}
