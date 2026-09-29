
**Programación Asistida de Aplicaciones — USFQ**

## Qué vamos a construir

Una aplicación Flutter con **dos pantallas**:

```text
Pantalla 1                        Pantalla 2
Ingresar / Crear cuenta    →      Usuarios registrados

[ correo          ]               Ana
[ contraseña      ]               Luis
[ nombre          ]               María
[ Crear cuenta ]                  …
[ Ingresar ]
```

Las cuentas se guardan en **Supabase**, no en el teléfono. Cualquier compañero que se
registre aparece en la lista de todos los demás.

Al final agregamos un **endpoint en FastAPI** que también crea usuarios en la misma base,
para ver que el teléfono no es el único que puede escribir ahí.

El código lo genera la IA. El trabajo del estudiante es dirigirla, entender el resultado y
justificar dónde va cada pieza.

---

## Antes de entrar a clase

- Crear una cuenta gratuita en [supabase.com](https://supabase.com) (sirve entrar con GitHub).
- Tener Flutter funcionando y un proyecto nuevo creado.
- Tener Python 3 instalado (para la última parte).

> Crear el proyecto de Supabase toma varios minutos mientras se levanta la base.
> Si llegas sin eso listo, pierdes media clase esperando.

---

# Parte 1 · Crear el proyecto en Supabase

### 1.1 · La cuenta

1. Entrar a **supabase.com** → **Start your project**.
2. Iniciar sesión con GitHub (o con correo).

### 1.2 · La organización y el proyecto

3. **New project**.
4. Si es la primera vez, pide crear una **organización**: cualquier nombre, plan **Free**.
5. Llenar:

| Campo | Qué poner |
|---|---|
| **Name** | `usuarios-usfq` |
| **Database Password** | una contraseña cualquiera — **cópiala a un lado** |
| **Region** | `South America (São Paulo)` |

6. **Create new project** y esperar 1–2 minutos.

> La **Database Password** no es la clave que usará la app. Es la contraseña del motor
> PostgreSQL, por si algún día te conectas con un cliente SQL. La app usa otra cosa.

### 1.3 · Desactivar la confirmación por correo

Por defecto Supabase manda un correo de confirmación antes de activar la cuenta. En clase
eso nos frena, así que lo apagamos:

7. Menú lateral → **Authentication** → **Sign In / Providers** → **Email**.
8. Desactivar **Confirm email** → **Save**.

> En una app real esto se deja activado. Lo apagamos solo para la práctica.

**Responder:**

> **1.** ¿Dónde están guardados ahora los datos de tu aplicación y qué implica eso para un
> usuario que abra la app desde otro teléfono?

---

# Parte 2 · Las dos claves

Ir a **Settings** (el engranaje) → **API Keys**.

Vas a ver dos claves. Según cuándo se creó tu proyecto aparecen con nombres nuevos o
antiguos — **son equivalentes**:

| Para qué sirve | Nombre nuevo | Nombre antiguo |
|---|---|---|
| Para el cliente (la app) | `sb_publishable_…` | `anon` `public` |
| Para el servidor | `sb_secret_…` | `service_role` `secret` |

### La diferencia, que es el punto de toda esta parte

**La clave publicable / anon** está *diseñada* para viajar dentro de la app. Se compila
dentro del `.apk` que instalas en el teléfono, así que cualquiera con ese archivo puede
extraerla. No es un secreto y no pretende serlo. Lo que protege tus datos no es esconderla:
son las **políticas RLS** que vamos a escribir en la Parte 4.

**La clave secreta / service_role** es otra cosa. **Ignora todas las políticas RLS** y puede
leer, modificar y borrar cualquier fila de cualquier tabla, además de crear y eliminar
usuarios. Si alguien la obtiene, tiene tu base entera.

```text
sb_publishable_…   →   app Flutter        ✓   (protegida con RLS)
sb_secret_…        →   app Flutter        ✗   NUNCA
sb_secret_…        →   servidor FastAPI   ✓
```

Copia las dos a un bloc de notas. Las vas a necesitar en dos lugares distintos.

**Responder:**

> **2.** ¿Por qué la clave publicable puede ir dentro de la app y la secreta no, si las dos
> son cadenas de texto? ¿Qué puede hacer la secreta que la publicable no?

---

# Parte 3 · Variables de entorno y `.gitignore`

No vamos a escribir las claves dentro del código.

### 3.1 · El archivo `.env`

En la raíz del proyecto Flutter, crear un archivo llamado **`.env`**:

```bash
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_KEY=sb_publishable_xxxxxxxxxxxxxxxx
```

La `SUPABASE_URL` está en la misma pantalla **Settings → API**.

> Aquí va **solo la clave publicable**. La secreta no entra nunca en el proyecto Flutter.

### 3.2 · `.gitignore`

Abrir `.gitignore` y agregar al final:

```bash
# configuración local
.env
.env.*
```

### 3.3 · Comprobar que funcionó

```bash
git status
```

El `.env` **no** debe aparecer en la lista. Si aparece, algo quedó mal escrito.

> **Ojo con la falsa sensación de seguridad.** El `.gitignore` evita que el archivo suba al
> repositorio. No convierte la clave en un secreto: la app compilada la lleva adentro de
> todos modos. Por eso la clave que ponemos ahí es la publicable, y la protección real la
> pone RLS.

**Responder:**

> **3.** Si un compañero clona tu repositorio, ¿qué le falta para que la app funcione y por
> qué está bien que le falte? ¿Qué tendrías que hacer si por error subes el `.env` y luego lo
> borras en otro commit?

---

# Parte 4 · La tabla de perfiles y las políticas

Supabase ya trae una tabla interna de usuarios (`auth.users`) que guarda correos y
contraseñas **cifradas**. Nosotros nunca la tocamos directamente y **nunca guardamos
contraseñas por nuestra cuenta**.

Lo que sí creamos es una tabla con los datos públicos que queremos mostrar.

### 4.1 · Crear la tabla

Ir a **SQL Editor** → **New query**, pegar esto y darle **Run**:

```sql
create table perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  creado_en timestamptz default now()
);
```

### 4.2 · Activar RLS y escribir las políticas

En el mismo editor, otra consulta:

```sql
alter table perfiles enable row level security;

create policy "cualquiera autenticado ve los perfiles"
on perfiles for select
to authenticated
using (true);

create policy "cada quien crea solo su perfil"
on perfiles for insert
to authenticated
with check (auth.uid() = id);
```

Traducido:

- **Leer:** cualquiera que haya iniciado sesión ve todos los perfiles. Por eso la Pantalla 2
  va a funcionar.
- **Insertar:** solo puedes crear la fila cuyo `id` coincide con **tu** sesión. No puedes
  inventar perfiles ajenos.

> Esto es lo que hace que la clave publicable sea segura: aunque alguien la extraiga del
> `.apk`, sigue chocando contra estas reglas.

**Responder:**

> **4.** Con estas políticas activas, ¿qué pasaría si alguien saca la clave publicable de tu
> app e intenta borrar los perfiles de los demás?

---

# Cómo trabajar de aquí en adelante

De la Parte 5 a la 8 **tú no escribes código**. Lo escribe el agente.

Cada sección tiene dos bloques:

- **Qué vamos a hacer y por qué** — léelo antes de pedir nada. Si no entiendes esto, no vas
  a poder revisar lo que te devuelva el agente.
- **▶ Pídeselo al agente** — un bloque listo para copiar y pegar tal cual.

Después de cada prompt hay un **Verifica** con lo que debe cumplirse. Si no se cumple, no
sigas: corrígelo con el agente antes de avanzar.

> Pide **un bloque por vez** y revisa el resultado antes del siguiente. Si pegas los cuatro
> juntos, el código sale igual pero no vas a poder explicar ninguna decisión — y eso es
> justo lo que se evalúa.

---

# Parte 5 · Conectar Flutter y armar el esqueleto

### 5.1 · Dependencias

```bash
flutter pub add supabase_flutter flutter_dotenv provider
```

### 5.2 · Declarar el `.env` como asset 

En `pubspec.yaml`, dentro de `flutter:`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
```

### 5.3 · La arquitectura que vamos a usar

La misma de la Semana 5: **tres capas y una sola dirección de dependencias.**

```text
presentation  ──►  domain  ◄──  data
```

| Capa | Qué va aquí | Qué NO puede importar |
|---|---|---|
| `domain` | las entidades y los **contratos** (clases abstractas) | `supabase_flutter`, `flutter`, `provider` |
| `data` | las implementaciones que hablan con Supabase | — |
| `presentation` | los providers y las pantallas | `supabase_flutter` |

La regla que importa: **la pantalla nunca sabe que existe Supabase.** Si mañana cambiamos
Supabase por otra cosa, `presentation` no se toca.

### ▶ Pídeselo al agente

```text
Voy a construir una app Flutter con arquitectura limpia en tres capas:
domain, data y presentation. La dirección de dependencias es
presentation -> domain <- data.

Haz dos cosas:

1) Crea esta estructura de carpetas vacías dentro de lib/:
   domain/entities
   domain/repositories
   domain/usecases
   data/repositories
   presentation/providers
   presentation/pantallas

