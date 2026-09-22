import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this._usuarioRepository);

  final UsuarioRepository _usuarioRepository;

  Future<List<Usuario>> ejecutar() async {
    final usuarios = await _usuarioRepository.obtener();

    return usuarios.where((usuario) {
      final nombre = usuario.nombre.trimLeft();

      return nombre.isNotEmpty && 'AEIOU'.contains(nombre[0].toUpperCase());
    }).toList();
  }
}
