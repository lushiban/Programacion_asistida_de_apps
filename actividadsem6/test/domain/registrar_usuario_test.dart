import 'package:actividadsem6/domain/entities/perfil.dart';
import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';
import 'package:actividadsem6/domain/usecases/registrar_usuario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registra la cuenta y crea el perfil con el ID devuelto', () async {
    final pasos = <String>[];
    final auth = _AuthRepositoryFalso(pasos);
    final perfiles = _PerfilesRepositoryFalso(pasos);

    await RegistrarUsuario(auth, perfiles)(
      'usuario@ejemplo.com',
      'clave-de-prueba',
      'Ana',
    );

    expect(pasos, ['registrar', 'crear']);
    expect(auth.correoRecibido, 'usuario@ejemplo.com');
    expect(auth.claveRecibida, 'clave-de-prueba');
    expect(perfiles.idRecibido, 'usuario-123');
    expect(perfiles.nombreRecibido, 'Ana');
  });

  test('propaga el error si falla la creación del perfil', () async {
    final pasos = <String>[];
    final errorOriginal = StateError('Falló la inserción');
    final perfiles = _PerfilesRepositoryFalso(
      pasos,
      errorAlCrear: errorOriginal,
    );

    await expectLater(
      RegistrarUsuario(_AuthRepositoryFalso(pasos), perfiles)(
        'usuario@ejemplo.com',
        'clave-de-prueba',
        'Ana',
      ),
      throwsA(same(errorOriginal)),
    );
    expect(pasos, ['registrar', 'crear']);
  });
}

class _AuthRepositoryFalso implements AuthRepository {
  _AuthRepositoryFalso(this.pasos);

  final List<String> pasos;
  String? correoRecibido;
  String? claveRecibida;

  @override
  Future<String> registrar(String correo, String clave) async {
    pasos.add('registrar');
    correoRecibido = correo;
    claveRecibida = clave;
    return 'usuario-123';
  }

  @override
  Future<void> ingresar(String correo, String clave) async {}

  @override
  Future<void> salir() async {}

  @override
  String? obtenerIdActual() => null;
}

class _PerfilesRepositoryFalso implements PerfilesRepository {
  _PerfilesRepositoryFalso(this.pasos, {this.errorAlCrear});

  final List<String> pasos;
  final Object? errorAlCrear;
  String? idRecibido;
  String? nombreRecibido;

  @override
  Future<void> crear(String id, String nombre) async {
    pasos.add('crear');
    idRecibido = id;
    nombreRecibido = nombre;
    if (errorAlCrear != null) throw errorAlCrear!;
  }

  @override
  Future<List<Perfil>> obtenerTodos() async => [];
}
