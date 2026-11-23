# Asistente Académico Virtual UNAB — CCD y Gestión Estudiantil

[![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python&logoColor=white)](https://www.python.org/)
[![FastMCP](https://img.shields.io/badge/MCP-FastMCP-emerald)](https://github.com/jlowin/fastmcp)
[![n8n](https://img.shields.io/badge/Orchestration-n8n-orange?logo=n8n&logoColor=white)](https://n8n.io/)
[![Supabase](https://img.shields.io/badge/Database-Supabase%20PostgreSQL-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com/)
[![Docker](https://img.shields.io/badge/Container-Docker%20Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

Proyecto integrador **Full Stack con Inteligencia Artificial Generativa** desarrollado para la **Universidad Autónoma de Bucaramanga (UNAB)**. Implementa un agente conversacional inteligente conectado en tiempo real a los sistemas académicos y del **Centro de Competencias Digitales (CCD)** mediante el estándar abierto **Model Context Protocol (MCP)**.

---

## 1. Planteamiento del Problema y Solución

### Problema
Los estudiantes universitarios enfrentan fricción al consultar su estado académico, avance de créditos, prerrequisitos de materias, certificaciones digitales del CCD y normativas institucionales, ya que la información suele encontrarse fragmentada en múltiples portales o documentos extensos.

### Solución Propuesta
Se diseñó una arquitectura desacoplada basada en agentes de IA y herramientas MCP que permite a los estudiantes consultar su información personalizada en lenguaje natural, garantizando:
* **Cero alucinaciones en datos críticos:** El LLM no inventa notas ni reglamentos; consulta directamente vistas SQL y bases documentales mediante herramientas tipadas.
* **Despliegue reproducible:** Todo el ecosistema corre aislado en contenedores Docker listos para producción o evaluación local.

---

## 2. Arquitectura del Sistema

```mermaid
flowchart LR
    U[Estudiante / Interfaz Web n8n] -->|Mensaje HTTP| A[AI Agent - n8n]
    A <-->|Razonamiento + Memoria| G[Google Gemini]
    A <-->|MCP Streamable HTTP :9000| M[Servidor FastMCP - Python]
    M <-->|Consultas SQL / REST + RLS| S[(Supabase PostgreSQL)]