import 'package:flutter/material.dart';

import '../models/match_model.dart';

String matchDate(DateTime? date) {
  if (date == null) return 'Fecha no disponible';
  final local = date.toLocal();
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  String two(int n) => n.toString().padLeft(2, '0');
  return '${local.day} ${months[local.month - 1]} ${local.year} · '
      '${two(local.hour)}:${two(local.minute)}';
}

class MatchThumbnail extends StatelessWidget {
  const MatchThumbnail({super.key, required this.uri});
  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: const Center(child: Icon(Icons.sports_soccer, size: 48)),
    );
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: uri == null
          ? fallback
          : Image.network(
              uri.toString(),
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (_, error, stackTrace) => fallback,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : fallback,
            ),
    );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match, required this.onTap});
  final MatchModel match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 18),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: Color(0xFFE0E8D8)),
    ),
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MatchThumbnail(uri: match.thumbnail),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.competition ?? 'Competición no disponible',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  match.title,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(matchDate(match.date)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_outline, size: 22),
                    Text(
                      '${match.videos.length} ${match.videos.length == 1 ? 'video' : 'videos'}',
                    ),
                    const Text(
                      '· Ver partido',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
