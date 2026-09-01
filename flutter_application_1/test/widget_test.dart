// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Counter increments and decrements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the increment button and trigger a frame.
    final incrementButton = find.widgetWithText(
      ElevatedButton,
      'Incrementar contador',
    );
    await tester.ensureVisible(incrementButton);
    await tester.tap(incrementButton);
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // Tap the decrement button and trigger a frame.
    final decrementButton = find.widgetWithText(
      ElevatedButton,
      'Disminuir contador',
    );
    await tester.ensureVisible(decrementButton);
    await tester.tap(decrementButton);
    await tester.pump();

    // Verify that our counter has decremented.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
