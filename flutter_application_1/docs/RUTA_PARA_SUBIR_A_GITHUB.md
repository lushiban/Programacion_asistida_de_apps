# Ruta para subir el proyecto a GitHub

## 1. Datos de este repositorio

- Repositorio remoto: `https://github.com/lushiban/Programacion_asistida_de_apps`
- Rama principal: `main`
- Carpeta del repositorio local: `Programacion_asistida_de_apps`
- Carpeta de esta aplicación: `Programacion_asistida_de_apps/flutter_application_1`

La carpeta `flutter_application_1` forma parte de un repositorio mayor. Por eso es importante seleccionar únicamente sus archivos cuando no se quieran publicar cambios de los demás proyectos.

## 2. Recorrido de una publicación

```text
Archivos de flutter_application_1
  ↓
git status: revisar los cambios
  ↓
git add: seleccionar solamente los archivos deseados
  ↓
git diff --cached: comprobar lo seleccionado
  ↓
git commit: guardar una versión local con un mensaje
  ↓
git push origin main: enviarla a GitHub
```

## 3. Primera comprobación

Abre una terminal en la carpeta `Programacion_asistida_de_apps` y ejecuta:

```powershell
git status
git branch --show-current
git remote -v
```

Debes comprobar que:

- la rama actual sea `main`;
- `origin` apunte a `https://github.com/lushiban/Programacion_asistida_de_apps`;
- los cambios mostrados correspondan a los archivos que deseas publicar.

## 4. Seleccionar únicamente esta aplicación

Desde la raíz `Programacion_asistida_de_apps`, usa:

```powershell
git add -- flutter_application_1
```

Esto selecciona los cambios de esta aplicación, pero no los cambios de otras carpetas vecinas.

Si deseas seleccionar archivos concretos, indica cada ruta:

```powershell
git add -- flutter_application_1/docs/RUTA_DE_ESTUDIO_DEL_PROYECTO.md
git add -- flutter_application_1/docs/RUTA_PARA_SUBIR_A_GITHUB.md
```

## 5. Revisar antes de crear el commit

```powershell
git status
git diff --cached
```

`git status` muestra qué archivos están seleccionados. `git diff --cached` muestra el contenido exacto que formará parte del siguiente commit.

Si aparece un archivo que no querías seleccionar, puedes retirarlo del área de preparación sin borrar su contenido:

```powershell
git restore --staged -- ruta/del/archivo
```

## 6. Crear el commit

Un commit representa una versión identificable del trabajo. Utiliza un mensaje corto que explique el propósito del cambio:

```powershell
git commit -m "docs: agregar rutas de estudio y publicación"
```

Crear el commit todavía no publica nada en internet; guarda la versión en el repositorio local.

## 7. Subir a GitHub

```powershell
git push origin main
```

- `origin` es el nombre local del repositorio remoto.
- `main` es la rama que se enviará.

Después de finalizar, visita:

`https://github.com/lushiban/Programacion_asistida_de_apps/tree/main/flutter_application_1`

## 8. Ruta corta para futuras actualizaciones

Para próximos cambios, el proceso habitual será:

```powershell
git status
git add -- flutter_application_1
git diff --cached
git commit -m "Descripción breve del cambio"
git push origin main
```

No uses `git add .` sin revisar dónde estás ubicado, porque la raíz del repositorio contiene más proyectos y podrías incluir cambios que no pertenecen a esta aplicación.

## 9. Si GitHub tiene cambios más recientes

Si `git push` indica que la rama remota contiene trabajo nuevo, primero revisa e integra esos cambios:

```powershell
git pull --rebase origin main
git push origin main
```

Si aparece un conflicto, no continúes a ciegas. Revisa los archivos marcados, decide qué contenido conservar y vuelve a comprobar la aplicación antes de completar la publicación.

## 10. Si GitHub solicita autenticación

GitHub ya no acepta la contraseña normal de la cuenta para operaciones Git por HTTPS. Normalmente debes iniciar sesión mediante el administrador de credenciales instalado con Git o utilizar un token personal cuando el sistema lo solicite.

No guardes tokens, contraseñas ni otras credenciales dentro del proyecto o de sus archivos de configuración versionados.

## 11. Comprobación final

Después de subir, ejecuta:

```powershell
git status
git log -1 --oneline
```

El resultado esperado es que la rama esté sincronizada y que el commit más reciente sea el que acabas de publicar. Finalmente, abre el repositorio en GitHub y verifica que los archivos aparezcan dentro de `flutter_application_1`.