2) En main.dart, antes de runApp:
   - WidgetsFlutterBinding.ensureInitialized()
   - carga el archivo .env con flutter_dotenv
   - inicializa Supabase leyendo SUPABASE_URL y SUPABASE_KEY del .env
   Deja runApp con un MaterialApp y un Scaffold vacio por ahora.

Regla que debes respetar en todo el proyecto: ningun archivo dentro de
domain/ puede importar supabase_flutter, flutter ni provider.
```

### Verifica

- La app arranca sin errores de conexión.
- Las carpetas existen.

---

# Parte 6 · El dominio, los datos y el estado

Aquí está el grueso de la arquitectura. Vamos en tres pedidos.

### 6.1 · Domain y data

El `domain` define **qué se puede hacer** sin decir cómo: una entidad `Perfil` y dos
contratos abstractos. El `data` los implementa usando Supabase.

**Sobre el caso de uso.** Registrar un usuario son en realidad **dos operaciones**: crear la
cuenta en el sistema de autenticación y después crear su fila en `perfiles`. Esa
orquestación no es acceso a datos ni es interfaz: es una regla del negocio. Por eso va en un
caso de uso. Entrar, salir y listar son operaciones sueltas, así que el provider llama al
repositorio directamente.

> Arquitectura limpia no significa envolver todo en una clase. Significa poner cada cosa
> donde le toca.

### ▶ Pídeselo al agente

```text
Sigue con la arquitectura limpia. Crea estos archivos:

