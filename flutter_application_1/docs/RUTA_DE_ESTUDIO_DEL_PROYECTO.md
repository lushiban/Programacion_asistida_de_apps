# Ruta de estudio y revisión del proyecto Flutter

## 1. Resumen del proyecto

`flutter_application_1` es una aplicación Flutter pequeña y multiplataforma. Su pantalla principal plantea la pregunta **“¿Cuántos gatos de 3 patas puedes contar?”**, muestra una imagen y permite:

- incrementar el contador;
- disminuir el contador;
- restablecer el contador a cero.

La lógica y la interfaz están concentradas en `lib/main.dart`. El estado es local y vive solamente mientras la aplicación está abierta. Actualmente no hay base de datos, consumo de API, autenticación, navegación entre pantallas ni una arquitectura dividida en modelos, servicios o repositorios.

La estructura actual es adecuada para practicar los fundamentos de Flutter antes de separar la aplicación en más archivos.

## 2. Mapa general de carpetas

```text
flutter_application_1/
├── lib/
│   └── main.dart                  Código Dart y pantalla de la aplicación
├── test/
│   └── widget_test.dart           Prueba automatizada del contador
├── assets/
│   └── images/
│       └── gatos.png              Imagen mostrada en la pantalla
├── android/                       Integración nativa para Android
├── ios/                           Integración nativa para iPhone y iPad
├── web/                           Archivos de inicio para navegador
├── windows/                       Integración nativa para Windows
├── linux/                         Integración nativa para Linux
├── macos/                         Integración nativa para macOS
├── pubspec.yaml                   Identidad, versión, paquetes y recursos
├── pubspec.lock                   Versiones exactas de paquetes resueltas
├── analysis_options.yaml          Reglas de análisis y estilo
└── README.md                      Presentación general del proyecto
```

Flutter permite mantener una sola interfaz principal en Dart y conectarla con cada plataforma mediante las carpetas `android`, `ios`, `web`, `windows`, `linux` y `macos`.

## 3. Clasificación de los archivos

### Código que se modifica con frecuencia

- `lib/main.dart`: contiene el punto de entrada, el tema, la pantalla, el estado y los botones.
- `test/widget_test.dart`: comprueba que el usuario pueda incrementar y disminuir el contador.
- `pubspec.yaml`: registra dependencias y la imagen utilizada por la aplicación.
- `assets/images/gatos.png`: recurso visual utilizado por `Image.asset`.

### Configuración que se modifica cuando existe una necesidad concreta

- `analysis_options.yaml`: activa `flutter_lints` y define qué carpetas no revisa el analizador de Dart.
- `android/app/build.gradle.kts`: configuración de compilación de Android.
- `android/app/src/main/AndroidManifest.xml`: nombre, actividad inicial y permisos de Android.
- `ios/Runner/Info.plist`: metadatos y capacidades de iOS.
- `web/index.html` y `web/manifest.json`: inicio, nombre, iconos y comportamiento de la versión web.
- Archivos equivalentes dentro de `windows`, `linux` y `macos`: arranque nativo de escritorio.

### Archivos generados o administrados por herramientas

- `.dart_tool/` y `build/`: caché y resultados de compilación; no se deben editar manualmente.
- `pubspec.lock`: lo actualiza el gestor de paquetes. En una aplicación normalmente se conserva en Git.
- `GeneratedPluginRegistrant.*`, `generated_plugins.cmake`, `Generated.xcconfig` y archivos con nombres similares: conectan complementos con cada plataforma y suelen regenerarse.

## 4. Flujo de ejecución

Cuando se inicia la aplicación ocurre este recorrido:

```text
main()
  ↓
runApp(const MyApp())
  ↓
MyApp.build(context)
  ↓
MaterialApp
  ↓
home: MyHomePage
  ↓
_MyHomePageState.build(context)
  ↓
Scaffold → AppBar + contenido + botones
```

### ¿Qué representa cada parte?

- `main()` es el punto de entrada del programa Dart.
- `runApp(...)` entrega a Flutter el widget raíz.
- `MyApp` es un `StatelessWidget`: configura la aplicación, pero no guarda un estado que cambie.
- `MaterialApp` proporciona tema, componentes Material y la pantalla inicial.
- `MyHomePage` es un `StatefulWidget`: necesita un objeto de estado porque el número cambia.
- `_MyHomePageState` conserva `_counter` y reconstruye la interfaz cuando cambia.
- `Scaffold` crea la estructura visual básica de una pantalla Material.

## 5. Flujo del contador

El valor empieza en cero:

```dart
int _counter = 0;
```

