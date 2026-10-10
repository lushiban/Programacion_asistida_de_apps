## 1. Métricas y comparación general

| Métrica | vibe | sdd |
|---|---|---|
| Casos de aceptación que cumple | 3/6 | 6/6 |
| Pruebas automatizadas | Sus 3 pruebas propias pasaron, pero las pruebas de dominio de `sdd` no compilaron en esta rama | 10/10 aprobadas |
| Archivos `.dart` en `lib/` | 1 | 11 |
| Líneas físicas en los `.dart` de `lib/` | 342 | 334 |
| Separación `presentation/domain/data` | No | Sí |
| Dominio independiente de Flutter | No existe `domain/`; toda la implementación está en un archivo que importa Flutter | Sí; `lib/domain/` es Dart puro |
| Funcionalidad no solicitada | Sí: botón Limpiar, propinas predefinidas, límite de 1 a 99 personas y visualización adicional del total con propina | No se agregó funcionalidad de negocio; las decisiones técnicas y de UI adicionales quedaron documentadas en el plan |
| Nueva estrategia sin modificar el cálculo | No | Sí |

- **Agente:**  Codez
- **Modelo exacto:** GPT-5 Sol 
- **Nivel de razonamiento/configuración:** ligero
- **Archivo de instrucciones:** `AGENTS.md`.
- **Caso Git de la Parte 1.5:** C
- **Iteraciones de vibe y sdd:** 0 en cada uno
El enfoque `sdd` cumplió mejor los seis escenarios: alcanzó 6/6, mientras que `vibe` alcanzó 3/6. En `sdd` quedaron explícitos los requisitos, mensajes de error, prioridad de validación, redondeo del tercer decimal igual a 5, arquitectura, responsabilidades y pruebas. El agente completó decisiones documentadas como iniciar los campos vacíos, usar Exacto como modo inicial y representar las estrategias mediante un catálogo inyectado. En `vibe`, el agente tomó decisiones como usar botones para personas, impedir llegar a cero, filtrar caracteres no numéricos, limitar la propina a valores predefinidos y no ofrecer modos de redondeo.

Aunque se hubiera medido el tiempo, no bastaría para decidir qué enfoque fue mejor: terminar más rápido no demuestra cumplimiento, testabilidad, mantenibilidad ni extensibilidad. La evidencia funcional y automatizada favorece a `sdd`.



## 2. Pruebas de sdd ejecutadas en vibe

Las pruebas de `sdd` no compilaron completamente en `vibe`. El primer error fue:

```text
test/division_test.dart:1:8: Error: Error when reading 'lib/data/redondeo_exacto.dart': El sistema no puede encontrar la ruta especificada
```

Este primer error demuestra una diferencia de arquitectura y testabilidad, no por sí solo un fallo funcional. Las pruebas esperaban las capas y tipos públicos de `sdd`, pero `vibe` concentra toda la aplicación en `lib/main.dart` y no tiene `data/` ni `domain/`.

| Escenario | Resultado manual en vibe |
|---|---|
| 100.00, 4 personas, 10% | PASA: muestra 27.50 |
| 90.00, 3 personas, 0% | PASA: muestra 30.00 |
| 50.00, 0 personas | FALLA: no permite bajar de una persona ni muestra el mensaje exigido |
| Monto `abc` | FALLA: el filtro impide ingresar letras y no aparece `Monto inválido` |
| 10.00, 3 personas, 0%, exacto | PASA: muestra 3.33 |
| 10.00, 3 personas, 0%, hacia arriba | FALLA: no existe ese modo ni puede obtenerse 4.00 mediante esa opción |

La evaluación funcional manual dio 3/6 para `vibe`. Es distinta de la incompatibilidad de arquitectura que impidió compilar las pruebas de dominio. `sdd` cumplió 6/6 y aprobó sus 10 pruebas.

## 3. Verificaciones SOLID

`sdd` cumple las reglas verificadas:

- **SRP:** `CalcularDivision` solo calcula. La búsqueda de `toStringAsFixed`, `inválido` y `al menos una persona` no devolvió resultados en esa clase. Validación y formato están en clases distintas.
- **OCP:** `CalcularDivision` recibe `EstrategiaRedondeo`; una estrategia nueva puede implementarse sin cambiar el cálculo.
- **LSP:** no hay comprobaciones `is Redondeo` ni conversiones `as Redondeo`; la prueba sustituyó ambas estrategias correctamente.
- **ISP:** `EstrategiaRedondeo` contiene un único método, `redondear`.
- **DIP:** `presentation` depende de tipos de `domain`, no de clases de `data`; las implementaciones concretas se conectan en `main.dart`.
- **Dominio puro:** buscar `package:flutter` en `lib/domain/` no devolvió resultados.

