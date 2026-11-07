"""Servidor MCP para consultar incidentes simulados y registrar alertas."""

import json
from pathlib import Path
from threading import Lock

from mcp.server import MCPServer
from mcp.server.mcpserver.exceptions import ToolError


mcp = MCPServer("MCP Detective")

_ruta_casos = Path(__file__).resolve().with_name("casos.json")
_casos = json.loads(_ruta_casos.read_text(encoding="utf-8"))
_alertas: dict[str, dict[str, str]] = {}
_bloqueo_alertas = Lock()


class ErrorDeValidacion(ToolError, ValueError):
    """Conserva el mensaje de validación en las respuestas MCP."""


def _obtener_caso(caso_id: str) -> dict:
    if not isinstance(caso_id, str):
        raise ErrorDeValidacion("El identificador del caso debe ser texto.")
    if caso_id not in _casos:
        raise ErrorDeValidacion(f"El caso {caso_id!r} no existe.")
    return _casos[caso_id]


@mcp.tool()
def listar_casos() -> list[dict]:
    """Lista los identificadores, sistemas y cantidades de eventos."""
    return [
        {
            "caso_id": caso_id,
            "sistema": caso["sistema"],
            "cantidad_eventos": len(caso["eventos"]),
        }
        for caso_id, caso in _casos.items()
    ]


@mcp.tool()
def consultar_eventos(caso_id: str) -> list[dict]:
    """Devuelve los eventos originales del caso y rechaza identificadores inexistentes."""
    return [evento.copy() for evento in _obtener_caso(caso_id)["eventos"]]


@mcp.tool()
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra una alerta en memoria para un caso que aún no tiene una."""
    _obtener_caso(caso_id)
    if nivel not in ("bajo", "medio", "alto"):
        raise ErrorDeValidacion("El nivel debe ser 'bajo', 'medio' o 'alto'.")
    if not isinstance(motivo, str) or not motivo.strip():
        raise ErrorDeValidacion(
            "El motivo debe ser texto y contener al menos un carácter no blanco."
        )

    alerta = {
        "caso_id": caso_id,
        "nivel": nivel,
        "motivo": motivo,
        "estado": "registrada",
    }
    with _bloqueo_alertas:
        if caso_id in _alertas:
            raise ErrorDeValidacion(
                f"El caso {caso_id!r} ya tiene una alerta registrada."
            )
        _alertas[caso_id] = alerta
    return alerta.copy()


if __name__ == "__main__":
    mcp.run(transport="stdio")
