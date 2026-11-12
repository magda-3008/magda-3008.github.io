const urlParams = new URLSearchParams(window.location.search);
const id_nivel = urlParams.get('id_nivel');
document.getElementById('nivel-title').innerText = id_nivel;

const container = document.getElementById('trivia-container');
const resultadoDiv = document.getElementById('resultado');
const submitBtn = document.getElementById('submit-btn');

let preguntasGlobal = [];

fetch(`../PHP/triviaController.php?id_nivel=${id_nivel}`)
  .then(res => res.json())
  .then(preguntas => {
    preguntasGlobal = preguntas;

    preguntas.forEach(preg => {
      const div = document.createElement('div');
      div.className = 'mb-3 pregunta-div';
      div.dataset.idPregunta = preg.id_pregunta;

      let html = `<h5>${preg.texto_pregunta}</h5>`;
      preg.respuestas.forEach(resp => {
        html += `
          <div class="form-check">
            <input class="form-check-input" type="radio" name="pregunta${preg.id_pregunta}" value="${resp.id_respuesta}">
            <label class="form-check-label">${resp.texto_respuesta}</label>
          </div>
        `;
      });

      div.innerHTML = html;
      container.appendChild(div);
    });
  });

submitBtn.addEventListener('click', () => {
  let puntos = 0;

  preguntasGlobal.forEach(preg => {
    const opciones = document.getElementsByName(`pregunta${preg.id_pregunta}`);
    let seleccion = null;

    opciones.forEach(opt => { if (opt.checked) seleccion = opt.value; });

    const correcta = preg.respuestas.find(r => r.es_correcta);
    const divPregunta = document.querySelector(`.pregunta-div[data-id-pregunta='${preg.id_pregunta}']`);

    divPregunta.querySelectorAll('label').forEach(label => label.style.color = '');

    if (seleccion == correcta.id_respuesta) {
      puntos += 10;
      divPregunta.querySelectorAll('input').forEach(i => {
        if (i.value == correcta.id_respuesta) i.nextElementSibling.style.color = 'green';
      });
    } else {
      divPregunta.querySelectorAll('input').forEach(i => {
        if (i.value == correcta.id_respuesta) i.nextElementSibling.style.color = 'green';
        if (i.checked) i.nextElementSibling.style.color = 'red';
      });
    }
  });

resultadoDiv.innerHTML = `<h4>¡Obtuviste ${puntos} puntos!</h4>`;
submitBtn.disabled = true;

  // Crear contenedor de botones
  const botonesDiv = document.createElement('div');
  botonesDiv.style.display = 'flex';
  botonesDiv.style.justifyContent = 'center';
  botonesDiv.style.gap = '15px';
  botonesDiv.style.marginTop = '20px';

  // Botón volver a niveles
  const btnVolver = document.createElement('button');
  btnVolver.textContent = 'Volver a Niveles';
  btnVolver.className = 'btn btn-secondary';
  btnVolver.style.fontWeight = 'bold';
  btnVolver.addEventListener('click', () => {
    window.location.href = 'niveles.html';
  });
  botonesDiv.appendChild(btnVolver);

  // Si el usuario obtuvo 60 puntos o más, mostrar botón de siguiente nivel
  if (puntos >= 60) {
    const siguienteNivel = parseInt(id_nivel) + 1;
    const btnSiguiente = document.createElement('button');
    btnSiguiente.textContent = 'Siguiente Nivel';
    btnSiguiente.className = 'btn btn-success';
    btnSiguiente.style.fontWeight = 'bold';
    btnSiguiente.addEventListener('click', () => {
      window.location.href = `trivia.html?id_nivel=${siguienteNivel}`;
    });
    botonesDiv.appendChild(btnSiguiente);
  }

  resultadoDiv.appendChild(botonesDiv);

  // Enviar resultado a PHP para actualizar progreso_usuario
  fetch('../PHP/guardarProgreso.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `id_nivel=${id_nivel}&puntos=${puntos}`
  })
  .then(res => res.json())
  .then(data => console.log('Progreso guardado', data))
  .catch(err => console.error(err));

});
