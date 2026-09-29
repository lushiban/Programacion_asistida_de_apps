import 'dart:async';

import 'package:actividadsem6/domain/entities/perfil.dart';
import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';
import 'package:actividadsem6/domain/usecases/registrar_usuario.dart';
import 'package:actividadsem6/presentation/providers/perfiles_provider.dart';
import 'package:actividadsem6/presentation/providers/sesion_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SesionProvider notifica al ingresar y salir', () async {
    final auth = _AuthFalso();
    final perfiles = _PerfilesFalso();
    final provider = SesionProvider(auth, RegistrarUsuario(auth, perfiles));
    addTearDown(provider.dispose);
    final estados = <bool>[];
    provider.addListener(() => estados.add(provider.cargando));

    final ingreso = provider.ingresar('ana@ejemplo.com', 'clave');
    expect(provider.cargando, isTrue);
    await ingreso;
    expect(provider.idUsuario, 'usuario-123');
    expect(provider.error, isNull);

    await provider.salir();
    expect(provider.idUsuario, isNull);
    expect(provider.cargando, isFalse);
    expect(estados, [true, false, true, false]);
  });

  test('SesionProvider guarda el error si falla crear el perfil', () async {
    final auth = _AuthFalso();
    final perfiles = _PerfilesFalso()
      ..errorAlCrear = StateError('No se pudo insertar');
    final provider = SesionProvider(auth, RegistrarUsuario(auth, perfiles));
    addTearDown(provider.dispose);
    var avisos = 0;
    provider.addListener(() => avisos++);

    await provider.registrar('ana@ejemplo.com', 'clave', 'Ana');

    expect(perfiles.idCreado, 'usuario-123');
    expect(provider.error, contains('No se pudo insertar'));
    expect(provider.cargando, isFalse);
    expect(provider.idUsuario, isNull);
    expect(avisos, 2);
  });

  test('SesionProvider guarda el id al completar cuenta y perfil', () async {
    final auth = _AuthFalso()..activarSesionAlRegistrar = true;
    final perfiles = _PerfilesFalso();
    final provider = SesionProvider(auth, RegistrarUsuario(auth, perfiles));
    addTearDown(provider.dispose);

    await provider.registrar('ana@ejemplo.com', 'clave', 'Ana');

    expect(perfiles.idCreado, 'usuario-123');
    expect(provider.idUsuario, 'usuario-123');
    expect(provider.error, isNull);
    expect(provider.cargando, isFalse);
  });

  test('SesionProvider informa si no hay sesion tras el registro', () async {
    final auth = _AuthFalso();
    final perfiles = _PerfilesFalso();
    final provider = SesionProvider(auth, RegistrarUsuario(auth, perfiles));
    addTearDown(provider.dispose);

    await provider.registrar('ana@ejemplo.com', 'clave', 'Ana');

    expect(perfiles.idCreado, 'usuario-123');
    expect(provider.error, contains('No hay una sesión activa'));
    expect(provider.idUsuario, isNull);
    expect(provider.cargando, isFalse);
  });

  test(
    'SesionProvider limpia errores al reintentar ingreso y salida',
    () async {
      final auth = _AuthFalso()
        ..errorAlIngresar = StateError('Clave incorrecta');
      final perfiles = _PerfilesFalso();
      final provider = SesionProvider(auth, RegistrarUsuario(auth, perfiles));
      addTearDown(provider.dispose);

      await provider.ingresar('ana@ejemplo.com', 'incorrecta');
      expect(provider.error, contains('Clave incorrecta'));
      expect(provider.cargando, isFalse);
      expect(provider.idUsuario, isNull);

      auth.errorAlIngresar = null;
      await provider.ingresar('ana@ejemplo.com', 'correcta');
      expect(provider.idUsuario, 'usuario-123');
      expect(provider.error, isNull);

      auth.errorAlSalir = StateError('No se pudo salir');
      await provider.salir();
      expect(provider.idUsuario, 'usuario-123');
      expect(provider.error, contains('No se pudo salir'));
      expect(provider.cargando, isFalse);

      auth.errorAlSalir = null;
      await provider.salir();
      expect(provider.idUsuario, isNull);
      expect(provider.error, isNull);
      expect(provider.cargando, isFalse);
    },
  );

  test('SesionProvider informa si ingreso no devuelve usuario', () async {
    final auth = _AuthFalso()..activarSesionAlIngresar = false;
    final provider = SesionProvider(
      auth,
      RegistrarUsuario(auth, _PerfilesFalso()),
    );
    addTearDown(provider.dispose);

    await provider.ingresar('ana@ejemplo.com', 'clave');

    expect(provider.idUsuario, isNull);
    expect(provider.error, contains('No se pudo obtener el usuario'));
    expect(provider.cargando, isFalse);
  });

  test(
    'PerfilesProvider carga, informa errores y permite reintentar',
    () async {
      final repo = _PerfilesFalso()
        ..perfilesDevueltos = [
          Perfil(
            id: 'id-1',
            nombre: 'Ana',
            creadoEn: DateTime.utc(2026, 9, 24),
          ),
        ];
      final provider = PerfilesProvider(repo);
      addTearDown(provider.dispose);
      final estados = <bool>[];
      provider.addListener(() => estados.add(provider.cargando));

      await provider.cargar();
      expect(provider.perfiles.single.nombre, 'Ana');
      expect(provider.error, isNull);

      repo.errorAlObtener = StateError('Sin conexión');
      await provider.cargar();
      expect(provider.error, contains('Sin conexión'));
      expect(provider.perfiles.single.nombre, 'Ana');

      repo.errorAlObtener = null;
      repo.perfilesDevueltos = [];
      await provider.cargar();
      expect(provider.perfiles, isEmpty);
      expect(provider.error, isNull);
      expect(estados, [true, false, true, false, true, false]);
    },
  );

  test('PerfilesProvider no notifica tras ser descartado', () async {
    final respuesta = Completer<List<Perfil>>();
    final repo = _PerfilesFalso()..respuestaPendiente = respuesta.future;
    final provider = PerfilesProvider(repo);
    final carga = provider.cargar();
    provider.dispose();
    respuesta.complete([]);
    await expectLater(carga, completes);
  });
}

class _AuthFalso implements AuthRepository {
  String? idActual;
  bool activarSesionAlRegistrar = false;
  bool activarSesionAlIngresar = true;
  Object? errorAlIngresar;
  Object? errorAlSalir;

  @override
  Future<String> registrar(String correo, String clave) async {
    if (activarSesionAlRegistrar) idActual = 'usuario-123';
    return 'usuario-123';
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    if (errorAlIngresar != null) throw errorAlIngresar!;
    if (activarSesionAlIngresar) idActual = 'usuario-123';
  }

  @override
  Future<void> salir() async {
    if (errorAlSalir != null) throw errorAlSalir!;
    idActual = null;
  }

  @override
  String? obtenerIdActual() => idActual;
}

class _PerfilesFalso implements PerfilesRepository {
  String? idCreado;
  Object? errorAlCrear;
  Object? errorAlObtener;
  Future<List<Perfil>>? respuestaPendiente;
  List<Perfil> perfilesDevueltos = [];

  @override
  Future<void> crear(String id, String nombre) async {
    idCreado = id;
    if (errorAlCrear != null) throw errorAlCrear!;
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    if (errorAlObtener != null) throw errorAlObtener!;
    return respuestaPendiente ?? perfilesDevueltos;
  }
}