Al pulsar un botón, el flujo es:

```text
Toque del usuario
  ↓
onPressed llama a un método
  ↓
_incrementCounter(), _decrementCounter() o _resetCounter()
  ↓
setState(...) cambia _counter
  ↓
Flutter vuelve a ejecutar build(...)
  ↓
Text('$_counter') muestra el valor nuevo
```

`setState` no vuelve a abrir toda la aplicación. Le avisa a Flutter que el estado de ese widget cambió y que debe actualizar la parte correspondiente de la interfaz.

## 6. Cómo se conecta la imagen

La relación entre configuración y código es:

```text
assets/images/gatos.png
  ↓ registrado en
pubspec.yaml
  ↓ solicitado por
Image.asset('assets/images/gatos.png')
  ↓ mostrado en
lib/main.dart
```

La ruta debe coincidir exactamente en el archivo físico, en `pubspec.yaml` y en `Image.asset`. Si una letra o carpeta cambia, Flutter no podrá cargar la imagen.

## 7. Revisión de la interfaz actual

La pantalla usa:

- `SafeArea` para evitar que el contenido quede debajo de zonas del sistema;
- `SingleChildScrollView` para permitir desplazamiento en pantallas pequeñas;
- `Column` para colocar pregunta, imagen, contador y botones verticalmente;
- `SizedBox` para crear espacios;
- `ElevatedButton` para las tres acciones;
- `Theme.of(context)` para reutilizar estilos del tema.

El contador mantiene correctamente sus tres operaciones. Sin embargo, el botón de disminuir permite obtener valores negativos. Esto no es un error técnico, pero puede no tener sentido al contar gatos. Si la regla del ejercicio exige un mínimo de cero, se podría impedir el decremento cuando `_counter == 0`.

## 8. Revisión de las pruebas

`test/widget_test.dart` crea `MyApp`, verifica que el contador empiece en `0`, pulsa **Incrementar contador** y comprueba el valor `1`; después pulsa **Disminuir contador** y comprueba el regreso a `0`.

La prueba actual cubre el recorrido principal de incremento y decremento. Todavía sería útil añadir casos para:

1. comprobar el botón **Restablecer contador** después de varios incrementos;
2. comprobar que la pregunta y la imagen existan;
3. decidir y probar si se permiten números negativos;
4. comprobar varios toques consecutivos.

## 9. Dependencias y configuración

En `pubspec.yaml` se observa:

- nombre del paquete: `flutter_application_1`;
- versión: `1.0.0+1`;
- restricción de Dart: `^3.13.1`;
- dependencia principal: Flutter;
- dependencia adicional: `cupertino_icons`;
- herramientas de desarrollo: `flutter_test` y `flutter_lints`;
- uso de Material Icons;
- registro de `assets/images/gatos.png`.

No hay paquetes para estado avanzado, red, almacenamiento, navegación o base de datos. Para el tamaño actual del proyecto, `setState` es suficiente.

## 10. Hallazgos y mejoras sugeridas

### Lo que está bien

- La aplicación conserva una responsabilidad fácil de entender.
- Los nombres de los métodos describen claramente cada operación.
- La imagen está declarada en la configuración y utilizada con la misma ruta.
- La pantalla contempla áreas seguras y desplazamiento vertical.
- Existe una prueba automatizada para dos acciones importantes.
- `debugShowCheckedModeBanner` está desactivado para limpiar la presentación.

### Mejoras de prioridad alta

1. Definir si el contador puede ser negativo y reflejar esa decisión en código y pruebas.
2. Añadir una prueba del botón de restablecimiento.
3. Reemplazar la descripción genérica de `pubspec.yaml` y el contenido genérico de `README.md` por información real de la aplicación.

### Mejoras para cuando el proyecto crezca

1. Mover `MyHomePage` a `lib/screens/home_page.dart`.
2. Extraer componentes repetibles a `lib/widgets/`.
3. Crear pruebas separadas por pantalla o componente.
4. Agregar rutas de navegación solamente cuando exista una segunda pantalla.
5. Incorporar otro gestor de estado únicamente si `setState` deja de ser suficiente.

No conviene dividir una aplicación tan pequeña en muchas capas todavía: primero es mejor dominar el flujo actual.

## 11. Ruta recomendada de estudio

### Etapa 1: comprender Dart básico

Estudia variables, tipos (`int`, `String`), funciones, clases, constructores, parámetros con nombre, `const`, privacidad mediante `_` y funciones anónimas.

Practica identificando estos elementos dentro de `lib/main.dart`.

### Etapa 2: comprender el árbol de widgets

