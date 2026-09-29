import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:actividadsem6/domain/usecases/registrar_usuario.dart';
import 'package:flutter/foundation.dart';

class SesionProvider extends ChangeNotifier {
  SesionProvider(this._authRepository, this._registrarUsuario)
    : _idUsuario = _authRepository.obtenerIdActual();

  final AuthRepository _authRepository;
  final RegistrarUsuario _registrarUsuario;

  String? _idUsuario;
  bool _cargando = false;
  String? _error;
  bool _disposed = false;

  String? get idUsuario => _idUsuario;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> registrar(String correo, String clave, String nombre) async {
    if (_cargando || _disposed) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _registrarUsuario(correo, clave, nombre);
      final id = _authRepository.obtenerIdActual();
      if (id == null) {
        throw StateError('No hay una sesión activa después del registro.');
      }
      _idUsuario = id;
    } catch (excepcion) {
      _error = excepcion.toString();
    } finally {
      _cargando = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> ingresar(String correo, String clave) async {
    if (_cargando || _disposed) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.ingresar(correo, clave);
      final id = _authRepository.obtenerIdActual();
      if (id == null) {
        throw StateError('No se pudo obtener el usuario después de ingresar.');
      }
      _idUsuario = id;
    } catch (excepcion) {
      _error = excepcion.toString();
    } finally {
      _cargando = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> salir() async {
    if (_cargando || _disposed) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.salir();
      _idUsuario = null;
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
