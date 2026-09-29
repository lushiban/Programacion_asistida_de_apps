import 'package:actividadsem6/domain/entities/registro_prueba.dart';
import 'package:actividadsem6/domain/repositories/registros_prueba_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRegistrosPruebaRepository implements RegistrosPruebaRepository {
  const SupabaseRegistrosPruebaRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<RegistroPrueba>> obtenerTodos() async {
    final rows = await _client
        .from('Tabla_prueba')
        .select('id, created_at')
        .order('id');

    return rows
        .map((row) {
          final id = row['id'];
          final createdAt = row['created_at'];
          if (id is! int || (createdAt != null && createdAt is! String)) {
            throw const FormatException(
              'El registro no tiene el formato esperado.',
            );
          }

          return RegistroPrueba(
            id: id,
            creadoEn: createdAt == null
                ? null
                : DateTime.parse(createdAt as String),
          );
        })
        .toList(growable: false);
  }
}
