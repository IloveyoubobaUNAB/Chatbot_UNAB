# Asistente Académico Virtual UNAB — CCD y Gestión Estudiantil

Agente conversacional académico construido con **n8n**, **FastMCP (Python)**, **Supabase (PostgreSQL)** y **Google Gemini** mediante el protocolo **Model Context Protocol (MCP)**.

## Arquitectura del Sistema
* **Interfaz y Orquestación (n8n):** Chat web institucional conectado a un nodo AI Agent con memoria conversacional y cliente MCP.
* **Servidor de Herramientas (FastMCP):** Microservicio en Python (server.py) expuesto por HTTP streamable en el puerto 9000 dentro de Docker.
* **Base de Datos y Seguridad (Supabase):** PostgreSQL con vistas consolidadas (vista_resumen_academico), base documental (documents) y políticas Row Level Security (RLS) habilitadas.

## Herramientas MCP Disponibles
1. consultar_estado_estudiante: Consulta estado de matrícula, semestre, promedio acumulado y avance de créditos.
2. consultar_historial_y_requisitos: Lista asignaturas aprobadas, matriculadas, pendientes y sus prerrequisitos en el pensum.
3. consultar_cursos_ccd: Consulta cursos e insignias digitales del Centro de Competencias Digitales (CCD).
4. consultar_noticias_ccd: Obtiene convocatorias, talleres y novedades vigentes del CCD.
5. consultar_reglamento_unab: Búsqueda sobre normativa institucional, homologación de insignias y cancelación de materias.

## Despliegue Local con Docker
1. Clonar el repositorio y copiar .env.example a .env completando las credenciales de Supabase.
2. Ejecutar schema.sql en el SQL Editor de Supabase.
3. Levantar los contenedores:
   docker compose up -d --build
4. Importar workflow_n8n.json en n8n (http://localhost:5678), configurar las credenciales de Gemini y publicar el workflow.
