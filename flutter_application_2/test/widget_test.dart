import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/spotify_example_page.dart';

void main() {
  testWidgets('muestra la interfaz y el contador inicia en cero', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Contador'), findsOneWidget);
    expect(
      find.text('¿Cuántos gatos de 3 patas puedes contar?'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('incrementa y restablece el contador', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Incrementar contador'),
    );
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Restablecer contador'),
    );
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('abre la pantalla de Spotify y avisa si falta configuración', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Abrir ejemplo de Spotify'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ejemplo de Spotify'), findsOneWidget);
    expect(
      find.textContaining('Faltan las credenciales de Spotify'),
      findsOneWidget,
    );

    final searchButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Buscar canciones'),
    );
    expect(searchButton.onPressed, isNull);
  });

  testWidgets('muestra las canciones recibidas por el stream', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SpotifyExamplePage(
          searchTracks: (query) async {
            expect(query, 'love');
            return const [SpotifyTrackResult(title: 'Love', artist: 'Artista')];
          },
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Buscar canciones'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Love'), findsOneWidget);
    expect(find.text('Artista'), findsOneWidget);
    expect(find.text('Stream finalizado con 1 canción.'), findsOneWidget);
  });
}
