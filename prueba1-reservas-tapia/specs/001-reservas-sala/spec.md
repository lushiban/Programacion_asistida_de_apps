# Feature Specification: Reservas de sala

**Feature Branch**: `001-reservas-sala`
**Created**: 2026-10-01
**Status**: Draft

## User Scenarios & Testing

### User Story 1 — Reservar una sala (Priority: P1)

Como estudiante autenticado, quiero reservar una sala de estudio por un intervalo de tiempo
para tener dónde trabajar con mi grupo.

**Why this priority**: sin reservas, la app no tiene propósito.

**Independent Test**: se puede probar creando una reserva y comprobando que queda registrada.

**Acceptance Scenarios**:

1. **Dado** que la sala A está libre, **Cuando** la reservo de 09:00 a 10:00, **Entonces** la
   reserva queda registrada a mi nombre.
2. **Dado** que elijo como inicio las 10:00 y como fin las 09:00, **Cuando** intento reservar,
   **Entonces** la reserva se rechaza con el mensaje "La hora de fin debe ser posterior a la de inicio".
3. **Dado** que la sala A está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   09:30 a 10:30, **Entonces** se rechaza con el mensaje "La sala ya está reservada en ese horario.".
4. **Dado** que la sala A está reservada de 09:00 a 11:00, **Cuando** intento reservarla de
   09:30 a 10:30, **Entonces** se rechaza con el mensaje "La sala ya está reservada en ese horario.".
5. **Dado** que la sala A está reservada de 09:30 a 10:30, **Cuando** intento reservarla de
   09:00 a 11:00, **Entonces** se rechaza con el mensaje "La sala ya está reservada en ese horario.".
6. **Dado** que la sala A está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   09:00 a 10:00, **Entonces** se rechaza con el mensaje "La sala ya está reservada en ese horario.".
7. **Dado** que la sala A está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   10:00 a 11:00, **Entonces** la nueva reserva queda registrada.
8. **Dado** que la sala A está reservada de 09:00 a 10:00, **Cuando** reservo la sala B de
   09:00 a 10:00, **Entonces** la nueva reserva queda registrada.

### Edge Cases

- Dos reservas de la misma sala no pueden compartir tiempo. Si una termina exactamente cuando
  empieza la otra, ambas se permiten.

## Requirements

### Functional Requirements

- **FR-001**: El estudiante elige una sala, una hora de inicio y una hora de fin.
- **FR-002**: Las salas disponibles son Sala A, Sala B y Sala C.
- **FR-003**: El estudiante recibe confirmación de la reserva o el motivo del rechazo.
- **FR-004**: Las reservas aceptadas quedan registradas.
- **FR-005**: La hora de fin debe ser posterior a la hora de inicio.
- **FR-006**: Se rechaza una reserva que comparte tiempo con otra de la misma sala, con el mensaje
  "La sala ya está reservada en ese horario.".
- **FR-007**: Se permiten reservas consecutivas sin tiempo compartido y reservas simultáneas en
  salas distintas.

### Key Entities

- **Reserva**: sala, estudiante, inicio y fin.
- **Sala**: identificada por su nombre (Sala A, Sala B, Sala C).

## Success Criteria

- **SC-001**: Un estudiante completa una reserva en menos de 30 segundos.
