1. **Rojo antes de verde.** ¿Qué mensaje de error te mostró `flutter test` en la Parte 2?
   ¿Por qué era importante ver esa prueba fallar **antes** de escribir el código?

 La prueba estaba esperando el mensaje "La propina no puede superar el 100%", pero esta recibió null. Mostrando asi que la app todavía aceptaba una propina de 150%. Era importante verla fallar primero para saber que la prueba sí detectaba el problema


2. **Linter vs. IA.** Nombra un aviso que te mostró `flutter analyze` y un code smell que te
   señaló la IA. ¿Por qué el linter no encontró el code smell?

Flutter analyze avisó que "variableSinUsar" no se usaba. Codex señaló que el controlador se creaba dentro de build(). El linter no marcó eso porque hace falta pensar en lo que pasa cuando Flutter vuelve a construir la pantalla

3. **Tu refactorización.** ¿Qué code smell elegiste, qué cambió en el código y cómo sabes
   que la app sigue haciendo exactamente lo mismo?

Elegí el controlador creado en build(). Cambié DivisorCuentaApp a StatefulWidget y creé el controlador una sola vez en initState(). Todas las pruebas pasaron antes y después del cambio y flutter analyze no me mostró problemas. No cambié la lógica de la app por lo que esos resultados me dan confianza en que sigue funcionando igual en los casos probados

4. **Coverage.** ¿Qué archivo de `lib/` tiene el porcentaje más bajo? ¿Significa eso que
   ese archivo tiene errores? Explica.

El archivo con menor cobertura fue "lib/presentation/divisor_controller.dart" 86,36% (19 de 22 líneas). Eso no quiere decir que el archivo tenga errores, sino que hay líneas que las pruebas todavia aun no ejecutaron