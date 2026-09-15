import 'package:html/parser.dart' show parseFragment;

String? textValue(dynamic value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

Uri? webUri(dynamic value) {
  final text = textValue(value);
  if (text == null) return null;
  final uri = Uri.tryParse(text.startsWith('//') ? 'https:$text' : text);
  return uri != null &&
          uri.host.isNotEmpty &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          uri.userInfo.isEmpty
      ? uri
      : null;
}

class TeamModel {
  const TeamModel({this.name, this.slug, this.id});
  final String? name;
  final String? slug;
  final String? id;

  static TeamModel? fromJson(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    return TeamModel(
      name: textValue(value['name']),
      slug: textValue(value['slug']),
      id: value['id']?.toString(),
    );
  }
}

class VideoModel {
  const VideoModel({required this.title, required this.embed, this.id});
  final String title;
  final String embed;
  final String? id;

  // El campo embed es HTML. El parser también decodifica &amp; en el src.
  // No ejecutamos el HTML recibido ni lo interpretamos como un archivo MP4.
  Uri? get playerUri =>
      webUri(parseFragment(embed).querySelector('iframe')?.attributes['src']);

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    title: textValue(json['title']) ?? 'Video',
    embed: textValue(json['embed']) ?? '',
    id: json['id']?.toString(),
  );
}

class MatchModel {
  const MatchModel({
    required this.title,
    required this.videos,
    this.competition,
    this.date,
    this.thumbnail,
    this.homeTeam,
    this.awayTeam,
    this.matchviewUrl,
    this.competitionUrl,
  });
  final String title;
  final String? competition;
  final DateTime? date;
  final Uri? thumbnail;
  final TeamModel? homeTeam;
  final TeamModel? awayTeam;
  final Uri? matchviewUrl;
  final Uri? competitionUrl;
  final List<VideoModel> videos;

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    title: textValue(json['title']) ?? 'Partido sin título',
    competition: textValue(json['competition']),
    date: DateTime.tryParse(textValue(json['date']) ?? ''),
    thumbnail: webUri(json['thumbnail']),
    homeTeam: TeamModel.fromJson(json['homeTeam']),
    awayTeam: TeamModel.fromJson(json['awayTeam']),
    matchviewUrl: webUri(json['matchviewUrl']),
    competitionUrl: webUri(json['competitionUrl']),
    videos: json['videos'] is List
        ? (json['videos'] as List)
              .whereType<Map<String, dynamic>>()
              .map(VideoModel.fromJson)
              .toList(growable: false)
        : const [],
  );

  String get searchableText =>
      '$title ${competition ?? ''} ${homeTeam?.name ?? ''} ${awayTeam?.name ?? ''}'
          .toLowerCase();
}

class ScorebatFeed {
  const ScorebatFeed({required this.matches, this.warning});
  final List<MatchModel> matches;
  final String? warning;

  factory ScorebatFeed.fromJson(dynamic json) {
    if (json is! Map<String, dynamic> || json['response'] is! List) {
      throw const FormatException('Respuesta de ScoreBat no válida');
    }
    final rows = json['response'] as List;
    if (rows.any((row) => row is! Map<String, dynamic>)) {
      throw const FormatException('Lista de partidos no válida');
    }
    return ScorebatFeed(
      matches: rows
          .cast<Map<String, dynamic>>()
          .map(MatchModel.fromJson)
          .toList(growable: false),
      warning: textValue(json['warning']),
    );
  }
}
