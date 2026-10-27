---

description: "Tareas de implementación para el divisor de cuenta"
---

# Tasks: Dividir cuenta de restaurante

**Input**: Documentos de diseño en `/specs/001-dividir-cuenta/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/ui-contract.md`

**Tests**: Son obligatorias porque la Constitution exige pruebas para toda funcionalidad crítica y pruebas ejecutables para cada criterio de aceptación.

**Organization**: Las tareas se agrupan por historia de usuario para permitir implementación y validación incremental.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Puede ejecutarse en paralelo porque trabaja en archivos distintos y no depende de tareas incompletas.
- **[Story]**: Historia de usuario asociada (`US1`, `US2` o `US3`).
- Cada tarea incluye una ruta exacta.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Preparar la estructura prevista sin agregar paquetes ni cambiar plataformas.

- [X] T001 Crear los directorios `lib/domain/`, `lib/data/` y `lib/presentation/` descritos en `specs/001-dividir-cuenta/plan.md`
- [X] T002 Eliminar `cupertino_icons` y `flutter_lints` de `pubspec.yaml`, retirar su referencia de `analysis_options.yaml` y documentar en `specs/001-dividir-cuenta/quickstart.md` que solo permanecen dependencias de SDK

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Crear entidades y contratos de dominio requeridos por todas las historias.

**⚠️ CRITICAL**: Ninguna historia puede implementarse hasta terminar esta fase.

- [X] T003 [P] Crear la entidad Dart pura `Cuenta` en `lib/domain/cuenta.dart` con las restricciones “monto mayor que cero”, “personas mayor o igual que uno” y “porcentajePropina mayor o igual que cero”
- [X] T004 [P] Crear la entidad Dart pura `Resultado` en `lib/domain/resultado.dart` con `montoPorPersona` no negativo
- [X] T005 [P] Crear la interfaz Dart pura `EstrategiaRedondeo` con un único método en `lib/domain/estrategia_redondeo.dart`

**Checkpoint**: El dominio base compila sin importar `package:flutter`.

---

## Phase 3: User Story 1 - Dividir una cuenta exactamente (Priority: P1) 🎯 MVP

**Goal**: Ingresar monto, personas y propina válidos y obtener el pago exacto por persona con dos decimales.

**Independent Test**: Los casos 100/4/10 → 27.50, 90/3/0 → 30.00, 10/3/0 → 3.33 y el empate 2.345 → 2.35 pasan usando únicamente el modo exacto.

### Tests for User Story 1

> Escribir estas pruebas primero y comprobar que fallen antes de implementar la historia.

- [ ] T006 [US1] Crear las definiciones de los casos exactos y sus resultados esperados en `test/casos_de_prueba.dart`
- [ ] T007 [P] [US1] Crear pruebas unitarias del cálculo exacto y del empate 2.345 → 2.35 en `test/division_test.dart`
- [ ] T008 [P] [US1] Crear la prueba de widget para 100.00, 4 personas, 10% y resultado 27.50 en `test/pantalla_test.dart`

### Implementation for User Story 1

- [X] T009 [P] [US1] Implementar `RedondeoExacto` con dos decimales y tercer decimal 5 hacia arriba en `lib/data/redondeo_exacto.dart`
- [X] T010 [US1] Implementar `CalcularDivision` para aplicar propina, dividir y delegar el redondeo sin validar ni formatear en `lib/domain/calcular_division.dart`
- [X] T011 [P] [US1] Crear `ValidarEntrada` con la conversión de entradas válidas a `Cuenta` y el contrato de error de dominio en `lib/domain/validar_entrada.dart`
- [X] T012 [P] [US1] Implementar `FormateadorMoneda` para producir exactamente dos decimales sin aplicar reglas de negocio en `lib/presentation/formateador_moneda.dart`
- [X] T013 [US1] Implementar `DivisorController` con dependencias de dominio inyectadas, catálogo de estrategias y reemplazo de resultado en `lib/presentation/divisor_controller.dart`
- [X] T014 [US1] Implementar la pantalla única con campos, selector, botón Calcular, estado local con `setState` y resultado exacto en `lib/presentation/pantalla_divisor.dart`
- [X] T015 [US1] Componer casos de uso, `RedondeoExacto`, controlador y pantalla sin instanciar concretos fuera de `lib/main.dart`

**Checkpoint**: US1 funciona y se prueba independientemente con modo exacto.

---

## Phase 4: User Story 2 - Redondear el pago hacia arriba (Priority: P2)

**Goal**: Elegir el modo hacia arriba y obtener el entero inmediato no inferior al pago individual, mostrado con dos decimales.

**Independent Test**: 10.00, 3 personas y 0% produce 4.00 en modo hacia arriba sin alterar los resultados del modo exacto.

### Tests for User Story 2

> Escribir estas pruebas primero y comprobar que fallen antes de implementar la historia.

- [ ] T016 [US2] Añadir el caso 10.00/3/0 en modo hacia arriba con esperado 4.00 en `test/casos_de_prueba.dart`
- [ ] T017 [P] [US2] Ampliar las pruebas unitarias con el modo hacia arriba y una prueba LSP que sustituya ambas estrategias sin `if` ni cast en `test/division_test.dart`
- [ ] T018 [P] [US2] Añadir la prueba de widget que selecciona Hacia arriba y muestra 4.00 en `test/pantalla_test.dart`

