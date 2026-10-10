
1.¿Dónde están guardados ahora los datos de tu aplicación y qué implica eso para un
> usuario que abra la app desde otro teléfono?
Esta guardada localmente, y cuando un usario lo abra desde otro telefono tendra que ingresar usuario y contraseña para entrar a la base de datos de otro telefono. Y en el caso que quiera guardar o acceder localmente a su base de datos. no tendra la informacion que tiene otro telefono


2. ¿Por qué la clave publicable puede ir dentro de la app y la secreta no, si las dos son cadenas de texto? ¿Qué puede hacer la secreta que la publicable no?

Basicamente porque la clave publicable tiene un limite de lo que puede hacer y acceder, limitado por las politicas RLS. En el caso en el que se tenga acceso a la clave secreta, se accedweria facilmente a datos sensibles

> **4.** Con estas políticas activas, ¿qué pasaría si alguien saca la clave publicable de tu app e intenta borrar los perfiles de los demás?

No podria, porque esa clave esta restringida por las politicas RLS

 **5.** ¿Por qué conviene que la sesión y la lista de perfiles sean dos clases separadas y no una sola con todo adentro? ¿Y por qué las implementaciones concretas se nombran solo en `main.dart`?

 Conviene separar la sesión y la lista de perfiles porque cumplen responsabilidades distintas. `SesionProvider` controla quién inició sesión y las operaciones de registro, ingreso y salida; `PerfilesProvider` controla la carga de perfiles. Así, un cambio o error al cargar la lista no altera el estado de la sesión, y cada clase se puede probar por separado.

Las implementaciones concretas se nombran solo en `main.dart` porque allí se conectan los contratos de `domain` con los repositorios de Supabase. Los providers reciben esos contratos y no necesitan saber de dónde vienen los datos. Si se cambia Supabase por otra fuente, se modifica esa conexión sin cambiar la lógica de `domain` ni las pantallas.

> **6.** ¿Dónde quedó guardada la contraseña que escribiste? Revisa **Authentication →
> Users** en Supabase y luego **Table Editor → perfiles**. ¿Qué ves en cada lugar y por qué
> es importante que sea así?

> **7.** ¿Por qué el servidor puede crear usuarios y la app no? Si quisieras que la app
> pudiera hacerlo, ¿pondrías la clave secreta en Flutter o llamarías a este endpoint? Explica
> qué ganas y qué pierdes con cada opción.