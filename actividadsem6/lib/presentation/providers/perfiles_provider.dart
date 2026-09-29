import 'package:actividadsem6/domain/entities/perfil.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';
import 'package:flutter/foundation.dart';

class PerfilesProvider extends ChangeNotifier {
  PerfilesProvider(this._perfilesRepository);

  final PerfilesRepository _perfilesRepository;

  List<Perfil> _perfiles = const [];
  bool _cargando = false;
  String? _error;
  bool _disposed = false;

  List<Perfil> get perfiles => List.unmodifiable(_perfiles);
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargar() async {
    if (_cargando || _disposed) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _perfiles = await _perfilesRepository.obtenerTodos();
    } catch (excepcion) {
      _error = excepcion.toString();
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
