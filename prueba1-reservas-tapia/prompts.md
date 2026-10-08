# Prompts de la prueba

## Prompt 1 — Revisión del repositorio

En una aplicación de comercio electrónico existen varios métodos de pago: tarjeta, PayPal y transferencia bancaria. Cada vez que se agrega un nuevo método, los desarrolladores deben modificar un bloque if/else (código de abajo) grande que ya funcionaba A ver, quiero que primero revises todo el repositorio antes de modificar cualquier archivo.

Necesito entender cómo está funcionando actualmente la aplicación de reservas y qué partes del proyecto intervienen en la creación de una reserva.

Tienes que revisar:

- ".specify/memory/constitution.md"
- "specs/001-reservas-sala/spec.md"
- "specs/001-reservas-sala/plan.md"
- "lib/domain/"
- "lib/data/"
- "lib/presentation/"
- "supabase/"
- "test/"

Quiero que me expliques:

1. Cómo funciona actualmente "CrearReserva".
2. Qué métodos ofrece "ReservasRepository".
3. Cómo se validan y guardan las reservas.
4. Qué pruebas existen y qué comportamientos comprueban.
5. Cómo se conecta la lógica del dominio con la persistencia real.
6. Qué posibles riesgos encuentras en la arquitectura actual.

IMPORTANTE: No modifiques ningún archivo todavía. No quiero implementaciones ni refactorizaciones.

Dame las rutas y números de línea que respalden las afirmaciones. Si hay algo que no puedes comprobar, indícalo y no inventes información.

Primero necesito comprender el proyecto para poder decidir los escenarios y los cambios.correctamente:

if tipo_pago == "tarjeta":
    ...
elif tipo_pago == "paypal":
    ...
elif tipo_pago == "transferencia":
    ...
¿Qué principio de diseño busca evitar este tipo de modificaciones continuas en código existente?

## Prompt 2 — Implementación

Ahora necesito que completes la Prueba 1 de reservas de sala en el menor tiempo posible, idealmente dentro de 10 minutos.

Ya te pedí que revisaras el repositorio. Utiliza ese análisis y las instrucciones de la prueba para continuar.

IMPORTANTE: Quiero que realices todo el proceso de forma ordenada, con SDD, TDD y Git. No te detengas innecesariamente entre etapas, pero respeta estrictamente el orden de los commits. Si encuentras un bloqueo que impida cumplir una condición obligatoria, infórmame; no simules que la cumpliste.

### ETAPA 1 — SPEC

Modifica únicamente `specs/001-reservas-sala/spec.md`.

La regla es que dos reservas de la misma sala no pueden solaparse.

Agrega como mínimo estos seis escenarios Dado/Cuando/Entonces:

1. Solapamiento parcial: rechazar.
2. Nueva reserva completamente dentro de otra: rechazar.
3. Nueva reserva que contiene una existente: rechazar.
4. Intervalos idénticos de la misma sala: rechazar.
5. Intervalos consecutivos sin tiempo compartido: permitir.
6. Mismo horario en salas distintas: permitir.

Toma como decisión que dos reservas consecutivas, donde una termina exactamente cuando comienza la otra, no se solapan, siempre que no contradiga un requisito existente.

Mensaje exacto de rechazo:
"La sala ya está reservada en ese horario."

Conserva los escenarios originales y evita detalles técnicos en la spec. Describe únicamente QUÉ hace el sistema.

Revisa el diff y crea el primer commit, exclusivamente con la spec:
`spec: define regla de solapamiento`

### ETAPA 2 — TDD RED

Escribe las pruebas correspondientes a esos escenarios utilizando un fake de ReservasRepository, sin conexión a Internet ni Supabase.

Respeta las firmas e interfaces existentes.

NO modifiques el código de producción todavía.

Ejecuta `flutter test` y verifica que las pruebas nuevas compilen y que al menos una falle por comportamiento, no por compilación.

Después de comprobar el fallo real, crea el segundo commit:
`test: comprueba solapamiento de reservas`

No cambies posteriormente las aserciones de estas pruebas.

