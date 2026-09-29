import '../entities/estado_conexion.dart';
import '../repositories/conexion_repository.dart';

class ConsultarConexion {
  const ConsultarConexion(this._repository);

  final ConexionRepository _repository;

  Future<EstadoConexion> call() {
    return _repository.consultarAhora();
  }
}
