# Data Model: Dividir cuenta de restaurante

## Cuenta

Representa las entradas válidas necesarias para calcular una división.

| Campo | Tipo conceptual | Reglas |
|---|---|---|
| monto | decimal | Mayor que cero |
| personas | entero | Mayor o igual que uno |
| porcentajePropina | decimal | Mayor o igual que cero |

`Cuenta` solo existe después de que `ValidarEntrada` haya aceptado todas las entradas. Es
inmutable durante un cálculo y no contiene lógica de formato ni referencias a Flutter.

## Resultado

Representa la salida numérica de un cálculo válido.

| Campo | Tipo conceptual | Reglas |
|---|---|---|
| montoPorPersona | decimal | Resultado de la estrategia seleccionada; no negativo |

El valor se conserva como número. `FormateadorMoneda` es responsable de presentarlo con dos
decimales.

## EstrategiaRedondeo

Abstracción de dominio con un solo comportamiento: recibir el importe individual sin
formatear y devolver el importe resultante según la política elegida.

Implementaciones iniciales:

- Exacto: dos decimales y empate en el tercer decimal hacia arriba.
- Hacia arriba: entero inmediato no inferior al importe individual.

## Estado de DivisorController

Estado local y efímero de presentación:

| Campo | Estado inicial | Transición |
|---|---|---|
| montoTexto | vacío | Cambia al editar el monto |
| personasTexto | vacío | Cambia al editar personas |
| propinaTexto | vacío | Cambia al editar propina |
| estrategiaSeleccionada | exacto | Cambia al elegir una opción del catálogo |
| mensajeError | ninguno | Se establece al fallar validación; se limpia antes de recalcular |
| resultado | ninguno | Se reemplaza al calcular; se elimina cuando la validación falla |

## Validación y prioridad de errores

`ValidarEntrada` evalúa en este orden: monto, personas y propina. Devuelve como máximo un
mensaje por intento:

1. Monto vacío, cero, negativo o no numérico: `Monto inválido`.
2. Personas cero, negativas, decimales o no numéricas:
   `Debe haber al menos una persona`.
3. Propina negativa o no numérica: `Propina inválida`.

No se crea `Cuenta` ni se conserva un resultado cuando existe un error.

## Relaciones y ciclo de vida

1. La presentación reúne texto y estrategia seleccionada.
2. `ValidarEntrada` produce una `Cuenta` válida o un mensaje de error.
3. `CalcularDivision` recibe `Cuenta` y `EstrategiaRedondeo`.
4. La estrategia transforma el importe individual y se crea `Resultado`.
5. El controlador reemplaza su resultado anterior y la pantalla lo formatea.

No hay identidad persistente, almacenamiento ni relaciones entre múltiples cuentas.