Lee `main()` y sigue el árbol hasta `Text`, `Image.asset` y cada `ElevatedButton`. Aprende qué es un widget y por qué la interfaz se construye anidando widgets.

### Etapa 3: diferenciar widgets con y sin estado

Compara `MyApp extends StatelessWidget` con `MyHomePage extends StatefulWidget`. Después relaciona `MyHomePage` con `_MyHomePageState` y `_counter`.

### Etapa 4: dominar eventos y `setState`

Sigue `onPressed` hasta cada método. Cambia temporalmente operaciones sencillas y observa cómo `setState` provoca una reconstrucción.

### Etapa 5: estudiar diseño y contexto

Revisa `Scaffold`, `SafeArea`, `SingleChildScrollView`, `Column`, espacios, alineación y estilos. Entiende que `BuildContext` indica la posición de un widget en el árbol y permite consultar elementos cercanos como el tema.

### Etapa 6: estudiar recursos y paquetes

Relaciona `pubspec.yaml` con `Image.asset`. Aprende la diferencia entre una dependencia, una dependencia de desarrollo y un recurso local.

### Etapa 7: estudiar pruebas

Lee `widget_test.dart` en este orden: `testWidgets`, `pumpWidget`, `find`, `tap`, `pump` y `expect`. Después implementa los casos de prueba pendientes.

### Etapa 8: conocer las plataformas

Revisa primero los manifiestos y puntos de entrada nativos. No necesitas aprender Kotlin, Swift y C++ al mismo tiempo; basta con entender que esas carpetas conectan Flutter con cada sistema operativo.

### Etapa 9: practicar una refactorización pequeña

Cuando comprendas todo el archivo principal, mueve la pantalla a otro archivo sin cambiar su comportamiento. Esto enseña importaciones y organización sin introducir arquitectura innecesaria.

### Etapa 10: añadir una segunda funcionalidad

Agrega una segunda pantalla sencilla y aprende `Navigator`. Luego considera persistencia local para guardar el contador. Cada concepto debe aparecer porque resuelve una necesidad real.

## 12. Diez archivos prioritarios

Estúdialos en este orden:

1. `lib/main.dart`: flujo completo, interfaz, estado y eventos.
2. `pubspec.yaml`: paquetes, versión, SDK y recursos.
3. `test/widget_test.dart`: interacción y verificaciones automáticas.
4. `analysis_options.yaml`: reglas que ayudan a detectar problemas.
5. `assets/images/gatos.png`: ejemplo de recurso conectado a la interfaz.
6. `README.md`: documentación de entrada que conviene personalizar.
7. `android/app/src/main/AndroidManifest.xml`: configuración principal de Android.
8. `android/app/build.gradle.kts`: compilación, identificador y versiones de Android.
9. `web/index.html`: documento que inicia la aplicación web.
10. `ios/Runner/Info.plist`: metadatos y capacidades de iOS.

Después de esos diez, compara los puntos de entrada de Windows, Linux y macOS para reconocer qué parte es Flutter y qué parte pertenece a cada plataforma.

## 13. Conceptos clave que debes aprender

### Dart

- tipos y variables;
- funciones y retorno `void`;
- clases, herencia y métodos sobrescritos;
- constructores y parámetros con nombre;
- `const` y objetos inmutables;
- interpolación de cadenas: `'$_counter'`;
- privacidad de biblioteca con el prefijo `_`;
- callbacks o funciones entregadas a `onPressed`.

### Flutter

- árbol de widgets;
- `StatelessWidget` y `StatefulWidget`;
- estado local y `setState`;
- ciclo de reconstrucción de `build`;
- `BuildContext`;
- diseño con `Scaffold`, `Column`, tamaños y espacios;
- temas y `Theme.of(context)`;
- recursos con `Image.asset`;
- pruebas de widgets;
- navegación con `Navigator`, como siguiente paso y no como parte actual.

## 14. Comprobaciones recomendadas

Desde la carpeta raíz del proyecto se deben ejecutar periódicamente:

```text
flutter analyze
flutter test
```

La primera revisión busca errores y advertencias en el código Dart. La segunda ejecuta las pruebas automatizadas. También conviene abrir la aplicación en un emulador o dispositivo para comprobar visualmente el desplazamiento, la imagen y los tres botones.

## 15. Próximo ejercicio recomendado

El siguiente ejercicio más útil es establecer que el contador no baje de cero y añadir pruebas para esa regla y para el botón de restablecimiento. Es un cambio pequeño que permite practicar lógica, estado, experiencia de usuario y pruebas sin alterar la estructura general.
