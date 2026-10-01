# UI Contract: Pantalla de división

## Entradas visibles

La única pantalla expone:

- Campo `Monto total`, que conserva el texto introducido hasta calcular.
- Campo `Número de personas`, que permite validar también entradas inválidas.
- Campo `Porcentaje de propina`, que permite 0 y valores decimales no negativos.
- Selector de estrategia con `Exacto` y `Hacia arriba`.
- Botón `Calcular`.

## Acción Calcular

Al tocar `Calcular`:

1. Se descarta el error anterior.
2. Se validan monto, personas y propina en ese orden.
3. Si existe un error, se muestra solo su mensaje y no se muestra resultado.
4. Si las entradas son válidas, se calcula con la estrategia seleccionada, se reemplaza el
   resultado anterior y se muestra el pago por persona con dos decimales.

## Salidas observables

| Condición | Texto o resultado | Resultado visible |
|---|---|---|
| Monto inválido | `Monto inválido` | No |
| Personas inválidas | `Debe haber al menos una persona` | No |
| Propina inválida | `Propina inválida` | No |
| Entradas válidas | Importe por persona con dos decimales | Sí |

## Límites del contrato

- No hay navegación, autenticación, historial, red ni base de datos.
- La pantalla no instancia ni identifica tipos concretos de estrategias.
- La pantalla solo solicita acciones al controlador y refleja su estado mediante `setState`.
