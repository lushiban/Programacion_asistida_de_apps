import 'package:actividadsem6/domain/entities/registro_prueba.dart';
import 'package:actividadsem6/domain/repositories/registros_prueba_repository.dart';

class ObtenerRegistrosPrueba {
  const ObtenerRegistrosPrueba(this._repository);

  final RegistrosPruebaRepository _repository;

  Future<List<RegistroPrueba>> call() {
    return _repository.obtenerTodos();
  }
}
