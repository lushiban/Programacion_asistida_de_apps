> **1.** ¿Qué pasó en el paso 3 y por qué? Ojo: el valor **sí** se guardó en disco. ¿Qué es exactamente lo que quedó desactualizado? Y para que el contador viajara entre las dos pantallas, ¿cuántos lugares del código tuvieron que ponerse de acuerdo?

El incremento si se guatdo, pero la copia local(State) quedo desactualizado. 
Al presionarse el boton +1, eñ caso de uso leyo el valor, lo invcremento, lo guardo y devolvio el resultado y luego pantallaControl actualizo su propia variable con ese resultado. Al mometno de darle hacia tras en mi caso si se devolvio hacia atras.

Los lugares de codigo fueron los siguientes: El visor tuvo que enviar el valor, Control tuvo que recibirlo, Control tuvo que devolver el valor actualizado y el visor tuvo que recibirlo y actualizar su estado. 


2. ¿Por qué ahora el botón atrás del sistema no rompe nada? ¿Dónde vive el contador?

Ahora el botón atrás del sistema no rompe la sincronización porque el contador ya no pertenece al estado local de ninguna pantalla y tampoco se transporta mediante Navigator
El valor actual vive en el `state` de `ContadorNotifier`, administrado por `contadorProvider` dentro del `ProviderScope`. Este `ProviderScope` envuelve toda la aplicación, por lo que continúa existiendo aunque `PantallaControl` sea eliminada de la navegación



3. ¿Qué te permite ver el BlocObserver que las otras dos versiones no te daban? ¿En qué situación real sería útil ese registro?

Lo que me permite ver el BlocObserver es el valor que cambia, desde el actual al nuevo, ya sea que aumente o disminuya. Este registro seria muy util al momento de o crear bases de datos con registros de cambios; o ver en  tiempo real los cambio que se producen en el programa y, en el caso que haya un error, poder ver el registro de lo que sucedio para poder ver en donde ocurrio el error


> **4.** Pega la salida de los tres comandos en `RESPUESTAS.md`. ¿Qué demuestra que los dos primeros salgan vacíos y el tercero no? Si mañana tuvieras que cambiar Riverpod por otro paquete, ¿qué parte del proyecto tendrías que volver a escribir?

eduta@LAPTOP-CGRNL3MN MINGW64 ~/Documents/Universidad/semestre 3/Programacion de Apps/Programacion_asistida_de_apps/deber1-estado-streams/parte_a_contador (version/bloc)
$ git diff version/setstate version/bloc -- lib/domain lib/data

eduta@LAPTOP-CGRNL3MN MINGW64 ~/Documents/Universidad/semestre 3/Programacion de Apps/Programacion_asistida_de_apps/deber1-estado-streams/parte_a_contador (version/bloc)
$ git diff version/setstate version/riverpod -- lib/domain lib/data

eduta@LAPTOP-CGRNL3MN MINGW64 ~/Documents/Universidad/semestre 3/Programacion de Apps/Programacion_asistida_de_apps/deber1-estado-streams/parte_a_contador (version/bloc)
$ git diff version/setstate version/bloc --stat -- lib/presentation
 lib/presentation/estado/contador_cubit.dart      | 43 ++++++++++++
 lib/presentation/pantallas/pantalla_control.dart | 81 ++++++-----------------
 lib/presentation/pantallas/pantalla_visor.dart   | 83 ++++++------------------
 3 files changed, 83 insertions(+), 124 deletions(-)

eduta@LAPTOP-CGRNL3MN MINGW64 ~/Documents/Universidad/semestre 3/Programacion de Apps/Programacion_asistida_de_apps/deber1-estado-streams/parte_a_contador (version/bloc)
$


Si fuera necesario cambiar Riverpod por otro paquete, habría que cambiar el administrador de estado, adaptar las pantallas que usan ref.watch y ref.read, modificar la configuración de dependencias en main.dart, actualizar pubspec.yaml y, posiblemente, ajustar las pruebas de presentación. No sería necesario reescribir las capas domain ni data, porque el nuevo administrador seguiría utilizando los mismos casos de uso y el mismo contrato del repositorio.


Pregunta::

| | setState | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? |de manera local _contador en cada StatefulWidget.  es por cada pantalla|En el state de ContadorNotifier, el cual es administrado por contadorProvider |En el state de ContadorCubit |
| ¿Las pantallas se pasan datos? | Sí. Visor pasa el valor inicial a Control y Control devuelve el valor mediante Navigator.pop(context, contador).| No, las 2 pantallas observan el mismo contadorProvider| No. Ambas pantallas acceden al mismo objeto ContadorCubit |
| Archivos de `presentation/` que tocaste | pantalla_visor.dart -- pantalla_control.dart| contador_provider.dart -- pantalla_visor.dart -- pantalla_control.dart|contador_cubit.dart -- pantalla_visor.dart -- pantalla_control.dart|
| ¿Qué pasa con el botón atrás? |El botón atrás del sistema no devuelve el contador, lo que pasa es que el valor queda guardado en disco, pero la copia local del visor se queda desactualizada |Funciona bien, solo cierra Control; el estado permanece en Riverpod y el visor ya observa el valor actualizado | Funciona correctamente, porque solo cierra Control; el estado permanece en el Cubit compartido y el visor muestra el valor actualizado |
| ¿Tuviste que tocar `domain/`? | no|no |no |




6. ¿Por qué la pantalla siguió mostrando "Wi-Fi" si el Wi-Fi ya estaba apagado? ¿La app tenía un dato incorrecto, o tenía un dato correcto de un momento equivocado?


La app no tenia un dato incorrecto, lo que pasa es que no se actualizo con el cambio, por lo que solo se puede ver el estado actual si se consulta manualmente. 



> **7.** ¿Qué pasaría si borras el `cancel()` del `close()` del Cubit y el usuario entra y sale de esa pantalla cincuenta veces?

Lo que pasaria es que se quedarian acumularian cada vez que se sale y entra a la pantalla, dejando 50 _sub abiertos, y seguirian escuchando informacion aunque ya no se usen. Por lo que habria como una fuga de memoria y aparte un mal funcionamiento

> **8.** Con lo que viste: ¿por qué decimos que un `Future` es una foto y un `Stream` una película? Explícalo con la conexión, no con la definición del libro. Cierra nombrando **dos datos** de una app real que pedirías con `Future` y **dos** que observarías con `Stream`.

Basicamente, con future se realiza diferentes consultas manuales, y cada consulta se queda en pantalla "como una fotografia" desde la ultima vez que se dio la orden de consultar sin importar si esos datos ya cambiaron o no. Y ocn Stream se tienen activado una suscripcion la cual siempre esta escuchando los cambios y a partir esto se va actualizando la pantalla constantemente si cambia los datos.
 
 2 datos con future: El estado de cuenta en una app de banco, los detalles de algun producto  
 2 datos con stream: Mensajes de la app, transferencias de dinero entre cuentas