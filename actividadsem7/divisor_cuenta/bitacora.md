# Bitácora de métricas — Deber 2 SDD

| Métrica | Flutter (laboratorio anterior) | React (Deber 2) |
|---|---|---|
| Minutos hasta la primera versión que compila. | no registrado | pendiente de registrar |
| Minutos hasta que pasan los 6 casos de aceptación. | no registrado | pendiente de registrar |
| Iteraciones con el agente. | no registrado | pendiente de registrar |
| Líneas de código escritas a mano. | no registrado | 50 líneas del archivo de casos declarado manual por el estudiante; otras ediciones pendientes de registrar |
| Enunciados modificados en la spec. | no registrado | 0; spec idéntica byte por byte |
| Enunciados modificados en la Constitution. | no registrado | 8 apartados atómicos adaptados en redacción según `analisis_spec.md`; 0 principios reemplazados |
| Líneas modificadas en el plan. | no registrado | 62 añadidas y 119 eliminadas según `git diff --no-index --numstat` entre los dos planes; el plan Flutter no se editó |
| Casos de aceptación que pasan (0–6). | 6, según la verificación previa del laboratorio (10 pruebas totales) | 6, confirmados por `npm test` (13 pruebas totales) |

## Reglas de registro

- El cronómetro React empieza cuando enviemos `/speckit-plan`.
- Anotaremos el tiempo hasta el primer `npm run build` exitoso sin detener el cronómetro.
- El cronómetro se detiene cuando los seis casos de aceptación React estén en verde.
- Una iteración es un mensaje posterior al prompt inicial que pide una corrección o modificación. No cuentan las herramientas que el agente ejecute por su cuenta.
- Las líneas escritas a mano son exclusivamente las modificadas directamente por mí, no por el agente.
- Los valores `—` están pendientes de registrar. Los datos del laboratorio anterior que no fueron registrados se identificarán como `no registrado`; no los estimaremos.

## Evidencia y límites

- El estudiante indicó que el cronómetro se detuvo cuando los seis casos React pasaron. No proporcionó las horas o minutos exactos; ambas celdas de tiempo React quedan `pendiente de registrar`.
- `test/casosDePrueba.js` tiene 50 líneas físicas no vacías en la versión actual. El estudiante declaró que escribió personalmente ese archivo; el número de otras ediciones manuales no está documentado y no se suma a las 50.
- El análisis manual en `analisis_spec.md` cuenta 70 enunciados de la spec: 70 intactos, 0 adaptados, 0 no reutilizables. Los SHA-256 de Flutter y React son iguales: `0AAD31E32AB01BB5C4A138364004297A5390F2D2532FF5FFDE1914EA8C00F6C9`.
- La Constitution Flutter es 1.0.0; la React 2.0.0 adapta ocho apartados atómicos de redacción tecnológica según la clasificación manual, conservando SOLID y gobierno.
- Los planes son artefactos distintos: Flutter tiene 159 líneas y React 102. El diff textual reportó 62 altas y 119 bajas; no representa líneas editadas a mano ni duración.
- `npm test` en React aprobó 13/13 pruebas: seis casos de aceptación, LSP, tres de pantalla y tres comprobaciones complementarias. `npm run build` terminó con código 0 y generó 8 entradas de precache. La comprobación real de uso sin conexión no concluyó con éxito; no se declara FR-009/SC-005 verificado.