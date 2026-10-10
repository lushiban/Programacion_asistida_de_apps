
## Vibe coding vs. SDD con GitHub Spec Kit

**Programación Asistida de Aplicaciones · USFQ**
Prof. Jose David Vega Sánchez

---

## De qué se trata

Vas a construir **la misma app dos veces**, en dos ramas distintas:

```text
rama vibe  →  le pides la app en una frase        →  lo que salga
rama sdd   →  constitution → specify → clarify →
              plan → tasks → analyze → implement   →  el agente deriva el código
```

### ¿Qué llamaremos "vibe coding" aquí?

En esta práctica usaremos **vibe coding** para describir un desarrollo guiado principalmente
por conversación: se parte de una intención general, el agente genera código y el estudiante
va corrigiendo sobre la marcha. No significa que todo vibe coding consista en un único
prompt; aquí lo usamos como una forma deliberadamente poco estructurada de iniciar el
desarrollo y compararla con SDD.

### Nota metodológica

Esta práctica **no pretende ser un benchmark científico ni demostrar causalmente que una
metodología es mejor que la otra**. La rama `vibe` comienza deliberadamente con una intención
mínima y el estudiante corrige sobre la marcha. La rama `sdd` externaliza requisitos,
decisiones y restricciones en artefactos antes de implementar. Observaremos qué decisiones
debe completar el agente cuando trabaja principalmente desde la conversación y cuáles quedan
explícitas al usar SDD.

### Pregunta guía

Observa qué ocurrió en tu ejecución y justifícalo con evidencia: ¿qué cambia cuando pasas de
pedir código sobre la marcha a estructurar primero requisitos, reglas, plan y pruebas?

El flujo de la actividad es:

```text
MISMO COMMIT INICIAL
        │
        ├────────────────────┐
        ↓                    ↓
      VIBE                  SDD
        │                    │
intención mínima       constitution
        │              specify → clarify
conversación           plan → tasks → analyze
        │              implement → converge*
correcciones           código
        ↓                    ↓
      código               código
        └──────────┬─────────┘
                   ↓
             MISMAS MÉTRICAS
                   ↓
        PRUEBAS / VERIFICACIONES
                   ↓
        COMPARACIÓN Y MANTENIBILIDAD
```

\* Ejecuta `/speckit-converge` si tu versión lo ofrece.

> **La app:** un **divisor de cuenta**. Una pantalla: monto total, número de personas,
> porcentaje de propina → cuánto paga cada uno. Nada más.

### MVP: producto mínimo viable

Un **MVP** (*Minimum Viable Product*, o **producto mínimo viable**) es la versión más
pequeña de un producto que ya permite a sus usuarios resolver su necesidad principal y
obtener retroalimentación. “Mínimo” se refiere al alcance: no significa que deba estar roto,
ser difícil de usar o carecer de calidad.

En esta práctica, el MVP es el divisor de cuenta de una sola pantalla: permite ingresar el
monto, el número de personas y la propina, y muestra cuánto paga cada persona. Mantendremos
ese alcance acotado para comparar cómo se construye la misma funcionalidad con `vibe` y con
SDD, sin añadir funciones que distraigan del objetivo de aprendizaje.

En la rama `sdd` no vas a escribir la especificación a mano: vas a usar **GitHub Spec
Kit**, y las reglas de SOLID y arquitectura limpia (lo de la semana pasada) van a vivir
en la **Constitution**. Al final vas a poder **demostrar con comandos** que se cumplieron.

---

## Antes de empezar

- Flutter funcionando (`flutter doctor` sin errores rojos).
- Git configurado.
- **Visual Studio Code**.
- **Python 3.11+** (uv lo instalamos en la Parte 4).
- Tu agente de código instalado y andando.

Crea una hoja (o un `bitacora.md`) con esta tabla vacía (la puedes pedir a tu agente). Llénala a medida que avanzas. La comparación principal se centra en cumplimiento, iteraciones, estructura y mantenibilidad:

| | rama vibe | rama sdd |
|---|---|---|
| Iteraciones (veces que le tuviste que volver a pedir algo) | | |
| Casos de aceptación que cumple (0–6) | | |
| Pruebas automatizadas que pasan | | |
| Archivos en `lib/` | | |
| Líneas de código en `lib/` | | |
| ¿`domain/` depende de Flutter? | | |
| ¿Existe separación `presentation/domain/data`? | | |
| ¿El agente agregó algo que nadie pidió? | | |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | | |

