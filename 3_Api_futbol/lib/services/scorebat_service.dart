import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/match_model.dart';

class ScorebatException implements Exception {
  const ScorebatException(this.message);
  final String message;
}

class ScorebatService {
  ScorebatService({
    http.Client? client,
    String? token,
    String? endpoint,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client(),
       _token = token ?? const String.fromEnvironment('SCOREBAT_TOKEN'),
       _endpoint =
           endpoint ?? const String.fromEnvironment('SCOREBAT_ENDPOINT');

  final http.Client _client;
  final String _token;
  final String _endpoint;
  final Duration timeout;

  Uri get endpoint {
    // Sin token se conserva la dirección solicitada (feed histórico).
    final base = Uri.parse(
      _endpoint.isNotEmpty
          ? _endpoint
          : _token.isEmpty
          ? 'https://www.scorebat.com/video-api/v3/'
          : 'https://www.scorebat.com/video-api/v3/free-feed/',
    );
    return _token.isEmpty
        ? base
        : base.replace(
            queryParameters: {...base.queryParameters, 'token': _token},
          );
  }

  Future<ScorebatFeed> fetchMatches() async {
    try {
      final result = await _client.get(endpoint).timeout(timeout);
      if (result.statusCode == 401 || result.statusCode == 403) {
        throw const ScorebatException(
          'ScoreBat no autorizó el acceso. Revisa el token y el plan de la API.',
        );
      }
      if (result.statusCode == 429) {
        throw const ScorebatException(
          'Se alcanzó el límite de consultas. Vuelve a intentarlo más tarde.',
        );
      }
      if (result.statusCode != 200) {
        throw const ScorebatException(
          'ScoreBat no está disponible en este momento. Inténtalo de nuevo.',
        );
      }
      return ScorebatFeed.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } on ScorebatException {
      rethrow;
    } on TimeoutException {
      throw const ScorebatException(
        'La consulta tardó demasiado. Revisa tu conexión y vuelve a intentar.',
      );
    } on FormatException {
      throw const ScorebatException(
        'ScoreBat devolvió una respuesta que no se puede leer. Inténtalo después.',
      );
    } catch (_) {
      // No exponemos URLs con tokens ni detalles internos de la petición.
      throw const ScorebatException(
        'No se pudo conectar con ScoreBat. Revisa tu conexión a Internet.',
      );
    }
  }

  void close() => _client.close();
}
