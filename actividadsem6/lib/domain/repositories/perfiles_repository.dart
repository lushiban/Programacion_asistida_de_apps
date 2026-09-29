import 'package:actividadsem6/domain/entities/perfil.dart';

abstract class PerfilesRepository {
  Future<void> crear(String id, String nombre);

  Future<List<Perfil>> obtenerTodos();
}