El tiempo es opcional y secundario. Si decides registrarlo, usa solo el **tiempo aproximado
hasta cumplir los seis escenarios**; no necesitas cronómetro. El tiempo puede depender del
equipo, la conexión, la experiencia previa, la configuración y las interrupciones, así que
no es una medida directa de calidad.

| Métrica secundaria opcional | rama vibe | rama sdd |
|---|---:|---:|
| Tiempo aproximado hasta cumplir los 6 escenarios | | |

### Qué cuenta como una iteración

El prompt o solicitud inicial para empezar el trabajo de cada rama no cuenta. Una iteración
es cada nuevo mensaje que envías al agente después de esa solicitud para pedir una corrección,
cambio, explicación o acción adicional. Las herramientas que el agente ejecute por su cuenta
no cuentan. Aplica la misma regla en las dos ramas y anota cualquier decisión de conteo que
pueda afectar la comparación.

```text
Solicitud inicial                     → no cuenta
"Falta la propina"                    → iteración 1
"Corrige este error"                  → iteración 2
"Ahora agrega validación"             → iteración 3
```

---

## Parte 1 — Crear el proyecto (dónde se escriben estos comandos)

Esta es la duda más común, así que va paso por paso.

### 1.1 Abre una terminal en la carpeta donde guardas tus proyectos

`flutter create` **crea una carpeta nueva**, así que hay que ejecutarlo *un nivel arriba*
de donde vivirá el proyecto. No lo corras dentro de otro proyecto de Flutter.

**Opción A — Terminal de Windows / macOS:**

```bash
cd C:\Users\TU_USUARIO\Documents\USFQ     # Windows
cd ~/Documents/USFQ                       # macOS o Linux
```

**Opción B — Terminal integrada de VS Code:**

1. Abre VS Code.
2. **File → Open Folder…** y elige tu carpeta de proyectos (`Documents/USFQ`).
3. Abre la terminal integrada: **Ctrl + Ñ** (Windows, teclado español) o
   **Ctrl + `** / **Cmd + `**. También por menú: **Terminal → New Terminal**.
4. La terminal ya está parada en esa carpeta.

### 1.2 Crea el proyecto

```bash
flutter create divisor_cuenta
```

### 1.3 Ahora sí, abre **la carpeta del proyecto** en VS Code

**File → Open Folder… → `divisor_cuenta`**

No abras la carpeta padre. Si el agente no está parado dentro de `divisor_cuenta`, no va
a encontrar ni tu archivo de instrucciones ni los artefactos de Spec Kit.

### 1.4 Verifica que estás parado en el lugar correcto

Abre la terminal integrada otra vez (**Ctrl + Ñ**) y corre:

```bash
pwd          # debe terminar en /divisor_cuenta  (en PowerShell también funciona)
ls           # debes ver: lib/  test/  pubspec.yaml  android/  ios/
```

Si ves `pubspec.yaml`, estás adentro. Todo lo que sigue —git, uv, Spec Kit, el agente,
las pruebas— se corre **desde esta terminal**.

### 1.5 Git: primero averigua si ya estás dentro de un repositorio

⚠️ **No corras `git init` a ciegas.** Si tu carpeta de proyectos (`Documents/USFQ`) ya es
un repositorio de git, hacerlo de nuevo puede dejarte con repositorios anidados y ramas
que afectan a todos tus proyectos. Primero mira dónde estás parado:

```bash
git rev-parse --show-toplevel
```

**Caso A — da error** (*"not a git repository"*): no hay ningún repositorio. Inicializa
uno aquí:

```bash
git init
```

**Caso B — devuelve la ruta de `divisor_cuenta`**: este proyecto ya tiene su propio
repositorio. **No hagas `git init`**, pasa directo al commit inicial.

**Caso C — devuelve una ruta de más arriba** (tu carpeta general ya es un repositorio).
Esto es lo más común si guardas todas tus prácticas en un mismo repo. Tienes dos caminos:

- **Recomendado para esta práctica:** dale a este proyecto su propio repositorio, para
  que las ramas `vibe` y `sdd` no toquen tus otros trabajos.

  ```bash
  git init                              # dentro de divisor_cuenta
  ```

  Y en el `.gitignore` de la carpeta de arriba agrega una línea con `divisor_cuenta/`
  para que los dos repositorios no se mezclen.

