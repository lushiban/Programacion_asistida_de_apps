import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(this._obtenerContador, this._incrementar, this._decrementar)
    : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> cargar() async {
    final resultado = await _obtenerContador();
    emit(resultado);
  }

  Future<void> incrementar() async {
    final resultado = await _incrementar();
    emit(resultado);
  }

  Future<void> decrementar() async {
    final resultado = await _decrementar();
    emit(resultado);
  }
}

class ContadorBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    if (bloc is ContadorCubit) {
      debugPrint(
        '${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}',
      );
    }
  }
}
