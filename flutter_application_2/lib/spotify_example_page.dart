import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

const _spotifyClientId = String.fromEnvironment('SPOTIFY_CLIENT_ID');
const _spotifyClientSecret = String.fromEnvironment('SPOTIFY_CLIENT_SECRET');

typedef SpotifyTrackSearch = Future<List<SpotifyTrackResult>> Function(
  String query,
);

@immutable
class SpotifyTrackResult {
  const SpotifyTrackResult({required this.title, required this.artist});

  final String title;
  final String artist;
}

class SpotifyExamplePage extends StatefulWidget {
  const SpotifyExamplePage({super.key, this.searchTracks});

  /// Permite reemplazar la llamada real a Spotify durante las pruebas.
  final SpotifyTrackSearch? searchTracks;

  @override
  State<SpotifyExamplePage> createState() => _SpotifyExamplePageState();
}

class _SpotifyExamplePageState extends State<SpotifyExamplePage> {
  final TextEditingController _queryController = TextEditingController(
    text: 'love',
  );
  final List<SpotifyTrackResult> _tracks = [];

  Timer? _secondsTimer;
  Timer? _timeoutTimer;
  StreamController<SpotifyTrackResult>? _streamController;
  StreamSubscription<SpotifyTrackResult>? _subscription;

  late String _statusMessage;
  String? _errorMessage;
  int _seconds = 0;
  int _searchId = 0;
  bool _isSearching = false;

  bool get _hasCredentials =>
      _spotifyClientId.isNotEmpty && _spotifyClientSecret.isNotEmpty;

  bool get _canSearch => widget.searchTracks != null || _hasCredentials;

  @override
  void initState() {
    super.initState();
    _statusMessage = _canSearch
        ? 'Escribe una palabra y comienza la búsqueda.'
        : 'Configura las credenciales para habilitar la búsqueda.';
  }

  Future<List<SpotifyTrackResult>> _searchSpotify(String query) async {
    final credentials = SpotifyApiCredentials(
      _spotifyClientId,
      _spotifyClientSecret,
    );
    final spotify = SpotifyApi(credentials);
    final pages = await spotify.search
        .get(query, types: [SearchType.track])
        .first(50);

    final results = <SpotifyTrackResult>[];

    for (final page in pages) {
      final items = page.items;
      if (items == null) {
        continue;
      }

      for (final item in items) {
        if (item is! Track) {
          continue;
        }

        final title = item.name?.trim();
        final artist =
            item.artists
                ?.map((artist) => artist.name)
                .whereType<String>()
                .map((name) => name.trim())
                .where((name) => name.isNotEmpty)
                .join(', ') ??
            '';

        if (title == null ||
            title.isEmpty ||
            title.length >= 10 ||
            artist.isEmpty) {
          continue;
        }

        results.add(SpotifyTrackResult(title: title, artist: artist));
      }
    }

    return results;
  }

