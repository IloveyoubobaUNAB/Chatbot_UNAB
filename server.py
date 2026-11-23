import os
from fastmcp import FastMCP
from supabase import create_client, Client

# Inicializar el servidor FastMCP
mcp = FastMCP("UNAB_Academico_MCP")

# Conexión a Supabase usando variables de entorno
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError("Faltan las variables de entorno SUPABASE_URL o SUPABASE_KEY.")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def _normalizar_codigo(codigo: str) -> str:
    """Limpia espacios y convierte a mayúsculas el código estudiantil."""
    return codigo.strip().upper()


@mcp.tool()
def consultar_estado_academico(codigo_estudiante: str) -> dict:
    """
    Consulta el estado de matrícula, promedio, créditos aprobados, créditos faltantes
    y proyección de semestres restantes de un estudiante de Ingeniería de Sistemas UNAB.
    """
    codigo = _normalizar_codigo(codigo_estudiante)
    try:
        res = (
            supabase.table("vista_resumen_academico")
            .select("*")
            .eq("codigo_estudiante", codigo)
            .execute()
        )
        if not res.data:
            return {"error": f"No se encontró ningún estudiante con el código {codigo}."}
        return res.data[0]
    except Exception as e:
        return {"error": f"Error al consultar el estado académico: {str(e)}"}


@mcp.tool()
def consultar_historial_y_requisitos(codigo_estudiante: str) -> dict:
    """
    Consulta las materias aprobadas, matriculadas, reprobadas o pendientes de un estudiante,
    junto con los prerrequisitos del pensum para alertar qué materias puede o no matricular.
    """
    codigo = _normalizar_codigo(codigo_estudiante)
    try:
        historial = (
            supabase.table("historial_academico")
            .select(
                "codigo_materia, estado, nota, "
                "pensum_materias(nombre_materia, semestre_sugerido, creditos, prerrequisito_codigo)"
            )
            .eq("codigo_estudiante", codigo)
            .execute()
        )
        if not historial.data:
            return {"error": f"No hay historial registrado para el código {codigo}."}
        return {"codigo_estudiante": codigo, "materias": historial.data}
    except Exception as e:
        return {"error": f"Error al consultar el historial académico: {str(e)}"}


@mcp.tool()
def consultar_cursos_competencias_digitales(codigo_estudiante: str) -> dict:
    """
    Consulta los cursos del Centro de Competencias Digitales (CCD) realizados o en curso
    por el estudiante y las insignias digitales obtenidas.
    """
    codigo = _normalizar_codigo(codigo_estudiante)
    try:
        cursos = (
            supabase.table("cursos_ccd")
            .select("*")
            .eq("codigo_estudiante", codigo)
            .execute()
        )
        if not cursos.data:
            return {
                "codigo_estudiante": codigo,
                "cursos_ccd": [],
                "mensaje": "El estudiante aún no registra cursos o insignias en el CCD.",
            }
        return {"codigo_estudiante": codigo, "cursos_ccd": cursos.data}
    except Exception as e:
        return {"error": f"Error al consultar cursos del CCD: {str(e)}"}


@mcp.tool()
def consultar_noticias_ccd() -> list | dict:
    """
    Obtiene las últimas noticias, convocatorias y nuevos cursos almacenados en la base de datos.
    """
    try:
        noticias = (
            supabase.table("noticias_ccd")
            .select("*")
            .order("fecha_extraccion", desc=True)
            .limit(5)
            .execute()
        )
        if not noticias.data:
            return {"mensaje": "No hay noticias recientes publicadas en el CCD."}
        return noticias.data
    except Exception as e:
        return {"error": f"Error al consultar noticias del CCD: {str(e)}"}


@mcp.tool()
def consultar_reglamento_unab(tema: str = "") -> list | dict:
    """
    Consulta la normativa institucional de la UNAB y guías del Centro de Competencias Digitales
    (matrícula financiera, homologación de insignias CCD, cancelación de asignaturas).
    """
    try:
        query = supabase.table("documents").select("content, metadata")
        if tema.strip():
            query = query.ilike("content", f"%{tema.strip()}%")
        res = query.limit(5).execute()
        if not res.data:
            res = supabase.table("documents").select("content, metadata").limit(5).execute()
        return res.data
    except Exception as e:
        return {"error": f"Error al consultar el reglamento institucional: {str(e)}"}


if __name__ == "__main__":
    # Exponer servidor MCP vía HTTP streamable en el puerto 9000
    mcp.run(transport="streamable-http", host="0.0.0.0", port=9000)