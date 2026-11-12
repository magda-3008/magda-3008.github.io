document.addEventListener("DOMContentLoaded", cargarPerfil);

function cargarPerfil() {
	fetch("../PHP/perfilController.php", {
		method: "GET",
		credentials: "include",
		cache: "no-store"
	}).then(response => {
		if (response.status === 401) {
			window.location.href = "login.html";
			return;
		}
		if (!response.ok) {
			throw new Error("Error al obtener los datos del perfil.");
		}
		return response.json();
	}).then(data => {
		if (!data) {
			return;
		}
		mostrarDatosUsuario(data);
		mostrarProgreso(data.progreso);
	}).catch(error => {
		console.error("Error:", error);
		alert("No se pudo cargar la información del perfil.");
	});
}

function mostrarDatosUsuario(data) {
	const nombreUsuario = document.getElementById("nombreUsuario");
	if (nombreUsuario) {
		nombreUsuario.textContent = data.nombre_usuario || "";
	}
	const correoUsuario = document.getElementById("correoUsuario");
	if (correoUsuario) {
		correoUsuario.textContent = data.email || "";
	}
	const puntosTotales = document.getElementById("puntosTotales");
	if (puntosTotales) {
		puntosTotales.textContent = data.pts_totales ?? 0;
	}
	const nivelActual = document.getElementById("nivelActual");
	if (nivelActual) {
		nivelActual.textContent = data.nivel_actual_text || "Principiante";
	}
	const fotoPerfil = document.getElementById("fotoPerfil");
	if (fotoPerfil && data.foto_perfil) {
		fotoPerfil.src = "../Resource/" + data.foto_perfil;
	}
}

function mostrarProgreso(progreso) {
	const contenedor = document.getElementById("progresoNiveles");
	if (!contenedor) {
		return;
	}
	contenedor.innerHTML = "";
	const nombresNiveles = {
		1: "Principiante",
		2: "Intermedio",
		3: "Avanzado",
		4: "Experto",
		5: "Maestro"
	};
	for (let i = 1; i <= 5; i++) {
		const nivel = progreso[i] || {
			puntos: 0,
			completado: 0
		};
		let puntos = Number(nivel.puntos) || 0;
		if (puntos > 100) {
			puntos = 100;
		}
		if (puntos < 0) {
			puntos = 0;
		}
		const completado = Number(nivel.completado) === 1;
		const color = completado ? "bg-success" : "bg-warning";
		const columna = document.createElement("div");
		columna.className = "col-sm-6 mb-3";
		columna.innerHTML = `

            <div class="card shadow-sm">

                <div class="card-body">

                    <h5 class="card-title">
                        Nivel ${i}: ${nombresNiveles[i]}
                    </h5>


                    <p class="card-text">
                        Progreso: ${puntos}%
                    </p>


                    <div
                        class="progress"
                        style="height: 20px;"
                    >

                        <div
                            class="progress-bar ${color}"
                            role="progressbar"
                            style="width: ${puntos}%;"
                            aria-valuenow="${puntos}"
                            aria-valuemin="0"
                            aria-valuemax="100"
                        >
                            ${puntos}%
                        </div>

                    </div>


                    ${
                        completado
                            ? `
                                <p class="mt-2 text-success">
                                    <strong>
                                        ¡Nivel completado!
                                    </strong>
                                </p>
                              `
                            : ""
                    }

                </div>

            </div>

        `;
		contenedor.appendChild(columna);
	}
}
