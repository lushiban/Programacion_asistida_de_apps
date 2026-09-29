import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultarConexion, this._observarConexion)
    : super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;

  StreamSubscription<EstadoConexion>? _sub;

  Future<void> iniciar() async {
    final estadoActual = await _consultarConexion();

    if (isClosed) {
      return;
    }

    emit(estadoActual);
    _sub = _observarConexion().listen((nuevoEstado) {
      if (!isClosed) {
        emit(nuevoEstado);
      }
    });
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await super.close();
  }
}