- **Alternativa:** trabajar en el repositorio de arriba. Funciona, pero las ramas `vibe`
  y `sdd` van a afectar a **todo** lo que tengas ahí. No lo recomiendo para este
  laboratorio.

Anota en tu bitácora **cuál de los tres casos te tocó**.

### 1.6 El commit inicial y las dos ramas

Antes del commit, asegúrate de que la rama actual se llame `main`. Esto también aplica si
el proyecto ya tenía un repositorio:

```bash
git branch -M main
```

```bash
git add .
git commit -m "proyecto base de flutter, sin tocar"
git branch vibe
git branch sdd
```

Las dos ramas salen del **mismo commit**. Eso es lo que hace justa la comparación.

**Verifica:** `git log --oneline --all` muestra un solo commit y `git branch` lista
`main`, `sdd` y `vibe`.

> **El agente también se abre aquí.** Sea cual sea tu agente, ábrelo desde la terminal
> integrada **dentro de `divisor_cuenta/`**.

---

## Parte 2 — Rama vibe: una sola frase

```bash
git checkout vibe
```

Abre el agente en esta carpeta y dale **exactamente esto**, sin agregar nada:

### ▶ Pídeselo al agente

```text
Hazme una app en Flutter para dividir la cuenta entre varias personas.
```

Eso es todo. **No le des más contexto.**

A partir de ahí puedes pedirle arreglos las veces que haga falta hasta que la app haga lo
que **tú** tenías en la cabeza cuando escribiste esa frase. Cada nuevo mensaje para pedir
una corrección, cambio, explicación o acción adicional cuenta como iteración según la regla
de la bitácora. Las acciones autónomas del agente no cuentan.

Cuando te des por satisfecho:

```bash
flutter analyze
git add . && git commit -m "app divisor de cuenta - rama vibe"
```

**Verifica:** anota las iteraciones y completa las métricas. Si optaste por registrar el
tiempo aproximado hasta cumplir los seis escenarios, anótalo como dato secundario. Usa la
misma regla de conteo de iteraciones definida al inicio:

```bash
# macOS / Linux
find lib -name "*.dart" | wc -l
find lib -name "*.dart" -exec cat {} + | wc -l

# Windows PowerShell
(Get-ChildItem lib -Recurse -Filter *.dart).Count
(Get-ChildItem lib -Recurse -Filter *.dart | Get-Content).Count
```

---

## Parte 3 — El archivo de instrucciones del agente

```bash
git checkout sdd
```

### 3.1 Primero: identifica cuál es **tu** agente

El archivo de instrucciones se llama distinto según el proveedor, así que el primer paso
es saber cuál tienes instalado. En la terminal, prueba estos comandos — el que responda
con una versión es el tuyo:

```bash
claude --version
codex --version
gemini --version
copilot --version
```

Si usas un agente integrado en el editor (Cursor, Cline, Windsurf…), no hay comando: el
archivo de reglas está en la configuración del propio editor.

Con eso ya sabes qué archivo crear:

| Si tu agente es… | Crea este archivo |
|---|---|
| Codex (OpenAI) | `AGENTS.md` |
| Claude Code (Anthropic) | `CLAUDE.md` |
| Gemini CLI (Google) | `GEMINI.md` |
| GitHub Copilot CLI | `AGENTS.md` |
| Cursor / Cline / Windsurf | `.cursor/rules`, `.clinerules`, según el editor |

> **Crea uno solo: el que lee tu agente.** No crees los cinco. Si tu agente lee
> `CLAUDE.md`, todo el contenido va en `CLAUDE.md` y ya está. El nombre cambia; el
> contenido y la función son exactamente los mismos.
>
> Anota en tu entrega **qué agente, modelo y nivel de razonamiento/configuración usaste**.
> Usa el mismo agente, modelo y, si existe la opción, el mismo nivel de razonamiento en
> ambas ramas. No cambies de modelo entre `vibe` y `sdd`, porque entonces estarías comparando
> la metodología y la capacidad del modelo al mismo tiempo.

### 3.2 Nota: también existe uno "general"

En clase vimos que, si guardas varios proyectos dentro de una misma carpeta, puedes poner
además un archivo de instrucciones **arriba**, con las reglas que valen para todos tus
proyectos.

