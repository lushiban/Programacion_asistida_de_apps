¿Qué responsabilidades distintas conviven dentro de la pantalla? Nombrarlas.

Esta accediendo a la llamada hhtp, la decodificacion json, le pone una regla de negocio

Si cambia la URL de la API, ¿por qué una modificación relacionada con acceso a datos obliga también a modificar el archivo que contiene la interfaz? ¿Qué problema de diseño evidencia esto?
class _UsersScreenState extends State<UsersScreen> ...
aqui esta la api completametne escrita, la llamada http, la conversion json, y la misma creacion de la interfaz

Los problemas que tiene es que tiene un acoplamiento alto(la interfaz está unida a la API), baja cohesión (una clase tiene tareas que son diferentes), y en si la pantalla tiene como muchas cosas para cambiar



3. ¿Puede probarse la regla "el nombre empieza con vocal" sin ejecutar la interfaz Flutter? Explicar por qué.

No se puedo o seria muy dificil, el filtro si funciona, pero actualmente como esta mezclada con la interfaz, http no se peude


4. En términos de **cohesión**: ¿qué responsabilidades están agrupadas en el mismo archivo aunque no
   pertenecen al mismo propósito?

los que estan son la creacion de la interfaz, el acceso de datos por http, la decodificaion json, la regla del negocioy el controlador de los estados de pantalla. Tiene baja cohesion por el momento}

5. En términos de **acoplamiento**: si los usuarios dejaran de obtenerse por HTTP y pasaran a
   obtenerse desde una base de datos local, ¿qué partes de la pantalla tendrían que modificarse?
   ¿Qué indica esto sobre el nivel de acoplamiento?

Los import de : import 'dart:convert';
import 'package:http/http.dart' as http;

el hhtp client, ese se podria sustituir por la base local

La url, poruqe ya no necesitaria

la decodificacion json y la conversion


6. ¿En qué capa quedó la regla "mostrar únicamente usuarios cuyo nombre empieza con vocal"?
   Justificar por qué pertenece allí y no a `data` ni a `presentation`.

En "obtener:usuarios_con_vocal", ahora ahi obtiene el usuario y aplica la regla "

return usuarios.where((usuario) {
  final nombre = usuario.nombre.trimLeft();

  return nombre.isNotEmpty &&
      'AEIOU'.contains(nombre[0].toUpperCase());
}).toList();"

No oertenece a Data porque ese archivo tiene que obtener y convertir los datos

y presentacion tiene que mostrar el resultado

7. Antes del refactor, ¿de qué detalles concretos dependía la pantalla? ¿Qué dependencias concretas
   desaparecieron de la presentación después del refactor?

El refractor tienia la importacion, dependia de "import 'dart:convert';"

y encesitaba la url, los codigos hhtp, la estructura json

leugo:

usyarios_screen desaparece todo eso y ahora solo depende de flutter y elementos que tiene "domain"

8. Indicar al menos una propuesta generada por la IA durante la actividad que se decidió **no
    aceptar tal como fue entregada**. Explicar qué se modificó o rechazó y por qué.


que se inyectar adirectametne  http.Client
