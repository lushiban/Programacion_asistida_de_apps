# Bitácora de métricas — Deber 2 SDD

| Métrica | Flutter (laboratorio anterior) | React (Deber 2) |
|---|---|---|
| Minutos hasta la primera versión que compila. | no registrado | 12 |
| Minutos hasta que pasan los 6 casos de aceptación. | no registrado | 31 |
| Iteraciones con el agente. | no registrado | 0; dato final confirmado por el estudiante. El prompt inicial se cuenta aparte y no incluyó los mensajes posteriores de guía |
| Líneas de código escritas a mano. | no registrado | 65 líneas no vacías modificadas directamente por el estudiante: 50 en `test/casosDePrueba.js` y 15 en `vite.offline.config.js` |
| Enunciados modificados en la spec. | no registrado | 0; spec idéntica byte por byte |
| Enunciados modificados en la Constitution. | no registrado | 8 apartados atómicos adaptados en redacción según `analisis_spec.md`; 0 principios reemplazados |
| Líneas modificadas en el plan. | no registrado | 62 añadidas y 119 eliminadas según `git diff --no-index --numstat` entre los dos planes; el plan Flutter no se editó |
| Casos de aceptación que pasan (0–6). | 6, según la verificación previa del laboratorio (10 pruebas totales) | 6, confirmados por `npm test` (14 pruebas totales) |

## Reglas de registro

- El cronómetro React empieza cuando enviemos `/speckit-plan`.
- Anotaremos el tiempo hasta el primer `npm run build` exitoso sin detener el cronómetro.
- El cronómetro se detiene cuando los seis casos de aceptación React estén en verde.
- Una iteración es un mensaje posterior al prompt inicial que pide una corrección o modificación. No cuentan las herramientas que el agente ejecute por su cuenta.
- Las líneas escritas a mano son exclusivamente las modificadas directamente por mí, no por el agente.
- Los valores `—` están pendientes de registrar. Los datos del laboratorio anterior que no fueron registrados se identificarán como `no registrado`; no los estimaremos.

## Evidencia y límites

- `test/casosDePrueba.js` tiene 50 líneas físicas no vacías; el estudiante declaró que lo escribió personalmente. Más tarde creó y guardó directamente `vite.offline.config.js`, con 15 líneas no vacías de JavaScript proporcionadas en instrucciones del agente. La línea añadida a `.gitignore` no se cuenta como código, y los cambios que `npm` hizo en `package.json` y `package-lock.json` no son escritura manual. El estudiante confirmó 0 iteraciones finales conforme a la regla de contar solo mensajes posteriores al prompt inicial que pidan corrección o modificación.
- El análisis manual en `analisis_spec.md` cuenta 70 enunciados de la spec: 70 intactos, 0 adaptados, 0 no reutilizables. Los SHA-256 de Flutter y React son iguales: `0AAD31E32AB01BB5C4A138364004297A5390F2D2532FF5FFDE1914EA8C00F6C9`.
- La Constitution Flutter es 1.0.0; la React 2.0.0 adapta ocho apartados atómicos de redacción tecnológica según la clasificación manual, conservando SOLID y gobierno.
- Los planes son artefactos distintos: Flutter tiene 159 líneas y React 102. El diff textual reportó 62 altas y 119 bajas; no representa líneas editadas a mano ni duración.
- `npm test` en React aprobó 14/14 pruebas: seis casos de aceptación, LSP, tres de pantalla y cuatro comprobaciones complementarias. `npm run build` terminó con código 0 y generó 8 entradas de precache. Chrome 156 recargó la app y calculó 27.50 y 4.00 con red emulada offline y service worker activo después de una carga inicial. En la prueba manual del 2026-10-10, el estudiante confirmó recarga y cálculos 27.50 y 4.00 con Offline marcado. Después de limpiar datos del sitio y recargar la URL web aún offline, reportó `ERR_INTERNET_DISCONNECTED`: su primera apertura sin caché no funcionó. Se preparó una entrega local separada en React (`dist-offline/`, generada desde `vite.offline.config.js`). El estudiante informó que, siguiendo el procedimiento sin conexión, abrió `index.html` con URL `file:///`, obtuvo 27.50 y 4.00 y recargó con F5; los campos regresaron a valores iniciales. Es evidencia manual comunicada por el estudiante, no una observación directa del agente. T043 se considera verificada para la entrega local; la limitación de primera apertura de la URL web permanece.
- SC-001: el estudiante informó 0:08.23 (8,23 segundos) desde la pantalla lista hasta mostrar 27.50 en un cálculo válido. Es una medición manual por debajo de 30 segundos, sin generalizar a otros usuarios.