**En esta práctica no lo vamos a usar.** Con uno solo, el del proyecto, es suficiente.

### 3.3 Genera el archivo

### ▶ Pídeselo al agente

```text
Genera tu archivo de instrucciones en la raíz de este proyecto (usa el nombre
que tú lees: AGENTS.md, CLAUDE.md o el que corresponda), en lenguaje natural
y breve, con:

- Descripción: app Flutter de una sola pantalla para dividir una cuenta.
- Estructura: lib/presentation, lib/domain, lib/data.
  Regla de dependencia: presentation -> domain <- data.
  domain NO importa nada de package:flutter.
- Estándares: null safety, nombres en español, sin paquetes externos.
- Qué NO tocar: no modifiques test/ sin que te lo pida, no agregues
  dependencias al pubspec sin avisar, no toques android/ ni ios/.
- Comandos: flutter pub get, flutter run, flutter analyze, flutter test.

No escribas código de la app todavía.
```

**Verifica:** el archivo existe, cabe en una pantalla y **no hay ni un archivo nuevo en
`lib/`**. Si el agente ya se puso a programar, córtalo y repíteselo.

```bash
git add . && git commit -m "archivo de instrucciones del agente"
```

---

## Parte 4 — Instalar uv y GitHub Spec Kit

Hasta ahora escribíamos la especificación a mano. Hay herramientas que le ponen estructura
al proceso: **Spec Kit es una de las herramientas más conocidas para aplicar SDD**, pero no
es la única — existen también **OpenSpec**, **Kiro**, **BMAD Method** y **Spec Kitty**.

Spec Kit **no es un modelo** y **no reemplaza a tu agente**: organiza su trabajo con
artefactos y skills. Se instala con **uv**, que es un gestor de paquetes de Python muy
rápido.

### 4.1 Instalar uv

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Alternativa con WinGet:

```powershell
winget install --id=astral-sh.uv -e
```

**macOS y Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Alternativa en macOS con Homebrew:

```bash
brew install uv
```

**Si ya tienes Python y prefieres no usar instaladores**, en cualquier sistema:

```bash
pip install uv
```

**Verifica** (cierra y vuelve a abrir la terminal si no lo encuentra):

```bash
uv --version
```

> Si dice *"command not found"* o *"no se reconoce como comando"*, es que el instalador
> agregó `uv` al PATH pero la terminal todavía tiene el PATH viejo. Cierra VS Code y
> ábrelo otra vez.

### 4.2 Instalar Spec Kit

```bash
uv tool install specify-cli
```

### 4.3 Inicializar Spec Kit en el proyecto

Desde dentro de `divisor_cuenta`:

```bash
specify init .
```

> Si tu versión no acepta el punto, usa `specify init --here`.

**Te va a preguntar con qué agente trabajas** y te va a mostrar una lista. Muévete con las
flechas y selecciona el tuyo (el mismo que identificaste en la Parte 3.1). No hace falta
pasarle nada por parámetro: la selección es interactiva.

**Verifica:**

```bash
ls -a          # debe aparecer una carpeta .specify/
git status     # hay archivos nuevos de Spec Kit
```

> Los pasos de Spec Kit **no son comandos de terminal**: son *skills* que se invocan en el
> **chat del agente**, escribiendo `/speckit-...`. Si tu agente usa otra sintaxis de
> invocación, revísalo en su documentación y anótalo.

```bash
git add . && git commit -m "uv y spec kit instalados"
```

---

## Parte 5 — Constitution (aquí vive SOLID)

La **Constitution** son las reglas permanentes del proyecto. No describe una
funcionalidad: describe los límites dentro de los que se construye **todo**. Se escribe
**una sola vez** por proyecto.

Aquí es donde SOLID deja de ser teoría y se vuelve una restricción verificable.

### ▶ Pídeselo al agente