`vibe` no implementa esa arquitectura: solo existe `lib/main.dart`, con 342 líneas, y este importa Flutter. La misma clase mantiene estado, valida, calcula, formatea y presenta, por lo que no satisface SRP. No existe `EstrategiaRedondeo`, así que no hay sustitución LSP, interfaz pequeña ISP ni extensión OCP. Tampoco existen las capas requeridas para DIP. Que `domain/` no exista no significa que sea independiente de Flutter: significa que la abstracción exigida nunca fue creada.

Las diferencias se explican por los cinco principios SOLID y por la regla `presentation -> domain <- data` de la Constitution.

## 4. Aclaraciones relevantes

1. **“¿Qué mensaje debe mostrarse cuando el número de personas sea negativo, decimal o no numérico?”** Se acordó mostrar `Debe haber al menos una persona` en todos los casos. La pregunta eliminó la ambigüedad sobre si cada variante necesitaba un mensaje diferente y permitió crear una regla comprobable.
2. **“En modo exacto, ¿cómo debe redondearse un resultado cuyo tercer decimal sea exactamente 5, como 2.345?”** Se acordó redondear hacia arriba y mostrar 2.35. Esto resolvió el tratamiento de empates, que puede variar entre algoritmos de redondeo.

En `sdd`, el usuario confirmó estas respuestas durante `/speckit-clarify`. En `vibe` no hay un artefacto que documente esas decisiones ni evidencia de que el usuario eligiera el stepper, el filtro o la ausencia de modos; según el código disponible, fueron decisiones tomadas por el agente.

## 5. Código o funcionalidades no solicitadas

`git diff vibe sdd --stat` mostró 58 archivos diferentes, 6534 inserciones y 420 eliminaciones. La mayor parte del volumen adicional de `sdd` corresponde a Spec Kit y a los artefactos solicitados durante el flujo: Constitution, spec, plan, modelo, contrato, tareas, checklists y pruebas. Ese volumen no es por sí mismo funcionalidad de negocio no pedida.

`vibe` sí agregó decisiones y funcionalidades no explícitas en el prompt inicial. Un ejemplo concreto es el botón **Limpiar**. También agregó chips de propina limitados a cinco porcentajes, un máximo de 99 personas y una tarjeta que muestra el total con propina. Algunas son útiles, pero no fueron solicitadas y ciertos controles impidieron ejecutar dos escenarios inválidos.

En `sdd` no se observó funcionalidad de negocio adicional. Sí hubo decisiones menores —tema visual, campos vacíos y modo Exacto inicial—, pero quedaron identificadas en el plan y no cambiaron los resultados requeridos.

## 6. Otra herramienta SDD y cuándo elegir vibe

Elegí **Kiro**. Al igual que Spec Kit, puede convertir una idea en requisitos, diseño y tareas. La diferencia principal es que Kiro es un entorno más amplio disponible como IDE, CLI y web: además de specs, ofrece archivos persistentes de *steering* para convenciones del proyecto y *hooks* que ejecutan acciones ante eventos como guardar archivos, usar herramientas o completar tareas. En esta actividad, Spec Kit funcionó como un flujo de comandos y artefactos versionados dentro del repositorio.

Preferiría Kiro cuando el equipo quiera una experiencia integrada y automatizaciones permanentes, por ejemplo ejecutar análisis y pruebas después de modificar archivos o terminar una tarea. Sus hooks pueden ejecutar comandos deterministas o enviar instrucciones al agente, y sus archivos de steering conservan estándares entre sesiones. Fuentes oficiales: [Kiro Specs](https://kiro.dev/docs/specs/best-practices/), [Kiro Steering](https://kiro.dev/docs/steering/) y [Kiro Hooks](https://kiro.dev/docs/hooks/).

Elegir `vibe` sería razonable para una tarea pequeña y desechable, por ejemplo crear rápidamente un prototipo visual de una tarjeta para enseñar colores y distribución al cliente, sin reglas críticas, integraciones ni expectativa de mantenimiento. Si el prototipo se convirtiera en producto o tuviera criterios de aceptación importantes, convendría pasar a SDD.

