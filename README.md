# Asistente Académico Virtual UNAB — CCD y Gestión Estudiantil

Proyecto integrador Full Stack con Inteligencia Artificial diseñado para optimizar la atención estudiantil de la **Universidad Autónoma de Bucaramanga (UNAB)** y su **Centro de Competencias Digitales (CCD)** mediante el protocolo **Model Context Protocol (MCP)**.

---

## Arquitectura del Sistema

```mermaid
flowchart LR
    U[Estudiante / Interfaz Web n8n] -->|Mensaje HTTP| A[AI Agent - n8n]
    A <-->|Razonamiento + Memoria| G[Google Gemini]
    A <-->|MCP Streamable HTTP :9000| M[Servidor FastMCP - Python]
    M <-->|Consultas SQL / REST + RLS| S[(Supabase PostgreSQL)]