```text
/speckit-constitution Crea la constitución de este proyecto con estos principios,
sin inventar otros:

CALIDAD DE CÓDIGO
- El código respeta SOLID:
  * SRP: una clase, una razón de cambio. El cálculo no valida ni formatea.
  * OCP: agregar una nueva regla de redondeo no obliga a editar las clases
    que ya existen.
  * LSP: cualquier implementación de una interfaz puede sustituir a otra
    sin que quien la usa tenga que preguntar de qué tipo es.
  * ISP: interfaces pequeñas; nadie depende de métodos que no usa.
  * DIP: presentation depende de abstracciones del domain, nunca de clases
    concretas de data.

ARQUITECTURA
- Capas: presentation / domain / data.
- Regla de dependencia: presentation -> domain <- data.
- lib/domain/ no importa package:flutter (es Dart puro).
- main.dart es el ÚNICO lugar donde se instancian implementaciones concretas.

SEGURIDAD
- Nunca guardar secretos ni API keys en el repositorio.

CALIDAD Y PRUEBAS
- Toda funcionalidad crítica tiene pruebas.
- Los criterios de aceptación de cada spec se convierten en pruebas ejecutables.

REGLA DE LA MATERIA
- Toda función generada por el agente debe poder explicarla el estudiante:
  qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.
```

**Verifica:** se creó el archivo de constitución dentro de `.specify/`. Ábrelo y léelo: si
alguna regla quedó vaga ("código limpio", "buenas prácticas"), corrígela tú a mano hasta
que sea comprobable.

```bash
git add . && git commit -m "constitution: SOLID, capas, seguridad y pruebas"
```

---

## Parte 6 — Specify y Clarify: qué debe hacer

### 6.1 Specify — el **qué**, todavía sin decidir el **cómo**

### ▶ Pídeselo al agente

```text
/speckit-specify Una app de una sola pantalla para dividir la cuenta de un
restaurante entre varias personas.

El usuario ingresa el monto total, el número de personas y el porcentaje de
propina, y al tocar "Calcular" ve cuánto paga cada persona con dos decimales.

Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al
entero más cercano.

La app funciona sin conexión: no hay red ni base de datos.

Escenarios de aceptación:
1. 100.00, 4 personas, 10% de propina, modo exacto -> 27.50 por persona
2. 90.00, 3 personas, 0% de propina, modo exacto -> 30.00 por persona
3. 50.00 y 0 personas -> mensaje "Debe haber al menos una persona",
   y NO se muestra resultado
4. el monto dice "abc" -> mensaje "Monto inválido"
5. 10.00, 3 personas, 0%, modo exacto -> 3.33 por persona
6. 10.00, 3 personas, 0%, modo hacia arriba -> 4.00 por persona
```

**Verifica:** léete la spec que generó. Busca específicamente **qué inventó que tú no
dijiste**. Anótalo.

### 6.2 Clarify — el paso que casi nadie hace

### ▶ Pídeselo al agente

```text
/speckit-clarify
```

Te puede hacer preguntas sobre lo ambiguo. **Contéstalas.** Copia hasta dos preguntas
relevantes para la pregunta 4 de la entrega. Si hizo una sola o ninguna, indícalo y explica
qué información de la especificación pudo evitar la ambigüedad. No asumas que cada pregunta
que haga necesariamente revela un hueco real: evalúa si era relevante para esta app.

```bash
git add . && git commit -m "spec y clarificaciones"
```

---

## Parte 7 — Plan, Tasks y Analyze

### 7.1 Plan — cómo se va a construir

### ▶ Pídeselo al agente

```text
/speckit-plan Flutter con el SDK estable, sin paquetes externos.
Estado local con setState (es una sola pantalla).

Capas, respetando la constitución:
- domain/  : Cuenta, Resultado, CalcularDivision, ValidarEntrada,
             y la interfaz abstracta EstrategiaRedondeo (un solo método)
- data/    : RedondeoExacto y RedondeoHaciaArriba (implementan la interfaz)
- presentation/ : DivisorController (recibe sus dependencias por
             constructor), FormateadorMoneda, PantallaDivisor
- main.dart: único punto de composición
```

### 7.2 Checklist — opcional

```text
/speckit-checklist
```

Genera una lista de cosas por revisar antes de seguir. **En esta práctica no es
obligatorio**; te lo menciono para que sepas que existe y lo puedas usar en el proyecto
final, cuando la spec sea más grande.

### 7.3 Tasks — partir el plan en pedazos

### ▶ Pídeselo al agente

```text
/speckit-tasks
```

**Verifica:** abre el archivo de tareas. Deberían ser tareas pequeñas y numeradas
(T001, T002…). Cuenta cuántas salieron y anótalo.

### 7.4 Analyze — la revisión antes de programar

### ▶ Pídeselo al agente

```text
/speckit-analyze
```