1) lib/domain/entities/perfil.dart
   class Perfil con: final String id, final String nombre, final DateTime creadoEn.
   Constructor const. Sin ninguna dependencia externa.

2) lib/domain/repositories/auth_repository.dart  (clase ABSTRACTA)
   Future<String> registrar(String correo, String clave);   // devuelve el id del usuario
   Future<void> ingresar(String correo, String clave);
   Future<void> salir();
   String? obtenerIdActual();

3) lib/domain/repositories/perfiles_repository.dart  (clase ABSTRACTA)
   Future<void> crear(String id, String nombre);
   Future<List<Perfil>> obtenerTodos();

4) lib/domain/usecases/registrar_usuario.dart
   class RegistrarUsuario que reciba AuthRepository y PerfilesRepository por
   constructor. Su metodo call(String correo, String clave, String nombre)
   primero registra la cuenta, obtiene el id devuelto, y con ese id crea el
   perfil. Si el segundo paso falla, propaga el error.

5) lib/data/repositories/supabase_auth_repository.dart
   implements AuthRepository usando Supabase.instance.client.auth
   (signUp, signInWithPassword, signOut, currentUser).

6) lib/data/repositories/supabase_perfiles_repository.dart
   implements PerfilesRepository usando
   Supabase.instance.client.from('perfiles') con select() e insert().
   Convierte los Map que devuelve Supabase en objetos Perfil.

