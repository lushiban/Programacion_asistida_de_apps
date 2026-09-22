import 'dart:async';

import 'package:actividadsem5/domain/entities/usuario.dart';
import 'package:actividadsem5/domain/repositories/usuario_repository.dart';
import 'package:actividadsem5/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:actividadsem5/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUsuarioRepository implements UsuarioRepository {
  const _FakeUsuarioRepository(this._obtenerUsuarios);

  final Future<List<Usuario>> Function() _obtenerUsuarios;

  @override
  Future<List<Usuario>> obtener() => _obtenerUsuarios();
}

void main() {
  testWidgets('muestra solo usuarios cuyo nombre comienza con vocal', (
    WidgetTester tester,
  ) async {
    final completer = Completer<List<Usuario>>();
    final repository = _FakeUsuarioRepository(() => completer.future);
    final useCase = ObtenerUsuariosConVocal(repository);

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: useCase));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(const [
      Usuario(id: 1, nombre: 'Ana Torres', email: 'ana@example.com'),
      Usuario(id: 2, nombre: 'Bruno Vega', email: 'bruno@example.com'),
      Usuario(id: 3, nombre: 'Oscar Ruiz', email: 'oscar@example.com'),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('Ana Torres'), findsOneWidget);
    expect(find.text('Oscar Ruiz'), findsOneWidget);
    expect(find.text('Bruno Vega'), findsNothing);
  });

  testWidgets('muestra un error y permite reintentar', (
    WidgetTester tester,
  ) async {
    final repository = _FakeUsuarioRepository(
      () async => throw Exception('Error de prueba'),
    );
    final useCase = ObtenerUsuariosConVocal(repository);

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: useCase));
    await tester.pumpAndSettle();

    expect(find.text('No se pudieron cargar los usuarios.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
  });
}
