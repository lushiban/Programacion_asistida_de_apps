# Integración de Tabla_prueba

La app consulta `public.Tabla_prueba`, respetando la mayúscula inicial. La captura proporcionada muestra dos columnas: `id` (int8) y `created_at` (timestamptz). No existe una columna `name` en esa tabla.

## Ruta del código

1. `lib/main.dart` inicializa Flutter, carga `.env` e inicializa Supabase. Crea el repositorio, el caso de uso y el provider; al crear el provider llama a `cargar()`.
2. `lib/presentation/providers/registros_prueba_provider.dart` activa el estado de carga y llama a `ObtenerRegistrosPrueba`.
3. `lib/domain/usecases/obtener_registros_prueba.dart` llama al contrato `RegistrosPruebaRepository.obtenerTodos()` definido en `lib/domain/repositories/registros_prueba_repository.dart`.
4. `lib/data/repositories/supabase_registros_prueba_repository.dart` implementa ese contrato. Ejecuta `from('Tabla_prueba').select('id, created_at').order('id')`.
5. El repositorio convierte cada fila en `RegistroPrueba`, definido en `lib/domain/entities/registro_prueba.dart`: `id` se conserva como entero y `created_at` se convierte en `DateTime?`.
6. El provider recibe los registros y notifica a `lib/presentation/pantallas/home_page.dart`. La pantalla muestra ID y fecha UTC, o el estado de carga, lista vacía o error con reintento. El botón Actualizar permite volver a consultar incluso con la lista vacía.

La dirección de dependencias continúa siendo `presentation -> domain <- data`. Solo `main.dart` conecta las implementaciones concretas. `domain` no importa Flutter, Provider ni Supabase; `presentation` no importa Supabase.

## Consulta y datos reales

La consulta de comprobación de solo lectura a `/rest/v1/Tabla_prueba?select=id,created_at&order=id.asc&limit=1` respondió HTTP 200 con `[]`. Esto confirma que la API reconoce la tabla y las columnas, y que la clave de la app no recibió un error en esa consulta. Una respuesta vacía por sí sola no demuestra que las políticas RLS permitan leer futuras filas; la captura también muestra la tabla vacía.

No se insertaron registros ni se modificaron tablas o políticas en Supabase. Los registros utilizados por las pruebas son simulados y no se envían a la base de datos.

La URL y la clave publicable se leen desde `.env`, ignorado por Git. El permiso INTERNET se declara en el manifiesto principal de Android para que la consulta también esté habilitada en versiones de distribución.
