1. Pega tu `ci.yml` y explica, en una línea cada uno, qué hace `analyze`, `test` y `build`.

""
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  verificar:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: actividadsem7/divisor_cuenta
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug

  entrega:
    needs: verificar
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: actividadsem7/divisor_cuenta
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter build apk --debug
      - uses: actions/upload-artifact@v4
        with:
          name: divisor-cuenta-debug
          path: actividadsem7/divisor_cuenta/build/app/outputs/flutter-apk/app-debug.apk
          if-no-files-found: error

""

Analyze revisa el código estáticamente y señala los problemas de análisis de Dart
Test ejecuta las pruebas automatizadas y este falla si alguna expectativa no se cumple
Build comprueba que la app se puede compilar como APK de depuración


2. Adjunta la captura del ✗ de la Parte 3. ¿Qué línea del log te dijo exactamente qué falló?
![alt text](image.png)

En la línea 18 del log apareció `division_test.dart: 1. reparto normal (failed)`, que me indicó cuál era la prueba que había fallado. En la línea 39 salió `11 tests passed, 1 failed`, mostrando que 11 pruebas pasaron y una falló. Al final en la línea 40 apareció `exit code 1` confirmandome que el proceso terminó con un error

3. ¿Qué diferencia hay entre *continuous integration*, *continuous delivery* y *continuous deployment*? ¿Cuál implementaste y por qué?

Continuous integration revisa automáticamente que los cambios no tengan errores y Continuous delivery deja la aplicación preparada para entregarla, mientras que continuous deployment la publica automáticamente

Yo implementé CI y una entrega automática básica, ya que GitHub revisa las pruebas y en el caso qeu todo salga bien genera un APK que se puede descargar

4. Adjunta la captura del *merge* bloqueado (Parte 3). ¿Qué problema evita que `main` quede roto?

![alt text](image-1.png)

El merge bloqueado evita que se suban cambios con errores a main. Como una de las pruebas falló, GitHub no me permitió unir los cambios hasta que corrigiera el problema y todas las pruebas pasaran. Así se evita que un error afecte la versión principal del proyecto.

5. ¿Qué sugirió el agente en la Parte 5? ¿Cuál aceptaste y cuál rechazaste, y por qué?

El agente encontró algunos riesgos en mi ci.yml, como el uso de versiones antiguas de algunas acciones de GitHub y posibles problemas con futuras actualizaciones. Aceptaría actualizar las acciones para que sean compatibles con Node 24, porque ayudaría a evitar problemas más adelante. En cambio rechazaría cambiar ubuntu-latest por una versión fija, ya que el profesor pidió utilizar esa configuración y hasta ahora ha funcionado correctamente

6. ¿Qué garantiza realmente un CI verde y qué errores pueden quedar sin detectar? Da un ejemplo de un error que pasaría en verde.

Que el CI esté en verde significa que las pruebas y revisiones se completaron sin errores. Sin embargo, eso no quiere decir que la aplicación funcione perfectamente, porque pueden existir problemas que las pruebas no detecten. Por ejemplo, si alguien ingresa una cantidad demasiado grande y no tenemos una prueba para ese caso, podría haber un error aunque el CI siga en verde

7. ¿Qué detectó el pipeline que tú no habías visto?
El pipeline mostró de forma automática que una expectativa incorrecta (27.00 en lugar de 27.50) hacía fallar el caso «1. reparto normal» y detenía la compilación posterior. Además, la ejecución de GitHub Actions mostró advertencias de compatibilidad de acciones que declaran Node.js 20; esas advertencias no aparecen al ejecutar solamente las pruebas de Flutter en mi computador.

