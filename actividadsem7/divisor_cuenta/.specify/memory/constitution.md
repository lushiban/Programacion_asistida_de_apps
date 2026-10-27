# Constitución de Divisor de Cuenta

## Core Principles

### I. Responsabilidad Única (SRP)

Cada clase DEBE tener una sola razón de cambio. El cálculo DEBE limitarse a calcular: no
DEBE validar entradas ni formatear resultados. La validación y el formato DEBEN residir en
responsabilidades separadas y comprobables.

### II. Abierto/Cerrado (OCP)

El diseño DEBE permitir agregar una nueva regla de redondeo mediante una nueva
implementación, sin modificar las clases de cálculo existentes.

### III. Sustitución de Liskov (LSP)

Toda implementación de una interfaz DEBE poder sustituir a cualquier otra implementación
de esa misma interfaz. El código consumidor NO DEBE consultar el tipo concreto, hacer casts
ni cambiar su comportamiento según la implementación recibida.

### IV. Segregación de Interfaces (ISP)

Las interfaces DEBEN ser pequeñas y contener únicamente los métodos que requieren sus
consumidores. Ninguna clase DEBE depender de métodos que no utiliza.

### V. Inversión de Dependencias (DIP)

La capa `presentation` DEBE depender de abstracciones definidas en `domain` y NUNCA de
implementaciones concretas de `data`. Las dependencias concretas DEBEN inyectarse desde
`main.dart`.

## Arquitectura y seguridad

- El código DEBE organizarse en las capas `presentation`, `domain` y `data`.
- La dirección de dependencias DEBE ser `presentation -> domain <- data`.
- Los archivos de `lib/domain/` DEBEN ser Dart puro y NO DEBEN importar
  `package:flutter`.
- `main.dart` DEBE ser el único lugar donde se instancian implementaciones concretas.
- El repositorio NUNCA DEBE contener secretos ni claves de API.

## Calidad, pruebas y explicabilidad

- Toda funcionalidad crítica DEBE contar con pruebas ejecutables.
- Cada criterio de aceptación definido en una especificación DEBE convertirse en una
  prueba ejecutable.
- El estudiante DEBE poder explicar cada función generada por el agente: qué hace, por qué
  existe, qué recibe, qué devuelve y qué errores produce.

## Governance

Esta constitución prevalece sobre las decisiones de implementación que la contradigan. Toda
enmienda DEBE documentar el cambio, actualizar la versión y verificar nuevamente el
cumplimiento. La versión sigue SemVer: MAYOR para cambios incompatibles en las reglas, MENOR
para principios o secciones nuevas y PARCHE para aclaraciones sin cambio semántico. Toda
revisión de especificaciones, planes, tareas y código DEBE comprobar estas reglas antes de
considerar el trabajo terminado.

**Version**: 1.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-01
