# Revisión Integral Checklist: Dividir cuenta de restaurante

**Purpose**: Revisar la calidad, claridad, consistencia y cobertura de los requisitos funcionales y arquitectónicos antes de generar tareas
**Created**: 2026-10-01
**Feature**: [spec.md](../spec.md)

**Note**: Esta checklist personalizada fue generada por `$speckit-checklist` a partir de la especificación, el plan y la Constitution.
**Review Ownership**: Esta checklist pertenece al revisor. Marca un ítem `[x]` únicamente cuando el revisor determine que el criterio de calidad de requisitos está satisfecho.
**Marker Semantics**: `[x]` significa que el criterio fue revisado y aprobado en cuanto a calidad de requisitos; no significa que la implementación esté terminada.

## Completitud de requisitos

- [ ] CHK001 ¿Están documentadas todas las entradas, selecciones y salidas visibles de la única pantalla? [Completitud, Spec §FR-001–FR-005]
- [ ] CHK002 ¿Están definidos los requisitos para cada uno de los seis escenarios de aceptación, incluidos resultado, mensaje y ausencia de resultado cuando corresponda? [Completitud, Spec §User Scenarios]
- [ ] CHK003 ¿Están documentadas las tres aclaraciones como reglas normativas y no solo como notas de conversación? [Completitud, Spec §Clarifications, §FR-004, §FR-006, §FR-008]
- [ ] CHK004 ¿Está definido qué datos componen `Cuenta` y `Resultado`, junto con sus restricciones relevantes? [Completitud, Spec §Key Entities, Data Model §Cuenta, §Resultado]
- [ ] CHK005 ¿Está delimitado explícitamente que no existen navegación, historial, autenticación, red ni persistencia? [Cobertura, Spec §Assumptions, UI Contract §Límites]

## Claridad y precisión

- [ ] CHK006 ¿El significado de modo `Exacto` distingue claramente el redondeo de negocio a dos decimales del formato visual? [Claridad, Spec §FR-004, Plan §Design Responsibilities]
- [ ] CHK007 ¿La expresión “hacia arriba al entero más cercano” especifica sin ambigüedad que se aplica al importe individual después de propina y división? [Claridad, Spec §FR-005, §Edge Cases]
- [ ] CHK008 ¿La regla del tercer decimal igual a 5 incluye un ejemplo numérico inequívoco y un resultado esperado? [Claridad, Spec §Clarifications]
- [ ] CHK009 ¿Cada condición inválida tiene definido un mensaje exacto y si el resultado debe ocultarse? [Claridad, Spec §FR-006–FR-008]
- [ ] CHK010 ¿El requisito de “dos decimales” aclara si exige ceros finales, por ejemplo `4.00` en lugar de `4`? [Claridad, Spec §FR-004–FR-005, §SC-004]

## Consistencia entre artefactos

- [ ] CHK011 ¿Coinciden los valores y resultados de los seis escenarios entre la spec y la guía de validación? [Consistencia, Spec §Acceptance Scenarios, Quickstart §Validación manual]
- [ ] CHK012 ¿Coinciden los mensajes de monto, personas y propina inválidos en spec, modelo de datos y contrato de UI? [Consistencia, Spec §FR-006–FR-008, Data Model §Validación, UI Contract §Salidas]
- [ ] CHK013 ¿La prioridad monto → personas → propina está definida consistentemente en requisitos, modelo y tareas? [Consistencia, Spec §FR-011, Data Model §Validación]
- [ ] CHK014 ¿La estrategia inicial `Exacto` y los campos inicialmente vacíos se presentan consistentemente como decisiones nuevas del plan? [Consistencia, Plan §New Planning Decisions, Data Model §Estado]
- [ ] CHK015 ¿La regla “un cálculo visible a la vez” coincide con el reemplazo del resultado anterior y la ausencia de historial? [Consistencia, Spec §FR-010, §Assumptions]

## Calidad de criterios de aceptación

- [ ] CHK016 ¿Cada requisito funcional puede relacionarse con al menos un escenario, caso límite o criterio de éxito objetivamente comprobable? [Trazabilidad, Spec §Requirements, §Success Criteria]
- [ ] CHK017 ¿El criterio de completar un cálculo en menos de 30 segundos define suficientemente el inicio y el final de la medición? [Medibilidad, Spec §SC-001]
- [ ] CHK018 ¿Los criterios porcentuales del 100% delimitan con precisión el conjunto de entradas y resultados al que se aplican? [Medibilidad, Spec §SC-003–SC-004]
- [ ] CHK019 ¿La disponibilidad sin conexión está expresada de forma verificable y consistente con la exclusión de red y base de datos? [Aceptación, Spec §FR-009, §SC-005]