Busca contradicciones entre la constitución, la spec, el plan y las tareas. **Si encuentra
algo, arréglalo en el artefacto que corresponda, no en el código** — todavía no hay
código.

```bash
git add . && git commit -m "plan, tareas y analisis"
```

---

## Parte 8 — Implement

### ▶ Pídeselo al agente

```text
/speckit-implement
```

Déjalo trabajar tarea por tarea.

> Si tu versión de Spec Kit trae `/speckit-converge`, córrelo después: revisa qué quedó
> pendiente respecto de la spec y se repite con `implement` hasta que no quede nada.

**Verifica a ojo** la estructura que debería haber quedado:

```text
lib/
├── domain/
│   ├── cuenta.dart                    entidad
│   ├── resultado.dart                 entidad
│   ├── estrategia_redondeo.dart       interfaz (ISP: un método)
│   ├── calcular_division.dart         caso de uso (SRP)
│   └── validar_entrada.dart           caso de uso (SRP)
├── data/
│   ├── redondeo_exacto.dart           implementación (OCP/LSP)
│   └── redondeo_hacia_arriba.dart     implementación (OCP/LSP)
├── presentation/
│   ├── divisor_controller.dart        recibe sus dependencias (DIP)
│   ├── formateador_moneda.dart        solo formatea (SRP)
│   └── pantalla_divisor.dart          solo dibuja
└── main.dart                          único punto de composición
```

---

## Parte 9 — Las pruebas: un archivo que crea los casos, corre y verifica

Los criterios de aceptación de la spec tienen que volverse ejecutables. Lo hacemos en dos
archivos, y la razón importa:

| Archivo | Qué hace | Por qué separado |
|---|---|---|
| `test/casos_de_prueba.dart` | **crea** los casos: entradas y resultados esperados | es la traducción literal de la spec; se lee sin saber Flutter |
| `test/division_test.dart` | **corre y verifica**: recorre la tabla y compara | si agregas un caso, tocas solo el primer archivo |

Eso también es SRP, aplicado a las pruebas.

### 9.1 El archivo que crea los casos

Créalo tú, a mano. Es la traducción directa de tus seis escenarios:

```dart
// test/casos_de_prueba.dart
// Los casos salen de la spec. Si cambia la spec, cambia este archivo.

class CasoDivision {
  final String nombre;
  final double monto;
  final int personas;
  final double propina;
  final String modo;          // 'exacto' o 'arriba'
  final double? esperado;     // null = se espera un error
  final String? errorEsperado;

  const CasoDivision({
    required this.nombre,
    required this.monto,
    required this.personas,
    required this.propina,
    required this.modo,
    this.esperado,
    this.errorEsperado,
  });
}

const casos = <CasoDivision>[
  CasoDivision(
    nombre: '1. reparto normal',
    monto: 100.00, personas: 4, propina: 10, modo: 'exacto',
    esperado: 27.50,
  ),
  CasoDivision(
    nombre: '2. sin propina',
    monto: 90.00, personas: 3, propina: 0, modo: 'exacto',
    esperado: 30.00,
  ),
  CasoDivision(
    nombre: '3. cero personas',
    monto: 50.00, personas: 0, propina: 0, modo: 'exacto',
    errorEsperado: 'Debe haber al menos una persona',
  ),
  CasoDivision(
    nombre: '4. monto no numerico',
    monto: double.nan, personas: 4, propina: 0, modo: 'exacto',
    errorEsperado: 'Monto inválido',
  ),
  CasoDivision(
    nombre: '5. redondeo exacto',
    monto: 10.00, personas: 3, propina: 0, modo: 'exacto',
    esperado: 3.33,
  ),
  CasoDivision(
    nombre: '6. redondeo hacia arriba',
    monto: 10.00, personas: 3, propina: 0, modo: 'arriba',
    esperado: 4.00,
  ),
];
```

### 9.2 El archivo que corre y verifica

### ▶ Pídeselo al agente