### Implementation for User Story 2

- [X] T019 [P] [US2] Implementar `RedondeoHaciaArriba` sobre el importe individual después de propina y división en `lib/data/redondeo_hacia_arriba.dart`
- [X] T020 [US2] Registrar `RedondeoHaciaArriba` en el catálogo inyectado y conservar `lib/main.dart` como único punto de instanciación concreta

**Checkpoint**: US1 y US2 funcionan de forma independiente y ambas estrategias son sustituibles.

---

## Phase 5: User Story 3 - Corregir entradas inválidas (Priority: P3)

**Goal**: Mostrar mensajes exactos para monto, personas y propina inválidos sin mostrar resultado.

**Independent Test**: Cada familia de entrada inválida produce su mensaje especificado, oculta cualquier resultado previo y permite corregir y recalcular.

### Tests for User Story 3

> Escribir estas pruebas primero y comprobar que fallen antes de ajustar la implementación.

- [ ] T021 [US3] Añadir a `test/casos_de_prueba.dart` los casos de monto `abc`, personas cero/negativas/decimales/no numéricas y propina negativa/no numérica con sus mensajes exactos
- [ ] T022 [P] [US3] Ampliar `test/division_test.dart` para validar entradas inválidas sin ejecutar `CalcularDivision` y comprobar la prioridad monto → personas → propina
- [ ] T023 [P] [US3] Añadir pruebas de widget de los tres mensajes exactos, ausencia de resultado y recuperación tras corregir entradas en `test/pantalla_test.dart`

### Implementation for User Story 3

- [X] T024 [US3] Implementar en `lib/domain/validar_entrada.dart` las variantes inválidas, los mensajes `Monto inválido`, `Debe haber al menos una persona` y `Propina inválida`, y la prioridad FR-011
- [X] T025 [US3] Ajustar `DivisorController` para limpiar error antes de recalcular, eliminar el resultado ante error y reemplazarlo tras éxito en `lib/presentation/divisor_controller.dart`
- [X] T026 [US3] Ajustar la presentación de errores y la ocultación del resultado en `lib/presentation/pantalla_divisor.dart` conforme a `specs/001-dividir-cuenta/contracts/ui-contract.md`

**Checkpoint**: Los seis escenarios y las tres aclaraciones son observables y están cubiertos por pruebas.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validar calidad, arquitectura y comportamiento completo.

- [ ] T027 [P] Formatear todos los archivos Dart generados en `lib/` y `test/` con el formateador del SDK
- [X] T028 Ejecutar `flutter analyze` y corregir únicamente problemas de la implementación en `lib/`
- [ ] T029 Ejecutar `flutter test --reporter expanded` y corregir fallos de implementación sin cambiar resultados esperados en `test/`
- [X] T030 Comprobar que `lib/domain/` no importa `package:flutter`, que `lib/presentation/` no importa `lib/data/`, que no existen dependencias ni llamadas de red, y registrar el resultado en `specs/001-dividir-cuenta/quickstart.md`
- [X] T031 Comprobar que `RedondeoExacto()` y `RedondeoHaciaArriba()` se instancian únicamente en `lib/main.dart` y registrar el resultado en `specs/001-dividir-cuenta/quickstart.md`
- [ ] T032 Ejecutar manualmente y sin conectividad los seis escenarios y las tres aclaraciones de `specs/001-dividir-cuenta/quickstart.md`, cronometrar un cálculo válido desde pantalla lista hasta resultado para comprobar menos de 30 segundos y registrar todo en ese archivo

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No tiene dependencias.
- **Foundational (Phase 2)**: Depende de Setup y bloquea todas las historias.
- **US1 (Phase 3)**: Depende de Foundational y entrega el MVP.
- **US2 (Phase 4)**: Depende de la interfaz y cálculo creados para US1; añade una estrategia sin modificar el cálculo.
- **US3 (Phase 5)**: Depende del flujo de controlador y pantalla de US1; completa validación y recuperación.
- **Polish (Phase 6)**: Depende de las historias que se quieran entregar; para validar toda la spec requiere US1, US2 y US3.

### User Story Dependencies

```text
Setup → Foundational → US1 (MVP) ─┬→ US2
                                  └→ US3
US2 + US3 → Polish completo
```

- **US1**: No depende de otras historias después de Foundational.
- **US2**: Reutiliza la abstracción y el flujo dinámico de US1, pero se prueba por separado.
- **US3**: Reutiliza el controlador y la pantalla de US1, pero sus errores se prueban por separado.
- Después de US1, US2 y US3 pueden desarrollarse en paralelo por trabajar principalmente en archivos distintos; las ampliaciones de pruebas compartidas deben coordinarse.

### Within Each User Story

- Las pruebas se escriben antes que la implementación correspondiente.
- Entidades e interfaces preceden a casos de uso.
- Casos de uso preceden al controlador.
- El controlador precede a la integración de pantalla y `main.dart`.
- Cada checkpoint se valida antes de continuar con la siguiente prioridad.

