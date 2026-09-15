import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../widgets/match_card.dart';
import 'embedded_content_screen.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key, required this.match});
  final MatchModel match;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalle del partido')),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: MatchThumbnail(uri: match.thumbnail),
              ),
              const SizedBox(height: 24),
              if (match.competition != null)
                Text(
                  match.competition!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                match.title,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text('${matchDate(match.date)} · Hora local'),
              const SizedBox(height: 20),
              if (match.homeTeam != null)
                _TeamInfo(label: 'Local', team: match.homeTeam!),
              if (match.awayTeam != null)
                _TeamInfo(label: 'Visitante', team: match.awayTeam!),
              const SizedBox(height: 20),
              Text(
                'Videos y highlights',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                match.videos.isEmpty
                    ? 'No hay videos disponibles para este partido.'
                    : 'Mira cada video en el reproductor oficial dentro de la aplicación.',
              ),
              const SizedBox(height: 16),
              for (final (index, video) in match.videos.indexed)
                Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${index + 1}. ${video.title}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: video.playerUri == null
                              ? null
                              : () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => EmbeddedContentScreen(
                                      title: video.title,
                                      uri: video.playerUri!,
                                    ),
                                  ),
                                ),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(
                            video.playerUri == null
                                ? 'Video no disponible'
                                : 'Ver video',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (match.matchviewUrl != null)
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EmbeddedContentScreen(
                        title: 'Estadísticas · ${match.title}',
                        uri: match.matchviewUrl!,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Ver estadísticas del partido'),
                ),
              if (match.competitionUrl != null)
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EmbeddedContentScreen(
                        title: match.competition ?? 'Competición',
                        uri: match.competitionUrl!,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('Explorar competición'),
                ),
              const SizedBox(height: 20),
              const Text(
                'Contenido proporcionado por ScoreBat.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _TeamInfo extends StatelessWidget {
  const _TeamInfo({required this.label, required this.team});
  final String label;
  final TeamModel team;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    child: ListTile(
      leading: const Icon(Icons.shield_outlined),
      title: Text(team.name ?? 'Nombre no disponible'),
      subtitle: Text(label),
    ),
  );
}