```text
Lee test/casos_de_prueba.dart. Crea test/division_test.dart que:

1. Recorra la lista `casos` con un bucle y genere un test() por cada uno,
   usando caso.nombre como nombre del test.
2. Para cada caso: valide la entrada con ValidarEntrada, y
   - si el caso tiene errorEsperado, verifique que la validación devuelve
     exactamente ese mensaje y que NO se calcula nada;
   - si el caso tiene esperado, ejecute CalcularDivision con la
     EstrategiaRedondeo que corresponda al campo modo y compare el
     resultado con closeTo(esperado, 0.001).
3. Agregue un test aparte que demuestre LSP: el mismo CalcularDivision
   recibe RedondeoExacto y luego RedondeoHaciaArriba sin ningún if ni cast,
   y funciona con los dos.

NO uses widgets aquí: estas pruebas son del domain y deben correr sin Flutter.
Corre flutter test y arregla lo que falle en lib/, nunca en test/.
```

### 9.3 Una prueba de widget, para la pantalla

### ▶ Pídeselo al agente

```text
Crea test/pantalla_test.dart con tres pruebas de widget:

1. Escribo 100, 4 y 10, toco "Calcular" y aparece "27.50" en pantalla.
2. Escribo 50 y 0 personas, toco "Calcular" y aparece
   "Debe haber al menos una persona", y NO aparece ningún resultado.
3. Escribo "abc" en el monto, toco "Calcular" y aparece "Monto inválido".

Usa testWidgets, tester.enterText y expect(find.text(...), findsOneWidget).
```

### 9.4 Corre todo

```bash
flutter test                        # los 6 casos + LSP + los 3 de widget, en verde
flutter test --reporter expanded    # para ver el nombre de cada caso
flutter analyze                     # sin issues
flutter build apk --debug            # comprueba que la app construye para Android
```

### 9.5 Verifica SOLID con comandos, no con fe

Esto es lo que convierte "aplicamos SOLID" en algo demostrable:

```bash
# En Windows, ejecuta estos comandos desde Git Bash para que grep esté disponible.

# DIP + capas: el domain no puede saber que existe Flutter
grep -rn "package:flutter" lib/domain/          # NO debe salir nada

# DIP: solo main.dart instancia implementaciones concretas
grep -rn -E "RedondeoExacto\\(\\)|RedondeoHaciaArriba\\(\\)" lib/
# debe aparecer SOLO en lib/main.dart

# OCP/LSP: CalcularDivision no debe preguntar de qué tipo es la estrategia
grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart
# NO debe salir nada

# SRP: el cálculo no formatea ni valida
grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart
# NO debe salir nada
```

Si alguno devuelve algo que no debería, **no lo arregles tú**: díselo al agente citando el
artefacto que define la regla incumplida, y vuelve a correr `/speckit-implement`.

```text
Requisito funcional incumplido       → spec
Regla SOLID incumplida                → constitution
Decisión de arquitectura incorrecta   → plan / constitution
```

**Esta es la diferencia entre parchar el código y corregir desde el artefacto que define la
regla incumplida.**

```bash
git add . && git commit -m "app divisor de cuenta - rama sdd, con pruebas"
```

---

## Parte 10 — Las mismas pruebas contra la rama vibe

Ahora evalúa si las pruebas de `sdd` se pueden reutilizar en `vibe`. Copia temporalmente
las pruebas y registra qué ocurre.

```bash
git checkout vibe
git checkout sdd -- test/          # trae SOLO la carpeta test/ desde la rama sdd
flutter test
```

Puede que no compile si la rama `vibe` no tiene clases con esos nombres o una estructura
compatible. **Eso también es un resultado de testabilidad.** Anota qué pasó:

- ¿Compiló? Si no, ¿por qué?
- Si compiló, ¿cuántos de los 6 casos pasó?
- ¿Cuánto tendrías que mover de sitio para que esas pruebas pudieran correr?

Si no compila, **corre los seis escenarios a mano** sobre la app:

```bash
flutter run
```

### Qué estamos midiendo aquí

Si las pruebas de la rama `sdd` no compilan en `vibe`, eso no demuestra automáticamente que
la app `vibe` funcione mal. Puede significar que esa rama no tiene la misma arquitectura,
contratos o puntos de prueba. Distingue:

1. **Testabilidad y estructura:** ¿pueden reutilizarse las pruebas de dominio?
2. **Comportamiento:** ¿la interfaz cumple manualmente los seis escenarios?

Y pásale también las verificaciones de SOLID:

```bash
grep -rn "package:flutter" lib/          # ¿hay alguna capa libre de Flutter?
ls lib/                             # ¿existe domain/ siquiera?
```

Anota los resultados y después devuelve `test/` exactamente a su estado original en la
rama `vibe`:

