"""Pruebas de consulta de incidentes y registro de alertas."""

import pytest

import server


@pytest.fixture
def alertas_vacias(monkeypatch: pytest.MonkeyPatch) -> None:
    """Usa un diccionario de alertas nuevo durante la prueba."""
    monkeypatch.setattr(server, "_alertas", {})


def test_listar_casos() -> None:
    assert server.listar_casos() == [
        {"caso_id": "INC-001", "sistema": "portal_acceso", "cantidad_eventos": 2},
        {"caso_id": "INC-002", "sistema": "portal_acceso", "cantidad_eventos": 6},
        {
            "caso_id": "INC-003",
            "sistema": "panel_administracion",
            "cantidad_eventos": 5,
        },
    ]


def test_consultar_eventos_existentes() -> None:
    eventos = server.consultar_eventos("INC-002")

    assert [(evento["evento"], evento["usuario"]) for evento in eventos] == [
        ("LOGIN_FAILED", "admin")
    ] * 6


def test_consultar_caso_inexistente() -> None:
    with pytest.raises(ValueError, match=r"^El caso 'INC-999' no existe\.$"):
        server.consultar_eventos("INC-999")


def test_registrar_alerta_valida(alertas_vacias: None) -> None:
    motivo = "Cuatro intentos fallidos seguidos de un acceso exitoso; requiere revisión"

    assert server.registrar_alerta("INC-003", "alto", motivo) == {
        "caso_id": "INC-003",
        "nivel": "alto",
        "motivo": motivo,
        "estado": "registrada",
    }


def test_rechazar_alerta_duplicada(alertas_vacias: None) -> None:
    primera = server.registrar_alerta("INC-003", "alto", "Revisar el acceso")
    assert primera["estado"] == "registrada"

    with pytest.raises(ValueError, match=r"INC-003.*ya tiene una alerta"):
        server.registrar_alerta("INC-003", "medio", "Segunda revisión")


def test_rechazar_nivel_invalido(alertas_vacias: None) -> None:
    with pytest.raises(ValueError, match=r"El nivel debe ser"):
        server.registrar_alerta("INC-003", "critico", "Revisar el acceso")


def test_rechazar_motivo_vacio(alertas_vacias: None) -> None:
    with pytest.raises(ValueError, match=r"El motivo debe ser texto"):
        server.registrar_alerta("INC-003", "alto", "   ")
