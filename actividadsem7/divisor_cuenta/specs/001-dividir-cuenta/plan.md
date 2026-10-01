# Implementation Plan: Dividir cuenta de restaurante

**Branch**: `sdd` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-dividir-cuenta/spec.md`

## Summary

Construir una aplicación Flutter de una sola pantalla que valide monto, personas y propina,
permita elegir redondeo exacto o hacia arriba y muestre el pago individual con dos
decimales. La solución usa estado local con `setState` y separa presentación, dominio Dart
puro e implementaciones de redondeo. `main.dart` es el único punto de composición.

## Technical Context

**Language/Version**: Dart 3.13.1 estable y Flutter SDK estable instalado

**Primary Dependencies**: Flutter SDK y `flutter_test`, ambos provistos por el SDK. La
implementación elimina las dependencias externas preexistentes `cupertino_icons` y
`flutter_lints` y no agrega ninguna nueva.

**Storage**: N/A; no hay persistencia, red ni base de datos

**Testing**: `flutter_test` para pruebas unitarias de dominio y pruebas de widgets

**Target Platform**: Aplicación Flutter en las plataformas ya configuradas por el proyecto

**Project Type**: Aplicación Flutter de una sola pantalla

**Performance Goals**: El usuario completa un cálculo en menos de 30 segundos

**Constraints**: Funciona sin conexión, usa `setState`, mantiene null safety, emplea nombres
en español y no agrega paquetes

**Scale/Scope**: Un usuario local, una pantalla, un cálculo visible a la vez y dos estrategias
de redondeo iniciales

## Constitution Check

*GATE: Debe aprobarse antes de Fase 0 y se revisa nuevamente después de Fase 1.*

| Regla constitucional | Evidencia prevista | Estado inicial |
|---|---|---|
| SRP | `CalcularDivision` calcula; `ValidarEntrada` valida; `FormateadorMoneda` formatea; `PantallaDivisor` dibuja | PASS |
| OCP | `CalcularDivision` recibe `EstrategiaRedondeo`; una nueva estrategia se agrega sin editar el cálculo | PASS |
| LSP | Todas las estrategias implementan el mismo método y se consumen mediante la abstracción | PASS |
| ISP | `EstrategiaRedondeo` expone un único método | PASS |
| DIP | `DivisorController` recibe casos de uso y estrategias como abstracciones de `domain` | PASS |
| Capas | Dependencias `presentation -> domain <- data`; `data` implementa interfaces de dominio | PASS |
| Dominio puro | `lib/domain/` usa solo Dart y no importa `package:flutter` | PASS |
| Composición | Solo `main.dart` instancia `RedondeoExacto` y `RedondeoHaciaArriba` | PASS |
| Seguridad | No se usan ni almacenan secretos o API keys | PASS |
| Pruebas | Los seis escenarios y las tres aclaraciones se convierten en pruebas ejecutables | PASS |
| Explicabilidad | Cada clase y función tiene propósito, entradas, salida y errores delimitados en los artefactos | PASS |

No existen violaciones que requieran excepción.

### Revisión posterior al diseño

El modelo, el contrato de UI y la guía de validación conservan todas las reglas anteriores:
el dominio no conoce Flutter, presentación no importa `data`, las estrategias concretas solo
se conectan en `main.dart`, no se añaden paquetes y cada regla aclarada tiene un resultado
observable. **Resultado posterior a Fase 1: PASS.**

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui-contract.md
├── checklists/
│   └── requirements.md
└── tasks.md                 # se creará posteriormente con /speckit-tasks
```

### Source Code (repository root)

```text
lib/
├── domain/
│   ├── cuenta.dart
│   ├── resultado.dart
│   ├── estrategia_redondeo.dart
│   ├── calcular_division.dart
│   └── validar_entrada.dart
├── data/
│   ├── redondeo_exacto.dart
│   └── redondeo_hacia_arriba.dart
├── presentation/
│   ├── divisor_controller.dart
│   ├── formateador_moneda.dart
│   └── pantalla_divisor.dart
└── main.dart

test/
├── casos_de_prueba.dart
├── division_test.dart
└── pantalla_test.dart
```

**Structure Decision**: Se adopta la estructura por capas indicada por el usuario y la
Constitution. `domain` contiene entidades, casos de uso y la interfaz; `data` contiene las
estrategias concretas; `presentation` contiene estado, formato y widgets; `main.dart`
construye e inyecta las dependencias.

## Design Responsibilities

- `Cuenta`: contiene monto, número de personas y porcentaje de propina ya validados.
- `Resultado`: contiene el importe final por persona producido por el cálculo.
- `EstrategiaRedondeo`: contrato de un método para transformar el importe individual.
- `CalcularDivision`: aplica la propina, divide y delega el redondeo; no valida ni formatea.
- `ValidarEntrada`: analiza las entradas de texto, devuelve errores exactos o una `Cuenta`
  válida y aplica la prioridad monto → personas → propina cuando coinciden varios errores.
- `RedondeoExacto`: redondea a dos decimales y, si el tercer decimal es 5, hacia arriba.
- `RedondeoHaciaArriba`: eleva el importe individual al entero siguiente y conserva dos
  decimales al presentarse.
- `DivisorController`: recibe `ValidarEntrada`, `CalcularDivision` y un catálogo de
  `EstrategiaRedondeo` por constructor; conserva entradas, selección, error y resultado.
- `FormateadorMoneda`: presenta valores válidos con exactamente dos decimales.
- `PantallaDivisor`: dibuja una pantalla y usa `setState` para reflejar el estado del
  controlador; no conoce implementaciones de `data`.
- `main.dart`: instancia casos de uso, estrategias concretas, controlador y pantalla.

El catálogo de estrategias se inyecta desde `main.dart` usando identificadores y etiquetas
de presentación. Agregar otra estrategia requiere crear su implementación y registrarla en
el punto de composición, sin modificar el cálculo ni el controlador.

## Clarification Coverage

| Aclaración | Cobertura en diseño y validación |
|---|---|
| Personas cero, negativas, decimales o no numéricas | `ValidarEntrada` devuelve exactamente "Debe haber al menos una persona" y no se calcula resultado |
| Propina negativa o no numérica | `ValidarEntrada` devuelve exactamente "Propina inválida" y no se calcula resultado |
| Tercer decimal igual a 5 en modo exacto | `RedondeoExacto` redondea hacia arriba; caso adicional 2.345 → 2.35 |

## New Planning Decisions

Estas decisiones permiten concretar el diseño, pero no estaban definidas explícitamente en
la spec ni en la Constitution:

- Los tres campos comienzan vacíos y el modo inicial es `Exacto`.
- El controlador recibe un catálogo de estrategias con identificadores y etiquetas,
  construido en `main.dart`, para cumplir OCP sin importar `data` desde presentación.
- Las entradas se conservan inicialmente como texto para poder validar valores no numéricos;
  después de validar se transforman a valores numéricos Dart sin un paquete decimal externo.
- Las dependencias externas preexistentes de la plantilla se eliminan para cumplir
  literalmente la restricción “sin paquetes externos”; solo permanecen SDKs de Flutter.
- El plan cubre todas las plataformas ya configuradas por el proyecto Flutter; no selecciona
  una plataforma exclusiva.

## Complexity Tracking

No hay violaciones constitucionales ni complejidad excepcional que justificar.
