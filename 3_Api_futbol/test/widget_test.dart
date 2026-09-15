import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:probador_de_aplicaciones_2/models/match_model.dart';
import 'package:probador_de_aplicaciones_2/screens/home_screen.dart';
import 'package:probador_de_aplicaciones_2/services/scorebat_service.dart';

// Datos de prueba controlados: nunca se usan como contenido de la aplicación.
Map<String, dynamic> fixture() => {
  'response': [
    {
      'title': 'Angers - PSG',
      'competition': 'FRANCE: Ligue 1',
      'date': '2026-04-25T12:00:00-05:00',
      'matchviewUrl': 'https://www.scorebat.com/embed/matchview/1730931/',
      'homeTeam': {'name': 'Angers'},
      'awayTeam': {'name': 'PSG'},
      'videos': [
        {
          'title': 'Highlights',
          'embed': '<iframe src="https://www.scorebat.com/embed/v/one/?a=1&amp;b=2"></iframe>',
        },
        {
          'title': 'Segundo video',
          'embed':
              '<iframe src="https://www.scorebat.com/embed/v/two/"></iframe>',
        },
      ],
    },
  ],
};

void main() {
  test('Interpreta equipos, fechas e iframe HTML', () {
    final match = ScorebatFeed.fromJson(fixture()).matches.single;
    expect(match.homeTeam?.name, 'Angers');
    expect(match.date?.toUtc().hour, 17);
    expect(match.videos.length, 2);
    expect(match.videos.first.playerUri?.queryParameters['b'], '2');
    expect(match.matchviewUrl?.path, '/embed/matchview/1730931/');
    expect(
      const VideoModel(
        title: '',
        embed: '<iframe src="javascript:alert(1)"></iframe>',
      ).playerUri,
      isNull,
    );
    expect(MatchModel.fromJson({}).videos, isEmpty);
    expect(
      () => ScorebatFeed.fromJson({'error': 'denied'}),
      throwsFormatException,
    );
  });

  test('Controla estados HTTP y JSON inválido', () async {
    for (final status in [401, 403, 429, 500]) {
      final service = ScorebatService(
        client: MockClient((_) async => http.Response('', status)),
      );
      await expectLater(
        service.fetchMatches(),
        throwsA(isA<ScorebatException>()),
      );
      service.close();
    }
    final service = ScorebatService(
      client: MockClient((_) async => http.Response('<html>', 200)),
    );
    await expectLater(
      service.fetchMatches(),
      throwsA(isA<ScorebatException>()),
    );
    service.close();
  });

  test('Timeout y configuración de token externo', () async {
    final service = ScorebatService(
      token: 'test-only',
      timeout: const Duration(milliseconds: 1),
      client: MockClient((_) => Completer<http.Response>().future),
    );
    expect(service.endpoint.path, '/video-api/v3/free-feed/');
    expect(service.endpoint.queryParameters['token'], 'test-only');
    await expectLater(
      service.fetchMatches(),
      throwsA(isA<ScorebatException>()),
    );
    service.close();
  });

  testWidgets('Carga, lista, búsqueda y detalle en móvil estrecho', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final response = Completer<http.Response>();
    final service = ScorebatService(client: MockClient((_) => response.future));
    addTearDown(service.close);
    await tester.pumpWidget(MaterialApp(home: HomeScreen(service: service)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    response.complete(http.Response(jsonEncode(fixture()), 200));
    await tester.pumpAndSettle();
    expect(find.text('Angers - PSG'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'inexistente');
    await tester.pumpAndSettle();
    expect(find.text('Sin coincidencias'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'PSG');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Angers - PSG'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Angers - PSG'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle del partido'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('2. Segundo video'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('2. Segundo video'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Ver estadísticas del partido'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ver estadísticas del partido'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('CANCHA'), findsOneWidget);
  });

  testWidgets('Error permite reintentar y mostrar feed vacío', (tester) async {
    var requests = 0;
    final service = ScorebatService(
      client: MockClient((_) async {
        requests++;
        return requests == 1
            ? http.Response('', 500)
            : http.Response('{"response":[]}', 200);
      }),
    );
    addTearDown(service.close);
    await tester.pumpWidget(MaterialApp(home: HomeScreen(service: service)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Volver a intentar'));
    await tester.tap(find.text('Volver a intentar'));
    await tester.pumpAndSettle();
    expect(find.text('Todavía no hay partidos'), findsOneWidget);
  });

  testWidgets('El contador original sigue funcionando', (tester) async {
    final service = ScorebatService(
      client: MockClient((_) async => http.Response('{"response":[]}', 200)),
    );
    addTearDown(service.close);
    await tester.pumpWidget(MaterialApp(home: HomeScreen(service: service)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más opciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contador original'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