Recuerda: domain/ no importa supabase_flutter ni flutter.
```

### Verifica

Abre los archivos de `domain/` y mira **solo los imports de arriba**. Si aparece
`supabase_flutter`, la arquitectura está mal aunque el código funcione. Dile al agente que
lo corrija.

### 6.2 · Los dos administradores de estado

Dos `ChangeNotifier`, cada uno con **una sola responsabilidad**: uno se ocupa de la sesión,
otro de la lista. Ninguno de los dos toca Supabase: hablan con los contratos del `domain`.

### ▶ Pídeselo al agente

```text
Ahora la capa presentation. Crea dos ChangeNotifier en
lib/presentation/providers/. Ninguno de los dos puede importar supabase_flutter:
solo conocen las interfaces de domain/.

1) sesion_provider.dart -> class SesionProvider extends ChangeNotifier
   Recibe por constructor: AuthRepository y RegistrarUsuario.
   Estado: String? idUsuario, bool cargando, String? error.
   Metodos:
     Future<void> registrar(String correo, String clave, String nombre)
     Future<void> ingresar(String correo, String clave)
     Future<void> salir()
   En cada uno: pon cargando=true y error=null, llama a notifyListeners(),
   ejecuta la operacion dentro de try/catch, guarda el mensaje en error si
   falla, pon cargando=false y vuelve a llamar a notifyListeners().

2) perfiles_provider.dart -> class PerfilesProvider extends ChangeNotifier
   Recibe PerfilesRepository por constructor.
   Estado: List<Perfil> perfiles, bool cargando, String? error.
   Metodo Future<void> cargar() con el mismo patron de cargando/error.
```

### 6.3 · Armar las dependencias en `main.dart`

Este es el único lugar del proyecto donde se nombran las clases concretas. Es el **punto de
composición**: aquí se decide que la implementación es Supabase. Si mañana fuera otra, solo
se cambia este archivo.

### ▶ Pídeselo al agente

```text
En main.dart, dentro de main() y despues de inicializar Supabase, compon las
dependencias:

  final authRepo = SupabaseAuthRepository();
  final perfilesRepo = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepo, perfilesRepo);

Envuelve la app en un MultiProvider con dos ChangeNotifierProvider:
SesionProvider(authRepo, registrarUsuario) y PerfilesProvider(perfilesRepo).

Este debe ser el UNICO archivo del proyecto que menciona las clases
SupabaseAuthRepository y SupabasePerfilesRepository.
```

**Responder:**

> **5.** ¿Por qué conviene que la sesión y la lista de perfiles sean dos clases separadas y no
> una sola con todo adentro? ¿Y por qué las implementaciones concretas se nombran solo en
> `main.dart`?

---

# Parte 7 · Pantalla 1 — Ingresar o crear cuenta

Tres campos y dos botones. Lo importante aquí es **dónde va `watch` y dónde va `read`**:

- `context.watch<SesionProvider>()` dentro del `build`, para redibujar cuando cambie
  `cargando` o `error`.
- `context.read<SesionProvider>()` dentro del `onPressed`, para disparar la acción sin
  suscribirse.

### ▶ Pídeselo al agente

```text
Crea lib/presentation/pantallas/pantalla_ingreso.dart.

Un StatefulWidget con tres TextEditingController: correo, clave y nombre.
El campo de clave con obscureText: true.

Dos botones:
  "Ingresar"     -> context.read<SesionProvider>().ingresar(correo, clave)
  "Crear cuenta" -> context.read<SesionProvider>().registrar(correo, clave, nombre)

En el build usa context.watch<SesionProvider>() para:
  - mostrar un CircularProgressIndicator y deshabilitar los botones mientras
    cargando sea true
  - mostrar el texto de error en rojo si error no es null

Cuando idUsuario deje de ser null, navega a PantallaUsuarios con
Navigator.pushReplacement.

