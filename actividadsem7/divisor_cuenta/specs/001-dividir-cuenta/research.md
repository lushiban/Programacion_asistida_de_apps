# Research: Dividir cuenta de restaurante

## Flutter estable y dependencias

**Decision**: Usar el Flutter SDK estable ya instalado, eliminar del `pubspec.yaml` las
dependencias externas preexistentes `cupertino_icons` y `flutter_lints`, y no agregar otras.

**Rationale**: La funcionalidad necesita únicamente controles, estado local, matemáticas y
pruebas incluidas en Flutter. Esto satisface literalmente la restricción del usuario de no
usar paquetes externos.

**Alternatives considered**: Paquetes de gestión de estado o aritmética decimal y conservar
las dependencias externas de la plantilla. Se descartan porque ampliarían o mantendrían
dependencias externas contra la restricción explícita.

## Estado de presentación

**Decision**: Usar `setState` en `PantallaDivisor`; el estado y las acciones se concentran
en un `DivisorController` inyectado.

**Rationale**: `setState` está solicitado expresamente y es suficiente para una pantalla.
El controlador mantiene la lógica de coordinación fuera del widget y depende solo del
dominio.

**Alternatives considered**: Provider, BLoC y Riverpod. Se descartan porque agregan
dependencias y complejidad sin aportar valor proporcional al alcance.

## Dependencias entre capas

**Decision**: Aplicar `presentation -> domain <- data`. `domain` contiene las entidades,
casos de uso y `EstrategiaRedondeo`; `data` solo implementa esa interfaz; presentación recibe
abstracciones por constructor.

**Rationale**: Es la dirección exigida por la Constitution y permite probar el cálculo sin
Flutter ni implementaciones concretas.

**Alternatives considered**: Lógica dentro del widget o importación de `data` desde el
controlador. Ambas se descartan por incumplir SRP y DIP.

## Redondeo exacto

**Decision**: Calcular con valores numéricos de Dart y delegar en `RedondeoExacto` el
redondeo monetario a dos decimales; los empates en el tercer decimal se resuelven hacia
arriba, según la aclaración registrada.

**Rationale**: Produce 3.33 para 10/3 y 2.35 para 2.345, separando la política de redondeo
del cálculo y del formato.

**Alternatives considered**: Redondeo al par y truncamiento. Se descartan porque contradicen
la aclaración. Una dependencia decimal externa se descarta por la restricción de paquetes.

## Redondeo hacia arriba

**Decision**: Aplicar la estrategia al importe individual ya calculado con propina y elevar
cualquier fracción al entero siguiente; el formato posterior conserva dos decimales.

**Rationale**: Corresponde a la spec y produce 4.00 para 10/3.

**Alternatives considered**: Redondear el total antes de dividir o elevar a centavos. Se
descartan porque cambiarían el escenario de aceptación.

## Catálogo extensible de estrategias

**Decision**: Inyectar en `DivisorController` un catálogo de identificadores y etiquetas
asociados con `EstrategiaRedondeo`, construido exclusivamente en `main.dart`.

**Rationale**: La pantalla puede listar opciones sin importar `data`; agregar una estrategia
solo requiere una implementación nueva y su registro en el punto de composición.

**Alternatives considered**: Condicional fijo de dos opciones o comprobaciones de tipo. Se
descartan porque obligarían a modificar clases existentes e incumplirían OCP/LSP.
