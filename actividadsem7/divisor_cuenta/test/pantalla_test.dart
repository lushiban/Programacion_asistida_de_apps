import 'package:divisor_cuenta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calcula 27.50 para 100, 4 personas y 10% de propina', (
    tester,
  ) async {
    await tester.pumpWidget(const DivisorCuentaApp());

    await tester.enterText(find.byKey(const Key('monto')), '100');
    await tester.enterText(find.byKey(const Key('personas')), '4');
    await tester.enterText(find.byKey(const Key('propina')), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets('muestra error para cero personas y oculta el resultado', (
    tester,
  ) async {
    await tester.pumpWidget(const DivisorCuentaApp());

    await tester.enterText(find.byKey(const Key('monto')), '50');
    await tester.enterText(find.byKey(const Key('personas')), '0');
    await tester.enterText(find.byKey(const Key('propina')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.text('Cada persona paga'), findsNothing);
  });

  testWidgets('muestra Monto inválido para un monto no numérico', (
    tester,
  ) async {
    await tester.pumpWidget(const DivisorCuentaApp());

    await tester.enterText(find.byKey(const Key('monto')), 'abc');
    await tester.enterText(find.byKey(const Key('personas')), '4');
    await tester.enterText(find.byKey(const Key('propina')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
