document.addEventListener("DOMContentLoaded", cargarConfiguracion);

function cargarConfiguracion() {
	fetch("../PHP/actualizar_perfil.php", {
		method: "GET",
		credentials: "include",
		cache: "no-store"
	}).then(response => {
		if (response.status === 401) {
			window.location.href = "login.html";
			return;
		}
		if (!response.ok) {
			throw new Error("No se pudo cargar la configuración.");
		}
		return response.json();
	}).then(data => {
		if (!data) {
			return;
		}
		const preview = document.getElementById("preview");
		if (preview) {
			const foto = data.foto_perfil || "user.webp";
			if (foto.startsWith("../") || foto.startsWith("http://") || foto.startsWith("https://")) {
				preview.src = foto;
			} else {
				preview.src = "../Resource/" + foto;
			}
		}
	}).catch(error => {
		console.error("Error:", error);
		mostrarMensaje("No se pudo cargar la información de la cuenta.", "danger");
	});
}
document.getElementById("foto_perfil").addEventListener("change", function(event) {
	const archivo = event.target.files[0];
	if (!archivo) {
		return;
	}
	const reader = new FileReader();
	reader.onload = function() {
		document.getElementById("preview").src = reader.result;
	};
	reader.readAsDataURL(archivo);
});
document.getElementById("formFoto").addEventListener("submit", function(event) {
	event.preventDefault();
	const archivo = document.getElementById("foto_perfil").files[0];
	if (!archivo) {
		mostrarMensaje("Selecciona una imagen.", "warning");
		return;
	}
	const formData = new FormData();
	formData.append("foto_perfil", archivo);
	fetch("../PHP/actualizar_perfil.php", {
		method: "POST",
		credentials: "include",
		body: formData
	}).then(response => {
		if (response.status === 401) {
			window.location.href = "login.html";
			return;
		}
		return response.json();
	}).then(data => {
		if (!data) {
			return;
		}
		if (data.exito) {
			mostrarMensaje(data.mensaje, "success");
		} else {
			mostrarMensaje(data.mensaje, "danger");
		}
	}).catch(error => {
		console.error("Error:", error);
		mostrarMensaje("Ocurrió un error al actualizar la foto.", "danger");
	});
});
document.getElementById("formContrasena").addEventListener("submit", function(event) {
	event.preventDefault();
	const nuevaContrasena = document.getElementById("nueva_contrasena").value;
	if (!nuevaContrasena.trim()) {
		mostrarMensaje("Escribe una nueva contraseña.", "warning");
		return;
	}
	const formData = new FormData();
	formData.append("nueva_contrasena", nuevaContrasena);
	fetch("../PHP/actualizar_perfil.php", {
		method: "POST",
		credentials: "include",
		body: formData
	}).then(response => {
		if (response.status === 401) {
			window.location.href = "login.html";
			return;
		}
		return response.json();
	}).then(data => {
		if (!data) {
			return;
		}
		if (data.exito) {
			mostrarMensaje(data.mensaje, "success");
			document.getElementById("nueva_contrasena").value = "";
		} else {
			mostrarMensaje(data.mensaje, "danger");
		}
	}).catch(error => {
		console.error("Error:", error);
		mostrarMensaje("Ocurrió un error al actualizar la contraseña.", "danger");
	});
});

function mostrarMensaje(texto, tipo) {
	const mensaje = document.getElementById("mensaje");
	mensaje.textContent = texto;
	mensaje.className = "alert alert-" + tipo + " text-center";
	mensaje.style.display = "block";
	setTimeout(function() {
		mensaje.style.display = "none";
	}, 4000);
}