## Parallel Opportunities

### User Story 1

```text
T007: pruebas de dominio en test/division_test.dart
T008: prueba de widget en test/pantalla_test.dart

T009: RedondeoExacto en lib/data/redondeo_exacto.dart
T011: ValidarEntrada en lib/domain/validar_entrada.dart
T012: FormateadorMoneda en lib/presentation/formateador_moneda.dart
```

### User Story 2

```text
T017: pruebas de estrategias en test/division_test.dart
T018: prueba de widget en test/pantalla_test.dart
T019: implementación en lib/data/redondeo_hacia_arriba.dart
```

### User Story 3

```text
T022: pruebas de dominio en test/division_test.dart
T023: pruebas de widget en test/pantalla_test.dart
```

## Implementation Strategy

### MVP First

1. Completar Setup y Foundational.
2. Completar US1 con pruebas primero.
3. Detenerse y validar los cuatro resultados exactos.
4. US1 constituye el MVP demostrable.

### Incremental Delivery

1. US1 entrega división exacta.
2. US2 añade redondeo hacia arriba sin alterar el cálculo existente.
3. US3 completa mensajes y recuperación para entradas inválidas.
4. Polish demuestra pruebas, análisis y reglas de arquitectura.

## Notes

- `[P]` identifica tareas en archivos distintos sin dependencia inmediata.
- `[US1]`, `[US2]` y `[US3]` mantienen trazabilidad con la spec.
- No se agregan paquetes ni se modifican `android/` o `ios/`.
- Los resultados esperados de las pruebas no se cambian para hacer pasar una implementación incorrecta.
- Cada función debe quedar explicable según la regla de la materia de la Constitution.

---

## Phase 7: Convergence

**Purpose**: Cerrar las diferencias comprobadas entre la implementación actual y los
artefactos de intención sin cambiar requisitos ni ampliar el alcance.

- [ ] T033 CRITICAL Reemplazar la prueba de contador obsoleta de `test/widget_test.dart`,
  que importa `lib/main.dart` y referencia la clase inexistente `MyApp`, por una prueba
  compatible con la aplicación Divisor de Cuenta o retirarla cuando su cobertura quede
  trasladada a `test/pantalla_test.dart`, conforme a la estructura de pruebas de
  `specs/001-dividir-cuenta/plan.md` (contradicts)
- [ ] T034 CRITICAL [US1] [US2] [US3] Completar en `test/casos_de_prueba.dart` las
  definiciones de los seis escenarios y las tres aclaraciones, y crear
  `test/division_test.dart` con pruebas ejecutables del cálculo exacto, el empate
  2.345 -> 2.35, el redondeo hacia arriba, todas las variantes inválidas, la prioridad
  monto -> personas -> propina y la sustitución LSP de estrategias, como exigen la
  sección Calidad, pruebas y explicabilidad de `.specify/memory/constitution.md`,
  FR-004 a FR-008, FR-011 y SC-002 a SC-004 de
  `specs/001-dividir-cuenta/spec.md` (missing)
- [ ] T035 HIGH [US1] [US2] [US3] Crear `test/pantalla_test.dart` con pruebas de widget
  para los resultados 27.50 y 4.00, los tres mensajes exactos, la ausencia de resultado
  ante error, el reemplazo del resultado y la recuperación después de corregir entradas,
  conforme a FR-001, FR-002, FR-005 a FR-008, FR-010 y al contrato
  `specs/001-dividir-cuenta/contracts/ui-contract.md` (missing)
- [ ] T036 HIGH Formatear todos los archivos Dart de `lib/` y `test/`, ejecutar
  `flutter analyze` y `flutter test --reporter expanded`, y corregir únicamente defectos
  de implementación hasta que ambas comprobaciones finalicen correctamente, cerrando
  T027 y T029 de `specs/001-dividir-cuenta/tasks.md` y la exigencia de pruebas ejecutables
  de `.specify/memory/constitution.md` (partial)
- [ ] T037 MEDIUM Ejecutar manualmente sin conectividad los seis escenarios y las tres
  aclaraciones, cronometrar desde la pantalla lista hasta un resultado válido y registrar
  en `specs/001-dividir-cuenta/quickstart.md` la evidencia de FR-009, SC-001 y SC-005 de
  `specs/001-dividir-cuenta/spec.md`, cerrando T032 (missing)

---

## Phase 8: Convergence

**Purpose**: Ajustar la ejecución pendiente a la restricción expresa de conservar intacto
el archivo manual de casos de prueba.

- [ ] T038 HIGH Preservar sin modificaciones ni eliminación `test/casos_de_prueba.dart`
  y completar la cobertura todavía exigida por T034 directamente en
  `test/division_test.dart` y `test/pantalla_test.dart`; esta tarea reemplaza únicamente
  la instrucción de T034 que pedía editar el archivo protegido, pero mantiene la cobertura
  de los seis escenarios, las tres aclaraciones, FR-004 a FR-008, FR-011 y SC-002 a SC-004
  (contradicts)
