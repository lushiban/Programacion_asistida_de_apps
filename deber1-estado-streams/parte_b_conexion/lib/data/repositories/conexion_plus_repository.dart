import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<EstadoConexion> consultarAhora() async {
    final resultados = await _connectivity.checkConnectivity();
    return _traducir(resultados);
  }

  @override
  Stream<EstadoConexion> observarCambios() {
    return _connectivity.onConnectivityChanged.map(_traducir);
  }

  EstadoConexion _traducir(List<ConnectivityResult> resultados) {
    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }

    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }

    if (resultados.isEmpty ||
        resultados.every((resultado) => resultado == ConnectivityResult.none)) {
      return EstadoConexion.sinConexion;
    }

    return EstadoConexion.otro;
  }
}