## Cobertura de escenarios y casos límite

- [ ] CHK020 ¿Están cubiertos por requisitos los flujos primario, alternativo y de error para ambos modos de redondeo? [Cobertura, Spec §User Scenarios]
- [ ] CHK021 ¿Están documentados monto vacío, cero, negativo y no numérico como variantes del mismo error? [Cobertura, Spec §Edge Cases, §FR-007]
- [ ] CHK022 ¿Están documentadas personas cero, negativas, decimales y no numéricas como variantes del mismo error? [Cobertura, Spec §Clarifications, §FR-006]
- [ ] CHK023 ¿Está definido qué ocurre cuando varias entradas son inválidas simultáneamente? [Cobertura, Plan §New Planning Decisions]
- [ ] CHK024 ¿Está definido qué ocurre con el error y el resultado anteriores después de corregir entradas y volver a calcular? [Recovery Flow, UI Contract §Acción Calcular]

## Arquitectura y principios SOLID

- [ ] CHK025 ¿Las responsabilidades de cálculo, validación, formato, coordinación y presentación están especificadas por separado? [SRP, Plan §Design Responsibilities, Constitution §I]
- [ ] CHK026 ¿El plan exige que una nueva estrategia pueda añadirse sin modificar `CalcularDivision` ni `DivisorController`? [OCP, Plan §Design Responsibilities, Constitution §II]
- [ ] CHK027 ¿El contrato de `EstrategiaRedondeo` está definido como una interfaz de un solo método sustituible sin comprobaciones de tipo? [LSP/ISP, Data Model §EstrategiaRedondeo, Constitution §III–IV]
- [ ] CHK028 ¿La dirección `presentation -> domain <- data` está documentada sin excepciones contradictorias? [DIP, Plan §Constitution Check, Constitution §V]
- [ ] CHK029 ¿Está especificado que `lib/domain/` es Dart puro y no conoce Flutter? [Arquitectura, Plan §Constitution Check]
- [ ] CHK030 ¿Está definido que `main.dart` es el único punto que instancia estrategias concretas? [Composición, Plan §Constitution Check]
- [ ] CHK031 ¿Los requisitos de pruebas cubren funcionalidad crítica, seis escenarios, tres aclaraciones y sustitución de estrategias? [Calidad, Plan §Constitution Check, Quickstart §Validación automatizada]

## Dependencias, restricciones y supuestos

- [ ] CHK032 ¿Está especificada consistentemente la eliminación de dependencias externas preexistentes y la conservación exclusiva de dependencias de SDK? [Dependencia, Plan §Technical Context, Tasks §T002]
- [ ] CHK033 ¿La elección de `setState` y el alcance de una sola pantalla son consistentes con la ausencia de estado global o persistente? [Restricción, Plan §Technical Context, Research §Estado]
- [ ] CHK034 ¿Los supuestos sobre ausencia de cuentas, permisos, almacenamiento e historial están documentados como límites de alcance? [Supuesto, Spec §Assumptions]
- [ ] CHK035 ¿Está especificado que ninguna clave de API ni secreto es necesario o permitido para esta función sin conexión? [Seguridad, Constitution §Arquitectura y seguridad, Spec §FR-009]

## Ambigüedades y brechas para revisión

- [ ] CHK036 ¿Está definido si se acepta coma decimal además de punto en monto y propina? [Ambigüedad, Gap]
- [ ] CHK037 ¿Está definido si existe un límite máximo para monto, personas o porcentaje de propina? [Gap, Spec §Edge Cases]
- [ ] CHK038 ¿Está definido si porcentajes superiores a 100 son válidos? [Ambigüedad, Spec §FR-008]
- [ ] CHK039 ¿Está definido si el resultado incluye símbolo o nombre de moneda, además de dos decimales? [Gap, Spec §FR-004–FR-005]
- [ ] CHK040 ¿Están documentados requisitos mínimos de accesibilidad para campos, selector, botón, errores y resultado? [Cobertura no funcional, Gap]

## Notes

- Marca los ítems `[x]` solo después de que la revisión confirme la calidad del requisito.
- Deja sin marcar los ítems que todavía requieran aclaración, corrección o evaluación humana.
- `$speckit-implement` lee el estado de la checklist como una compuerta y no modifica sus marcadores.
- `checklists/requirements.md` conserva su ciclo independiente administrado por `$speckit-specify` y `$speckit-clarify`.
- Agrega comentarios o hallazgos junto al ítem correspondiente.
- Los identificadores son secuenciales para facilitar referencias durante la revisión.
