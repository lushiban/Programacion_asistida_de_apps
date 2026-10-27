# Instrucciones del proyecto

Este proyecto es una app Flutter de una sola pantalla para dividir una cuenta entre varias personas.

Organiza el código en `lib/presentation`, `lib/domain` y `lib/data`. Respeta la regla de dependencia `presentation -> domain <- data`: presentación y datos pueden depender del dominio, pero el dominio no depende de esas capas ni importa nada de `package:flutter`.

Usa null safety, nombres en español y únicamente las dependencias incluidas en el SDK y el proyecto. No agregues paquetes externos.

No modifiques `test/` salvo que el usuario lo pida. No agregues dependencias a `pubspec.yaml` sin avisar primero. No toques `android/` ni `ios/`.

Comandos habituales del proyecto:

- `flutter pub get`
- `flutter run`
- `flutter analyze`
- `flutter test`
