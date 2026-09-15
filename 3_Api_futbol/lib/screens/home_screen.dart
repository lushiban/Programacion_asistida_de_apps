import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../services/scorebat_service.dart';
import '../widgets/feed_message.dart';
import '../widgets/match_card.dart';
import 'counter_screen.dart';
import 'match_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.service});
  final ScorebatService? service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScorebatService _service;
  final _search = TextEditingController();
  ScorebatFeed? _feed;
  String? _error;
  String? _competition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? ScorebatService();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final feed = await _service.fetchMatches();
      if (!mounted) return;
      setState(() {
        _feed = feed;
        if (!feed.matches.any((m) => m.competition == _competition)) {
          _competition = null;
        }
      });
    } on ScorebatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    if (widget.service == null) _service.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = _feed?.matches ?? <MatchModel>[];
    final competitions =
        all.map((m) => m.competition).whereType<String>().toSet().toList()
          ..sort();
    final query = _search.text.trim().toLowerCase();
    final matches = all
        .where(
          (m) =>
              (_competition == null || m.competition == _competition) &&
              m.searchableText.contains(query),
        )
        .toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CANCHA',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar partidos',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            tooltip: 'Más opciones',
            onSelected: (_) => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MyHomePage(title: 'Contador original'),
              ),
            ),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'counter', child: Text('Contador original')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: RefreshIndicator(
              onRefresh: () async {
                if (!_loading) await _load();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'El fútbol, a tu ritmo.',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Partidos y momentos para volver a ver.\nVideos e información de ScoreBat.',
                          ),
                          const SizedBox(height: 22),
                          if (_feed?.warning != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEEC7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Aviso de la fuente',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (_feed!.warning!.contains('deprecated'))
                                    const Text(
                                      'Este feed es histórico y dejó de actualizarse. '
                                      'Los partidos mostrados no son un calendario actual.',
                                    ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    title: const Text('Ver aviso de ScoreBat'),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Text(_feed!.warning!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Buscar equipo o partido',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _search.text.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Borrar búsqueda',
                                      icon: const Icon(Icons.close),
                                      onPressed: () => setState(_search.clear),
                                    ),
                            ),
                          ),
                          if (competitions.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              key: ValueKey(_competition),
                              initialValue: _competition ?? '',
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Competición',
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: '',
                                  child: Text('Todas las competiciones'),
                                ),
                                ...competitions.map(
                                  (name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) => setState(
                                () => _competition = value == '' ? null : value,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            'Partidos${_feed == null ? '' : ' · ${matches.length}'}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          const Text('Fechas en tu hora local'),
                          const SizedBox(height: 16),
                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.all(36),
                              child: Center(
                                child: CircularProgressIndicator(
                                  semanticsLabel: 'Cargando partidos',
                                ),
                              ),
                            ),
                          if (!_loading && _error != null)
                            FeedMessage(
                              icon: Icons.wifi_off_rounded,
                              title: 'No pudimos actualizar los partidos',
                              message: _error!,
                              onRetry: _load,
                            ),
                          if (!_loading && _error == null && matches.isEmpty)
                            FeedMessage(
                              icon: Icons.sports_soccer,
                              title: all.isEmpty
                                  ? 'Todavía no hay partidos'
                                  : 'Sin coincidencias',
                              message: all.isEmpty
                                  ? 'ScoreBat no devolvió partidos. Puedes actualizar más tarde.'
                                  : 'Prueba con otro equipo o cambia la competición.',
                              action: all.isEmpty
                                  ? 'Actualizar'
                                  : 'Limpiar filtros',
                              onRetry: all.isEmpty
                                  ? _load
                                  : () => setState(() {
                                      _competition = null;
                                      _search.clear();
                                    }),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // SliverList crea las tarjetas según entran en pantalla; el feed
                  // no proporciona paginación y no se inventan páginas adicionales.
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, index) => MatchCard(
                        match: matches[index],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                MatchDetailScreen(match: matches[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
