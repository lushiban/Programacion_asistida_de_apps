import 'package:actividadsem6/domain/entities/registro_prueba.dart';
import 'package:actividadsem6/domain/usecases/obtener_registros_prueba.dart';
import 'package:flutter/foundation.dart';

class RegistrosPruebaProvider extends ChangeNotifier {
  RegistrosPruebaProvider(this._obtenerRegistros);

  final ObtenerRegistrosPrueba _obtenerRegistros;

  List<RegistroPrueba> _registros = const [];
  bool _cargando = false;
  String? _error;
  bool _disposed = false;

  List<RegistroPrueba> get registros => List.unmodifiable(_registros);
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargar() async {
    if (_cargando || _disposed) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _registros = await _obtenerRegistros();
    } catch (_) {
      _registros = const [];
      _error = 'No se pudieron cargar los registros. Inténtalo de nuevo.';
    } finally {
      _cargando = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
