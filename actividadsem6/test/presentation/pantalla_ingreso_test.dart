import 'dart:async';

import 'package:actividadsem6/domain/entities/perfil.dart';
import 'package:actividadsem6/domain/entities/registro_prueba.dart';
import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:actividadsem6/domain/repositories/perfiles_repository.dart';
import 'package:actividadsem6/domain/repositories/registros_prueba_repository.dart';
import 'package:actividadsem6/domain/usecases/obtener_registros_prueba.dart';
import 'package:actividadsem6/domain/usecases/registrar_usuario.dart';
import 'package:actividadsem6/presentation/pantallas/home_page.dart';
import 'package:actividadsem6/presentation/pantallas/pantalla_ingreso.dart';
import 'package:actividadsem6/presentation/pantallas/pantalla_usuarios.dart';
import 'package:actividadsem6/presentation/providers/perfiles_provider.dart';
import 'package:actividadsem6/presentation/providers/registros_prueba_provider.dart';
import 'package:actividadsem6/presentation/providers/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Se puede abrir el formulario desde Tabla_prueba', (
    tester,
  ) async {
    final auth = _AuthFalso();
    final perfiles = _PerfilesFalso();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                SesionProvider(auth, RegistrarUsuario(auth, perfiles)),
          ),
          ChangeNotifierProvider(
            create: (_) => RegistrosPruebaProvider(
              ObtenerRegistrosPrueba(_RegistrosFalso()),
            )..cargar(),
          ),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ingresar o crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaIngreso), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  testWidgets('Deshabilita botones mientras ingresa y luego navega', (
    tester,
  ) async {
    final auth = _AuthFalso()..ingresoPendiente = Completer<void>();
    final perfiles = _PerfilesFalso();
    await tester.pumpWidget(_app(auth, perfiles));

    await tester.enterText(find.byType(TextField).at(0), 'ana@ejemplo.com');
    await tester.enterText(find.byType(TextField).at(1), 'mi-clave');
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );

    auth.ingresoPendiente!.complete();
    await tester.pumpAndSettle();

    expect(auth.correoIngresado, 'ana@ejemplo.com');
    expect(auth.claveIngresada, 'mi-clave');
    expect(find.byType(PantallaUsuarios), findsOneWidget);
    expect(find.byType(PantallaIngreso), findsNothing);
  });

  testWidgets('Crear cuenta envía correo, clave y nombre', (tester) async {
    final auth = _AuthFalso()..activarSesionAlRegistrar = true;
    final perfiles = _PerfilesFalso();
    await tester.pumpWidget(_app(auth, perfiles));

    await tester.enterText(find.byType(TextField).at(0), ' ana@ejemplo.com ');
    await tester.enterText(find.byType(TextField).at(1), 'mi-clave');
    await tester.enterText(find.byType(TextField).at(2), ' Ana ');
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    expect(auth.correoRegistrado, 'ana@ejemplo.com');
    expect(auth.claveRegistrada, 'mi-clave');
    expect(perfiles.idCreado, 'usuario-123');
    expect(perfiles.nombreCreado, 'Ana');
    expect(find.byType(PantallaUsuarios), findsOneWidget);
  });

  testWidgets('Muestra el error de ingreso en rojo', (tester) async {
    final auth = _AuthFalso()..errorAlIngresar = StateError('Clave incorrecta');
    await tester.pumpWidget(_app(auth, _PerfilesFalso()));

    final campoClave = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(campoClave.obscureText, isTrue);

    await tester.enterText(find.byType(TextField).at(0), 'ana@ejemplo.com');
    await tester.enterText(find.byType(TextField).at(1), 'clave-equivocada');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    final textoError = tester.widget<Text>(
      find.textContaining('Clave incorrecta'),
    );
    expect(textoError.style?.color, Colors.red);
    expect(find.byType(PantallaIngreso), findsOneWidget);
    expect(find.byType(PantallaUsuarios), findsNothing);
  });

  testWidgets('Puede cerrar sesión y probar una contraseña incorrecta', (
    tester,
  ) async {
    final auth = _AuthFalso()..idActual = 'usuario-existente';
    await tester.pumpWidget(_app(auth, _PerfilesFalso()));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaUsuarios), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaIngreso), findsOneWidget);
    expect(auth.idActual, isNull);

    auth.errorAlIngresar = StateError('Clave incorrecta');
    await tester.enterText(find.byType(TextField).at(0), 'ana@ejemplo.com');
    await tester.enterText(find.byType(TextField).at(1), 'clave-equivocada');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Clave incorrecta'), findsOneWidget);
    expect(find.byType(PantallaIngreso), findsOneWidget);
  });

  testWidgets('Una sesión existente navega después del primer frame', (
    tester,
  ) async {
    final auth = _AuthFalso()..idActual = 'usuario-existente';
    await tester.pumpWidget(_app(auth, _PerfilesFalso()));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaUsuarios), findsOneWidget);
  });

  testWidgets('Usuarios carga perfiles después del primer frame', (
    tester,
  ) async {
    final auth = _AuthFalso()..idActual = 'usuario-existente';
    final perfiles = _PerfilesFalso()
      ..perfilesDevueltos = [
        Perfil(
          id: 'usuario-existente',
          nombre: 'Ana',
          creadoEn: DateTime(2026, 9, 24, 12),
        ),
      ];

    await tester.pumpWidget(_app(auth, perfiles));
    await tester.pumpAndSettle();

    expect(perfiles.consultas, 1);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Creado: 2026-09-24'), findsOneWidget);
  });

  testWidgets('Usuarios muestra carga, error y permite recargar', (
    tester,
  ) async {
    final auth = _AuthFalso()..idActual = 'usuario-existente';
    final respuesta = Completer<List<Perfil>>();
    final perfiles = _PerfilesFalso()..respuestaPendiente = respuesta.future;

    await tester.pumpWidget(_app(auth, perfiles));
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(perfiles.consultas, 1);

    respuesta.completeError(StateError('Sin conexión'));
    await tester.pumpAndSettle();
    final textoError = tester.widget<Text>(find.textContaining('Sin conexión'));
    expect(textoError.style?.color, Colors.red);

    perfiles.respuestaPendiente = null;
    perfiles.perfilesDevueltos = [
      Perfil(id: 'id-2', nombre: 'Luis', creadoEn: DateTime(2026, 9, 24, 12)),
    ];
    await tester.tap(find.byTooltip('Recargar perfiles'));
    await tester.pumpAndSettle();

    expect(perfiles.consultas, 2);
    expect(find.text('Luis'), findsOneWidget);
    expect(find.textContaining('Sin conexión'), findsNothing);
  });

  testWidgets('Salir reemplaza la ruta y no permite volver a Usuarios', (
    tester,
  ) async {
    final auth = _AuthFalso()..idActual = 'usuario-existente';
    await tester.pumpWidget(_app(auth, _PerfilesFalso()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaIngreso), findsOneWidget);
    expect(find.byType(PantallaUsuarios), findsNothing);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
  });
}