Esta pantalla NO puede importar supabase_flutter.
```

### Verifica — pruébalo antes de seguir

1. Crear una cuenta con tu correo.
2. Cerrar sesión y volver a entrar con la misma.
3. Entrar con una contraseña equivocada y ver el mensaje de error.

**Responder:**

> **6.** ¿Dónde quedó guardada la contraseña que escribiste? Revisa **Authentication →
> Users** en Supabase y luego **Table Editor → perfiles**. ¿Qué ves en cada lugar y por qué
> es importante que sea así?

---

# Parte 8 · Pantalla 2 — Los usuarios registrados

La lista de todos los perfiles. Se carga una vez al entrar y se puede recargar a mano.

### ▶ Pídeselo al agente

```text
Crea lib/presentation/pantallas/pantalla_usuarios.dart.

Un StatefulWidget que en initState llame a
context.read<PerfilesProvider>().cargar()
(usa WidgetsBinding.instance.addPostFrameCallback para no llamarlo
durante el build).

En el build, con context.watch<PerfilesProvider>():
  - CircularProgressIndicator si cargando
  - el error en rojo si existe
  - si no, un ListView.builder con un ListTile por cada Perfil, mostrando el
    nombre como titulo y la fecha creadoEn como subtitulo

En el AppBar: un IconButton de recargar que llame a cargar(), y otro de
cerrar sesion que llame a context.read<SesionProvider>().salir() y vuelva a
PantallaIngreso.

Esta pantalla NO puede importar supabase_flutter.
```

### El momento de la clase

Ponte de acuerdo con un compañero: **que él cree una cuenta ahora**. Toca recargar en tu
pantalla. Su nombre aparece en tu teléfono.

> Eso es lo que no podía hacer SQLite: los datos son compartidos, no tuyos.

### La prueba de que la arquitectura quedó bien

Busca `supabase` en todo el proyecto (`Ctrl+Shift+F` en VS Code).

Solo debe aparecer en:

```text
lib/data/repositories/…      las dos implementaciones
lib/main.dart                la inicialización y la composición
```

Si aparece en `presentation/` o en `domain/`, algo se filtró. Es el error más común y el más
fácil de pasar por alto, porque **la app funciona igual**.

---

# Parte 9 · Crear usuarios desde FastAPI

Ahora la parte que muestra para qué sirve la **otra** clave.

### 9.1 · Una carpeta aparte

Fuera del proyecto Flutter:

```bash
mkdir api_usuarios
cd api_usuarios
pip install fastapi uvicorn supabase python-dotenv
```

### 9.2 · Su propio `.env`

Crear `api_usuarios/.env` — **este sí lleva la clave secreta**:

```bash
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_SECRET=sb_secret_xxxxxxxxxxxxxxxx
```

Y un `.gitignore` en esa carpeta con `.env` adentro.

### 9.3 · El endpoint

Crear `api_usuarios/main.py`:

```python
import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

# clave secreta: esto NUNCA iría dentro de la app Flutter
supabase = create_client(os.environ["SUPABASE_URL"], os.environ["SUPABASE_SECRET"])

app = FastAPI()


class NuevoUsuario(BaseModel):
    correo: str
    clave: str
    nombre: str


@app.post("/usuarios")
def crear_usuario(u: NuevoUsuario):
    try:
        r = supabase.auth.admin.create_user({
            "email": u.correo,
            "password": u.clave,
            "email_confirm": True,
        })
        supabase.table("perfiles").insert({"id": r.user.id, "nombre": u.nombre}).execute()
        return {"ok": True, "id": r.user.id}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
