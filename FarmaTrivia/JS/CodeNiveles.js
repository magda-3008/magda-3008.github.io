const container = document.getElementById("niveles-container");
const MIN_PUNTOS_DESBLOQUEO = 60;

fetch('../PHP/nivelesController.php')
  .then(response => response.json())
  .then(niveles => {
    let nivelAnteriorPuntos = 100;

    niveles.forEach(nivel => {
      const puntos = nivel.puntos_obtenidos;
      const desbloqueado = nivelAnteriorPuntos >= MIN_PUNTOS_DESBLOQUEO;

      // Determinar color de la barra de progreso
      let barraClass = 'bg-danger';
      if (puntos >= 60 && puntos < 80) barraClass = 'bg-warning';
      if (puntos >= 80) barraClass = 'bg-success';

      // Crear tarjeta
      const cardDiv = document.createElement("div");
      cardDiv.className = "card mb-3";

      cardDiv.innerHTML = `
        <div class="card-body">
          <h5 class="card-title">Nivel ${nivel.id_nivel}</h5>
          <p class="card-text">${nivel.descripcion}</p>
          <p>Puntos obtenidos: ${puntos}/100</p>
          <div class="progress mb-2" style="height: 20px;">
            <div class="progress-bar ${barraClass}" role="progressbar" style="width: ${puntos}%;" aria-valuenow="${puntos}" aria-valuemin="0" aria-valuemax="100">
              ${puntos}%
            </div>
          </div>
        </div>
      `;

      // Crear botón dinámicamente
      const boton = document.createElement("button");
      boton.className = "btn iniciar-btn";
      boton.style.fontWeight = "bold"; // texto en negrita

      if (desbloqueado) {
        boton.textContent = "Iniciar nivel";
        boton.style.backgroundColor = "#ffbf00c0"; // amarillo dorado
        boton.style.color = "#b67d03";
        boton.style.border = "none";
        boton.style.transition = "all 0.2s"; // suaviza el hover

        // Hover dinámico
        boton.addEventListener("mouseenter", () => {
          boton.style.backgroundColor = "white"; // amarillo más oscuro
          boton.style.color = "#ffbf00c0";
        });
        boton.addEventListener("mouseleave", () => {
          boton.style.backgroundColor = "#ffbf00c0"; // vuelve al amarillo original
          boton.style.color = "#b67d03";
        });

        // Click
        boton.addEventListener("click", () => {
          window.location.href = `trivia.html?id_nivel=${nivel.id_nivel}`;
        });
      } else {
        boton.textContent = "Nivel bloqueado";
        boton.classList.add("btn-secondary");
        boton.disabled = true;
      }

      // Agregar botón a la tarjeta
      cardDiv.querySelector(".card-body").appendChild(boton);

      // Agregar tarjeta al contenedor
      container.appendChild(cardDiv);

      // Actualizar puntos del nivel anterior
      nivelAnteriorPuntos = puntos;
    });
  })
  .catch(error => console.error('Error al cargar niveles:', error));
