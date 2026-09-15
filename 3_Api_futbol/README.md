# Cancha · Fútbol con ScoreBat

Aplicación Flutter con lista vertical de partidos, búsqueda, filtro por competición,
detalle y reproductores oficiales dentro de la aplicación. Colores: #1B8F2A y #F2F5E6.
El contador original se conserva en el menú superior.

## Ejecutar

```sh
flutter pub get
flutter run
```

Por defecto consulta https://www.scorebat.com/video-api/v3/.
La respuesta real inspeccionada contiene 50 partidos y un aviso de ScoreBat:
el endpoint quedó obsoleto y su última actualización fue el 27 de abril de 2026.
La app muestra ese aviso; no presenta este contenido como resultados actuales.
No hay datos ficticios ni un archivo local usado como respaldo.

## Feed actual (opcional, requiere token propio)

La documentación actual está en https://www.scorebat.com/video-api/docs/.
Con SCOREBAT_TOKEN se selecciona automáticamente /video-api/v3/free-feed/.
El contenido disponible depende del plan de ScoreBat.

Crear un archivo local fuera del repositorio con:

```json
{"SCOREBAT_TOKEN":"TU_TOKEN"}
```

```sh
flutter run --dart-define-from-file=RUTA_AL_ARCHIVO_LOCAL.json
```

SCOREBAT_ENDPOINT permite configurar otro endpoint de ScoreBat autorizado.
No subir tokens a Git. Los valores compilados en una app cliente pueden extraerse;
para una publicación que requiera proteger el token, usar un backend propio.
No se validó el feed autenticado porque no se proporcionó un token.

## Estructura

- lib/models/match_model.dart: feed, partidos, equipos y videos; campos opcionales.
- lib/services/scorebat_service.dart: HTTP, timeout, validación y errores legibles.
- lib/screens/embedded_content_screen.dart: WebView interno con carga, error y reintento.
- lib/screens/home_screen.dart: estados, actualización, búsqueda y filtros.
- lib/screens/match_detail_screen.dart: equipos, fecha y todos los videos.
- lib/screens/counter_screen.dart: funcionalidad original conservada.
- lib/widgets/: tarjetas, miniaturas y mensajes reutilizables.

El campo videos[].embed contiene HTML con iframe. Se extrae src mediante un
parser HTML (incluye decodificación de entidades), se admiten únicamente enlaces
HTTP/HTTPS y se abre el reproductor oficial dentro de un WebView.
No se descarga video ni se supone que embed sea un MP4. El proveedor controla
la disponibilidad de reproducción. `matchviewUrl` se abre igualmente dentro
de la app para mostrar las estadísticas, resultados y tablas que ScoreBat ofrezca
en su widget. El feed JSON no entrega cifras de estadísticas para dibujarlas
de forma nativa. No se crean marcadores ni escudos inexistentes.
Los iconos de equipos son genéricos. Las fechas se muestran en hora local.

La API inspeccionada devuelve una lista completa sin metadatos de paginación.
SliverList.builder crea las tarjetas bajo demanda. La búsqueda y el filtro son locales.
Si una actualización falla, se conservan los datos anteriores junto al error.
Android incluye permiso de Internet también para release. En web, el servidor
de ScoreBat debe permitir CORS; el cliente no puede saltarse esa restricción.

## Verificar

```sh
flutter analyze
flutter test
flutter build apk --debug
```

Los tests usan respuestas controladas para verificar parsing, errores, timeout,
búsqueda, navegación, pantalla estrecha y conservación del contador.
