import '../entities/estado_conexion.dart';
import '../repositories/conexion_repository.dart';

class ObservarConexion {
  const ObservarConexion(this._repository);

  final ConexionRepository _repository;

  Stream<EstadoConexion> call() {
    return _repository.observarCambios();
  }
}
