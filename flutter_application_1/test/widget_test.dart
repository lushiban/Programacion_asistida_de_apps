// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/ver_imagen_jpg.dart';

void main() {
  testWidgets('Image navigation preserves state and blocks system back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final incrementButton = find.widgetWithText(
      ElevatedButton,
      'Incrementar contador',
    );
    await tester.ensureVisible(incrementButton);
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();

    await tester.tap(find.text('ver imagen'));
    await tester.pumpAndSettle();

    expect(find.byType(VerImagenJPG), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/images/buho_mojado.jpg',
    );
    expect(tester.takeException(), isNull);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(VerImagenJPG), findsOneWidget);

    await tester.tap(find.byTooltip('Volver a la pantalla principal'));
    await tester.pumpAndSettle();
    expect(find.byType(VerImagenJPG), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('ver imagen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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
