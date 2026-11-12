-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-11-2026 a las 04:06:44
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `farmatriviabdd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_usuario`
--

CREATE TABLE `datos_usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `pts_totales` int(11) DEFAULT 0,
  `nivel_actual` int(11) DEFAULT 1,
  `token` varchar(64) DEFAULT NULL,
  `token_recuperacion` varchar(100) DEFAULT NULL,
  `token_expiracion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `datos_usuario`
--

INSERT INTO `datos_usuario` (`id_usuario`, `nombre_usuario`, `email`, `contrasena`, `foto_perfil`, `pts_totales`, `nivel_actual`, `token`, `token_recuperacion`, `token_expiracion`) VALUES
(1, 'Magda', 'magdaverocas@gmail.com', '$2y$10$9vdBhCX0bMQAIJzKZokupeOSOrqPDkc0DfTjJ4dViGmFvzHwe4uai', 'perfil_1_Gráfico árbol de problemas ilustrado verde y azul.png', 290, 4, '59bb7117ccadecfb73e2ada90df98e4f', NULL, NULL),
(2, 'Danoli', 'juandanielolivasmartinez@gmail.com', '$2y$10$sh5u/EZiryzs8UEN26b5POC5.9Hwlm.l4l.dBJ8UuFAggYP27N73u', NULL, 120, 2, 'e6f804dde95fa701f875108816f6393c', NULL, NULL),
(3, 'Verónica', 'veroverouwu@gmail.com', '$2y$10$tp5Y5h9WGw2Do7VrM5SsK.xYIbapV9NPSb6QXz6E9kllFX1LcusfK', 'perfil_3_Fondo asterik versión de agosto.png', 0, 1, NULL, NULL, NULL),
(4, 'Vero', 'vero@gmail.com', '$2y$10$c4rdzf3WQjTcHG8h4OY7XunKMH6M1Tn08.QZyfio/WmgSuXYky8mu', 'perfil_4_Fondo asterik versión de julio modificado.png', 70, 2, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `niveles`
--

CREATE TABLE `niveles` (
  `id_nivel` int(11) NOT NULL,
  `nombre_nivel` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `niveles`
--

INSERT INTO `niveles` (`id_nivel`, `nombre_nivel`, `descripcion`) VALUES
(1, 'Nivel 1', 'Preguntas básicas de farmacología y ética'),
(2, 'Nivel 2', 'Preguntas intermedias de farmacología y ética'),
(3, 'Nivel 3', 'Preguntas avanzadas de farmacología y ética'),
(4, 'Nivel 4', 'Preguntas sobre antiinflamatorios no esteroideos y su mecanismo de acción.'),
(5, 'Nivel 5', 'Preguntas sobre ansiolíticos, benzodiacepinas y su farmacología.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas`
--

CREATE TABLE `preguntas` (
  `id_pregunta` int(11) NOT NULL,
  `id_nivel` int(11) NOT NULL,
  `texto_pregunta` text NOT NULL,
  `puntos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `preguntas`
--

INSERT INTO `preguntas` (`id_pregunta`, `id_nivel`, `texto_pregunta`, `puntos`) VALUES
(1, 1, 'Vía de administración más rápida de un fármaco.', 10),
(2, 1, 'El principio de beneficencia significa:', 10),
(3, 1, 'Efecto adverso grave de la aspirina:', 10),
(4, 1, '¿Verdadero o falso? El placebo puede tener efectos reales aunque no contenga principios activos.', 10),
(5, 1, 'Antibiótico bactericida:', 10),
(6, 1, 'El principio de autonomía implica:', 10),
(7, 1, '¿Verdadero o falso? Los fármacos liposolubles atraviesan fácilmente la barrera hematoencefálica.', 10),
(8, 1, 'Teratogénico significa:', 10),
(9, 1, 'No maleficencia significa:', 10),
(10, 1, 'Anti-inflamatorio no esteroideo (AINE):', 10),
(11, 2, 'La farmacocinética estudia:', 10),
(12, 2, 'Principio de justicia en ética médica:', 10),
(13, 2, 'Efecto secundario más común de los antihistamínicos:', 10),
(14, 2, '¿Verdadero o falso? La dosis depende solo del peso del paciente.', 10),
(15, 2, 'Un fármaco con potencial de abuso es:', 10),
(16, 2, 'Principio ético que indica respetar la confidencialidad del paciente:', 10),
(17, 2, 'La biodisponibilidad de un fármaco indica:', 10),
(18, 2, '¿Verdadero o falso? Todos los medicamentos de venta libre son seguros en cualquier dosis.', 10),
(19, 2, 'Fármaco usado para tratar hipertensión:', 10),
(20, 2, 'Principio ético que implica honestidad con el paciente:', 10),
(21, 3, 'Reacción adversa grave a antibióticos betalactámicos:', 10),
(22, 3, 'La vía subcutánea se utiliza principalmente para:', 10),
(23, 3, '¿Verdadero o falso? El consentimiento informado es obligatorio en procedimientos riesgosos.', 10),
(24, 3, 'Fármaco anticoagulante:', 10),
(25, 3, 'La farmacodinamia estudia:', 10),
(26, 3, 'Ética profesional significa:', 10),
(27, 3, 'Fármaco antiinflamatorio esteroideo:', 10),
(28, 3, '¿Verdadero o falso? Un medicamento vencido puede perder eficacia y volverse peligroso.', 10),
(29, 3, 'En ética, el principio de dignidad indica:', 10),
(30, 3, 'Farmacéutico que aconseja a un paciente sobre un tratamiento actúa bajo el principio de:', 10),
(31, 4, '¿Cuál es el principal mecanismo de acción de los AINEs (antiinflamatorios no esteroideos)?', 10),
(32, 4, 'Los AINEs reducen la inflamación al disminuir la síntesis de:', 10),
(33, 4, '¿Qué diferencia principal existe entre COX-1 y COX-2?', 10),
(34, 4, 'El paracetamol (acetaminofén) actúa principalmente:', 10),
(35, 4, 'Los corticosteroides ejercen su acción antiinflamatoria principalmente mediante:', 10),
(36, 5, '¿Cuál es el principal mecanismo de acción de las benzodiacepinas?', 10),
(37, 5, 'El neurotransmisor más directamente relacionado con el efecto ansiolítico de las benzodiacepinas es:', 10),
(38, 5, 'La buspirona, un ansiolítico no benzodiacepínico, actúa principalmente como:', 10),
(39, 5, 'A diferencia de las benzodiacepinas, la buspirona no causa sedación importante porque:', 10),
(40, 5, 'Los barbitúricos difieren de las benzodiacepinas porque:', 10),
(41, 4, '¿Cuál es la dosis habitual de ibuprofeno para adultos en caso de dolor leve o moderado?', 10),
(42, 4, '¿Cuál es la dosis máxima recomendada de naproxeno en adultos por día?', 10),
(43, 4, '¿Cuál de los siguientes AINEs se asocia con menor riesgo gastrointestinal?', 10),
(44, 4, 'El uso prolongado de AINEs puede causar principalmente:', 10),
(45, 4, '¿Cuál de los siguientes AINEs está contraindicado en niños por riesgo de síndrome de Reye?', 10),
(46, 5, '¿Cuál es la dosis inicial recomendada de diazepam en adultos para ansiedad?', 10),
(47, 5, '¿Cuál es la dosis habitual de lorazepam para tratar la ansiedad generalizada?', 10),
(48, 5, '¿Cuál de los siguientes fármacos tiene mayor riesgo de dependencia física y psicológica?', 10),
(49, 5, '¿Cuál es la dosis inicial recomendada de diazepam en adultos para ansiedad?', 10),
(50, 5, '¿Cuál es la dosis habitual de lorazepam para tratar la ansiedad generalizada?', 10),
(51, 5, '¿Cuál de los siguientes fármacos tiene mayor riesgo de dependencia física y psicológica?', 10),
(52, 5, '¿Qué precaución debe tenerse al suspender el uso prolongado de benzodiacepinas?', 10),
(53, 5, '¿Cuál de las siguientes benzodiacepinas tiene una vida media corta?', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `progreso_usuario`
--

CREATE TABLE `progreso_usuario` (
  `id_progreso` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_nivel` int(11) NOT NULL,
  `puntos_obtenidos` int(11) DEFAULT 0,
  `completado` tinyint(1) DEFAULT 0,
  `fecha_ultimo_intento` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `progreso_usuario`
--

INSERT INTO `progreso_usuario` (`id_progreso`, `id_usuario`, `id_nivel`, `puntos_obtenidos`, `completado`, `fecha_ultimo_intento`) VALUES
(1, 1, 1, 90, 1, '2025-10-20 19:21:06'),
(2, 1, 2, 100, 1, '2025-10-20 19:11:16'),
(3, 1, 3, 60, 1, '2025-10-20 19:28:41'),
(4, 1, 4, 40, 0, '2025-10-22 15:21:35'),
(5, 1, 5, 0, 0, '2025-10-20 19:17:35'),
(6, 2, 1, 70, 1, '2025-10-21 19:15:54'),
(7, 2, 2, 50, 0, '2025-10-21 19:16:28'),
(8, 2, 3, 0, 0, '2025-10-21 14:43:15'),
(9, 2, 4, 0, 0, '2025-10-21 14:43:15'),
(10, 2, 5, 0, 0, '2025-10-21 14:43:15'),
(11, 3, 1, 0, 0, '2025-10-21 21:55:12'),
(12, 3, 2, 0, 0, '2025-10-21 21:55:12'),
(13, 3, 3, 0, 0, '2025-10-21 21:55:12'),
(14, 3, 4, 0, 0, '2025-10-21 21:55:12'),
(15, 3, 5, 0, 0, '2025-10-21 21:55:12'),
(16, 4, 1, 70, 1, '2026-11-11 16:11:39'),
(17, 4, 2, 0, 0, '2026-11-11 16:01:39'),
(18, 4, 3, 0, 0, '2026-11-11 16:01:39'),
(19, 4, 4, 0, 0, '2026-11-11 16:01:39'),
(20, 4, 5, 0, 0, '2026-11-11 16:01:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rangos`
--

CREATE TABLE `rangos` (
  `id_rango` int(11) NOT NULL,
  `nombre_rango` varchar(50) NOT NULL,
  `min_puntos` int(11) NOT NULL,
  `max_puntos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rangos`
--

INSERT INTO `rangos` (`id_rango`, `nombre_rango`, `min_puntos`, `max_puntos`) VALUES
(1, 'XD', 0, 20),
(2, 'Intermedio', 21, 40),
(3, 'Avanzado', 41, 60),
(4, 'Experto', 61, 80),
(5, 'Maestro', 81, 100),
(6, 'Principiante', 0, 20),
(7, 'Intermedio', 21, 40),
(8, 'Avanzado', 41, 60),
(9, 'Experto', 61, 80),
(10, 'Maestro', 81, 100),
(11, 'Principiante', 0, 20),
(12, 'Intermedio', 21, 40),
(13, 'Avanzado', 41, 60),
(14, 'Experto', 61, 80),
(15, 'Maestro', 81, 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recovery_tokens`
--

CREATE TABLE `recovery_tokens` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expira` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recovery_tokens`
--

INSERT INTO `recovery_tokens` (`id`, `id_usuario`, `token`, `expira`) VALUES
(1, 1, '075f28bb57932011718293d00764c3e0', '2025-10-22 04:24:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestas`
--

CREATE TABLE `respuestas` (
  `id_respuesta` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `texto_respuesta` text NOT NULL,
  `es_correcta` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `respuestas`
--

INSERT INTO `respuestas` (`id_respuesta`, `id_pregunta`, `texto_respuesta`, `es_correcta`) VALUES
(1, 1, 'Oral', 0),
(2, 1, 'Intravenosa', 1),
(3, 1, 'Tópica', 0),
(4, 1, 'Subcutánea', 0),
(5, 2, 'Hacer daño para enseñar', 0),
(6, 2, 'Actuar en beneficio del paciente', 1),
(7, 2, 'Respetar la autonomía', 0),
(8, 2, 'Proteger solo a los familiares', 0),
(9, 3, 'Hemorragia gastrointestinal', 1),
(10, 3, 'Dolor de cabeza leve', 0),
(11, 3, 'Sequedad de boca', 0),
(12, 3, 'Sedación', 0),
(13, 4, 'Verdadero', 1),
(14, 4, 'Falso', 0),
(15, 5, 'Penicilina', 1),
(16, 5, 'Tetraciclina', 0),
(17, 5, 'Cloranfenicol', 0),
(18, 5, 'Eritromicina', 0),
(19, 6, 'El profesional decide todo', 0),
(20, 6, 'Respetar la decisión informada del paciente', 1),
(21, 6, 'Actuar según normas institucionales', 0),
(22, 6, 'Priorizar la economía del tratamiento', 0),
(23, 7, 'Verdadero', 1),
(24, 7, 'Falso', 0),
(25, 8, 'Produce fiebre', 0),
(26, 8, 'Afecta riñón', 0),
(27, 8, 'Provoca malformaciones en el feto', 1),
(28, 8, 'Estimula apetito', 0),
(29, 9, 'Evitar daño al paciente', 1),
(30, 9, 'Administrar medicación sin indicación', 0),
(31, 9, 'Priorizar beneficio económico', 0),
(32, 9, 'Obligar tratamiento', 0),
(33, 10, 'Ibuprofeno', 1),
(34, 10, 'Insulina', 0),
(35, 10, 'Omeprazol', 0),
(36, 10, 'Metformina', 0),
(37, 11, 'Qué hace el fármaco en el cuerpo', 0),
(38, 11, 'Cómo el cuerpo absorbe, distribuye, metaboliza y elimina el fármaco', 1),
(39, 11, 'Solo la toxicidad', 0),
(40, 11, 'Solo la dosis', 0),
(41, 12, 'Tratar a todos con equidad', 1),
(42, 12, 'Priorizar amigos y familiares', 0),
(43, 12, 'Actuar según intereses económicos', 0),
(44, 12, 'Solo dar tratamiento a quien paga', 0),
(45, 13, 'Somnolencia', 1),
(46, 13, 'Hipertensión', 0),
(47, 13, 'Insomnio', 0),
(48, 13, 'Diarrea', 0),
(49, 14, 'Verdadero', 0),
(50, 14, 'Falso', 1),
(51, 15, 'Paracetamol', 0),
(52, 15, 'Morfina', 1),
(53, 15, 'Amoxicilina', 0),
(54, 15, 'Omeprazol', 0),
(55, 16, 'Confidencialidad', 1),
(56, 17, 'La dosis máxima tolerada', 0),
(57, 17, 'La cantidad que llega a la circulación sistémica', 1),
(58, 17, 'La velocidad de eliminación', 0),
(59, 17, 'Su toxicidad', 0),
(60, 18, 'Verdadero', 0),
(61, 18, 'Falso', 1),
(62, 19, 'Lisinopril', 1),
(63, 19, 'Ibuprofeno', 0),
(64, 19, 'Metformina', 0),
(65, 19, 'Loratadina', 0),
(66, 20, 'Veracidad', 1),
(67, 21, 'Diarrea', 0),
(68, 21, 'Anemia', 0),
(69, 21, 'Anafilaxia', 1),
(70, 21, 'Somnolencia', 0),
(71, 22, 'Fármacos de absorción rápida', 0),
(72, 22, 'Vacunas y hormonas', 1),
(73, 22, 'Antibióticos de acción inmediata', 0),
(74, 22, 'Medicamentos tópicos', 0),
(75, 23, 'Verdadero', 1),
(76, 23, 'Falso', 0),
(77, 24, 'Heparina', 1),
(78, 24, 'Paracetamol', 0),
(79, 24, 'Loratadina', 0),
(80, 24, 'Omeprazol', 0),
(81, 25, 'Efectos de los fármacos en el organismo', 1),
(82, 25, 'Absorción y eliminación', 0),
(83, 25, 'Toxicidad únicamente', 0),
(84, 25, 'Farmacogenética', 0),
(85, 26, 'Cumplir leyes locales solamente', 0),
(86, 26, 'Actuar con responsabilidad y respeto', 1),
(87, 26, 'Priorizar ganancias económicas', 0),
(88, 26, 'Trabajar solo si hay supervisión', 0),
(89, 27, 'Ibuprofeno', 0),
(90, 27, 'Prednisona', 1),
(91, 27, 'Paracetamol', 0),
(92, 27, 'Amoxicilina', 0),
(93, 28, 'Verdadero', 1),
(94, 28, 'Falso', 0),
(95, 29, 'Tratar al paciente con respeto y consideración', 1),
(96, 29, 'Dar prioridad a los amigos', 0),
(97, 29, 'Actuar solo según reglas internas', 0),
(98, 29, 'Ignorar la opinión del paciente', 0),
(99, 30, 'Justicia', 0),
(100, 30, 'Beneficencia', 1),
(101, 30, 'Autonomía', 0),
(102, 30, 'No maleficencia', 0),
(103, 31, 'Bloqueo de los receptores GABA-A', 0),
(104, 31, 'Inhibición de la enzima ciclooxigenasa (COX)', 1),
(105, 31, 'Estimulación de la liberación de serotonina', 0),
(106, 31, 'Activación del sistema adrenérgico', 0),
(107, 32, 'Dopamina', 0),
(108, 32, 'Prostaglandinas', 1),
(109, 32, 'Noradrenalina', 0),
(110, 32, 'Histamina', 0),
(111, 33, 'COX-1 se expresa solo en el cerebro', 0),
(112, 33, 'COX-2 es la isoforma inducible durante la inflamación', 1),
(113, 33, 'COX-2 produce ácido araquidónico', 0),
(114, 33, 'COX-1 es inhibida solo por paracetamol', 0),
(115, 34, 'Inhibiendo COX-1 en tejidos periféricos', 0),
(116, 34, 'Aumentando la liberación de GABA', 0),
(117, 34, 'Inhibiendo COX en el sistema nervioso central', 1),
(118, 34, 'Bloqueando los receptores NMDA', 0),
(119, 35, 'Inhibición directa de la COX', 0),
(120, 35, 'Activación de los receptores glucocorticoides que reducen la síntesis de citocinas', 1),
(121, 35, 'Inhibición de los receptores GABA-A', 0),
(122, 35, 'Estimulación de la liberación de adrenalina', 0),
(123, 36, 'Inhibición de la recaptación de serotonina', 0),
(124, 36, 'Bloqueo de los receptores dopaminérgicos D2', 0),
(125, 36, 'Potenciación de la acción del GABA en el receptor GABA-A', 1),
(126, 36, 'Inhibición de la enzima monoaminooxidasa', 0),
(127, 37, 'Dopamina', 0),
(128, 37, 'Noradrenalina', 0),
(129, 37, 'GABA (ácido gamma-aminobutírico)', 1),
(130, 37, 'Acetilcolina', 0),
(131, 38, 'Agonista parcial de los receptores de serotonina 5-HT1A', 1),
(132, 38, 'Antagonista de los receptores NMDA', 0),
(133, 38, 'Bloqueador de los canales de calcio', 0),
(134, 38, 'Inhibidor de la monoaminooxidasa', 0),
(135, 39, 'No actúa sobre receptores GABA', 1),
(136, 39, 'Aumenta la dopamina', 0),
(137, 39, 'Inhibe COX-2', 0),
(138, 39, 'Activa los receptores de histamina', 0),
(139, 40, 'Disminuyen la duración de la apertura del canal GABA-A', 0),
(140, 40, 'Prolongan la apertura del canal GABA-A y pueden abrirlo directamente en dosis altas', 1),
(141, 40, 'No afectan el receptor GABA-A', 0),
(142, 40, 'Son antagonistas dopaminérgicos', 0),
(143, 41, '200-400 mg cada 6-8 horas', 1),
(144, 41, '50 mg cada 12 horas', 0),
(145, 41, '1000 mg cada 4 horas', 0),
(146, 41, '10 mg/kg cada hora', 0),
(147, 42, '500 mg/día', 0),
(148, 42, '1000 mg/día', 0),
(149, 42, '1250 mg/día', 1),
(150, 42, '2000 mg/día', 0),
(151, 43, 'Celecoxib', 1),
(152, 43, 'Indometacina', 0),
(153, 43, 'Ketorolaco', 0),
(154, 43, 'Diclofenaco', 0),
(155, 44, 'Hipotensión crónica', 0),
(156, 44, 'Daño renal y úlceras gástricas', 1),
(157, 44, 'Hiperglucemia', 0),
(158, 44, 'Anemia perniciosa', 0),
(159, 45, 'Aspirina (ácido acetilsalicílico)', 1),
(160, 45, 'Ibuprofeno', 0),
(161, 45, 'Naproxeno', 0),
(162, 45, 'Meloxicam', 0),
(163, 46, '2-10 mg dos a cuatro veces al día', 1),
(164, 46, '0.5 mg una vez al día', 0),
(165, 46, '50 mg cada 8 horas', 0),
(166, 46, '100 mg una vez al día', 0),
(167, 47, '1-3 mg/día divididos en varias dosis', 1),
(168, 47, '10 mg/día en una sola toma', 0),
(169, 47, '20 mg cada 6 horas', 0),
(170, 47, '0.1 mg cada 12 horas', 0),
(171, 48, 'Diazepam', 1),
(172, 48, 'Buspirona', 0),
(173, 48, 'Propranolol', 0),
(174, 48, 'Melatonina', 0),
(175, 49, '2-10 mg dos a cuatro veces al día', 1),
(176, 49, '0.5 mg una vez al día', 0),
(177, 49, '50 mg cada 8 horas', 0),
(178, 49, '100 mg una vez al día', 0),
(179, 50, '1-3 mg/día divididos en varias dosis', 1),
(180, 50, '10 mg/día en una sola toma', 0),
(181, 50, '20 mg cada 6 horas', 0),
(182, 50, '0.1 mg cada 12 horas', 0),
(183, 51, 'Diazepam', 1),
(184, 51, 'Buspirona', 0),
(185, 51, 'Propranolol', 0),
(186, 51, 'Melatonina', 0),
(187, 52, 'Suspender abruptamente para evitar efectos secundarios', 0),
(188, 52, 'Reducir la dosis gradualmente para evitar síndrome de abstinencia', 1),
(189, 52, 'Aumentar la dosis antes de suspenderla', 0),
(190, 52, 'Cambiar a un antidepresivo de inmediato', 0),
(191, 53, 'Midazolam', 1),
(192, 53, 'Diazepam', 0),
(193, 53, 'Clonazepam', 0),
(194, 53, 'Flurazepam', 0),
(195, 16, 'Autonomía', 0),
(196, 16, 'Beneficencia', 0),
(197, 16, 'Justicia', 0),
(198, 20, 'Justicia', 0),
(199, 20, 'No maleficencia', 0),
(200, 20, 'Autonomía', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `datos_usuario`
--
ALTER TABLE `datos_usuario`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `niveles`
--
ALTER TABLE `niveles`
  ADD PRIMARY KEY (`id_nivel`);

--
-- Indices de la tabla `preguntas`
--
ALTER TABLE `preguntas`
  ADD PRIMARY KEY (`id_pregunta`),
  ADD KEY `id_nivel` (`id_nivel`);

--
-- Indices de la tabla `progreso_usuario`
--
ALTER TABLE `progreso_usuario`
  ADD PRIMARY KEY (`id_progreso`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`,`id_nivel`),
  ADD KEY `id_nivel` (`id_nivel`);

--
-- Indices de la tabla `rangos`
--
ALTER TABLE `rangos`
  ADD PRIMARY KEY (`id_rango`);

--
-- Indices de la tabla `recovery_tokens`
--
ALTER TABLE `recovery_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `respuestas`
--
ALTER TABLE `respuestas`
  ADD PRIMARY KEY (`id_respuesta`),
  ADD KEY `id_pregunta` (`id_pregunta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `datos_usuario`
--
ALTER TABLE `datos_usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `niveles`
--
ALTER TABLE `niveles`
  MODIFY `id_nivel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `preguntas`
--
ALTER TABLE `preguntas`
  MODIFY `id_pregunta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `progreso_usuario`
--
ALTER TABLE `progreso_usuario`
  MODIFY `id_progreso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `rangos`
--
ALTER TABLE `rangos`
  MODIFY `id_rango` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `recovery_tokens`
--
ALTER TABLE `recovery_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `respuestas`
--
ALTER TABLE `respuestas`
  MODIFY `id_respuesta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `preguntas`
--
ALTER TABLE `preguntas`
  ADD CONSTRAINT `preguntas_ibfk_1` FOREIGN KEY (`id_nivel`) REFERENCES `niveles` (`id_nivel`) ON DELETE CASCADE;

--
-- Filtros para la tabla `progreso_usuario`
--
ALTER TABLE `progreso_usuario`
  ADD CONSTRAINT `progreso_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `datos_usuario` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `progreso_usuario_ibfk_2` FOREIGN KEY (`id_nivel`) REFERENCES `niveles` (`id_nivel`) ON DELETE CASCADE;

--
-- Filtros para la tabla `respuestas`
--
ALTER TABLE `respuestas`
  ADD CONSTRAINT `respuestas_ibfk_1` FOREIGN KEY (`id_pregunta`) REFERENCES `preguntas` (`id_pregunta`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
