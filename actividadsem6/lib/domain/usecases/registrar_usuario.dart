import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';

class RegistrarUsuario {
  const RegistrarUsuario(this._authRepository, this._perfilesRepository);

  final AuthRepository _authRepository;
  final PerfilesRepository _perfilesRepository;

  Future<void> call(String correo, String clave, String nombre) async {
    final id = await _authRepository.registrar(correo, clave);
    await _perfilesRepository.crear(id, nombre);
  }
}
