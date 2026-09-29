import 'dart:async';

import 'package:actividadsem6/domain/entities/registro_prueba.dart';
import 'package:actividadsem6/domain/repositories/registros_prueba_repository.dart';
import 'package:actividadsem6/domain/usecases/obtener_registros_prueba.dart';
import 'package:actividadsem6/main.dart';
import 'package:actividadsem6/presentation/providers/registros_prueba_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Muestra carga y luego id y fecha del registro', (tester) async {
    final respuesta = Completer<List<RegistroPrueba>>();
    await tester.pumpWidget(_app(() => respuesta.future));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    respuesta.complete([
      RegistroPrueba(id: 42, creadoEn: DateTime.utc(2026, 9, 24, 15)),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('Tabla_prueba'), findsOneWidget);
    expect(find.text('ID: 42'), findsOneWidget);
    expect(find.text('Creado (UTC): 2026-09-24T15:00:00.000Z'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Permite actualizar una lista vacia', (tester) async {
    var llamadas = 0;
    await tester.pumpWidget(
      _app(() async {
        llamadas++;
        return llamadas == 1
            ? []
            : [const RegistroPrueba(id: 7, creadoEn: null)];
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('No hay registros disponibles.'), findsOneWidget);

    await tester.tap(find.byTooltip('Actualizar'));
    await tester.pumpAndSettle();
    expect(find.text('ID: 7'), findsOneWidget);
    expect(find.text('Fecha no disponible'), findsOneWidget);
    expect(llamadas, 2);
  });

  testWidgets('Permite reintentar despues de un error', (tester) async {
    var llamadas = 0;
    await tester.pumpWidget(
      _app(() async {
        if (++llamadas == 1) throw Exception('Fallo simulado de red');
        return [const RegistroPrueba(id: 3, creadoEn: null)];
      }),
    );
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('ID: 3'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  test('Terminar una carga despues de dispose no notifica', () async {
    final respuesta = Completer<List<RegistroPrueba>>();
    final provider = RegistrosPruebaProvider(
      ObtenerRegistrosPrueba(_FakeRepository(() => respuesta.future)),
    );
    final carga = provider.cargar();
    provider.dispose();
    respuesta.complete([]);
    await expectLater(carga, completes);
  });
}

Widget _app(Future<List<RegistroPrueba>> Function() obtener) {
  return ChangeNotifierProvider(
    create: (_) => RegistrosPruebaProvider(
      ObtenerRegistrosPrueba(_FakeRepository(obtener)),
    )..cargar(),
    child: const MyApp(),
  );
}

class _FakeRepository implements RegistrosPruebaRepository {
  const _FakeRepository(this._obtener);

  final Future<List<RegistroPrueba>> Function() _obtener;

  @override
  Future<List<RegistroPrueba>> obtenerTodos() => _obtener();
}
