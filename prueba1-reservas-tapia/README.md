# Reservas de sala

App Flutter para que un estudiante autenticado reserve una sala de estudio por un intervalo
de tiempo. Los datos viven en Supabase.

## Correr las pruebas

```bash
flutter pub get
flutter test
```

Las pruebas de `test/` no necesitan red ni Supabase: usan un repositorio en memoria
(`test/support/reservas_en_memoria.dart`).

## Correr la app

1. Crea un proyecto en Supabase y ejecuta `supabase/migracion.sql` en el SQL Editor.
2. Usa la URL del proyecto y su clave pública `anon` al ejecutar la app.
3. `flutter run --dart-define=SUPABASE_URL=TU_URL --dart-define=SUPABASE_ANON_KEY=TU_CLAVE_ANON`

## Estructura

```text
lib/
├── domain/        reglas de negocio (Dart puro)
├── data/          acceso a Supabase
└── presentation/  pantallas
specs/001-reservas-sala/   spec y plan (GitHub Spec Kit)
supabase/                  esquema de la base
test/                      pruebas de dominio
```
