
1. **Arquitectura:** ¿qué hizo el LLM, qué el harness/host, qué el cliente MCP y qué el servidor MCP? ¿Cuál ejecutó realmente Python?

El LLM se encargó de interpretar las instrucciones, decidir qué herramientas utilizar y analizar los resultados para llegar a conclusiones sobre los incidentes. El harness o host, en este caso Codex, coordinó la interacción entre el modelo y las herramientas, gestionando los permisos y las ejecuciones. Por su parte, el cliente MCP, que funciona dentro del host, permitió la comunicación con el servidor, enviando las solicitudes y recibiendo sus respuestas. Finalmente, el servidor MCP proporcionó las tres herramientas que implementamos, listar_casos, consultar_eventos y registrar_alerta, con las que se pudieron consultar los datos, validar los argumentos y guardar las alertas en memoria

En cuanto a Python, quien realmente ejecutó el código fue el intérprete de Python del sistema, que corría nuestro servidor server.py y sus funciones. Durante las pruebas también se ejecutaron procesos de Python para comprobar su funcionamiento. El LLM no ejecutó directamente ese código, sino que solicitó las acciones y después interpretó los resultados que recibió.

2. **Evidencia:** ¿por qué `INC-003` merece investigación, pero los logs no permiten afirmar con certeza que hubo una intrusión?

El caso INC-003 merece investigarse porque hubo cuatro intentos fallidos entre las 03:00 y las 03:03, y después, a las 03:04, se logró entrar con el usuario admin desde la misma IP. Esto es sospechoso porque podría ser alguien intentando entrar a una cuenta hasta conseguirlo.

Pero tampoco podemos asegurar que haya sido un ataque, porque podría ser simplemente una persona que se equivocó varias veces con su contraseña. No sabemos quién entró, si tenía permiso o qué hizo después, así que haría falta revisar más información para saber qué pasó.

También comprobé que el servidor funcionaba usando las herramientas MCP. Pude ver los casos, revisar sus eventos y registrar una alerta. Además, cuando intenté consultar INC-999, el servidor me dio un error porque ese caso no existía

3. **Validación y seguridad:** ¿quién rechaza `INC-999` o los parámetros inválidos, y por qué no es seguro confiar solo en que el modelo genere argumentos correctos?

El servidor MCP es el encargado de revisar que los datos sean correctos y rechazar los que no cumplen las reglas. Por ejemplo, cuando consulté el caso INC-999, me dio un error porque no existía. También rechaza niveles diferentes de bajo, medio o alto, motivos vacíos y alertas que ya fueron registradas. Todo esto se comprobó con las siete pruebas que realizamos.

No podemos confiar solamente en el modelo porque puede equivocarse al interpretar las instrucciones o enviar datos incorrectos. Por eso es importante que el servidor también revise la información antes de aceptar una solicitud, así evitamos que se registren alertas con datos que no son válidos.


4. Incluye también: qué agente usaste, cómo comprobaste que estaba conectado y las instrucciones **breves** para instalar,
iniciar el Inspector y conectar el servidor (sin tokens ni contraseñas).

Codex
Comprobé la conexión mediante el comando codex.cmd mcp list, donde el servidor mcp-detective apareció habilitado. Después, en una conversación nueva, Codex descubrió y ejecutó las herramientas listar_casos, consultar_eventos y registrar_alerta

Para hacer este proyecto utilicé Python 3.11 y Node.js con npm/npx. Primero instalé las librerías necesarias desde la terminal con este comando:

```
python -m pip install "mcp[cli]>=2,<3" pytest
```

Después, desde la carpeta principal del repositorio, inicié MCP Inspector con:

```
npx.cmd -y @modelcontextprotocol/inspector@2.13.0 python .\mcp-detective\server.py
```

Esto me permitió abrir Inspector en el navegador y conectarme al servidor. Ahí pude ver las tres herramientas y comprobar que funcionaban. Al ejecutar `listar_casos`, aparecieron los tres incidentes con 2, 6 y 5 eventos.

Para conectar el servidor a Codex, primero obtuve las rutas de Python y de `server.py`:

```
$python = python -c "import sys; print(sys.executable)"
$server = (Resolve-Path .\mcp-detective\server.py).Path
```

Luego agregué el servidor con:

```
codex.cmd mcp add mcp-detective -- $python $server
```

Y comprobé que estuviera habilitado con:

```
codex.cmd mcp list
```

Después abrí una conversación nueva en Codex y pude utilizar las herramientas MCP para revisar los incidentes y registrar una alerta.

Por último, ejecuté las pruebas automáticas con:

```
python -m pytest mcp-detective -q
```

Las siete pruebas pasaron correctamente. También comprobé que el servidor funcionaba desde MCP Inspector y que Codex podía utilizar las herramientas para consultar los casos y registrar alertas.
