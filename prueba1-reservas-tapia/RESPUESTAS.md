## Escenarios que elegí y por qué

Elegí solapamiento parcial, reserva contenida, reserva que contiene otra e intervalos idénticos: son cuatro maneras de compartir tiempo en una sala que la especificación rechaza con el mismo mensaje (`prueba1-reservas-tapia/specs/001-reservas-sala/spec.md:24-31`). Los intervalos consecutivos y las salas distintas fijan los casos permitidos (`prueba1-reservas-tapia/specs/001-reservas-sala/spec.md:32-40`). Las pruebas comprueban la respuesta y cuántas reservas guarda el repositorio en memoria (`prueba1-reservas-tapia/test/crear_reserva_test.dart:51-120`, `prueba1-reservas-tapia/test/support/reservas_en_memoria.dart:4-24`).

## Riesgo más grave del repositorio

La aplicación puede crear reservas sin ejecutar la regla de dominio: `prueba1-reservas-tapia/lib/main.dart:13-26` construye e inyecta `CrearReserva`, pero `prueba1-reservas-tapia/lib/presentation/reserva_page.dart:58-65` inserta directamente en Supabase. Por ello, las pruebas de `CrearReserva` no demuestran que la pantalla rechace solapamientos (`prueba1-reservas-tapia/test/crear_reserva_test.dart:17-23`, `prueba1-reservas-tapia/lib/presentation/reserva_page.dart:58-65`).

## ¿La regla protege la app real?

No todavía: la comprobación solo ocurre al llamar al caso de uso (`prueba1-reservas-tapia/lib/domain/crear_reserva.dart:9-27`). Además, este consulta y guarda en operaciones separadas (`prueba1-reservas-tapia/lib/domain/crear_reserva.dart:16-26`), por lo que dos solicitudes simultáneas podrían observar la sala libre. El SQL mostrado solo restringe `fin > inicio` y no contiene una restricción contra solapamientos (`prueba1-reservas-tapia/supabase/migracion.sql:4-12`). No he comprobado la base de datos desplegada.
