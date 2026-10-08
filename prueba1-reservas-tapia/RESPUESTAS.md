## Escenarios que elegí y por qué

Elegí solapamiento parcial, reserva contenida, reserva que contiene otra e intervalos idénticos porque representan formas distintas de compartir tiempo en una sala; la especificación los rechaza con el mismo mensaje (`specs/001-reservas-sala/spec.md:24-31`). Elegí también intervalos consecutivos y el mismo horario en salas distintas para fijar los límites de la regla: ninguno comparte tiempo en la misma sala (`specs/001-reservas-sala/spec.md:32-40`). Las seis pruebas usan un repositorio en memoria y comprueban tanto la respuesta como la cantidad guardada (`test/crear_reserva_test.dart:51-120`, `test/support/reservas_en_memoria.dart:4-24`).

## Riesgo más grave del repositorio

Hay una clave incrustada en el código y el README la identifica como `service_role` (`lib/data/supabase_config.dart:3-4`, `README.md:17-20`); esto contradice la prohibición de guardar secretos en el repositorio (`.specify/memory/constitution.md:16-17`). No comprobé si la clave sigue activa, por lo que describo una exposición potencial, no un acceso demostrado.

## ¿La regla protege la app real?

No en el flujo actual: `lib/main.dart:13-26` inyecta `CrearReserva`, pero el botón ejecuta una inserción directa desde `lib/presentation/reserva_page.dart:58-65`. La nueva comprobación solo se ejecuta cuando se llama al caso de uso (`lib/domain/crear_reserva.dart:9-27`). Además, consulta y guardado son operaciones separadas (`lib/domain/crear_reserva.dart:16-26`): dos solicitudes simultáneas podrían observar la misma sala libre. El SQL mostrado restringe `fin > inicio`, pero no contiene una restricción contra solapamientos (`supabase/migracion.sql:4-12`). No verifiqué que esa migración esté aplicada en una base real.