### ETAPA 3 — TDD GREEN

Implementa la regla de solapamiento en CrearReserva, haciendo únicamente los cambios necesarios.

Condiciones:
- No cambiar la firma de CrearReserva.
- No modificar la interfaz ReservasRepository.
- No modificar constitution.md ni plan.md.
- No introducir pantallas nuevas ni funcionalidades fuera de alcance.
- Conservar exactamente el mensaje de rechazo.
- Verificar todos los casos, incluidos intervalos límite.
- Mantener las pruebas anteriores.

Ejecuta `flutter test` hasta comprobar que las pruebas están verdes.

No modifiques ni debilites las aserciones de la etapa RED.

Revisa el diff y crea el tercer commit:
`feat: impide reservas solapadas`

### ETAPA 4 — REVISIÓN Y RESPUESTAS

Revisa el repositorio completo e identifica el riesgo técnico más importante respaldado por evidencia.

Comprueba especialmente si el sistema real está protegido frente a reservas simultáneas y si la validación de dominio está respaldada por la persistencia.

Crea `RESPUESTAS.md`, con máximo aproximado de 400 palabras y estos títulos EXACTOS:

## Escenarios que elegí y por qué
## Riesgo más grave del repositorio
## ¿La regla protege la app real?

Cada afirmación sobre el repositorio debe incluir una evidencia real con formato `ruta:línea` y explicar qué demuestra.

No inventes números de línea ni afirmes que la base de datos está protegida si no puedes verificarlo.

### ETAPA 5 — PROMPTS E HISTORIAL

Crea `prompts.md` en la raíz.

Incluye en orden todos los prompts que realmente te envié durante esta prueba, copiados literalmente. Recupera el primer mensaje de revisión del repositorio y este mensaje de implementación de la conversación o sesión disponible.

Si no puedes recuperar un prompt exacto, avísame. No lo reconstruyas ni lo inventes.

Comprueba con Git que los tres commits obligatorios aparecen en orden y que las aserciones RED siguen iguales.

Crea el commit final que incluya RESPUESTAS.md y prompts.md.

### ETAPA 6 — ENTREGA

Comprueba:
- `flutter test` en verde.
- Rama `prueba/solapamiento`.
- Al menos tres commits independientes de spec, RED y GREEN.
- Archivos de documentación incluidos en el último commit.
- Ninguna modificación fuera de alcance.

Publica la rama con:
`git push -u origin prueba/solapamiento`

Si GitHub CLI está disponible y autenticado, abre un pull request dentro de MI repositorio, desde prueba/solapamiento hacia main, SIN hacer merge.

Genera `prueba1-<apellido>.bundle` usando git bundle create con --all, sustituyendo el apellido por el del repositorio.

Genera `sesion-<apellido>.zip` con las sesiones rollout de Codex de la prueba, filtradas según las instrucciones del profesor, y ubícalo fuera del repositorio.

No incluyas los archivos bundle ni zip en Git.

Si no puedes completar la apertura del PR o generar algún archivo, indícame exactamente qué falta y el comando o acción necesaria. No afirmes haber entregado archivos al aula virtual.

### RESTRICCIONES ABSOLUTAS

- No ejecutar /speckit-*.
- No cambiar constitution.md ni plan.md.
- No cambiar contratos existentes.
- No utilizar red ni Supabase en los tests.
- No modificar las aserciones del commit RED.
- No falsificar pruebas, commits, resultados o evidencias.
- No trabajar sobre el repositorio del profesor.
- No hacer merge del pull request.
- No introducir refactorizaciones innecesarias.

Prioriza terminar correctamente los entregables obligatorios antes que mejoras opcionales.

Trabaja siguiendo las etapas, sin combinarlas en un solo commit.

Al terminar, dame un informe breve con:
1. Commits y sus hashes.
2. Resultado real de flutter test.
3. Archivos modificados.
4. Estado del push y pull request.
5. Ubicación de bundle y zip.
6. Lo que falta hacer manualmente para entregar.

Comienza directamente con la ETAPA 1.
