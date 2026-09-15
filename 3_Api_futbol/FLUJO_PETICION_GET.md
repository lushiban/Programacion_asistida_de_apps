# Flujo de la petición GET y la espera de la respuesta

Este documento explica lo que ocurre **en esta aplicación** cuando se consultan los partidos de ScoreBat. El recorrido principal está en [`lib/screens/home_screen.dart`](lib/screens/home_screen.dart), [`lib/services/scorebat_service.dart`](lib/services/scorebat_service.dart) y [`lib/models/match_model.dart`](lib/models/match_model.dart).

## Recorrido paso a paso

1. Al abrir la pantalla, `initState()` crea `ScorebatService` y llama a `_load()`. También se puede volver a consultar con el botón de actualizar, al deslizar hacia abajo o al tocar «Volver a intentar».
2. `_load() async` pone `_loading = true` y limpia el error anterior mediante `setState()`. La pantalla se vuelve a dibujar y muestra `CircularProgressIndicator`.
3. La línea `await _service.fetchMatches()` inicia la consulta. `_load()` queda en espera del resultado, pero **la interfaz de Flutter no se congela**: puede seguir dibujando el indicador y respondiendo a otras acciones.
4. `fetchMatches() async` construye la dirección `endpoint` y ejecuta `await _client.get(endpoint).timeout(timeout)`. `_client.get(...)` usa el método HTTP **GET** para pedir datos; devuelve un `Future` que se completará cuando llegue una respuesta o falle la operación. El tiempo máximo configurado es de **20 segundos**. Mientras se espera, todavía no hay código de estado ni JSON disponibles para esta llamada.
5. Cuando llega la respuesta, `result` contiene, entre otras cosas, `result.statusCode` (código HTTP) y `result.bodyBytes` (contenido de la respuesta). El servicio revisa primero el código de estado:

   | Código | Qué hace esta aplicación |
   | --- | --- |
   | `200` | Continúa y lee el cuerpo como JSON. |
   | `401` o `403` | Informa que el acceso no fue autorizado. |
   | `429` | Informa que se alcanzó el límite de consultas. |
   | Cualquier otro código | Muestra un error de disponibilidad. |

6. **Solo con `200`**, `utf8.decode(result.bodyBytes)` convierte los bytes en texto y `jsonDecode(...)` convierte ese texto JSON en datos de Dart. Luego `ScorebatFeed.fromJson(...)` comprueba que exista una lista `response`, crea los `MatchModel` y lee el aviso opcional `warning`.
7. El `Future<ScorebatFeed>` se completa y el `await` de `_load()` recibe el feed. Si la pantalla sigue abierta (`mounted`), `setState()` guarda los partidos en `_feed`. En `finally`, `_loading` vuelve a `false`; desaparece el indicador y se muestran los partidos, un estado vacío o el error.

```text
Pantalla: _load() async
  ├─ _loading = true → indicador de carga
  └─ await _service.fetchMatches()
       └─ Servicio: fetchMatches() async
            └─ await _client.get(endpoint).timeout(20 segundos)
                 ├─ En espera: el Future está pendiente; la UI sigue activa
                 ├─ Respuesta: consultar result.statusCode
                 ├─ Si es 200: bodyBytes → UTF-8 → jsonDecode → ScorebatFeed.fromJson
                 └─ Si falla: lanzar ScorebatException
  └─ Resultado o error → actualizar la pantalla → _loading = false
```

## Dónde están `async` y `await`

| Lugar | Código | Función |
| --- | --- | --- |
| `home_screen.dart`, método `_load()` | `Future<void> _load() async` | Permite esperar el feed y manejar éxito, error y fin de la carga. |
| `home_screen.dart`, dentro de `_load()` | `await _service.fetchMatches()` | Espera el resultado del servicio antes de guardar los partidos. |
| `scorebat_service.dart`, método `fetchMatches()` | `Future<ScorebatFeed> fetchMatches() async` | Devuelve posteriormente el feed o un error. |
| `scorebat_service.dart`, dentro de `fetchMatches()` | `await _client.get(endpoint).timeout(timeout)` | Espera la respuesta del GET, con límite de tiempo. |
| `home_screen.dart`, `RefreshIndicator.onRefresh` | `onRefresh: () async { if (!_loading) await _load(); }` | Mantiene la acción de actualizar pendiente hasta que termina `_load()`. |

`async` marca una función que trabaja con un resultado futuro. `await` pausa **esa función** hasta que se completa el `Future`; no pausa toda la aplicación. Después del `await`, la ejecución continúa con el siguiente paso, o entra en el manejo de errores si el `Future` falló.

## Qué significa «JSON» aquí

El JSON es **el cuerpo de la respuesta**, no el método GET ni el código de estado. Una forma simplificada del cuerpo que el modelo espera es:

```json
{
  "response": [
    {
      "title": "Equipo A - Equipo B",
      "competition": "Competición",
      "date": "2026-09-15T12:00:00Z",
      "videos": []
    }
  ],
  "warning": "Aviso opcional"
}
```

Este ejemplo muestra la **estructura esperada por el código**; no representa una respuesta real obtenida de la API. `response` debe ser una lista de objetos. Si el JSON no se puede leer o la estructura requerida no es válida, el servicio convierte el problema en un mensaje de error para la pantalla.

## Si la espera o la petición fallan

Si pasan más de 20 segundos, `.timeout(timeout)` produce un `TimeoutException` y la pantalla muestra el mensaje de demora. Si falla la conexión, se muestra un mensaje para revisar Internet. Si llega una respuesta HTTP con un código distinto de `200`, se maneja ese código antes de intentar convertir el cuerpo a JSON. En todos esos casos, `_load()` captura `ScorebatException` y `finally` apaga el indicador de carga.
