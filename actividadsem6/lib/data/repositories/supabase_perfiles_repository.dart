import 'package:actividadsem6/domain/entities/perfil.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePerfilesRepository implements PerfilesRepository {
  @override
  Future<void> crear(String id, String nombre) async {
    await Supabase.instance.client.from('perfiles').insert({
      'id': id,
      'nombre': nombre,
    });
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    final rows = await Supabase.instance.client
        .from('perfiles')
        .select('id, nombre, creado_en');

    return rows
        .map(
          (row) => Perfil(
            id: row['id'] as String,
            nombre: row['nombre'] as String,
            creadoEn: DateTime.parse(row['creado_en'] as String),
          ),
        )
        .toList(growable: false);
  }
}