Widget _app(_AuthFalso auth, _PerfilesFalso perfiles) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => SesionProvider(auth, RegistrarUsuario(auth, perfiles)),
      ),
      ChangeNotifierProvider(create: (_) => PerfilesProvider(perfiles)),
    ],
    child: const MaterialApp(home: PantallaIngreso()),
  );
}

class _AuthFalso implements AuthRepository {
  String? idActual;
  String? correoIngresado;
  String? claveIngresada;
  String? correoRegistrado;
  String? claveRegistrada;
  Object? errorAlIngresar;
  Completer<void>? ingresoPendiente;
  bool activarSesionAlRegistrar = false;

  @override
  Future<String> registrar(String correo, String clave) async {
    correoRegistrado = correo;
    claveRegistrada = clave;
    if (activarSesionAlRegistrar) idActual = 'usuario-123';
    return 'usuario-123';
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    correoIngresado = correo;
    claveIngresada = clave;
    if (ingresoPendiente != null) await ingresoPendiente!.future;
    if (errorAlIngresar != null) throw errorAlIngresar!;
    idActual = 'usuario-123';
  }

  @override
  Future<void> salir() async {
    idActual = null;
  }

  @override
  String? obtenerIdActual() => idActual;
}

class _PerfilesFalso implements PerfilesRepository {
  String? idCreado;
  String? nombreCreado;
  int consultas = 0;
  Future<List<Perfil>>? respuestaPendiente;
  List<Perfil> perfilesDevueltos = [];

  @override
  Future<void> crear(String id, String nombre) async {
    idCreado = id;
    nombreCreado = nombre;
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    consultas++;
    return respuestaPendiente ?? perfilesDevueltos;
  }
}

class _RegistrosFalso implements RegistrosPruebaRepository {
  @override
  Future<List<RegistroPrueba>> obtenerTodos() async => [];
}