  Future<void> _fetchTracks() async {
    final query = _queryController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Escribe una palabra para buscar canciones.';
      });
      return;
    }

    if (!_canSearch) {
      setState(() {
        _errorMessage = 'Faltan las credenciales de Spotify.';
      });
      return;
    }

    await _cancelCurrentSearch(showMessage: false);

    final searchId = ++_searchId;
    final controller = StreamController<SpotifyTrackResult>();
    _streamController = controller;

    setState(() {
      _tracks.clear();
      _seconds = 0;
      _errorMessage = null;
      _isSearching = true;
      _statusMessage = 'Buscando canciones con “$query”…';
    });

    _subscription = controller.stream.listen(
      (track) {
        if (!mounted || searchId != _searchId) {
          return;
        }

        setState(() {
          _tracks.add(track);
          _statusMessage = 'Canciones recibidas: ${_tracks.length}';
        });
      },
      onError: (Object error) {
        if (!mounted || searchId != _searchId) {
          return;
        }

        setState(() {
          _errorMessage = _friendlyError(error);
          _statusMessage = 'La búsqueda no pudo completarse.';
        });
      },
      onDone: () {
        if (!mounted || searchId != _searchId) {
          return;
        }

        _secondsTimer?.cancel();
        _timeoutTimer?.cancel();
        _streamController = null;
        _subscription = null;

        setState(() {
          _isSearching = false;
          if (_errorMessage == null) {
            _statusMessage = _tracks.isEmpty
                ? 'La búsqueda terminó sin canciones de menos de 10 caracteres.'
                : 'Stream finalizado con ${_songCount(_tracks.length)}.';
          }
        });
      },
    );

    _startTimers(controller, searchId);

    try {
      final search = widget.searchTracks ?? _searchSpotify;
      final results = await search(query);

      for (final track in results) {
        await Future<void>.delayed(const Duration(seconds: 3));

        if (searchId != _searchId || controller.isClosed) {
          return;
        }

        controller.add(track);
      }

      if (!controller.isClosed) {
        await controller.close();
      }
    } catch (error) {
      if (searchId == _searchId && !controller.isClosed) {
        controller.addError(error);
        await controller.close();
      }
    }
  }

  void _startTimers(
    StreamController<SpotifyTrackResult> controller,
    int searchId,
  ) {
    _secondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || searchId != _searchId || controller.isClosed) {
        timer.cancel();
        return;
      }

      setState(() {
        _seconds++;
      });
    });

    _timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (searchId == _searchId && !controller.isClosed) {
        unawaited(controller.close());
      }
    });
  }

  String _friendlyError(Object error) {
    if (error is SpotifyException) {
      return 'Spotify respondió con un error: ${error.message}';
    }

    return 'Ocurrió un error al consultar Spotify. Revisa las credenciales y la conexión.';
  }

  String _songCount(int count) =>
      '$count ${count == 1 ? 'canción' : 'canciones'}';

  Future<void> _cancelCurrentSearch({required bool showMessage}) async {
    _searchId++;
    _secondsTimer?.cancel();
    _timeoutTimer?.cancel();

    final subscription = _subscription;
    final controller = _streamController;
    _subscription = null;
    _streamController = null;

    await subscription?.cancel();
    if (controller != null && !controller.isClosed) {
      await controller.close();
    }

    if (mounted && showMessage) {
      setState(() {
        _isSearching = false;
        _statusMessage = 'Búsqueda detenida a los $_seconds segundos.';
      });
    }
  }

  @override
  void dispose() {
    _searchId++;
    _secondsTimer?.cancel();
    _timeoutTimer?.cancel();
    unawaited(_subscription?.cancel());

    final controller = _streamController;
    if (controller != null && !controller.isClosed) {
      unawaited(controller.close());
    }

    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo de Spotify'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              Icons.music_note,
              size: 72,
              color: colorScheme.primary,
              semanticLabel: 'Nota musical',
            ),
            const SizedBox(height: 12),
            Text(
              'Búsqueda de canciones con Stream',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Se consultan hasta 50 resultados, se conservan los títulos de '
              'menos de 10 caracteres y se muestran cada 3 segundos.',
              textAlign: TextAlign.center,
            ),
            if (!_canSearch) ...[
              const SizedBox(height: 20),
              Card(
                color: colorScheme.errorContainer,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Faltan las credenciales de Spotify. Copia el archivo de '
                    'ejemplo, agrega tus credenciales y ejecuta Flutter con '
                    '--dart-define-from-file=spotify_credentials.json.',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _queryController,
              enabled: !_isSearching,
              textInputAction: TextInputAction.search,
              onSubmitted: _canSearch && !_isSearching
                  ? (_) => _fetchTracks()
                  : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Palabra de búsqueda',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: !_canSearch
                    ? null
                    : _isSearching
                    ? () => _cancelCurrentSearch(showMessage: true)
                    : _fetchTracks,
                icon: Icon(_isSearching ? Icons.stop : Icons.search),
                label: Text(
                  _isSearching ? 'Detener búsqueda' : 'Buscar canciones',
                ),
              ),
            ),
            if (_isSearching) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: 8),
                Text('Tiempo: $_seconds segundos'),
              ],
            ),
            const SizedBox(height: 8),
            Text(_statusMessage, textAlign: TextAlign.center),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              Card(
                color: colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(error),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_tracks.isEmpty && !_isSearching && _errorMessage == null)
              const Text(
                'Todavía no hay canciones para mostrar.',
                textAlign: TextAlign.center,
              )
            else
              ..._tracks.map(
                (track) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.audiotrack),
                    title: Text(track.title),
                    subtitle: Text(track.artist),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
