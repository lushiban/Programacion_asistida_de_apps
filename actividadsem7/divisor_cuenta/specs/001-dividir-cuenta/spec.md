# Feature Specification: Dividir cuenta de restaurante

**Feature Branch**: `sdd`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas, con monto total, número de personas, porcentaje de propina y modos de redondeo exacto o hacia arriba."

## Clarifications

### Session 2026-10-01

- Q: ¿Qué mensaje debe mostrarse cuando el número de personas sea negativo, decimal o no numérico? → A: Mostrar "Debe haber al menos una persona" en todos los casos.
- Q: ¿Qué debe ocurrir cuando la propina sea negativa o no numérica? → A: Mostrar "Propina inválida" y ocultar el resultado.
- Q: En modo exacto, ¿cómo debe redondearse un resultado cuyo tercer decimal sea exactamente 5, como 2.345? → A: Redondear hacia arriba; 2.345 se muestra como 2.35.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Dividir una cuenta exactamente (Priority: P1)

Como usuario, quiero ingresar el monto, la cantidad de personas y la propina para conocer cuánto debe pagar cada persona con dos decimales.

**Why this priority**: Es la necesidad principal de la aplicación y entrega valor aun sin un modo alternativo de redondeo.

**Independent Test**: Se puede probar ingresando una cuenta válida, eligiendo el modo exacto y verificando que el resultado por persona incluya la propina y tenga dos decimales.

**Acceptance Scenarios**:

1. **Given** un monto de 100.00, 4 personas, 10% de propina y modo exacto, **When** el usuario toca "Calcular", **Then** se muestra 27.50 por persona.
2. **Given** un monto de 90.00, 3 personas, 0% de propina y modo exacto, **When** el usuario toca "Calcular", **Then** se muestra 30.00 por persona.
3. **Given** un monto de 10.00, 3 personas, 0% de propina y modo exacto, **When** el usuario toca "Calcular", **Then** se muestra 3.33 por persona.

---

### User Story 2 - Redondear el pago hacia arriba (Priority: P2)

Como usuario, quiero elegir el redondeo hacia arriba para que cada persona pague un valor entero que no sea inferior a su parte de la cuenta.

**Why this priority**: Es el segundo modo solicitado y ofrece una alternativa práctica al reparto exacto.

**Independent Test**: Se puede probar con una división no entera y verificar que el pago individual sea el entero inmediatamente superior.

**Acceptance Scenarios**:

1. **Given** un monto de 10.00, 3 personas, 0% de propina y modo hacia arriba, **When** el usuario toca "Calcular", **Then** se muestra 4.00 por persona.

---

### User Story 3 - Corregir entradas inválidas (Priority: P3)

Como usuario, quiero recibir un mensaje claro cuando el monto o la cantidad de personas no sean válidos para poder corregirlos sin ver un resultado engañoso.

**Why this priority**: Evita divisiones imposibles y resultados basados en datos que no representan una cuenta válida.

**Independent Test**: Se puede probar cada entrada inválida por separado y verificar el mensaje exacto y la ausencia de un resultado.

**Acceptance Scenarios**:

1. **Given** un monto de 50.00 y 0 personas, **When** el usuario toca "Calcular", **Then** se muestra "Debe haber al menos una persona" y no se muestra ningún resultado.
2. **Given** que el monto contiene "abc", **When** el usuario toca "Calcular", **Then** se muestra "Monto inválido" y no se muestra ningún resultado.

### Edge Cases

- Una cantidad de personas igual a cero, negativa, decimal o no numérica muestra "Debe haber al menos una persona" y no produce resultado.
- Un monto vacío, cero, negativo o no numérico se considera inválido y no produce resultado.
- Un porcentaje de propina negativo o no numérico muestra "Propina inválida" y no produce resultado.
- Una propina de 0% conserva el monto original antes de dividirlo.
- En modo exacto, un resultado con más de dos decimales se presenta redondeado a dos decimales; cuando el tercer decimal es 5, se redondea hacia arriba.
- En modo hacia arriba, primero se calcula la parte individual con propina y luego se eleva al entero más cercano, mostrándolo con dos decimales.
- Cuando varias entradas son inválidas simultáneamente, se muestra un solo mensaje con prioridad monto, personas y propina, en ese orden.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La aplicación DEBE presentar en una sola pantalla entradas para el monto total, el número de personas y el porcentaje de propina.
- **FR-002**: El usuario DEBE poder seleccionar entre el modo exacto y el modo hacia arriba al entero más cercano.
- **FR-003**: La aplicación DEBE calcular el total con propina y dividirlo entre el número de personas cuando el usuario toca "Calcular".
- **FR-004**: En modo exacto, la aplicación DEBE mostrar el pago por persona con exactamente dos decimales y DEBE redondear hacia arriba cuando el tercer decimal sea 5.
- **FR-005**: En modo hacia arriba, la aplicación DEBE elevar el pago individual al entero más cercano y mostrarlo con exactamente dos decimales.
- **FR-006**: Si el número de personas es cero, negativo, decimal o no numérico, la aplicación DEBE mostrar "Debe haber al menos una persona" y NO DEBE mostrar un resultado.
- **FR-007**: Si el monto no es numérico, está vacío, es cero o es negativo, la aplicación DEBE mostrar "Monto inválido" y NO DEBE mostrar un resultado.
- **FR-008**: Si el porcentaje de propina es negativo o no numérico, la aplicación DEBE mostrar "Propina inválida" y NO DEBE mostrar un resultado.
- **FR-009**: La aplicación DEBE funcionar completamente sin conexión, sin usar red ni base de datos.
- **FR-010**: Cada cálculo válido DEBE reemplazar en pantalla el resultado del cálculo anterior.
- **FR-011**: Si varias entradas son inválidas simultáneamente, la aplicación DEBE mostrar un solo mensaje con prioridad monto → personas → propina.

### Key Entities

- **Cuenta**: Representa el monto total, el número de personas y el porcentaje de propina introducidos para un cálculo.
- **Modo de redondeo**: Representa la regla elegida por el usuario: exacto o hacia arriba al entero más cercano.
- **Resultado de división**: Representa el pago calculado por persona y su presentación con dos decimales.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Desde que la pantalla está lista para recibir datos hasta que aparece el resultado, el usuario puede completar un cálculo válido en menos de 30 segundos.
- **SC-002**: Los seis escenarios de aceptación producen exactamente el resultado o mensaje especificado.
- **SC-003**: El 100% de las entradas inválidas descritas no muestran un resultado de pago.
- **SC-004**: El 100% de los resultados válidos se muestran con exactamente dos decimales.
- **SC-005**: Todas las funciones de ingreso, selección y cálculo permanecen disponibles sin conexión.

## Assumptions

- El monto total y el porcentaje de propina se expresan como valores decimales, mientras que el número de personas es un entero.
- El porcentaje de propina se aplica al monto total antes de dividir la cuenta.
- El modo hacia arriba se aplica al resultado individual después de incluir la propina.
- La aplicación realiza un cálculo a la vez y no conserva historial entre usos.
- No existen cuentas de usuario, permisos ni almacenamiento persistente.
