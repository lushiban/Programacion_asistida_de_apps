# Quickstart: Validación de Dividir Cuenta

## Requisitos

- Flutter SDK estable disponible.
- Flutter SDK estable; no se requieren paquetes externos.
- Ningún servicio, conexión o base de datos externa.

## Comandos de validación

Desde la raíz del proyecto:

```text
flutter pub get
flutter analyze
flutter test --reporter expanded
flutter run
```

No se requiere instalar ningún paquete externo.

## Validación automatizada esperada

Las pruebas de dominio deben cubrir los seis escenarios de [spec.md](spec.md), la
sustitución de ambas estrategias y las tres aclaraciones. Las pruebas de widget deben
confirmar el contrato observable de [contracts/ui-contract.md](contracts/ui-contract.md).

El análisis debe finalizar sin errores y todas las pruebas deben quedar en verde.

## Validación manual de aceptación

| Monto | Personas | Propina | Modo | Resultado esperado |
|---:|---:|---:|---|---|
| 100.00 | 4 | 10 | Exacto | 27.50 |
| 90.00 | 3 | 0 | Exacto | 30.00 |
| 50.00 | 0 | 0 | Exacto | `Debe haber al menos una persona`; sin resultado |
| abc | 4 | 0 | Exacto | `Monto inválido`; sin resultado |
| 10.00 | 3 | 0 | Exacto | 3.33 |
| 10.00 | 3 | 0 | Hacia arriba | 4.00 |

Casos aclarados adicionales:

- Personas negativas, decimales o no numéricas muestran
  `Debe haber al menos una persona` y ocultan el resultado.
- Propina negativa o no numérica muestra `Propina inválida` y oculta el resultado.
- Un valor individual de 2.345 en modo exacto se muestra como 2.35.

## Comprobaciones arquitectónicas

- `lib/domain/` no contiene importaciones de `package:flutter`.
- `lib/presentation/` no importa archivos de `lib/data/`.
- Las construcciones de `RedondeoExacto` y `RedondeoHaciaArriba` aparecen únicamente en
  `lib/main.dart`.
- `pubspec.yaml` no contiene dependencias externas; solo referencias a SDKs de Flutter.

### Resultado de comprobación de implementación (2026-10-01)

- `flutter analyze --no-pub lib` finalizó sin problemas.
- `lib/domain/` no contiene importaciones de `package:flutter`.
- `lib/presentation/` no importa archivos de `lib/data/`.
- No existen dependencias ni llamadas de red en `lib/`.
- Las instancias concretas de `RedondeoExacto` y `RedondeoHaciaArriba` se crean únicamente
  en `lib/main.dart`; sus archivos de clase solo declaran los constructores.
- `pubspec.yaml` conserva únicamente dependencias provistas por el SDK de Flutter.
- Las pruebas automatizadas y la validación manual permanecen pendientes porque `test/` no
  se modifica en esta etapa por instrucción del usuario.
