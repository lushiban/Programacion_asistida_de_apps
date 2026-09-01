import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:probador_de_aplicaciones/main.dart';

void main() {
  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.widgetWithText(ElevatedButton, text));
    await tester.pump();
  }

  Finder displayWithText(String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.key == const Key('display') &&
          widget.data == text,
    );
  }

  testWidgets('suma dos numeros y muestra el resultado', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.byKey(const Key('display')), findsOneWidget);
    expect(displayWithText('0'), findsOneWidget);

    await tapText(tester, '7');
    await tapText(tester, '+');
    await tapText(tester, '5');
    await tapText(tester, '=');

    expect(find.text('12'), findsOneWidget);
    expect(find.text('7 + 5 ='), findsOneWidget);
  });

  testWidgets('muestra error al dividir entre cero', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapText(tester, '8');
    await tapText(tester, '÷');
    await tapText(tester, '0');
    await tapText(tester, '=');

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('No se puede dividir entre cero'), findsOneWidget);
  });

  testWidgets('AC restablece la calculadora', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapText(tester, '9');
    await tapText(tester, 'AC');

    expect(displayWithText('0'), findsOneWidget);
    expect(find.text('Lista para calcular'), findsOneWidget);
  });
}