```bash
git restore --source=HEAD --staged --worktree test/
```

---

## Parte 11 — No compares solo el código: compara mantenibilidad

```bash
git diff vibe sdd --stat
```

Completa también las métricas de la tabla inicial. Luego compara la mantenibilidad mirando
los archivos:

- Si volvieras en dos semanas, ¿cuál de las dos podrías retomar?
- Si un compañero se suma mañana, ¿qué le mandas para que entienda el proyecto?
- Si el cliente pide una tercera forma de redondear ("al múltiplo de 5 más cercano"),
  ¿en cuál sabes exactamente qué archivo crear y cuál **no** tocar?

Estas preguntas ayudan a evaluar si puedes entender, retomar y modificar cada solución.

---

## Preguntas

Responde en un archivo `respuestas.md` dentro del repositorio, en la rama `main`.

1. Llena la tabla de métricas completa. Indica el agente, modelo y nivel de
   razonamiento/configuración utilizados; el archivo de instrucciones; y cuál de los tres
   casos de Git (Parte 1.5) te tocó.
   ¿Qué enfoque cumplió mejor los seis escenarios? ¿Cuántas iteraciones necesitó cada uno?
   Explica qué decisiones quedaron explícitas y cuáles tuvo que completar el agente. Si
   registraste el tiempo aproximado, repórtalo como dato secundario y explica por qué no
   basta para decidir qué enfoque fue mejor.

2. Cuenta qué pasó en la Parte 10 cuando llevaste las pruebas de `sdd` a `vibe`.
   ¿Compilaron? Si no, pega el primer error. ¿Ese error demuestra un fallo funcional o una
   diferencia de arquitectura/testabilidad? Ejecuta después los seis escenarios manualmente
   y compara los resultados.

3. De las verificaciones de SOLID (Parte 9.5), ¿cuáles pasa `sdd` y cuáles `vibe`? Pega
   evidencia de ambas ramas. ¿Qué principio o regla concreta de la **Constitution** explica
   cada diferencia?

4. ¿Qué preguntas relevantes hizo `/speckit-clarify`? Copia hasta dos y explica qué
   ambigüedad destapó cada una. Si no hizo preguntas relevantes, explica qué información
   de la especificación evitó esa ambigüedad. ¿Quién tomó esas decisiones en la rama `vibe`:
   tú explícitamente o el agente por su cuenta?

5. Mira `git diff vibe sdd --stat`. ¿Alguna de las dos ramas agregó código, archivos o
   funcionalidades que nadie pidió? Si ocurrió, identifica cuál y da un ejemplo concreto.
   Si no ocurrió, indícalo.

6. Spec Kit no es la única herramienta relacionada con SDD: también están OpenSpec, Kiro,
   BMAD Method y Spec Kitty. Elige una, averigua brevemente en qué se diferencia de Spec Kit
   y en qué situación la preferirías. Finalmente, describe una situación real y pequeña en
   la que sería razonable elegir `vibe` en lugar de SDD.

---

## Antes de entregar

- [ ] `git branch` muestra `main`, `vibe` y `sdd`.
- [ ] Las dos ramas salen del mismo commit inicial (`git log --oneline --all`).
- [ ] Se usó el mismo agente, modelo y nivel de razonamiento/configuración en ambas ramas.
- [ ] La rama `sdd` tiene el archivo de instrucciones de tu agente en la raíz y la carpeta
      `.specify/` versionada.
- [ ] La constitución incluye los cinco principios SOLID, escritos de forma comprobable.
- [ ] Existen los artefactos de spec, plan y tareas generados por Spec Kit.
- [ ] `test/casos_de_prueba.dart`, `test/division_test.dart` y `test/pantalla_test.dart`
      existen en la rama `sdd`.
- [ ] `flutter test` pasa en verde en la rama `sdd`.
- [ ] `flutter analyze` termina sin errores en la rama `sdd`.
- [ ] `flutter build apk --debug` construye la app en la rama `sdd`.
- [ ] `grep -rn "package:flutter" lib/domain/` no devuelve nada en la rama `sdd` (Git Bash en Windows).
- [ ] `RedondeoExacto()` y `RedondeoHaciaArriba()` solo aparecen en `lib/main.dart`.
- [ ] `respuestas.md` está en `main`, con la tabla de métricas llena.
- [ ] El repositorio está subido a GitHub con las tres ramas.