```

### 9.4 · Levantarlo y probarlo

```bash
uvicorn main:app --reload
```

Abrir **http://127.0.0.1:8000/docs**, desplegar `POST /usuarios`, **Try it out** y enviar:

```json
{ "correo": "robot@usfq.edu.ec", "clave": "123456", "nombre": "Robot FastAPI" }
```

Volver a la app Flutter y recargar la Pantalla 2: **Robot FastAPI está en la lista.**

### 9.5 · El experimento que cierra la idea

En `api_usuarios/.env`, cambia temporalmente la clave secreta por la **publicable** y vuelve
a intentar el endpoint.

Falla. `auth.admin.create_user` solo existe para la clave secreta.

Devuelve la clave secreta a su lugar.

**Responder:**

> **7.** ¿Por qué el servidor puede crear usuarios y la app no? Si quisieras que la app
> pudiera hacerlo, ¿pondrías la clave secreta en Flutter o llamarías a este endpoint? Explica
> qué ganas y qué pierdes con cada opción.

---

# Cierre

```bash
git add .
git commit -m "feat: registro e ingreso con Supabase, lista de usuarios con Provider"
```

Verificar en GitHub que **ningún `.env` subió**.

---

## Estructura esperada

```text
mi_app/
├── lib/
│   ├── domain/                              ← no conoce Supabase ni Flutter
│   │   ├── entities/perfil.dart
│   │   ├── repositories/auth_repository.dart          (abstracto)
│   │   ├── repositories/perfiles_repository.dart      (abstracto)
│   │   └── usecases/registrar_usuario.dart
│   ├── data/                                ← aquí y solo aquí vive Supabase
│   │   └── repositories/
│   │       ├── supabase_auth_repository.dart
│   │       └── supabase_perfiles_repository.dart
│   ├── presentation/                        ← no conoce Supabase
│   │   ├── providers/sesion_provider.dart
│   │   ├── providers/perfiles_provider.dart
│   │   └── pantallas/
│   │       ├── pantalla_ingreso.dart
│   │       └── pantalla_usuarios.dart
│   └── main.dart                            ← composición de dependencias
├── .env                                     (clave PUBLICABLE)
└── .gitignore

api_usuarios/
├── main.py
├── .env                                     (clave SECRETA)
└── .gitignore
```

### Verificación por imports

Es el chequeo más rápido, el mismo de la Semana 5:

| Archivo | NO debe importar |
|---|---|
| `domain/*` | `supabase_flutter`, `flutter`, `provider` |
| `presentation/*` | `supabase_flutter` |
| `data/*` | — (aquí sí va) |
| `main.dart` | — (es el único que nombra las clases concretas) |

## El recorrido completo

```text
Flutter  ──clave publicable──►  Supabase  ──►  RLS  ──►  datos permitidos
FastAPI  ──clave secreta────►  Supabase  ──►  (sin RLS: acceso total)
```

---

## Criterios de evaluación

| Criterio | Puntos | Cómo se verifica |
|---|---:|---|
| Proyecto creado, tabla `perfiles` con RLS y las dos políticas funcionando | 2 | se registra un usuario y aparece en la tabla |
| Las dos pantallas funcionan: registro, ingreso y lista de usuarios reales | 2 | en el emulador |
| **Arquitectura limpia**: `domain` sin Supabase, `presentation` sin Supabase, composición en `main.dart` | 2 | lectura de imports · búsqueda de `supabase` |
| `Provider`: dos clases de estado separadas, `watch` en `build` y `read` en `onPressed` | 1 | lectura del código |
| Endpoint de FastAPI creando un usuario que aparece en la app | 1 | demostración en vivo |
| Respuestas 2, 3, 5 y 7 con criterio propio, no copiadas del agente | 2 | las respuestas |
| **Total** | **10** | |

> **Descuento automático:** si algún `.env` aparece en el repositorio, la entrega pierde 2
> puntos aunque todo lo demás funcione.

---

## Si algo no funciona

| Síntoma | Causa más común |
|---|---|
| La app arranca pero no conecta | `.env` no declarado en `assets:` del `pubspec.yaml` |
| El registro dice que falta confirmar el correo | Quedó activado **Confirm email** en Authentication |
| La Pantalla 2 sale vacía sin error | Falta la política de `select` en `perfiles` |
| Falla al crear el perfil tras registrarse | Falta la política de `insert`, o el `id` no es el del usuario |
| El endpoint responde 401 o "not allowed" | En el `.env` de FastAPI quedó la clave publicable |
| `setState() or markNeedsBuild() called during build` | El `cargar()` se llamó directo en `initState` sin `addPostFrameCallback` |
| Todo funciona pero `supabase` aparece en `presentation/` | El agente tomó el atajo: pídele que lo mueva a `data/` y use el contrato |
