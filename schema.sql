-- ============================================================================
-- ESQUEMA DE BASE DE DATOS - ASISTENTE ACADÉMICO VIRTUAL UNAB
-- ============================================================================

-- 1. Tablas Principales
CREATE TABLE IF NOT EXISTS public.estudiantes (
  codigo_estudiante VARCHAR PRIMARY KEY,
  nombre VARCHAR NOT NULL,
  programa VARCHAR NOT NULL,
  semestre_actual INTEGER NOT NULL,
  estado_matricula VARCHAR NOT NULL,
  promedio_acumulado NUMERIC(3,2) NOT NULL,
  creditos_aprobados INTEGER NOT NULL,
  creditos_totales_programa INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS public.pensum_materias (
  codigo_materia VARCHAR PRIMARY KEY,
  nombre_materia VARCHAR NOT NULL,
  semestre_sugerido INTEGER NOT NULL,
  creditos INTEGER NOT NULL,
  prerrequisito_codigo VARCHAR REFERENCES public.pensum_materias(codigo_materia)
);

CREATE TABLE IF NOT EXISTS public.historial_academico (
  id SERIAL PRIMARY KEY,
  codigo_estudiante VARCHAR REFERENCES public.estudiantes(codigo_estudiante),
  codigo_materia VARCHAR REFERENCES public.pensum_materias(codigo_materia),
  estado VARCHAR NOT NULL,
  nota NUMERIC(3,2)
);

CREATE TABLE IF NOT EXISTS public.cursos_ccd (
  id SERIAL PRIMARY KEY,
  codigo_estudiante VARCHAR REFERENCES public.estudiantes(codigo_estudiante),
  nombre_curso VARCHAR NOT NULL,
  insignia_obtenida VARCHAR,
  estado VARCHAR NOT NULL,
  fecha_completado DATE
);

CREATE TABLE IF NOT EXISTS public.noticias_ccd (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR NOT NULL,
  descripcion TEXT NOT NULL,
  fecha_publicacion DATE DEFAULT CURRENT_DATE,
  enlace VARCHAR
);

CREATE TABLE IF NOT EXISTS public.documents (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  metadata JSONB
);

-- 2. Vista Consolidada de Resumen Académico
CREATE OR REPLACE VIEW public.vista_resumen_academico AS
SELECT
  codigo_estudiante,
  nombre,
  programa,
  semestre_actual,
  estado_matricula,
  promedio_acumulado,
  creditos_aprobados,
  creditos_totales_programa,
  (creditos_totales_programa - creditos_aprobados) AS creditos_faltantes,
  CEIL((creditos_totales_programa - creditos_aprobados)::numeric / 16.0) AS semestres_restantes_estimados
FROM public.estudiantes;

-- 3. Seguridad Row Level Security (RLS)
ALTER TABLE public.estudiantes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pensum_materias ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historial_academico ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cursos_ccd ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.noticias_ccd ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

-- 4. Datos de Pensum Base
INSERT INTO public.pensum_materias (codigo_materia, nombre_materia, semestre_sugerido, creditos, prerrequisito_codigo)
VALUES
  ('SIS101', 'Fundamentos de Programación', 1, 4, NULL),
  ('SIS201', 'Estructura de Datos', 2, 4, 'SIS101'),
  ('SIS301', 'Bases de Datos I', 3, 4, 'SIS201'),
  ('SIS401', 'Ingeniería de Software I', 4, 4, 'SIS301'),
  ('SIS501', 'Inteligencia Artificial', 5, 3, 'SIS201'),
  ('SIS601', 'Ciencia de Datos', 6, 3, 'SIS501')
ON CONFLICT (codigo_materia) DO NOTHING;

-- 5. Perfiles de Estudiantes de Prueba (10 perfiles)
INSERT INTO public.estudiantes (codigo_estudiante, nombre, programa, semestre_actual, estado_matricula, promedio_acumulado, creditos_aprobados, creditos_totales_programa)
VALUES
  ('U00174682', 'Martin Santiago Rodriguez Quesada', 'Ingeniería de Sistemas', 7, 'Activa', 3.68, 112, 160),
  ('U00174101', 'Laura Valentina Gómez Pérez', 'Ingeniería de Sistemas', 8, 'Activa', 4.42, 128, 160),
  ('U00174102', 'Andrés Felipe Rincón Duarte', 'Ingeniería de Sistemas', 4, 'Pendiente Pago', 3.25, 58, 160),
  ('U00174103', 'Camila Andrea Mantilla Silva', 'Ingeniería de Sistemas', 6, 'Activa', 4.15, 96, 160),
  ('U00174104', 'Sebastián Camilo Ortiz Vega', 'Ingeniería de Sistemas', 3, 'Activa', 2.95, 40, 160),
  ('U00174105', 'Daniela Sofía Quintero León', 'Ingeniería de Sistemas', 9, 'Activa', 4.61, 146, 160),
  ('U00174106', 'Juan David Cáceres Moreno', 'Ingeniería de Sistemas', 5, 'Pendiente Pago', 3.54, 76, 160),
  ('U00174107', 'Valeria Alejandra Prada Niño', 'Ingeniería de Sistemas', 2, 'Activa', 3.89, 28, 160),
  ('U00174108', 'Nicolás Esteban Vargas Jaimes', 'Ingeniería de Sistemas', 7, 'Activa', 3.77, 110, 160),
  ('U00174109', 'Mariana Isabel Sarmiento Cruz', 'Ingeniería de Sistemas', 10, 'Activa', 4.30, 154, 160)
ON CONFLICT (codigo_estudiante) DO NOTHING;
